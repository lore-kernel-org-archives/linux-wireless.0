Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:63570 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaLCUFk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2014 15:05:40 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 7/7] brcmfmac: add multiple BSS support.
Date: Wed, 3 Dec 2014 21:05:33 +0100
Message-ID: <1417637133-6966-8-git-send-email-arend@broadcom.com> (sfid-20141203_210551_058532_28EEE850)
In-Reply-To: <1417637133-6966-1-git-send-email-arend@broadcom.com>
References: <1417637133-6966-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

This patch adds support for multiple BSS interfaces (AP). In
total three AP configurations can be created. In order to use
multiple BSS firmware needs to support it.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 245 +++++++++++++++++----
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h |   2 +
 drivers/net/wireless/brcm80211/brcmfmac/core.c     |  39 +++-
 drivers/net/wireless/brcm80211/brcmfmac/core.h     |   3 +-
 drivers/net/wireless/brcm80211/brcmfmac/feature.c  |  23 ++
 drivers/net/wireless/brcm80211/brcmfmac/feature.h  |   1 +
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |   6 +-
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |   6 +
 8 files changed, 272 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 0ea3125..3aecc5f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -520,6 +520,95 @@ brcmf_cfg80211_update_proto_addr_mode(struct wireless_dev *wdev)
 						ADDR_INDIRECT);
 }
 
+static int brcmf_cfg80211_request_ap_if(struct brcmf_if *ifp)
+{
+	struct brcmf_mbss_ssid_le mbss_ssid_le;
+	int bsscfgidx;
+	int err;
+
+	memset(&mbss_ssid_le, 0, sizeof(mbss_ssid_le));
+	bsscfgidx = brcmf_get_next_free_bsscfgidx(ifp->drvr);
+	if (bsscfgidx < 0)
+		return bsscfgidx;
+
+	mbss_ssid_le.bsscfgidx = cpu_to_le32(bsscfgidx);
+	mbss_ssid_le.SSID_len = cpu_to_le32(5);
+	sprintf(mbss_ssid_le.SSID, "ssid%d" , bsscfgidx);
+
+	err = brcmf_fil_bsscfg_data_set(ifp, "bsscfg:ssid", &mbss_ssid_le,
+					sizeof(mbss_ssid_le));
+	if (err < 0)
+		brcmf_err("setting ssid failed %d\n", err);
+
+	return err;
+}
+
+/**
+ * brcmf_ap_add_vif() - create a new AP virtual interface for multiple BSS
+ *
+ * @wiphy: wiphy device of new interface.
+ * @name: name of the new interface.
+ * @flags: not used.
+ * @params: contains mac address for AP device.
+ */
+static
+struct wireless_dev *brcmf_ap_add_vif(struct wiphy *wiphy, const char *name,
+				      u32 *flags, struct vif_params *params)
+{
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
+	struct brcmf_cfg80211_vif *vif;
+	int err;
+
+	if (brcmf_cfg80211_vif_event_armed(cfg))
+		return ERR_PTR(-EBUSY);
+
+	brcmf_dbg(INFO, "Adding vif \"%s\"\n", name);
+
+	vif = brcmf_alloc_vif(cfg, NL80211_IFTYPE_AP, false);
+	if (IS_ERR(vif))
+		return (struct wireless_dev *)vif;
+
+	brcmf_cfg80211_arm_vif_event(cfg, vif);
+
+	err = brcmf_cfg80211_request_ap_if(ifp);
+	if (err) {
+		brcmf_cfg80211_arm_vif_event(cfg, NULL);
+		goto fail;
+	}
+
+	/* wait for firmware event */
+	err = brcmf_cfg80211_wait_vif_event_timeout(cfg, BRCMF_E_IF_ADD,
+						    msecs_to_jiffies(1500));
+	brcmf_cfg80211_arm_vif_event(cfg, NULL);
+	if (!err) {
+		brcmf_err("timeout occurred\n");
+		err = -EIO;
+		goto fail;
+	}
+
+	/* interface created in firmware */
+	ifp = vif->ifp;
+	if (!ifp) {
+		brcmf_err("no if pointer provided\n");
+		err = -ENOENT;
+		goto fail;
+	}
+
+	strncpy(ifp->ndev->name, name, sizeof(ifp->ndev->name) - 1);
+	err = brcmf_net_attach(ifp, true);
+	if (err) {
+		brcmf_err("Registering netdevice failed\n");
+		goto fail;
+	}
+
+	return &ifp->vif->wdev;
+
+fail:
+	brcmf_free_vif(vif);
+	return ERR_PTR(err);
+}
+
 static bool brcmf_is_apmode(struct brcmf_cfg80211_vif *vif)
 {
 	enum nl80211_iftype iftype;
@@ -545,12 +634,16 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 	switch (type) {
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_MESH_POINT:
 		return ERR_PTR(-EOPNOTSUPP);
+	case NL80211_IFTYPE_AP:
+		wdev = brcmf_ap_add_vif(wiphy, name, flags, params);
+		if (!IS_ERR(wdev))
+			brcmf_cfg80211_update_proto_addr_mode(wdev);
+		return wdev;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_P2P_DEVICE:
@@ -3361,11 +3454,10 @@ static bool brcmf_valid_wpa_oui(u8 *oui, bool is_rsn_ie)
 }
 
 static s32
-brcmf_configure_wpaie(struct net_device *ndev,
+brcmf_configure_wpaie(struct brcmf_if *ifp,
 		      const struct brcmf_vs_tlv *wpa_ie,
 		      bool is_rsn_ie)
 {
-	struct brcmf_if *ifp = netdev_priv(ndev);
 	u32 auth = 0; /* d11 open authentication */
 	u16 count;
 	s32 err = 0;
@@ -3840,6 +3932,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	enum nl80211_iftype dev_role;
 	struct brcmf_fil_bss_enable_le bss_enable;
 	u16 chanspec;
+	bool mbss;
 
 	brcmf_dbg(TRACE, "ctrlchn=%d, center=%d, bw=%d, beacon_interval=%d, dtim_period=%d,\n",
 		  settings->chandef.chan->hw_value,
@@ -3850,6 +3943,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		  settings->inactivity_timeout);
 
 	dev_role = ifp->vif->wdev.iftype;
+	mbss = ifp->vif->mbss;
 
 	memset(&ssid_le, 0, sizeof(ssid_le));
 	if (settings->ssid == NULL || settings->ssid_len == 0) {
@@ -3869,8 +3963,10 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		ssid_le.SSID_len = cpu_to_le32((u32)settings->ssid_len);
 	}
 
-	brcmf_set_mpc(ifp, 0);
-	brcmf_configure_arp_offload(ifp, false);
+	if (!mbss) {
+		brcmf_set_mpc(ifp, 0);
+		brcmf_configure_arp_offload(ifp, false);
+	}
 
 	/* find the RSN_IE */
 	rsn_ie = brcmf_parse_tlvs((u8 *)settings->beacon.tail,
@@ -3884,13 +3980,16 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		brcmf_dbg(TRACE, "WPA(2) IE is found\n");
 		if (wpa_ie != NULL) {
 			/* WPA IE */
-			err = brcmf_configure_wpaie(ndev, wpa_ie, false);
+			err = brcmf_configure_wpaie(ifp, wpa_ie, false);
 			if (err < 0)
 				goto exit;
 		} else {
+			struct brcmf_vs_tlv *tmp_ie;
+
+			tmp_ie = (struct brcmf_vs_tlv *)rsn_ie;
+
 			/* RSN IE */
-			err = brcmf_configure_wpaie(ndev,
-				(struct brcmf_vs_tlv *)rsn_ie, true);
+			err = brcmf_configure_wpaie(ifp, tmp_ie, true);
 			if (err < 0)
 				goto exit;
 		}
@@ -3901,45 +4000,53 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 
 	brcmf_config_ap_mgmt_ie(ifp->vif, &settings->beacon);
 
-	chanspec = chandef_to_chanspec(&cfg->d11inf, &settings->chandef);
-	err = brcmf_fil_iovar_int_set(ifp, "chanspec", chanspec);
-	if (err < 0) {
-		brcmf_err("Set Channel failed: chspec=%d, %d\n", chanspec, err);
-		goto exit;
-	}
-
-	if (settings->beacon_interval) {
-		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_BCNPRD,
-					    settings->beacon_interval);
+	if (!mbss) {
+		chanspec = chandef_to_chanspec(&cfg->d11inf,
+					       &settings->chandef);
+		err = brcmf_fil_iovar_int_set(ifp, "chanspec", chanspec);
 		if (err < 0) {
-			brcmf_err("Beacon Interval Set Error, %d\n", err);
+			brcmf_err("Set Channel failed: chspec=%d, %d\n",
+				  chanspec, err);
 			goto exit;
 		}
-	}
-	if (settings->dtim_period) {
-		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_DTIMPRD,
-					    settings->dtim_period);
-		if (err < 0) {
-			brcmf_err("DTIM Interval Set Error, %d\n", err);
-			goto exit;
+
+		if (settings->beacon_interval) {
+			err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_BCNPRD,
+						    settings->beacon_interval);
+			if (err < 0) {
+				brcmf_err("Beacon Interval Set Error, %d\n",
+					  err);
+				goto exit;
+			}
+		}
+		if (settings->dtim_period) {
+			err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_DTIMPRD,
+						    settings->dtim_period);
+			if (err < 0) {
+				brcmf_err("DTIM Interval Set Error, %d\n", err);
+				goto exit;
+			}
 		}
-	}
 
-	if (dev_role == NL80211_IFTYPE_AP) {
-		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1);
+		if (dev_role == NL80211_IFTYPE_AP) {
+			err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1);
+			if (err < 0) {
+				brcmf_err("BRCMF_C_DOWN error %d\n", err);
+				goto exit;
+			}
+			brcmf_fil_iovar_int_set(ifp, "apsta", 0);
+		}
+
+		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_INFRA, 1);
 		if (err < 0) {
-			brcmf_err("BRCMF_C_DOWN error %d\n", err);
+			brcmf_err("SET INFRA error %d\n", err);
 			goto exit;
 		}
-		brcmf_fil_iovar_int_set(ifp, "apsta", 0);
-	}
-
-	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_INFRA, 1);
-	if (err < 0) {
-		brcmf_err("SET INFRA error %d\n", err);
-		goto exit;
 	}
 	if (dev_role == NL80211_IFTYPE_AP) {
+		if ((brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS)) && (!mbss))
+			brcmf_fil_iovar_int_set(ifp, "mbss", 1);
+
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 1);
 		if (err < 0) {
 			brcmf_err("setting AP mode failed %d\n", err);
@@ -3984,7 +4091,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	set_bit(BRCMF_VIF_STATUS_AP_CREATED, &ifp->vif->sme_state);
 
 exit:
-	if (err) {
+	if ((err) && (!mbss)) {
 		brcmf_set_mpc(ifp, 1);
 		brcmf_configure_arp_offload(ifp, true);
 	}
@@ -4005,20 +4112,31 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 		/* first to make sure they get processed by fw. */
 		msleep(400);
 
+		if (ifp->vif->mbss) {
+			err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1);
+			return err;
+		}
+
 		memset(&join_params, 0, sizeof(join_params));
 		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
 					     &join_params, sizeof(join_params));
 		if (err < 0)
 			brcmf_err("SET SSID error (%d)\n", err);
-		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 0);
+		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1);
 		if (err < 0)
-			brcmf_err("BRCMF_C_UP error %d\n", err);
+			brcmf_err("BRCMF_C_DOWN error %d\n", err);
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 0);
 		if (err < 0)
 			brcmf_err("setting AP mode failed %d\n", err);
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_INFRA, 0);
 		if (err < 0)
 			brcmf_err("setting INFRA mode failed %d\n", err);
+		if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS))
+			brcmf_fil_iovar_int_set(ifp, "mbss", 0);
+		/* Bring device back up so it can be used again */
+		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 1);
+		if (err < 0)
+			brcmf_err("BRCMF_C_UP error %d\n", err);
 	} else {
 		bss_enable.bsscfg_idx = cpu_to_le32(ifp->bssidx);
 		bss_enable.enable = cpu_to_le32(0);
@@ -4370,7 +4488,9 @@ struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
 					   enum nl80211_iftype type,
 					   bool pm_block)
 {
+	struct brcmf_cfg80211_vif *vif_walk;
 	struct brcmf_cfg80211_vif *vif;
+	bool mbss;
 
 	brcmf_dbg(TRACE, "allocating virtual interface (size=%zu)\n",
 		  sizeof(*vif));
@@ -4386,6 +4506,17 @@ struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
 
 	brcmf_init_prof(&vif->profile);
 
+	if (type == NL80211_IFTYPE_AP) {
+		mbss = false;
+		list_for_each_entry(vif_walk, &cfg->vif_list, list) {
+			if (vif_walk->wdev.iftype == NL80211_IFTYPE_AP) {
+				mbss = true;
+				break;
+			}
+		}
+		vif->mbss = mbss;
+	}
+
 	list_add_tail(&vif->list, &cfg->vif_list);
 	return vif;
 }
@@ -4628,6 +4759,7 @@ brcmf_notify_connect_status_ap(struct brcmf_cfg80211_info *cfg,
 			       struct net_device *ndev,
 			       const struct brcmf_event_msg *e, void *data)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	static int generation;
 	u32 event = e->event_code;
 	u32 reason = e->reason;
@@ -4638,6 +4770,8 @@ brcmf_notify_connect_status_ap(struct brcmf_cfg80211_info *cfg,
 	    ndev != cfg_to_ndev(cfg)) {
 		brcmf_dbg(CONN, "AP mode link down\n");
 		complete(&cfg->vif_disabled);
+		if (ifp->vif->mbss)
+			brcmf_remove_interface(ifp->drvr, ifp->bssidx);
 		return 0;
 	}
 
@@ -5429,7 +5563,28 @@ static int brcmf_setup_wiphybands(struct wiphy *wiphy)
 	return 0;
 }
 
-static const struct ieee80211_iface_limit brcmf_iface_limits[] = {
+static const struct ieee80211_iface_limit brcmf_iface_limits_mbss[] = {
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_STATION) |
+			 BIT(NL80211_IFTYPE_ADHOC)
+	},
+	{
+		.max = 4,
+		.types = BIT(NL80211_IFTYPE_AP)
+	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_P2P_CLIENT) |
+			 BIT(NL80211_IFTYPE_P2P_GO)
+	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_P2P_DEVICE)
+	}
+};
+
+static const struct ieee80211_iface_limit brcmf_iface_limits_sbss[] = {
 	{
 		.max = 2,
 		.types = BIT(NL80211_IFTYPE_STATION) |
@@ -5450,8 +5605,8 @@ static struct ieee80211_iface_combination brcmf_iface_combos[] = {
 	{
 		 .max_interfaces = BRCMF_IFACE_MAX_CNT,
 		 .num_different_channels = 1,
-		 .n_limits = ARRAY_SIZE(brcmf_iface_limits),
-		 .limits = brcmf_iface_limits
+		 .n_limits = ARRAY_SIZE(brcmf_iface_limits_sbss),
+		 .limits = brcmf_iface_limits_sbss,
 	}
 };
 
@@ -5527,6 +5682,10 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 	ifc_combo = brcmf_iface_combos[0];
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MCHAN))
 		ifc_combo.num_different_channels = 2;
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS)) {
+		ifc_combo.n_limits = ARRAY_SIZE(brcmf_iface_limits_mbss),
+		ifc_combo.limits = brcmf_iface_limits_mbss;
+	}
 	wiphy->iface_combinations = kmemdup(&ifc_combo,
 					    sizeof(ifc_combo),
 					    GFP_KERNEL);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h
index 2a5b22c..9e98b8d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h
@@ -183,6 +183,7 @@ struct vif_saved_ie {
  * @pm_block: power-management blocked.
  * @list: linked list.
  * @mgmt_rx_reg: registered rx mgmt frame types.
+ * @mbss: Multiple BSS type, set if not first AP (not relevant for P2P).
  */
 struct brcmf_cfg80211_vif {
 	struct brcmf_if *ifp;
@@ -194,6 +195,7 @@ struct brcmf_cfg80211_vif {
 	struct vif_saved_ie saved_ie;
 	struct list_head list;
 	u16 mgmt_rx_reg;
+	bool mbss;
 };
 
 /* association inform */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index f407665..effe6d7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -836,7 +836,7 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
 	return ifp;
 }
 
-void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx)
+static void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx)
 {
 	struct brcmf_if *ifp;
 
@@ -869,6 +869,38 @@ void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx)
 	}
 }
 
+void brcmf_remove_interface(struct brcmf_pub *drvr, u32 bssidx)
+{
+	if (drvr->iflist[bssidx]) {
+		brcmf_fws_del_interface(drvr->iflist[bssidx]);
+		brcmf_del_if(drvr, bssidx);
+	}
+}
+
+int brcmf_get_next_free_bsscfgidx(struct brcmf_pub *drvr)
+{
+	int ifidx;
+	int bsscfgidx;
+	bool available;
+	int highest;
+
+	available = false;
+	bsscfgidx = 2;
+	highest = 2;
+	for (ifidx = 0; ifidx < BRCMF_MAX_IFS; ifidx++) {
+		if (drvr->iflist[ifidx]) {
+			if (drvr->iflist[ifidx]->bssidx == bsscfgidx)
+				bsscfgidx = highest + 1;
+			else if (drvr->iflist[ifidx]->bssidx > highest)
+				highest = drvr->iflist[ifidx]->bssidx;
+		} else {
+			available = true;
+		}
+	}
+
+	return available ? bsscfgidx : -ENOMEM;
+}
+
 int brcmf_attach(struct device *dev)
 {
 	struct brcmf_pub *drvr = NULL;
@@ -1033,10 +1065,7 @@ void brcmf_detach(struct device *dev)
 
 	/* make sure primary interface removed last */
 	for (i = BRCMF_MAX_IFS-1; i > -1; i--)
-		if (drvr->iflist[i]) {
-			brcmf_fws_del_interface(drvr->iflist[i]);
-			brcmf_del_if(drvr, i);
-		}
+		brcmf_remove_interface(drvr, i);
 
 	brcmf_cfg80211_detach(drvr->config);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.h b/drivers/net/wireless/brcm80211/brcmfmac/core.h
index 98228e9..23f74b1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.h
@@ -175,7 +175,8 @@ char *brcmf_ifname(struct brcmf_pub *drvr, int idx);
 int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked);
 struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
 			      char *name, u8 *mac_addr);
-void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx);
+void brcmf_remove_interface(struct brcmf_pub *drvr, u32 bssidx);
+int brcmf_get_next_free_bsscfgidx(struct brcmf_pub *drvr);
 void brcmf_txflowblock_if(struct brcmf_if *ifp,
 			  enum brcmf_netif_stop_reason reason, bool state);
 void brcmf_txfinalize(struct brcmf_pub *drvr, struct sk_buff *txp, u8 ifidx,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
index 931f68a..defb7a4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
@@ -97,6 +97,28 @@ static void brcmf_feat_iovar_int_get(struct brcmf_if *ifp,
 	}
 }
 
+/**
+ * brcmf_feat_iovar_int_set() - determine feature through iovar set.
+ *
+ * @ifp: interface to query.
+ * @id: feature id.
+ * @name: iovar name.
+ */
+static void brcmf_feat_iovar_int_set(struct brcmf_if *ifp,
+				     enum brcmf_feat_id id, char *name, u32 val)
+{
+	int err;
+
+	err = brcmf_fil_iovar_int_set(ifp, name, val);
+	if (err == 0) {
+		brcmf_dbg(INFO, "enabling feature: %s\n", brcmf_feat_names[id]);
+		ifp->drvr->feat_flags |= BIT(id);
+	} else {
+		brcmf_dbg(TRACE, "%s feature check failed: %d\n",
+			  brcmf_feat_names[id], err);
+	}
+}
+
 void brcmf_feat_attach(struct brcmf_pub *drvr)
 {
 	struct brcmf_if *ifp = drvr->iflist[0];
@@ -104,6 +126,7 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_MCHAN, "mchan");
 	if (drvr->bus_if->wowl_supported)
 		brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_WOWL, "wowl");
+	brcmf_feat_iovar_int_set(ifp, BRCMF_FEAT_MBSS, "mbss", 0);
 
 	/* set chip related quirks */
 	switch (drvr->bus_if->chip) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/brcm80211/brcmfmac/feature.h
index b9a796d..f5832e0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/feature.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/feature.h
@@ -22,6 +22,7 @@
  * MCHAN: multi-channel for concurrent P2P.
  */
 #define BRCMF_FEAT_LIST \
+	BRCMF_FEAT_DEF(MBSS) \
 	BRCMF_FEAT_DEF(MCHAN) \
 	BRCMF_FEAT_DEF(WOWL)
 /*
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index 7338b33..ec62492 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -221,10 +221,8 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 
 	err = brcmf_fweh_call_event_handler(ifp, emsg->event_code, emsg, data);
 
-	if (ifp && ifevent->action == BRCMF_E_IF_DEL) {
-		brcmf_fws_del_interface(ifp);
-		brcmf_del_if(drvr, ifevent->bssidx);
-	}
+	if (ifp && ifevent->action == BRCMF_E_IF_DEL)
+		brcmf_remove_interface(drvr, ifevent->bssidx);
 }
 
 /**
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
index ba64b29..50891c0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
@@ -519,4 +519,10 @@ struct brcmf_fil_wowl_pattern_le {
 	/* u8 pattern[] - Pattern follows the mask is at 'patternoffset' */
 };
 
+struct brcmf_mbss_ssid_le {
+	__le32	bsscfgidx;
+	__le32	SSID_len;
+	unsigned char SSID[32];
+};
+
 #endif /* FWIL_TYPES_H_ */
-- 
1.9.1

