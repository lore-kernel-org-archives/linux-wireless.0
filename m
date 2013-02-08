Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3737 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760148Ab3BHO4k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:40 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/27] brcmfmac: implement support for deleting virtual
 interfaces
Date: Fri, 8 Feb 2013 15:53:41 +0100
Message-ID: <1360335242-12608-7-git-send-email-arend@broadcom.com> (sfid-20130208_163817_869730_CF84F763)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Deletion of the virtual interface was not fully supported so
adding it now. Tested using p2p_connect command in wpa_supplicant.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |   64 +++++--
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  199 ++++++++++++--------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    4 +
 4 files changed, 176 insertions(+), 92 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 82724d3..c4f30bd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -150,6 +150,7 @@
 #define BRCMF_E_REASON_MINTXRATE		9
 #define BRCMF_E_REASON_TXFAIL			10
 
+#define BRCMF_E_REASON_LINK_BSSCFG_DIS		4
 #define BRCMF_E_REASON_FAST_ROAM_FAILED		5
 #define BRCMF_E_REASON_DIRECTED_ROAM		6
 #define BRCMF_E_REASON_TSPEC_REJECTED		7
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index cec4116..fff5722 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -827,6 +827,26 @@ static int brcmf_p2p_request_p2p_if(struct brcmf_if *ifp, u8 ea[ETH_ALEN],
 	return err;
 }
 
+static int brcmf_p2p_disable_p2p_if(struct brcmf_cfg80211_vif *vif)
+{
+	struct brcmf_cfg80211_info *cfg = wdev_to_cfg(&vif->wdev);
+	struct net_device *pri_ndev = cfg_to_ndev(cfg);
+	struct brcmf_if *ifp = netdev_priv(pri_ndev);
+	u8 *addr = vif->wdev.netdev->dev_addr;
+
+	return brcmf_fil_iovar_data_set(ifp, "p2p_ifdis", addr, ETH_ALEN);
+}
+
+static int brcmf_p2p_release_p2p_if(struct brcmf_cfg80211_vif *vif)
+{
+	struct brcmf_cfg80211_info *cfg = wdev_to_cfg(&vif->wdev);
+	struct net_device *pri_ndev = cfg_to_ndev(cfg);
+	struct brcmf_if *ifp = netdev_priv(pri_ndev);
+	u8 *addr = vif->wdev.netdev->dev_addr;
+
+	return brcmf_fil_iovar_data_set(ifp, "p2p_ifdel", addr, ETH_ALEN);
+}
+
 /**
  * brcmf_p2p_add_vif() - create a new P2P virtual interface.
  *
@@ -910,23 +930,43 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
 	struct brcmf_cfg80211_vif *vif;
+	unsigned long jiffie_timeout = msecs_to_jiffies(1500);
+	bool wait_for_disable = false;
 	int err;
 
+	brcmf_dbg(TRACE, "delete P2P vif\n");
 	vif = container_of(wdev, struct brcmf_cfg80211_vif, wdev);
 
-	if (brcmf_cfg80211_vif_event_armed(cfg))
-		return -EBUSY;
+	switch (vif->wdev.iftype) {
+	case NL80211_IFTYPE_P2P_CLIENT:
+		if (test_bit(BRCMF_VIF_STATUS_DISCONNECTING, &vif->sme_state))
+			wait_for_disable = true;
+		break;
+
+	case NL80211_IFTYPE_P2P_GO:
+		if (!brcmf_p2p_disable_p2p_if(vif))
+			wait_for_disable = true;
+		break;
+
+	case NL80211_IFTYPE_P2P_DEVICE:
+	default:
+		return -ENOTSUPP;
+		break;
+	}
+
+	if (wait_for_disable)
+		wait_for_completion_timeout(&cfg->vif_disabled, 500);
+
+	brcmf_vif_clear_mgmt_ies(vif);
 
 	brcmf_cfg80211_arm_vif_event(cfg, vif);
-	/* wait for firmware event */
-	err = brcmf_cfg80211_wait_vif_event_timeout(cfg, BRCMF_E_IF_DEL,
-						    msecs_to_jiffies(1500));
+	err = brcmf_p2p_release_p2p_if(vif);
+	if (!err)
+		/* wait for firmware event */
+		err = brcmf_cfg80211_wait_vif_event_timeout(cfg, BRCMF_E_IF_DEL,
+							    jiffie_timeout);
 	brcmf_cfg80211_arm_vif_event(cfg, NULL);
-	if (wdev->netdev)
-		brcmf_dbg(INFO, "deleting vif \"%s\"\n", wdev->netdev->name);
-	else
-		brcmf_dbg(INFO, "deleting vif \"wdev-%u\"\n",
-			  wdev->identifier);
-	brcmf_err("enter - not supported yet\n");
-	return -EOPNOTSUPP;
+	brcmf_free_vif(vif);
+
+	return err;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 6cd47e2..d792c3b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -445,9 +445,103 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 	}
 }
 
+static void brcmf_set_mpc(struct net_device *ndev, int mpc)
+{
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	s32 err = 0;
+
+	if (check_vif_up(ifp->vif)) {
+		err = brcmf_fil_iovar_int_set(ifp, "mpc", mpc);
+		if (err) {
+			brcmf_err("fail to set mpc\n");
+			return;
+		}
+		brcmf_dbg(INFO, "MPC : %d\n", mpc);
+	}
+}
+
+static s32
+brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
+			    struct net_device *ndev,
+			    bool aborted, bool fw_abort)
+{
+	struct brcmf_scan_params_le params_le;
+	struct cfg80211_scan_request *scan_request;
+	s32 err = 0;
+
+	brcmf_dbg(SCAN, "Enter\n");
+
+	/* clear scan request, because the FW abort can cause a second call */
+	/* to this functon and might cause a double cfg80211_scan_done      */
+	scan_request = cfg->scan_request;
+	cfg->scan_request = NULL;
+
+	if (timer_pending(&cfg->escan_timeout))
+		del_timer_sync(&cfg->escan_timeout);
+
+	if (fw_abort) {
+		/* Do a scan abort to stop the driver's scan engine */
+		brcmf_dbg(SCAN, "ABORT scan in firmware\n");
+		memset(&params_le, 0, sizeof(params_le));
+		memset(params_le.bssid, 0xFF, ETH_ALEN);
+		params_le.bss_type = DOT11_BSSTYPE_ANY;
+		params_le.scan_type = 0;
+		params_le.channel_num = cpu_to_le32(1);
+		params_le.nprobes = cpu_to_le32(1);
+		params_le.active_time = cpu_to_le32(-1);
+		params_le.passive_time = cpu_to_le32(-1);
+		params_le.home_time = cpu_to_le32(-1);
+		/* Scan is aborted by setting channel_list[0] to -1 */
+		params_le.channel_list[0] = cpu_to_le16(-1);
+		/* E-Scan (or anyother type) can be aborted by SCAN */
+		err = brcmf_fil_cmd_data_set(netdev_priv(ndev), BRCMF_C_SCAN,
+					     &params_le, sizeof(params_le));
+		if (err)
+			brcmf_err("Scan abort  failed\n");
+	}
+	/*
+	 * e-scan can be initiated by scheduled scan
+	 * which takes precedence.
+	 */
+	if (cfg->sched_escan) {
+		brcmf_dbg(SCAN, "scheduled scan completed\n");
+		cfg->sched_escan = false;
+		if (!aborted)
+			cfg80211_sched_scan_results(cfg_to_wiphy(cfg));
+		brcmf_set_mpc(ndev, 1);
+	} else if (scan_request) {
+		brcmf_dbg(SCAN, "ESCAN Completed scan: %s\n",
+			  aborted ? "Aborted" : "Done");
+		cfg80211_scan_done(scan_request, aborted);
+		brcmf_set_mpc(ndev, 1);
+	}
+	if (!test_and_clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
+		brcmf_err("Scan complete while device not scanning\n");
+		return -EPERM;
+	}
+
+	return err;
+}
+
 static
 int brcmf_cfg80211_del_iface(struct wiphy *wiphy, struct wireless_dev *wdev)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
+	struct net_device *ndev = wdev->netdev;
+
+	/* vif event pending in firmware */
+	if (brcmf_cfg80211_vif_event_armed(cfg))
+		return -EBUSY;
+
+	if (ndev) {
+		if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status) &&
+		    cfg->escan_info.ndev == ndev)
+			brcmf_notify_escan_complete(cfg, ndev, true,
+						    true);
+
+		brcmf_fil_iovar_int_set(netdev_priv(ndev), "mpc", 1);
+	}
+
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_STATION:
@@ -525,21 +619,6 @@ done:
 	return err;
 }
 
-static void brcmf_set_mpc(struct net_device *ndev, int mpc)
-{
-	struct brcmf_if *ifp = netdev_priv(ndev);
-	s32 err = 0;
-
-	if (check_vif_up(ifp->vif)) {
-		err = brcmf_fil_iovar_int_set(ifp, "mpc", mpc);
-		if (err) {
-			brcmf_err("fail to set mpc\n");
-			return;
-		}
-		brcmf_dbg(INFO, "MPC : %d\n", mpc);
-	}
-}
-
 static void brcmf_escan_prep(struct brcmf_scan_params_le *params_le,
 			     struct cfg80211_scan_request *request)
 {
@@ -620,69 +699,6 @@ static void brcmf_escan_prep(struct brcmf_scan_params_le *params_le,
 }
 
 static s32
-brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
-			    struct net_device *ndev,
-			    bool aborted, bool fw_abort)
-{
-	struct brcmf_scan_params_le params_le;
-	struct cfg80211_scan_request *scan_request;
-	s32 err = 0;
-
-	brcmf_dbg(SCAN, "Enter\n");
-
-	/* clear scan request, because the FW abort can cause a second call */
-	/* to this functon and might cause a double cfg80211_scan_done      */
-	scan_request = cfg->scan_request;
-	cfg->scan_request = NULL;
-
-	if (timer_pending(&cfg->escan_timeout))
-		del_timer_sync(&cfg->escan_timeout);
-
-	if (fw_abort) {
-		/* Do a scan abort to stop the driver's scan engine */
-		brcmf_dbg(SCAN, "ABORT scan in firmware\n");
-		memset(&params_le, 0, sizeof(params_le));
-		memset(params_le.bssid, 0xFF, ETH_ALEN);
-		params_le.bss_type = DOT11_BSSTYPE_ANY;
-		params_le.scan_type = 0;
-		params_le.channel_num = cpu_to_le32(1);
-		params_le.nprobes = cpu_to_le32(1);
-		params_le.active_time = cpu_to_le32(-1);
-		params_le.passive_time = cpu_to_le32(-1);
-		params_le.home_time = cpu_to_le32(-1);
-		/* Scan is aborted by setting channel_list[0] to -1 */
-		params_le.channel_list[0] = cpu_to_le16(-1);
-		/* E-Scan (or anyother type) can be aborted by SCAN */
-		err = brcmf_fil_cmd_data_set(netdev_priv(ndev), BRCMF_C_SCAN,
-					     &params_le, sizeof(params_le));
-		if (err)
-			brcmf_err("Scan abort  failed\n");
-	}
-	/*
-	 * e-scan can be initiated by scheduled scan
-	 * which takes precedence.
-	 */
-	if (cfg->sched_escan) {
-		brcmf_dbg(SCAN, "scheduled scan completed\n");
-		cfg->sched_escan = false;
-		if (!aborted)
-			cfg80211_sched_scan_results(cfg_to_wiphy(cfg));
-		brcmf_set_mpc(ndev, 1);
-	} else if (scan_request) {
-		brcmf_dbg(SCAN, "ESCAN Completed scan: %s\n",
-			  aborted ? "Aborted" : "Done");
-		cfg80211_scan_done(scan_request, aborted);
-		brcmf_set_mpc(ndev, 1);
-	}
-	if (!test_and_clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
-		brcmf_err("Scan complete while device not scanning\n");
-		return -EPERM;
-	}
-
-	return err;
-}
-
-static s32
 brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct net_device *ndev,
 		struct cfg80211_scan_request *request, u16 action)
 {
@@ -3474,6 +3490,22 @@ exit:
 	return err;
 }
 
+s32 brcmf_vif_clear_mgmt_ies(struct brcmf_cfg80211_vif *vif)
+{
+	s32 pktflags[] = {
+		BRCMF_VNDR_IE_PRBREQ_FLAG,
+		BRCMF_VNDR_IE_PRBRSP_FLAG,
+		BRCMF_VNDR_IE_BEACON_FLAG
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(pktflags); i++)
+		brcmf_vif_set_mgmt_ie(vif, pktflags[i], NULL, 0);
+
+	memset(&vif->saved_ie, 0, sizeof(vif->saved_ie));
+	return 0;
+}
+
 static s32
 brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			struct cfg80211_ap_settings *settings)
@@ -4260,6 +4292,12 @@ brcmf_notify_connect_status_ap(struct brcmf_cfg80211_info *cfg,
 	struct station_info sinfo;
 
 	brcmf_dbg(CONN, "event %d, reason %d\n", event, reason);
+	if (event == BRCMF_E_LINK && reason == BRCMF_E_REASON_LINK_BSSCFG_DIS &&
+	    ndev != cfg_to_ndev(cfg)) {
+		brcmf_dbg(CONN, "AP mode link down\n");
+		complete(&cfg->vif_disabled);
+		return 0;
+	}
 
 	if (((event == BRCMF_E_ASSOC_IND) || (event == BRCMF_E_REASSOC_IND)) &&
 	    (reason == BRCMF_E_STATUS_SUCCESS)) {
@@ -4316,6 +4354,8 @@ brcmf_notify_connect_status(struct brcmf_if *ifp,
 		}
 		brcmf_link_down(ifp->vif);
 		brcmf_init_prof(ndev_to_prof(ndev));
+		if (ndev != cfg_to_ndev(cfg))
+			complete(&cfg->vif_disabled);
 	} else if (brcmf_is_nonetwork(cfg, e)) {
 		if (brcmf_is_ibssmode(ifp->vif))
 			clear_bit(BRCMF_VIF_STATUS_CONNECTING,
@@ -4401,7 +4441,6 @@ static s32 brcmf_notify_vif_event(struct brcmf_if *ifp,
 
 	case BRCMF_E_IF_DEL:
 		ifp->vif = NULL;
-		brcmf_free_vif(vif);
 		mutex_unlock(&event->vif_event_lock);
 		/* event may not be upon user request */
 		if (brcmf_cfg80211_vif_event_armed(cfg))
@@ -4507,7 +4546,7 @@ static s32 wl_init_priv(struct brcmf_cfg80211_info *cfg)
 	mutex_init(&cfg->usr_sync);
 	brcmf_init_escan(cfg);
 	brcmf_init_conf(cfg->conf);
-
+	init_completion(&cfg->vif_disabled);
 	return err;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index a996afa..5068188 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -148,6 +148,7 @@ struct brcmf_cfg80211_profile {
  * @BRCMF_VIF_STATUS_READY: ready for operation.
  * @BRCMF_VIF_STATUS_CONNECTING: connect/join in progress.
  * @BRCMF_VIF_STATUS_CONNECTED: connected/joined succesfully.
+ * @BRCMF_VIF_STATUS_DISCONNECTING: disconnect/disable in progress.
  * @BRCMF_VIF_STATUS_AP_CREATING: interface configured for AP operation.
  * @BRCMF_VIF_STATUS_AP_CREATED: AP operation started.
  */
@@ -155,6 +156,7 @@ enum brcmf_vif_status {
 	BRCMF_VIF_STATUS_READY,
 	BRCMF_VIF_STATUS_CONNECTING,
 	BRCMF_VIF_STATUS_CONNECTED,
+	BRCMF_VIF_STATUS_DISCONNECTING,
 	BRCMF_VIF_STATUS_AP_CREATING,
 	BRCMF_VIF_STATUS_AP_CREATED
 };
@@ -405,6 +407,7 @@ struct brcmf_cfg80211_info {
 	struct list_head vif_list;
 	u8 vif_cnt;
 	struct brcmf_cfg80211_vif_event vif_event;
+	struct completion vif_disabled;
 };
 
 /**
@@ -479,6 +482,7 @@ void brcmf_free_vif(struct brcmf_cfg80211_vif *vif);
 
 s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 			  const u8 *vndr_ie_buf, u32 vndr_ie_len);
+s32 brcmf_vif_clear_mgmt_ies(struct brcmf_cfg80211_vif *vif);
 struct brcmf_tlv *brcmf_parse_tlvs(void *buf, int buflen, uint key);
 u16 channel_to_chanspec(struct ieee80211_channel *ch);
 u32 wl_get_vif_state_all(struct brcmf_cfg80211_info *cfg, unsigned long state);
-- 
1.7.10.4


