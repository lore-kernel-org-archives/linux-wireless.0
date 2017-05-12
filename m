Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31917 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751442AbdELPUn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 11:20:43 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        Dmitrii Lebed <dlebed@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        "hwang@quantenna.com" <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [v6] qtnfmac: introduce new FullMAC driver for Quantenna chipsets
Date: Fri, 12 May 2017 15:20:35 +0000
Message-ID: <87shkap0e5.fsf@kamboji.qca.qualcomm.com> (sfid-20170512_172047_759740_2C6368E5)
References: <20170511215101.15356-1-igor.mitsyanko.os@quantenna.com>
        <20170512151854.6F16A60953@smtp.codeaurora.org>
In-Reply-To: <20170512151854.6F16A60953@smtp.codeaurora.org> (Kalle Valo's
        message of "Fri, 12 May 2017 15:18:54 +0000 (UTC)")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Igor Mitsyanko <igor.mitsyanko.os@quantenna.com> wrote:
>> From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
>>=20
>> This patch adds support for new FullMAC WiFi driver for Quantenna
>> QSR10G chipsets.
>>=20
>> QSR10G (aka Pearl) is Quantenna's 8x8, 160M, 11ac offering.
>> QSR10G supports 2 simultaneous WMACs - one 5G and one 2G.
>> 5G WMAC supports 160M, 8x8 configuration. FW supports
>> up to 8 concurrent virtual interfaces on each WMAC.
>>=20
>> Patch introduces 2 new drivers:
>> - qtnfmac.ko for interfacing with kernel wireless core
>> - qtnfmac_pearl_pcie.ko for interfacing with hardware over PCIe interfac=
e
>>=20
>> Signed-off-by: Dmitrii Lebed <dlebed@quantenna.com>
>> Signed-off-by: Sergei Maksimenko <smaksimenko@quantenna.com>
>> Signed-off-by: Sergey Matyukevich <smatyukevich@quantenna.com>
>> Signed-off-by: Bindu Therthala <btherthala@quantenna.com>
>> Signed-off-by: Huizhao Wang <hwang@quantenna.com>
>> Signed-off-by: Kamlesh Rath <krath@quantenna.com>
>> Signed-off-by: Avinash Patil <avinashp@quantenna.com>
>> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
>
> I applied this now to the pending branch so that the kbuild bot can do it=
's
> magic:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-ne=
xt.git/log/?h=3Dpending
>
> If all goes smooth I'm planning to apply this to wireless-drivers-next ma=
ster
> branch within the next week or two. So if there's something still to comm=
ent
> about this driver better speak up now. And unless it's something really
> critical any changes can be done as followup patches. I don't want to del=
ay
> this any longer.

Here's the diff between v5 and v6:

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index b74944652eb5..fc0ce2c09097 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -80,11 +80,12 @@ qtnf_mgmt_stypes[NUM_NL80211_IFTYPES] =3D {
 static int
 qtnf_change_virtual_intf(struct wiphy *wiphy,
 			 struct net_device *dev,
-			 enum nl80211_iftype type, u32 *flags,
+			 enum nl80211_iftype type,
 			 struct vif_params *params)
 {
 	struct qtnf_vif *vif =3D qtnf_netdev_get_priv(dev);
 	u8 *mac_addr;
+	int ret;
=20
 	if (params)
 		mac_addr =3D params->macaddr;
@@ -93,9 +94,11 @@ qtnf_change_virtual_intf(struct wiphy *wiphy,
=20
 	qtnf_scan_done(vif->mac, true);
=20
-	if (qtnf_cmd_send_change_intf_type(vif, type, mac_addr)) {
-		pr_err("failed to change interface type\n");
-		return -EFAULT;
+	ret =3D qtnf_cmd_send_change_intf_type(vif, type, mac_addr);
+	if (ret) {
+		pr_err("VIF%u.%u: failed to change VIF type: %d\n",
+		       vif->mac->macid, vif->vifid, ret);
+		return ret;
 	}
=20
 	vif->wdev.iftype =3D type;
@@ -107,13 +110,14 @@ int qtnf_del_virtual_intf(struct wiphy *wiphy, struct=
 wireless_dev *wdev)
 	struct net_device *netdev =3D  wdev->netdev;
 	struct qtnf_vif *vif;
=20
-	if (WARN(!netdev, "qtnfmac: could not get netdev for wdev"))
+	if (WARN_ON(!netdev))
 		return -EFAULT;
=20
 	vif =3D qtnf_netdev_get_priv(wdev->netdev);
=20
 	if (qtnf_cmd_send_del_intf(vif))
-		pr_err("failed to send del_intf command\n");
+		pr_err("VIF%u.%u: failed to delete VIF\n", vif->mac->macid,
+		       vif->vifid);
=20
 	/* Stop data */
 	netif_tx_stop_all_queues(netdev);
@@ -131,12 +135,11 @@ int qtnf_del_virtual_intf(struct wiphy *wiphy, struct=
 wireless_dev *wdev)
 	return 0;
 }
=20
-struct wireless_dev *qtnf_add_virtual_intf(struct wiphy *wiphy,
-					   const char *name,
-					   unsigned char name_assign_type,
-					   enum nl80211_iftype type,
-					   u32 *flags,
-					   struct vif_params *params)
+static struct wireless_dev *qtnf_add_virtual_intf(struct wiphy *wiphy,
+						  const char *name,
+						  unsigned char name_assign_t,
+						  enum nl80211_iftype type,
+						  struct vif_params *params)
 {
 	struct qtnf_wmac *mac;
 	struct qtnf_vif *vif;
@@ -152,7 +155,7 @@ struct wireless_dev *qtnf_add_virtual_intf(struct wiphy=
 *wiphy,
 	case NL80211_IFTYPE_AP:
 		vif =3D qtnf_mac_get_free_vif(mac);
 		if (!vif) {
-			pr_err("could not get free private structure\n");
+			pr_err("MAC%u: no free VIF available\n", mac->macid);
 			return ERR_PTR(-EFAULT);
 		}
=20
@@ -163,7 +166,7 @@ struct wireless_dev *qtnf_add_virtual_intf(struct wiphy=
 *wiphy,
 		vif->sta_state =3D QTNF_STA_DISCONNECTED;
 		break;
 	default:
-		pr_err("unsupported virtual interface type (%d)\n", type);
+		pr_err("MAC%u: unsupported IF type %d\n", mac->macid, type);
 		return ERR_PTR(-ENOTSUPP);
 	}
=20
@@ -171,18 +174,19 @@ struct wireless_dev *qtnf_add_virtual_intf(struct wip=
hy *wiphy,
 		mac_addr =3D params->macaddr;
=20
 	if (qtnf_cmd_send_add_intf(vif, type, mac_addr)) {
-		pr_err("failed to send add_intf command\n");
+		pr_err("VIF%u.%u: failed to add VIF\n", mac->macid, vif->vifid);
 		goto err_cmd;
 	}
=20
 	if (!is_valid_ether_addr(vif->mac_addr)) {
-		pr_err("FW reported invalid MAC for new interface: %pM\n",
-		       vif->mac_addr);
+		pr_err("VIF%u.%u: FW reported bad MAC: %pM\n",
+		       mac->macid, vif->vifid, vif->mac_addr);
 		goto err_mac;
 	}
=20
-	if (qtnf_core_net_attach(mac, vif, name, name_assign_type, type)) {
-		pr_err("could not attach netdev\n");
+	if (qtnf_core_net_attach(mac, vif, name, name_assign_t, type)) {
+		pr_err("VIF%u.%u: failed to attach netdev\n", mac->macid,
+		       vif->vifid);
 		goto err_net;
 	}
=20
@@ -191,11 +195,8 @@ struct wireless_dev *qtnf_add_virtual_intf(struct wiph=
y *wiphy,
=20
 err_net:
 	vif->netdev =3D NULL;
-
 err_mac:
-	if (qtnf_cmd_send_del_intf(vif))
-		pr_err("failed to send del_intf command\n");
-
+	qtnf_cmd_send_del_intf(vif);
 err_cmd:
 	vif->wdev.iftype =3D NL80211_IFTYPE_UNSPECIFIED;
=20
@@ -254,7 +255,7 @@ static int qtnf_change_beacon(struct wiphy *wiphy, stru=
ct net_device *dev,
 	struct qtnf_vif *vif =3D qtnf_netdev_get_priv(dev);
=20
 	if (!(vif->bss_status & QTNF_STATE_AP_START)) {
-		pr_err("bss not started\n");
+		pr_err("VIF%u.%u: not started\n", vif->mac->macid, vif->vifid);
 		return -EFAULT;
 	}
=20
@@ -266,6 +267,7 @@ static int qtnf_start_ap(struct wiphy *wiphy, struct ne=
t_device *dev,
 {
 	struct qtnf_vif *vif =3D qtnf_netdev_get_priv(dev);
 	struct qtnf_bss_config *bss_cfg;
+	int ret;
=20
 	bss_cfg =3D &vif->bss_cfg;
=20
@@ -284,48 +286,60 @@ static int qtnf_start_ap(struct wiphy *wiphy, struct =
net_device *dev,
 	memcpy(&bss_cfg->crypto, &settings->crypto,
 	       sizeof(struct cfg80211_crypto_settings));
=20
-	if (qtnf_cmd_send_config_ap(vif)) {
-		pr_err("failed to upload AP configuration to FW\n");
-		return -EFAULT;
+	ret =3D qtnf_cmd_send_config_ap(vif);
+	if (ret) {
+		pr_err("VIF%u.%u: failed to push config to FW\n",
+		       vif->mac->macid, vif->vifid);
+		goto out;
 	}
=20
 	if (!(vif->bss_status & QTNF_STATE_AP_CONFIG)) {
-		pr_err("failed to configure AP settings in FW\n");
-		return -EFAULT;
+		pr_err("VIF%u.%u: AP config failed in FW\n", vif->mac->macid,
+		       vif->vifid);
+		ret =3D -EFAULT;
+		goto out;
 	}
=20
-	/* update beacon extra IEs */
-	if (qtnf_mgmt_set_appie(vif, &settings->beacon)) {
-		pr_err("failed to setup mgmt frames IEs in FW\n");
-		return -EFAULT;
+	ret =3D qtnf_mgmt_set_appie(vif, &settings->beacon);
+	if (ret) {
+		pr_err("VIF%u.%u: failed to add IEs to beacon\n",
+		       vif->mac->macid, vif->vifid);
+		goto out;
 	}
=20
-	if (qtnf_cmd_send_start_ap(vif)) {
-		pr_err("failed to issue start AP command\n");
-		return -EFAULT;
+	ret =3D qtnf_cmd_send_start_ap(vif);
+	if (ret) {
+		pr_err("VIF%u.%u: failed to start AP\n", vif->mac->macid,
+		       vif->vifid);
+		goto out;
 	}
=20
 	if (!(vif->bss_status & QTNF_STATE_AP_START)) {
-		pr_err("failed to start AP operations in FW\n");
-		return -EFAULT;
+		pr_err("VIF%u.%u: FW failed to start AP operation\n",
+		       vif->mac->macid, vif->vifid);
+		ret =3D -EFAULT;
 	}
=20
-	return 0;
+out:
+	return ret;
 }
=20
 static int qtnf_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 {
 	struct qtnf_vif *vif =3D qtnf_netdev_get_priv(dev);
+	int ret;
=20
-	if (qtnf_cmd_send_stop_ap(vif)) {
-		pr_err("failed to stop AP operation in FW\n");
+	ret =3D qtnf_cmd_send_stop_ap(vif);
+	if (ret) {
+		pr_err("VIF%u.%u: failed to stop AP operation in FW\n",
+		       vif->mac->macid, vif->vifid);
 		vif->bss_status &=3D ~QTNF_STATE_AP_START;
 		vif->bss_status &=3D ~QTNF_STATE_AP_CONFIG;
=20
 		netif_carrier_off(vif->netdev);
-		return -EFAULT;
 	}
-	return 0;
+
+	return ret;
 }
=20
 static int qtnf_set_wiphy_params(struct wiphy *wiphy, u32 changed)
@@ -336,18 +350,18 @@ static int qtnf_set_wiphy_params(struct wiphy *wiphy,=
 u32 changed)
=20
 	vif =3D qtnf_mac_get_base_vif(mac);
 	if (!vif) {
-		pr_err("primary interface is not configured\n");
+		pr_err("MAC%u: primary VIF is not configured\n", mac->macid);
 		return -EFAULT;
 	}
=20
 	if (changed & (WIPHY_PARAM_RETRY_LONG | WIPHY_PARAM_RETRY_SHORT)) {
-		pr_err("device doesn't support modifing retry parameters\n");
+		pr_err("MAC%u: can't modify retry params\n", mac->macid);
 		return -EOPNOTSUPP;
 	}
=20
 	ret =3D qtnf_cmd_send_update_phy_params(mac, changed);
 	if (ret)
-		pr_err("failed to configure phy thresholds\n");
+		pr_err("MAC%u: failed to update PHY params\n", mac->macid);
=20
 	return ret;
 }
@@ -379,20 +393,22 @@ qtnf_mgmt_frame_register(struct wiphy *wiphy, struct =
wireless_dev *wdev,
 		qlink_frame_type =3D QLINK_MGMT_FRAME_ACTION;
 		break;
 	default:
-		pr_warn("unsupported frame type: %X\n",
+		pr_warn("VIF%u.%u: unsupported frame type: %X\n",
+			vif->mac->macid, vif->vifid,
 			(frame_type & IEEE80211_FCTL_STYPE) >> 4);
 		return;
 	}
=20
 	if (qtnf_cmd_send_register_mgmt(vif, qlink_frame_type, reg)) {
-		pr_warn("failed to %sregistered mgmt frame type 0x%x\n",
-			reg ? "" : "un", frame_type);
+		pr_warn("VIF%u.%u: failed to %sregister mgmt frame type 0x%x\n",
+			vif->mac->macid, vif->vifid, reg ? "" : "un",
+			frame_type);
 		return;
 	}
=20
 	vif->mgmt_frames_bitmask =3D new_mask;
-	pr_debug("%sregistered mgmt frame type 0x%x\n",
-		 reg ? "" : "un", frame_type);
+	pr_debug("VIF%u.%u: %sregistered mgmt frame type 0x%x\n",
+		 vif->mac->macid, vif->vifid, reg ? "" : "un", frame_type);
 }
=20
 static int
@@ -465,43 +481,44 @@ static int qtnf_add_key(struct wiphy *wiphy, struct n=
et_device *dev,
 			struct key_params *params)
 {
 	struct qtnf_vif *vif =3D qtnf_netdev_get_priv(dev);
+	int ret;
=20
-	pr_debug("cipher=3D%x idx=3D%u pairwise=3D%u\n", params->cipher,
-		 key_index, pairwise);
-	if (qtnf_cmd_send_add_key(vif, key_index, pairwise, mac_addr,
-				  params)) {
-		pr_err("failed to add key\n");
-		return -EFAULT;
-	}
-	return 0;
+	ret =3D qtnf_cmd_send_add_key(vif, key_index, pairwise, mac_addr, params)=
;
+	if (ret)
+		pr_err("VIF%u.%u: failed to add key: cipher=3D%x idx=3D%u pw=3D%u\n",
+		       vif->mac->macid, vif->vifid, params->cipher, key_index,
+		       pairwise);
+
+	return ret;
 }
=20
 static int qtnf_del_key(struct wiphy *wiphy, struct net_device *dev,
 			u8 key_index, bool pairwise, const u8 *mac_addr)
 {
 	struct qtnf_vif *vif =3D qtnf_netdev_get_priv(dev);
+	int ret;
=20
-	pr_debug("idx=3D%u pairwise=3D%u\n", key_index, pairwise);
-	if (qtnf_cmd_send_del_key(vif, key_index, pairwise, mac_addr)) {
-		pr_err("failed to delete key\n");
-		return -EFAULT;
-	}
-	return 0;
+	ret =3D qtnf_cmd_send_del_key(vif, key_index, pairwise, mac_addr);
+	if (ret)
+		pr_err("VIF%u.%u: failed to delete key: idx=3D%u pw=3D%u\n",
+		       vif->mac->macid, vif->vifid, key_index, pairwise);
+
+	return ret;
 }
=20
 static int qtnf_set_default_key(struct wiphy *wiphy, struct net_device *de=
v,
 				u8 key_index, bool unicast, bool multicast)
 {
 	struct qtnf_vif *vif =3D qtnf_netdev_get_priv(dev);
+	int ret;
=20
-	pr_debug("idx=3D%u unicast=3D%u multicast=3D%u\n", key_index,
-		 unicast, multicast);
-	if (qtnf_cmd_send_set_default_key(vif, key_index, unicast,
-					  multicast)) {
-		pr_err("failed to set default key\n");
-		return -EFAULT;
-	}
-	return 0;
+	ret =3D qtnf_cmd_send_set_default_key(vif, key_index, unicast, multicast)=
;
+	if (ret)
+		pr_err("VIF%u.%u: failed to set dflt key: idx=3D%u uc=3D%u mc=3D%u\n",
+		       vif->mac->macid, vif->vifid, key_index, unicast,
+		       multicast);
+
+	return ret;
 }
=20
 static int
@@ -509,13 +526,14 @@ qtnf_set_default_mgmt_key(struct wiphy *wiphy, struct=
 net_device *dev,
 			  u8 key_index)
 {
 	struct qtnf_vif *vif =3D qtnf_netdev_get_priv(dev);
+	int ret;
=20
-	pr_debug("idx=3D%u\n", key_index);
-	if (qtnf_cmd_send_set_default_mgmt_key(vif, key_index)) {
-		pr_err("failed to set default mgmt key\n");
-		return -EFAULT;
-	}
-	return 0;
+	ret =3D qtnf_cmd_send_set_default_mgmt_key(vif, key_index);
+	if (ret)
+		pr_err("VIF%u.%u: failed to set default MGMT key: idx=3D%u\n",
+		       vif->mac->macid, vif->vifid, key_index);
+
+	return ret;
 }
=20
 static int
@@ -523,12 +541,14 @@ qtnf_change_station(struct wiphy *wiphy, struct net_d=
evice *dev,
 		    const u8 *mac, struct station_parameters *params)
 {
 	struct qtnf_vif *vif =3D qtnf_netdev_get_priv(dev);
+	int ret;
=20
-	if (qtnf_cmd_send_change_sta(vif, mac, params)) {
-		pr_err("failed to change STA\n");
-		return -EFAULT;
-	}
-	return 0;
+	ret =3D qtnf_cmd_send_change_sta(vif, mac, params);
+	if (ret)
+		pr_err("VIF%u.%u: failed to change STA %pM\n",
+		       vif->mac->macid, vif->vifid, mac);
+
+	return ret;
 }
=20
 static int
@@ -536,6 +556,7 @@ qtnf_del_station(struct wiphy *wiphy, struct net_device=
 *dev,
 		 struct station_del_parameters *params)
 {
 	struct qtnf_vif *vif =3D qtnf_netdev_get_priv(dev);
+	int ret;
=20
 	if (params->mac &&
 	    (vif->wdev.iftype =3D=3D NL80211_IFTYPE_AP) &&
@@ -545,25 +566,26 @@ qtnf_del_station(struct wiphy *wiphy, struct net_devi=
ce *dev,
=20
 	qtnf_scan_done(vif->mac, true);
=20
-	if (qtnf_cmd_send_del_sta(vif, params)) {
-		pr_err("failed to delete STA\n");
-		return -EFAULT;
-	}
-	return 0;
+	ret =3D qtnf_cmd_send_del_sta(vif, params);
+	if (ret)
+		pr_err("VIF%u.%u: failed to delete STA %pM\n",
+		       vif->mac->macid, vif->vifid, params->mac);
+	return ret;
 }
=20
 static int
 qtnf_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 {
 	struct qtnf_wmac *mac =3D wiphy_priv(wiphy);
+	int ret;
=20
 	mac->scan_req =3D request;
=20
-	if (qtnf_cmd_send_scan(mac)) {
-		pr_err("failed to start scan\n");
-		return -EFAULT;
-	}
-	return 0;
+	ret =3D qtnf_cmd_send_scan(mac);
+	if (ret)
+		pr_err("MAC%u: failed to start scan\n", mac->macid);
+
+	return ret;
 }
=20
 static int
@@ -572,11 +594,10 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *=
dev,
 {
 	struct qtnf_vif *vif =3D qtnf_netdev_get_priv(dev);
 	struct qtnf_bss_config *bss_cfg;
+	int ret;
=20
-	if (vif->wdev.iftype !=3D NL80211_IFTYPE_STATION) {
-		pr_err("can't connect when not in STA mode\n");
+	if (vif->wdev.iftype !=3D NL80211_IFTYPE_STATION)
 		return -EOPNOTSUPP;
-	}
=20
 	if (vif->sta_state !=3D QTNF_STA_DISCONNECTED)
 		return -EBUSY;
@@ -590,6 +611,7 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *de=
v,
 	bss_cfg->auth_type =3D sme->auth_type;
 	bss_cfg->privacy =3D sme->privacy;
 	bss_cfg->mfp =3D sme->mfp;
+
 	if ((sme->bg_scan_period > 0) &&
 	    (sme->bg_scan_period <=3D QTNF_MAX_BG_SCAN_PERIOD))
 		bss_cfg->bg_scan_period =3D sme->bg_scan_period;
@@ -597,22 +619,27 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *=
dev,
 		bss_cfg->bg_scan_period =3D QTNF_DEFAULT_BG_SCAN_PERIOD;
 	else
 		bss_cfg->bg_scan_period =3D 0; /* disabled */
+
 	bss_cfg->connect_flags =3D 0;
+
 	if (sme->flags & ASSOC_REQ_DISABLE_HT)
 		bss_cfg->connect_flags |=3D QLINK_STA_CONNECT_DISABLE_HT;
 	if (sme->flags & ASSOC_REQ_DISABLE_VHT)
 		bss_cfg->connect_flags |=3D QLINK_STA_CONNECT_DISABLE_VHT;
 	if (sme->flags & ASSOC_REQ_USE_RRM)
 		bss_cfg->connect_flags |=3D QLINK_STA_CONNECT_USE_RRM;
+
 	memcpy(&bss_cfg->crypto, &sme->crypto, sizeof(bss_cfg->crypto));
 	if (sme->bssid)
 		ether_addr_copy(bss_cfg->bssid, sme->bssid);
 	else
 		eth_zero_addr(bss_cfg->bssid);
=20
-	if (qtnf_cmd_send_connect(vif, sme)) {
-		pr_err("failed to connect\n");
-		return -EFAULT;
+	ret =3D qtnf_cmd_send_connect(vif, sme);
+	if (ret) {
+		pr_err("VIF%u.%u: failed to connect\n", vif->mac->macid,
+		       vif->vifid);
+		return ret;
 	}
=20
 	vif->sta_state =3D QTNF_STA_CONNECTING;
@@ -625,24 +652,25 @@ qtnf_disconnect(struct wiphy *wiphy, struct net_devic=
e *dev,
 {
 	struct qtnf_wmac *mac =3D wiphy_priv(wiphy);
 	struct qtnf_vif *vif;
+	int ret;
=20
 	vif =3D qtnf_mac_get_base_vif(mac);
 	if (!vif) {
-		pr_err("primary interface is not configured\n");
+		pr_err("MAC%u: primary VIF is not configured\n", mac->macid);
 		return -EFAULT;
 	}
=20
-	if (vif->wdev.iftype !=3D NL80211_IFTYPE_STATION) {
-		pr_err("can't disconnect when not in STA mode\n");
+	if (vif->wdev.iftype !=3D NL80211_IFTYPE_STATION)
 		return -EOPNOTSUPP;
-	}
=20
 	if (vif->sta_state =3D=3D QTNF_STA_DISCONNECTED)
 		return 0;
=20
-	if (qtnf_cmd_send_disconnect(vif, reason_code)) {
-		pr_err("failed to disconnect\n");
-		return -EFAULT;
+	ret =3D qtnf_cmd_send_disconnect(vif, reason_code);
+	if (ret) {
+		pr_err("VIF%u.%u: failed to disconnect\n", mac->macid,
+		       vif->vifid);
+		return ret;
 	}
=20
 	vif->sta_state =3D QTNF_STA_DISCONNECTED;
@@ -684,29 +712,30 @@ static void qtnf_cfg80211_reg_notifier(struct wiphy *=
wiphy,
=20
 	bus =3D mac->bus;
=20
-	pr_debug("initiator=3D%d, alpha=3D%c%c, mac=3D%d\n", req->initiator,
-		 req->alpha2[0], req->alpha2[1], mac->macid);
+	pr_debug("MAC%u: initiator=3D%d alpha=3D%c%c\n", mac->macid, req->initiat=
or,
+		 req->alpha2[0], req->alpha2[1]);
=20
 	vif =3D qtnf_mac_get_base_vif(mac);
 	if (!vif) {
-		pr_err("primary interface is not configured\n");
+		pr_err("MAC%u: primary VIF is not configured\n", mac->macid);
 		return;
 	}
+
 	/* ignore non-ISO3166 country codes */
 	for (i =3D 0; i < sizeof(req->alpha2); i++) {
 		if (req->alpha2[i] < 'A' || req->alpha2[i] > 'Z') {
-			pr_err("not a ISO3166 code\n");
+			pr_err("MAC%u: not an ISO3166 code\n", mac->macid);
 			return;
 		}
 	}
 	if (!strncasecmp(req->alpha2, bus->hw_info.alpha2_code,
 			 sizeof(req->alpha2))) {
-		pr_warn("unchanged country code\n");
+		pr_warn("MAC%u: unchanged country code\n", mac->macid);
 		return;
 	}
=20
 	if (qtnf_cmd_send_regulatory_config(mac, req->alpha2)) {
-		pr_err("failed to download regulatory configuration\n");
+		pr_err("MAC%u: failed to configure regulatory\n", mac->macid);
 		return;
 	}
=20
@@ -725,7 +754,7 @@ static void qtnf_cfg80211_reg_notifier(struct wiphy *wi=
phy,
=20
 			if (qtnf_cmd_get_mac_chan_info(chan_mac,
 						       wiphy->bands[band])) {
-				pr_err("could not get channel information for mac%d\n",
+				pr_err("MAC%u: can't get channel info\n",
 				       chan_mac->macid);
 				qtnf_core_detach(bus);
=20
@@ -767,10 +796,8 @@ struct wiphy *qtnf_wiphy_allocate(struct qtnf_bus *bus=
)
 	struct wiphy *wiphy;
=20
 	wiphy =3D wiphy_new(&qtn_cfg80211_ops, sizeof(struct qtnf_wmac));
-	if (!wiphy) {
-		pr_err("could not create new wiphy\n");
+	if (!wiphy)
 		return NULL;
-	}
=20
 	set_wiphy_dev(wiphy, bus->dev);
=20
@@ -785,10 +812,8 @@ static int qtnf_wiphy_setup_if_comb(struct wiphy *wiph=
y,
 	u16 interface_modes =3D 0;
 	size_t i;
=20
-	if (unlikely(!mac_info->limits || !mac_info->n_limits)) {
-		pr_err("no interface types supported\n");
+	if (unlikely(!mac_info->limits || !mac_info->n_limits))
 		return -ENOENT;
-	}
=20
 	if_comb->limits =3D mac_info->limits;
 	if_comb->n_limits =3D mac_info->n_limits;
@@ -804,9 +829,6 @@ static int qtnf_wiphy_setup_if_comb(struct wiphy *wiphy=
,
 	if_comb->radar_detect_widths =3D mac_info->radar_detect_widths;
 	wiphy->interface_modes =3D interface_modes;
=20
-	pr_debug("MAX_IF: %zu; MODES: %.4X; RADAR WIDTHS: %.2X\n",
-		 max_interfaces, interface_modes, if_comb->radar_detect_widths);
-
 	return 0;
 }
=20
@@ -831,8 +853,8 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, s=
truct qtnf_wmac *mac)
 	if (ret)
 		goto out;
=20
-	pr_info("macid=3D%d, phymode=3D%#x\n", mac->macid,
-		mac->macinfo.phymode_cap);
+	pr_info("MAC%u: phymode=3D%#x radar=3D%#x\n", mac->macid,
+		mac->macinfo.phymode_cap, mac->macinfo.radar_detect_widths);
=20
 	wiphy->frag_threshold =3D mac->macinfo.frag_thr;
 	wiphy->rts_threshold =3D mac->macinfo.rts_thr;
@@ -878,12 +900,10 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info,=
 struct qtnf_wmac *mac)
 		wiphy->regulatory_flags |=3D REGULATORY_WIPHY_SELF_MANAGED;
 	}
=20
-	pr_debug("registering regulatory for mac(%d)\n", mac->macid);
 	ret =3D wiphy_register(wiphy);
=20
 out:
 	if (ret < 0) {
-		pr_err("could not register wiphy\n");
 		kfree(iface_comb);
 		return ret;
 	}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.h
index 3788be90a06a..5bd33124a7c8 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
@@ -24,11 +24,6 @@
 int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *ma=
c);
 int qtnf_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev);
 void qtnf_cfg80211_vif_reset(struct qtnf_vif *vif);
-struct wireless_dev *qtnf_add_virtual_intf(struct wiphy *wiphy,
-					   const char *name,
-					   unsigned char name_assign_type,
-					   enum nl80211_iftype type, u32 *flags,
-					   struct vif_params *params);
 void qtnf_band_init_rates(struct ieee80211_supported_band *band);
 void qtnf_band_setup_htvht_caps(struct qtnf_mac_info *macinfo,
 				struct ieee80211_supported_band *band);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index ab000af60bb4..f0a0cfa7d8a1 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -28,26 +28,26 @@ static int qtnf_cmd_check_reply_header(const struct qli=
nk_resp *resp,
 				       size_t resp_size)
 {
 	if (unlikely(le16_to_cpu(resp->cmd_id) !=3D cmd_id)) {
-		pr_warn("invalid response cmd_id: 0x%.4X !=3D 0x%.4X\n",
-			le16_to_cpu(resp->cmd_id), cmd_id);
+		pr_warn("VIF%u.%u CMD%x: bad cmd_id in response: 0x%.4X\n",
+			mac_id, vif_id, cmd_id, le16_to_cpu(resp->cmd_id));
 		return -EINVAL;
 	}
=20
 	if (unlikely(resp->macid !=3D mac_id)) {
-		pr_warn("invalid response macid: 0x%.2X !=3D 0x%.2X\n",
-			resp->macid, mac_id);
+		pr_warn("VIF%u.%u CMD%x: bad MAC in response: %u\n",
+			mac_id, vif_id, cmd_id, resp->macid);
 		return -EINVAL;
 	}
=20
 	if (unlikely(resp->vifid !=3D vif_id)) {
-		pr_warn("invalid response vif_id: 0x%.2X !=3D 0x%.2X\n",
-			resp->vifid, vif_id);
+		pr_warn("VIF%u.%u CMD%x: bad VIF in response: %u\n",
+			mac_id, vif_id, cmd_id, resp->vifid);
 		return -EINVAL;
 	}
=20
 	if (unlikely(le16_to_cpu(resp->mhdr.len) < resp_size)) {
-		pr_warn("invalid response size for cmd=3D0x%.4X mac=3D0x%.2X vif=3D0x%.2=
X: %u < %zu\n",
-			cmd_id, mac_id, vif_id,
+		pr_warn("VIF%u.%u CMD%x: bad response size %u < %zu\n",
+			mac_id, vif_id, cmd_id,
 			le16_to_cpu(resp->mhdr.len), resp_size);
 		return -ENOSPC;
 	}
@@ -69,17 +69,6 @@ static int qtnf_cmd_send_with_reply(struct qtnf_bus *bus=
,
 	u8 mac_id, vif_id;
 	int ret;
=20
-	if (unlikely(!cmd_skb)) {
-		pr_err("no command skb\n");
-		return -EFAULT;
-	}
-
-	if (unlikely(!cmd_skb->data) || unlikely(cmd_skb->len < sizeof(*cmd))) {
-		pr_err("invalid command skb data\n");
-		kfree_skb(cmd_skb);
-		return -EFAULT;
-	}
-
 	cmd =3D (struct qlink_cmd *)cmd_skb->data;
 	cmd_id =3D le16_to_cpu(cmd->cmd_id);
 	mac_id =3D cmd->macid;
@@ -88,13 +77,14 @@ static int qtnf_cmd_send_with_reply(struct qtnf_bus *bu=
s,
=20
 	if (unlikely(bus->fw_state !=3D QTNF_FW_STATE_ACTIVE &&
 		     le16_to_cpu(cmd->cmd_id) !=3D QLINK_CMD_FW_INIT)) {
-		pr_warn("drop cmd 0x%.4X in fw state %d\n",
-			le16_to_cpu(cmd->cmd_id), bus->fw_state);
+		pr_warn("VIF%u.%u: drop cmd 0x%.4X in fw state %d\n",
+			mac_id, vif_id, le16_to_cpu(cmd->cmd_id),
+			bus->fw_state);
 		return -ENODEV;
 	}
=20
-	pr_debug("cmd=3D0x%.4X macid=3D0x%.2X vif=3D0x%.2X\n",
-		 le16_to_cpu(cmd->cmd_id), cmd->macid, cmd->vifid);
+	pr_debug("VIF%u.%u cmd=3D0x%.4X\n", mac_id, vif_id,
+		 le16_to_cpu(cmd->cmd_id));
=20
 	ret =3D qtnf_trans_send_cmd_with_resp(bus, cmd_skb, &resp_skb);
=20
@@ -141,7 +131,7 @@ static struct sk_buff *qtnf_cmd_alloc_new_cmdskb(u8 mac=
id, u8 vifid, u16 cmd_no,
 	cmd_skb =3D __dev_alloc_skb(sizeof(*cmd) +
 				  QTNF_MAX_CMD_BUF_SIZE, GFP_KERNEL);
 	if (unlikely(!cmd_skb)) {
-		pr_err("failed to allocate cmd_skb\n");
+		pr_err("VIF%u.%u CMD %u: alloc failed\n", macid, vifid, cmd_no);
 		return NULL;
 	}
=20
@@ -177,7 +167,8 @@ int qtnf_cmd_send_start_ap(struct qtnf_vif *vif)
 		goto out;
=20
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
 		ret =3D -EFAULT;
 		goto out;
 	}
@@ -211,7 +202,7 @@ int qtnf_cmd_send_regulatory_config(struct qtnf_wmac *m=
ac, const char *alpha2)
 		goto out;
=20
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		pr_err("MAC%u: CMD failed: %u\n", mac->macid, res_code);
 		ret =3D -EFAULT;
 		goto out;
 	}
@@ -287,7 +278,8 @@ int qtnf_cmd_send_config_ap(struct qtnf_vif *vif)
 		goto out;
=20
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
 		ret =3D -EFAULT;
 		goto out;
 	}
@@ -319,7 +311,8 @@ int qtnf_cmd_send_stop_ap(struct qtnf_vif *vif)
 		goto out;
=20
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
 		ret =3D -EFAULT;
 		goto out;
 	}
@@ -359,7 +352,8 @@ int qtnf_cmd_send_register_mgmt(struct qtnf_vif *vif, u=
16 frame_type, bool reg)
 		goto out;
=20
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
 		ret =3D -EFAULT;
 		goto out;
 	}
@@ -378,7 +372,8 @@ int qtnf_cmd_send_mgmt_frame(struct qtnf_vif *vif, u32 =
cookie, u16 flags,
 	int ret;
=20
 	if (sizeof(*cmd) + len > QTNF_MAX_CMD_BUF_SIZE) {
-		pr_warn("frame is too big: %zu\n", len);
+		pr_warn("VIF%u.%u: frame is too big: %zu\n", vif->mac->macid,
+			vif->vifid, len);
 		return -E2BIG;
 	}
=20
@@ -404,7 +399,8 @@ int qtnf_cmd_send_mgmt_frame(struct qtnf_vif *vif, u32 =
cookie, u16 flags,
 		goto out;
=20
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
 		ret =3D -EFAULT;
 		goto out;
 	}
@@ -423,7 +419,8 @@ int qtnf_cmd_send_mgmt_set_appie(struct qtnf_vif *vif, =
u8 frame_type,
 	int ret;
=20
 	if (sizeof(*cmd) + len > QTNF_MAX_CMD_BUF_SIZE) {
-		pr_warn("frame is too big: %zu\n", len);
+		pr_warn("VIF%u.%u: %u frame is too big: %zu\n", vif->mac->macid,
+			vif->vifid, frame_type, len);
 		return -E2BIG;
 	}
=20
@@ -451,7 +448,8 @@ int qtnf_cmd_send_mgmt_set_appie(struct qtnf_vif *vif, =
u8 frame_type,
 		goto out;
=20
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		pr_err("VIF%u.%u frame %u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, frame_type, res_code);
 		ret =3D -EFAULT;
 		goto out;
 	}
@@ -694,11 +692,13 @@ int qtnf_cmd_get_sta_info(struct qtnf_vif *vif, const=
 u8 *sta_mac,
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
 		switch (res_code) {
 		case QLINK_CMD_RESULT_ENOTFOUND:
-			pr_warn("STA %pM not found\n", sta_mac);
+			pr_warn("VIF%u.%u: %pM STA not found\n",
+				vif->mac->macid, vif->vifid, sta_mac);
 			ret =3D -ENOENT;
 			break;
 		default:
-			pr_err("error returned: %u\n", res_code);
+			pr_err("VIF%u.%u: can't get info for %pM: %u\n",
+			       vif->mac->macid, vif->vifid, sta_mac, res_code);
 			ret =3D -EFAULT;
 			break;
 		}
@@ -708,8 +708,8 @@ int qtnf_cmd_get_sta_info(struct qtnf_vif *vif, const u=
8 *sta_mac,
 	resp =3D (const struct qlink_resp_get_sta_info *)resp_skb->data;
=20
 	if (unlikely(!ether_addr_equal(sta_mac, resp->sta_addr))) {
-		pr_err("wrong mac in reply: %pM !=3D %pM\n",
-		       resp->sta_addr, sta_mac);
+		pr_err("VIF%u.%u: wrong mac in reply: %pM !=3D %pM\n",
+		       vif->mac->macid, vif->vifid, resp->sta_addr, sta_mac);
 		ret =3D -EINVAL;
 		goto out;
 	}
@@ -752,7 +752,8 @@ static int qtnf_cmd_send_add_change_intf(struct qtnf_vi=
f *vif,
 		cmd->intf_info.if_type =3D cpu_to_le16(QLINK_IFTYPE_STATION);
 		break;
 	default:
-		pr_err("unsupported iftype %d\n", iftype);
+		pr_err("VIF%u.%u: unsupported type %d\n", vif->mac->macid,
+		       vif->vifid, iftype);
 		ret =3D -EINVAL;
 		goto out;
 	}
@@ -769,7 +770,8 @@ static int qtnf_cmd_send_add_change_intf(struct qtnf_vi=
f *vif,
 		goto out;
=20
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		pr_err("VIF%u.%u: CMD %d failed: %u\n", vif->mac->macid,
+		       vif->vifid, cmd_type, res_code);
 		ret =3D -EFAULT;
 		goto out;
 	}
@@ -823,7 +825,8 @@ int qtnf_cmd_send_del_intf(struct qtnf_vif *vif)
 		cmd->intf_info.if_type =3D cpu_to_le16(QLINK_IFTYPE_STATION);
 		break;
 	default:
-		pr_warn("unsupported iftype %d\n", vif->wdev.iftype);
+		pr_warn("VIF%u.%u: unsupported iftype %d\n", vif->mac->macid,
+			vif->vifid, vif->wdev.iftype);
 		ret =3D -EINVAL;
 		goto out;
 	}
@@ -836,7 +839,8 @@ int qtnf_cmd_send_del_intf(struct qtnf_vif *vif)
 		goto out;
=20
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
 		ret =3D -EFAULT;
 		goto out;
 	}
@@ -889,8 +893,8 @@ static int qtnf_parse_variable_mac_info(struct qtnf_wma=
c *mac,
 		tlv_value_len =3D le16_to_cpu(tlv->len);
 		tlv_full_len =3D tlv_value_len + sizeof(struct qlink_tlv_hdr);
 		if (tlv_full_len > tlv_buf_size) {
-			pr_warn("malformed TLV 0x%.2X; LEN: %u\n",
-				tlv_type, tlv_value_len);
+			pr_warn("MAC%u: malformed TLV 0x%.2X; LEN: %u\n",
+				mac->macid, tlv_type, tlv_value_len);
 			return -EINVAL;
 		}
=20
@@ -913,16 +917,17 @@ static int qtnf_parse_variable_mac_info(struct qtnf_w=
mac *mac,
 				return -ENOMEM;
=20
 			limits =3D mac->macinfo.limits;
-			pr_debug("iface limit record count=3D%zu\n",
-				 record_count);
 			break;
 		case QTN_TLV_ID_IFACE_LIMIT:
 			if (unlikely(!limits)) {
-				pr_warn("limits yet not initialized\n");
+				pr_warn("MAC%u: limits are not inited\n",
+					mac->macid);
 				return -EINVAL;
 			}
+
 			if (unlikely(tlv_value_len !=3D sizeof(*limit_record))) {
-				pr_warn("record size mismatch\n");
+				pr_warn("MAC%u: record size mismatch\n",
+					mac->macid);
 				return -EINVAL;
 			}
=20
@@ -934,7 +939,7 @@ static int qtnf_parse_variable_mac_info(struct qtnf_wma=
c *mac,
 			limits[rec].types &=3D BIT(NL80211_IFTYPE_AP) |
 					     BIT(NL80211_IFTYPE_STATION);
=20
-			pr_debug("MAX: %u; TYPES: %.4X\n",
+			pr_debug("MAC%u: MAX: %u; TYPES: %.4X\n", mac->macid,
 				 limits[rec].max, limits[rec].types);
=20
 			if (limits[rec].types)
@@ -946,14 +951,16 @@ static int qtnf_parse_variable_mac_info(struct qtnf_w=
mac *mac,
 		tlv_buf_size -=3D tlv_full_len;
 		tlv =3D (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
 	}
+
 	if (tlv_buf_size) {
-		pr_warn("malformed TLV buf; bytes left: %zu\n", tlv_buf_size);
+		pr_warn("MAC%u: malformed TLV buf; bytes left: %zu\n",
+			mac->macid, tlv_buf_size);
 		return -EINVAL;
 	}
=20
 	if (mac->macinfo.n_limits !=3D rec) {
-		pr_err("iface combination mismatch: reported=3D%zu, parsed=3D%zu\n",
-		       mac->macinfo.n_limits, rec);
+		pr_err("MAC%u: combination mismatch: reported=3D%zu parsed=3D%zu\n",
+		       mac->macid, mac->macinfo.n_limits, rec);
 		return -EINVAL;
 	}
=20
@@ -1160,11 +1167,13 @@ static int qtnf_cmd_resp_proc_phy_params(struct qtn=
f_wmac *mac,
 		tlv_type =3D le16_to_cpu(tlv->type);
 		tlv_value_len =3D le16_to_cpu(tlv->len);
 		tlv_full_len =3D tlv_value_len + sizeof(struct qlink_tlv_hdr);
+
 		if (tlv_full_len > payload_len) {
-			pr_warn("malformed TLV 0x%.2X; LEN: %u\n",
-				tlv_type, tlv_value_len);
+			pr_warn("MAC%u: malformed TLV 0x%.2X; LEN: %u\n",
+				mac->macid, tlv_type, tlv_value_len);
 			return -EINVAL;
 		}
+
 		switch (tlv_type) {
 		case QTN_TLV_ID_FRAG_THRESH:
 			phy_thr =3D (void *)tlv;
@@ -1187,16 +1196,18 @@ static int qtnf_cmd_resp_proc_phy_params(struct qtn=
f_wmac *mac,
 			mac_info->coverage_class =3D class->cclass;
 			break;
 		default:
-			pr_err("Unknown TLV type: %#x\n",
+			pr_err("MAC%u: Unknown TLV type: %#x\n", mac->macid,
 			       le16_to_cpu(tlv->type));
 			break;
 		}
+
 		payload_len -=3D tlv_full_len;
 		tlv =3D (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
 	}
=20
 	if (payload_len) {
-		pr_warn("malformed TLV buf; bytes left: %zu\n", payload_len);
+		pr_warn("MAC%u: malformed TLV buf; bytes left: %zu\n",
+			mac->macid, payload_len);
 		return -EINVAL;
 	}
=20
@@ -1225,7 +1236,7 @@ int qtnf_cmd_get_mac_info(struct qtnf_wmac *mac)
 		goto out;
=20
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		pr_err("MAC%u: CMD failed: %u\n", mac->macid, res_code);
 		ret =3D -EFAULT;
 		goto out;
 	}
@@ -1318,14 +1329,15 @@ int qtnf_cmd_get_mac_chan_info(struct qtnf_wmac *ma=
c,
 		goto out;
=20
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		pr_err("MAC%u: CMD failed: %u\n", mac->macid, res_code);
 		ret =3D -EFAULT;
 		goto out;
 	}
=20
 	resp =3D (struct qlink_resp_get_chan_info *)resp_skb->data;
 	if (resp->band !=3D qband) {
-		pr_err("reply band %u !=3D cmd band %u\n", resp->band, qband);
+		pr_err("MAC%u: reply band %u !=3D cmd band %u\n", mac->macid,
+		       resp->band, qband);
 		ret =3D -EINVAL;
 		goto out;
 	}
@@ -1361,7 +1373,7 @@ int qtnf_cmd_send_get_phy_params(struct qtnf_wmac *ma=
c)
 		goto out;
=20
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		pr_err("MAC%u: CMD failed: %u\n", mac->macid, res_code);
 		ret =3D -EFAULT;
 		goto out;
 	}
@@ -1407,7 +1419,7 @@ int qtnf_cmd_send_update_phy_params(struct qtnf_wmac =
*mac, u32 changed)
 		goto out;
=20
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		pr_err("MAC%u: CMD failed: %u\n", mac->macid, res_code);
 		ret =3D -EFAULT;
 		goto out;
 	}
@@ -1506,7 +1518,8 @@ int qtnf_cmd_send_add_key(struct qtnf_vif *vif, u8 ke=
y_index, bool pairwise,
 		goto out;
=20
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		pr_err("VIF%u.%u: CMD failed: %u\n",
+		       vif->mac->macid, vif->vifid, res_code);
 		ret =3D -EFAULT;
 		goto out;
 	}
@@ -1546,7 +1559,8 @@ int qtnf_cmd_send_del_key(struct qtnf_vif *vif, u8 ke=
y_index, bool pairwise,
 		goto out;
=20
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		pr_err("VIF%u.%u: CMD failed: %u\n",
+		       vif->mac->macid, vif->vifid, res_code);
 		ret =3D -EFAULT;
 		goto out;
 	}
@@ -1581,7 +1595,8 @@ int qtnf_cmd_send_set_default_key(struct qtnf_vif *vi=
f, u8 key_index,
 		goto out;
=20
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
 		ret =3D -EFAULT;
 		goto out;
 	}
@@ -1613,7 +1628,8 @@ int qtnf_cmd_send_set_default_mgmt_key(struct qtnf_vi=
f *vif, u8 key_index)
 		goto out;
=20
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
 		ret =3D -EFAULT;
 		goto out;
 	}
@@ -1672,7 +1688,8 @@ int qtnf_cmd_send_change_sta(struct qtnf_vif *vif, co=
nst u8 *mac,
 		goto out;
=20
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
 		ret =3D -EFAULT;
 		goto out;
 	}
@@ -1713,7 +1730,8 @@ int qtnf_cmd_send_del_sta(struct qtnf_vif *vif,
 		goto out;
=20
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
 		ret =3D -EFAULT;
 		goto out;
 	}
@@ -1736,7 +1754,7 @@ int qtnf_cmd_send_scan(struct qtnf_wmac *mac)
 	u32 flags;
=20
 	if (scan_req->n_ssids > QTNF_MAX_SSID_LIST_LENGTH) {
-		pr_err("too many SSIDs in scan request\n");
+		pr_err("MAC%u: too many SSIDs in scan request\n", mac->macid);
 		return -EINVAL;
 	}
=20
@@ -1773,8 +1791,9 @@ int qtnf_cmd_send_scan(struct qtnf_wmac *mac)
 				continue;
 			}
=20
-			pr_debug("scan chan=3D%d, freq=3D%d, flags=3D%#x\n",
-				 sc->hw_value, sc->center_freq, sc->flags);
+			pr_debug("MAC%u: scan chan=3D%d, freq=3D%d, flags=3D%#x\n",
+				 mac->macid, sc->hw_value, sc->center_freq,
+				 sc->flags);
 			qchan =3D (struct qlink_tlv_channel *)
 					skb_put(cmd_skb, sizeof(*qchan));
 			memset(qchan, 0, sizeof(*qchan));
@@ -1803,10 +1822,10 @@ int qtnf_cmd_send_scan(struct qtnf_wmac *mac)
 	if (unlikely(ret))
 		goto out;
=20
-	pr_debug("scan started on mac(%u)\n", mac->macid);
+	pr_debug("MAC%u: scan started\n", mac->macid);
=20
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		pr_err("MAC%u: CMD failed: %u\n", mac->macid, res_code);
 		ret =3D -EFAULT;
 		goto out;
 	}
@@ -1884,7 +1903,8 @@ int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 		goto out;
=20
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
 		ret =3D -EFAULT;
 		goto out;
 	}
@@ -1917,7 +1937,8 @@ int qtnf_cmd_send_disconnect(struct qtnf_vif *vif, u1=
6 reason_code)
 		goto out;
=20
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
 		ret =3D -EFAULT;
 		goto out;
 	}
@@ -1950,7 +1971,8 @@ int qtnf_cmd_send_updown_intf(struct qtnf_vif *vif, b=
ool up)
 		goto out;
=20
 	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
+		       vif->vifid, res_code);
 		ret =3D -EFAULT;
 		goto out;
 	}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wi=
reless/quantenna/qtnfmac/core.c
index 9ceb4fb5cea9..c5ac252464f4 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -27,6 +27,7 @@
 #include "util.h"
=20
 #define QTNF_DMP_MAX_LEN 48
+#define QTNF_PRIMARY_VIF_IDX	0
=20
 struct qtnf_frame_meta_info {
 	u8 magic_s;
@@ -40,14 +41,14 @@ struct qtnf_wmac *qtnf_core_get_mac(const struct qtnf_b=
us *bus, u8 macid)
 	struct qtnf_wmac *mac =3D NULL;
=20
 	if (unlikely(macid >=3D QTNF_MAX_MAC)) {
-		pr_err("received invalid mac(%u)\n", macid);
+		pr_err("invalid MAC index %u\n", macid);
 		return NULL;
 	}
=20
 	mac =3D bus->mac[macid];
=20
 	if (unlikely(!mac)) {
-		pr_err("mac(%u) not initialized\n", macid);
+		pr_err("MAC%u: not initialized\n", macid);
 		return NULL;
 	}
=20
@@ -90,21 +91,21 @@ qtnf_netdev_hard_start_xmit(struct sk_buff *skb, struct=
 net_device *ndev)
 	}
=20
 	if (unlikely(vif->wdev.iftype =3D=3D NL80211_IFTYPE_UNSPECIFIED)) {
-		pr_err_ratelimited("unsupported vif type (%d)\n",
-				   vif->wdev.iftype);
+		pr_err_ratelimited("%s: VIF not initialized\n", ndev->name);
 		dev_kfree_skb_any(skb);
 		return 0;
 	}
=20
 	mac =3D vif->mac;
 	if (unlikely(!mac)) {
-		pr_err_ratelimited("NULL mac pointer");
+		pr_err_ratelimited("%s: NULL mac pointer", ndev->name);
 		dev_kfree_skb_any(skb);
 		return 0;
 	}
=20
 	if (!skb->len || (skb->len > ETH_FRAME_LEN)) {
-		pr_err_ratelimited("invalid skb len %d\n", skb->len);
+		pr_err_ratelimited("%s: invalid skb len %d\n", ndev->name,
+				   skb->len);
 		dev_kfree_skb_any(skb);
 		ndev->stats.tx_dropped++;
 		return 0;
@@ -137,8 +138,7 @@ static void qtnf_netdev_tx_timeout(struct net_device *n=
dev)
 	mac =3D vif->mac;
 	bus =3D mac->bus;
=20
-	pr_warn("Tx timeout- %lu, mac/vif =3D %d/%d\n",
-		jiffies, mac->macid, vif->vifid);
+	pr_warn("VIF%u.%u: Tx timeout- %lu\n", mac->macid, vif->vifid, jiffies);
=20
 	qtnf_bus_data_tx_timeout(bus, ndev);
 	ndev->stats.tx_errors++;
@@ -173,8 +173,8 @@ static int qtnf_mac_init_single_band(struct wiphy *wiph=
y,
=20
 	ret =3D qtnf_cmd_get_mac_chan_info(mac, wiphy->bands[band]);
 	if (ret) {
-		pr_err("failed to get chans info for band %u\n",
-		       band);
+		pr_err("MAC%u: band %u: failed to get chans info: %d\n",
+		       mac->macid, band, ret);
 		return ret;
 	}
=20
@@ -226,7 +226,7 @@ struct qtnf_vif *qtnf_mac_get_base_vif(struct qtnf_wmac=
 *mac)
 {
 	struct qtnf_vif *vif;
=20
-	vif =3D &mac->iflist[0];
+	vif =3D &mac->iflist[QTNF_PRIMARY_VIF_IDX];
=20
 	if (vif->wdev.iftype =3D=3D NL80211_IFTYPE_UNSPECIFIED)
 		return NULL;
@@ -255,31 +255,23 @@ static void qtnf_vif_reset_handler(struct work_struct=
 *work)
 	rtnl_unlock();
 }
=20
-static int qtnf_mac_add_default_intf(struct qtnf_wmac *mac)
+static void qtnf_mac_init_primary_intf(struct qtnf_wmac *mac)
 {
-	struct qtnf_vif *vif;
-
-	vif =3D qtnf_mac_get_free_vif(mac);
-	if (!vif) {
-		pr_err("could not get free vif structure\n");
-		return -EFAULT;
-	}
+	struct qtnf_vif *vif =3D &mac->iflist[QTNF_PRIMARY_VIF_IDX];
=20
 	vif->wdev.iftype =3D NL80211_IFTYPE_AP;
 	vif->bss_priority =3D QTNF_DEF_BSS_PRIORITY;
 	vif->wdev.wiphy =3D priv_to_wiphy(mac);
 	INIT_WORK(&vif->reset_work, qtnf_vif_reset_handler);
 	vif->cons_tx_timeout_cnt =3D 0;
-
-	return 0;
 }
=20
-static struct qtnf_wmac *qtnf_core_mac_alloc(struct qtnf_bus *bus, int mac=
id)
+static struct qtnf_wmac *qtnf_core_mac_alloc(struct qtnf_bus *bus,
+					     unsigned int macid)
 {
 	struct wiphy *wiphy;
 	struct qtnf_wmac *mac;
 	unsigned int i;
-	int ret;
=20
 	wiphy =3D qtnf_wiphy_allocate(bus);
 	if (!wiphy)
@@ -298,15 +290,9 @@ static struct qtnf_wmac *qtnf_core_mac_alloc(struct qt=
nf_bus *bus, int macid)
 		qtnf_sta_list_init(&mac->iflist[i].sta_list);
 	}
=20
-	ret =3D qtnf_mac_add_default_intf(mac);
-	if (ret) {
-		pr_err("failed to create primary interface for mac(%d)\n",
-		       macid);
-		wiphy_free(wiphy);
-		return ERR_PTR(ret);
-	}
-
+	qtnf_mac_init_primary_intf(mac);
 	bus->mac[macid] =3D mac;
+
 	return mac;
 }
=20
@@ -317,11 +303,11 @@ int qtnf_core_net_attach(struct qtnf_wmac *mac, struc=
t qtnf_vif *vif,
 	struct wiphy *wiphy =3D priv_to_wiphy(mac);
 	struct net_device *dev;
 	void *qdev_vif;
+	int ret;
=20
 	dev =3D alloc_netdev_mqs(sizeof(struct qtnf_vif *), name,
 			       name_assign_type, ether_setup, 1, 1);
 	if (!dev) {
-		pr_err("failed to allocate net_device\n");
 		memset(&vif->wdev, 0, sizeof(vif->wdev));
 		vif->wdev.iftype =3D NL80211_IFTYPE_UNSPECIFIED;
 		return -ENOMEM;
@@ -345,14 +331,13 @@ int qtnf_core_net_attach(struct qtnf_wmac *mac, struc=
t qtnf_vif *vif,
=20
 	SET_NETDEV_DEV(dev, mac->bus->dev);
=20
-	if (register_netdevice(dev)) {
-		pr_err("failed to register virtual network device\n");
+	ret =3D register_netdevice(dev);
+	if (ret) {
 		free_netdev(dev);
 		vif->wdev.iftype =3D NL80211_IFTYPE_UNSPECIFIED;
-		return -EFAULT;
 	}
=20
-	return 0;
+	return ret;
 }
=20
 static void qtnf_core_mac_detach(struct qtnf_bus *bus, unsigned int macid)
@@ -402,66 +387,62 @@ static void qtnf_core_mac_detach(struct qtnf_bus *bus=
, unsigned int macid)
 	bus->mac[macid] =3D NULL;
 }
=20
-static int qtnf_core_mac_attach(struct qtnf_bus *bus, int macid)
+static int qtnf_core_mac_attach(struct qtnf_bus *bus, unsigned int macid)
 {
 	struct qtnf_wmac *mac;
 	struct qtnf_vif *vif;
 	int ret;
=20
-	pr_debug("starting mac(%d) init\n", macid);
-
 	if (!(bus->hw_info.mac_bitmap & BIT(macid))) {
-		pr_info("mac(%d) is not available for host operations\n",
-			macid);
+		pr_info("MAC%u is not active in FW\n", macid);
 		return 0;
 	}
=20
 	mac =3D qtnf_core_mac_alloc(bus, macid);
 	if (IS_ERR(mac)) {
-		pr_err("failed to alloc mac(%d)\n", macid);
+		pr_err("MAC%u allocation failed\n", macid);
 		return PTR_ERR(mac);
 	}
=20
 	ret =3D qtnf_cmd_get_mac_info(mac);
 	if (ret) {
-		pr_err("failed to get mac(%d) info\n", macid);
+		pr_err("MAC%u: failed to get info\n", macid);
 		goto error;
 	}
=20
 	vif =3D qtnf_mac_get_base_vif(mac);
 	if (!vif) {
-		pr_err("could not get valid vif pointer\n");
+		pr_err("MAC%u: primary VIF is not ready\n", macid);
 		ret =3D -EFAULT;
 		goto error;
 	}
=20
 	ret =3D qtnf_cmd_send_add_intf(vif, NL80211_IFTYPE_AP, vif->mac_addr);
 	if (ret) {
-		pr_err("could not add primary vif for mac(%d)\n", macid);
+		pr_err("MAC%u: failed to add VIF\n", macid);
 		goto error;
 	}
=20
 	ret =3D qtnf_cmd_send_get_phy_params(mac);
 	if (ret) {
-		pr_err("could not get phy thresholds for mac(%d)\n", macid);
+		pr_err("MAC%u: failed to get PHY settings\n", macid);
 		goto error;
 	}
=20
 	ret =3D qtnf_mac_init_bands(mac);
 	if (ret) {
-		pr_err("could not get channel info for mac(%d)\n", macid);
+		pr_err("MAC%u: failed to init bands\n", macid);
 		goto error;
 	}
=20
 	ret =3D qtnf_wiphy_register(&bus->hw_info, mac);
 	if (ret) {
-		pr_err("wiphy registration failed for mac(%d)\n", macid);
+		pr_err("MAC%u: wiphy registration failed\n", macid);
 		goto error;
 	}
=20
 	mac->wiphy_registered =3D 1;
=20
-	/* add primary networking interface */
 	rtnl_lock();
=20
 	ret =3D qtnf_core_net_attach(mac, vif, "wlan%d", NET_NAME_ENUM,
@@ -469,13 +450,14 @@ static int qtnf_core_mac_attach(struct qtnf_bus *bus,=
 int macid)
 	rtnl_unlock();
=20
 	if (ret) {
-		pr_err("could not attach primary interface for mac(%d)\n",
-		       macid);
+		pr_err("MAC%u: failed to attach netdev\n", macid);
 		vif->wdev.iftype =3D NL80211_IFTYPE_UNSPECIFIED;
 		vif->netdev =3D NULL;
 		goto error;
 	}
=20
+	pr_debug("MAC%u initialized\n", macid);
+
 	return 0;
=20
 error:
@@ -485,7 +467,7 @@ static int qtnf_core_mac_attach(struct qtnf_bus *bus, i=
nt macid)
=20
 int qtnf_core_attach(struct qtnf_bus *bus)
 {
-	int i;
+	unsigned int i;
 	int ret;
=20
 	qtnf_trans_init(bus);
@@ -504,7 +486,7 @@ int qtnf_core_attach(struct qtnf_bus *bus)
=20
 	ret =3D qtnf_cmd_send_init_fw(bus);
 	if (ret) {
-		pr_err("failed to send FW init commands\n");
+		pr_err("failed to init FW: %d\n", ret);
 		goto error;
 	}
=20
@@ -512,7 +494,7 @@ int qtnf_core_attach(struct qtnf_bus *bus)
=20
 	ret =3D qtnf_cmd_get_hw_info(bus);
 	if (ret) {
-		pr_err("failed to get HW info\n");
+		pr_err("failed to get HW info: %d\n", ret);
 		goto error;
 	}
=20
@@ -524,7 +506,7 @@ int qtnf_core_attach(struct qtnf_bus *bus)
 	}
=20
 	if (bus->hw_info.num_mac > QTNF_MAX_MAC) {
-		pr_err("FW reported invalid mac count: %d\n",
+		pr_err("no support for number of MACs=3D%u\n",
 		       bus->hw_info.num_mac);
 		ret =3D -ERANGE;
 		goto error;
@@ -534,7 +516,7 @@ int qtnf_core_attach(struct qtnf_bus *bus)
 		ret =3D qtnf_core_mac_attach(bus, i);
=20
 		if (ret) {
-			pr_err("mac(%d) init failed\n", i);
+			pr_err("MAC%u: attach failed: %d\n", i, ret);
 			goto error;
 		}
 	}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/w=
ireless/quantenna/qtnfmac/event.c
index e3bcb92cea90..9b61e9a83670 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -41,25 +41,28 @@ qtnf_event_handle_sta_assoc(struct qtnf_wmac *mac, stru=
ct qtnf_vif *vif,
 	const struct qlink_tlv_hdr *tlv;
=20
 	if (unlikely(len < sizeof(*sta_assoc))) {
-		pr_err("payload is too short (%u < %zu)\n",
-		       len, sizeof(*sta_assoc));
+		pr_err("VIF%u.%u: payload is too short (%u < %zu)\n",
+		       mac->macid, vif->vifid, len, sizeof(*sta_assoc));
 		return -EINVAL;
 	}
=20
 	if (vif->wdev.iftype !=3D NL80211_IFTYPE_AP) {
-		pr_err("STA_ASSOC event when not in AP mode\n");
+		pr_err("VIF%u.%u: STA_ASSOC event when not in AP mode\n",
+		       mac->macid, vif->vifid);
 		return -EPROTO;
 	}
=20
 	if (!(vif->bss_status & QTNF_STATE_AP_START)) {
-		pr_err("STA_ASSOC event when AP is not started\n");
+		pr_err("VIF%u.%u: STA_ASSOC event when AP is not started\n",
+		       mac->macid, vif->vifid);
 		return -EPROTO;
 	}
=20
 	sta_addr =3D sta_assoc->sta_addr;
 	frame_control =3D le16_to_cpu(sta_assoc->frame_control);
=20
-	pr_debug("MAC:%pM FC:%x\n", sta_addr, frame_control);
+	pr_debug("VIF%u.%u: MAC:%pM FC:%x\n", mac->macid, vif->vifid, sta_addr,
+		 frame_control);
=20
 	qtnf_sta_list_add(&vif->sta_list, sta_addr);
=20
@@ -75,8 +78,9 @@ qtnf_event_handle_sta_assoc(struct qtnf_wmac *mac, struct=
 qtnf_vif *vif,
 		tlv_full_len =3D tlv_value_len + sizeof(struct qlink_tlv_hdr);
=20
 		if (tlv_full_len > payload_len) {
-			pr_warn("malformed TLV 0x%.2X; LEN: %u\n",
-				tlv_type, tlv_value_len);
+			pr_warn("VIF%u.%u: malformed TLV 0x%.2X; LEN: %u\n",
+				mac->macid, vif->vifid, tlv_type,
+				tlv_value_len);
 			return -EINVAL;
 		}
=20
@@ -90,7 +94,8 @@ qtnf_event_handle_sta_assoc(struct qtnf_wmac *mac, struct=
 qtnf_vif *vif,
 	}
=20
 	if (payload_len) {
-		pr_warn("malformed TLV buf; bytes left: %zu\n", payload_len);
+		pr_warn("VIF%u.%u: malformed TLV buf; bytes left: %zu\n",
+			mac->macid, vif->vifid, payload_len);
 		return -EINVAL;
 	}
=20
@@ -109,25 +114,29 @@ qtnf_event_handle_sta_deauth(struct qtnf_wmac *mac, s=
truct qtnf_vif *vif,
 	u16 reason;
=20
 	if (unlikely(len < sizeof(*sta_deauth))) {
-		pr_err("payload is too short (%u < %zu)\n", len,
+		pr_err("VIF%u.%u: payload is too short (%u < %zu)\n",
+		       mac->macid, vif->vifid, len,
 		       sizeof(struct qlink_event_sta_deauth));
 		return -EINVAL;
 	}
=20
 	if (vif->wdev.iftype !=3D NL80211_IFTYPE_AP) {
-		pr_err("STA_DEAUTH event when not in AP mode\n");
+		pr_err("VIF%u.%u: STA_DEAUTH event when not in AP mode\n",
+		       mac->macid, vif->vifid);
 		return -EPROTO;
 	}
=20
 	if (!(vif->bss_status & QTNF_STATE_AP_START)) {
-		pr_err("STA_DEAUTH event when AP is not started\n");
+		pr_err("VIF%u.%u: STA_DEAUTH event when AP is not started\n",
+		       mac->macid, vif->vifid);
 		return -EPROTO;
 	}
=20
 	sta_addr =3D sta_deauth->sta_addr;
 	reason =3D le16_to_cpu(sta_deauth->reason);
=20
-	pr_debug("MAC:%pM; reason:%x\n", sta_addr, reason);
+	pr_debug("VIF%u.%u: MAC:%pM reason:%x\n", mac->macid, vif->vifid,
+		 sta_addr, reason);
=20
 	if (qtnf_sta_list_del(&vif->sta_list, sta_addr))
 		cfg80211_del_sta(vif->netdev, sta_deauth->sta_addr,
@@ -142,22 +151,26 @@ qtnf_event_handle_bss_join(struct qtnf_vif *vif,
 			   u16 len)
 {
 	if (unlikely(len < sizeof(*join_info))) {
-		pr_err("payload is too short (%u < %zu)\n", len,
+		pr_err("VIF%u.%u: payload is too short (%u < %zu)\n",
+		       vif->mac->macid, vif->vifid, len,
 		       sizeof(struct qlink_event_bss_join));
 		return -EINVAL;
 	}
=20
 	if (vif->wdev.iftype !=3D NL80211_IFTYPE_STATION) {
-		pr_err("BSS_JOIN event when not in STA mode\n");
+		pr_err("VIF%u.%u: BSS_JOIN event when not in STA mode\n",
+		       vif->mac->macid, vif->vifid);
 		return -EPROTO;
 	}
=20
 	if (vif->sta_state !=3D QTNF_STA_CONNECTING) {
-		pr_err("BSS_JOIN event when STA is not connecting\n");
+		pr_err("VIF%u.%u: BSS_JOIN event when STA is not connecting\n",
+		       vif->mac->macid, vif->vifid);
 		return -EPROTO;
 	}
=20
-	pr_debug("BSSID:%pM\n", join_info->bssid);
+	pr_debug("VIF%u.%u: BSSID:%pM\n", vif->mac->macid, vif->vifid,
+		 join_info->bssid);
=20
 	cfg80211_connect_result(vif->netdev, join_info->bssid, NULL, 0, NULL,
 				0, le16_to_cpu(join_info->status), GFP_KERNEL);
@@ -178,22 +191,25 @@ qtnf_event_handle_bss_leave(struct qtnf_vif *vif,
 			    u16 len)
 {
 	if (unlikely(len < sizeof(*leave_info))) {
-		pr_err("payload is too short (%u < %zu)\n", len,
+		pr_err("VIF%u.%u: payload is too short (%u < %zu)\n",
+		       vif->mac->macid, vif->vifid, len,
 		       sizeof(struct qlink_event_bss_leave));
 		return -EINVAL;
 	}
=20
 	if (vif->wdev.iftype !=3D NL80211_IFTYPE_STATION) {
-		pr_err("BSS_LEAVE event when not in STA mode\n");
+		pr_err("VIF%u.%u: BSS_LEAVE event when not in STA mode\n",
+		       vif->mac->macid, vif->vifid);
 		return -EPROTO;
 	}
=20
 	if (vif->sta_state !=3D QTNF_STA_CONNECTED) {
-		pr_err("BSS_LEAVE event when STA is not connected\n");
+		pr_err("VIF%u.%u: BSS_LEAVE event when STA is not connected\n",
+		       vif->mac->macid, vif->vifid);
 		return -EPROTO;
 	}
=20
-	pr_debug("disconnected\n");
+	pr_debug("VIF%u.%u: disconnected\n", vif->mac->macid, vif->vifid);
=20
 	cfg80211_disconnected(vif->netdev, leave_info->reason, NULL, 0, 0,
 			      GFP_KERNEL);
@@ -216,7 +232,8 @@ qtnf_event_handle_mgmt_received(struct qtnf_vif *vif,
 	enum nl80211_rxmgmt_flags flags =3D 0;
=20
 	if (unlikely(len < min_len)) {
-		pr_err("payload is too short (%u < %zu)\n", len, min_len);
+		pr_err("VIF%u.%u: payload is too short (%u < %zu)\n",
+		       vif->mac->macid, vif->vifid, len, min_len);
 		return -EINVAL;
 	}
=20
@@ -252,13 +269,15 @@ qtnf_event_handle_scan_results(struct qtnf_vif *vif,
 	size_t ies_len =3D 0;
=20
 	if (len < sizeof(*sr)) {
-		pr_err("payload is too short\n");
+		pr_err("VIF%u.%u: payload is too short\n", vif->mac->macid,
+		       vif->vifid);
 		return -EINVAL;
 	}
=20
 	channel =3D ieee80211_get_channel(wiphy, le16_to_cpu(sr->freq));
 	if (!channel) {
-		pr_err("channel at %u MHz not found\n", le16_to_cpu(sr->freq));
+		pr_err("VIF%u.%u: channel at %u MHz not found\n",
+		       vif->mac->macid, vif->vifid, le16_to_cpu(sr->freq));
 		return -EINVAL;
 	}
=20
@@ -282,8 +301,9 @@ qtnf_event_handle_scan_results(struct qtnf_vif *vif,
 		tlv_full_len =3D tlv_value_len + sizeof(struct qlink_tlv_hdr);
=20
 		if (tlv_full_len > payload_len) {
-			pr_warn("malformed TLV 0x%.2X; LEN: %u\n",
-				tlv_type, tlv_value_len);
+			pr_warn("VIF%u.%u: malformed TLV 0x%.2X; LEN: %u\n",
+				vif->mac->macid, vif->vifid, tlv_type,
+				tlv_value_len);
 			return -EINVAL;
 		}
=20
@@ -297,7 +317,8 @@ qtnf_event_handle_scan_results(struct qtnf_vif *vif,
 	}
=20
 	if (payload_len) {
-		pr_warn("malformed TLV buf; bytes left: %zu\n", payload_len);
+		pr_warn("VIF%u.%u: malformed TLV buf; bytes left: %zu\n",
+			vif->mac->macid, vif->vifid, payload_len);
 		return -EINVAL;
 	}
=20
@@ -320,7 +341,7 @@ qtnf_event_handle_scan_complete(struct qtnf_wmac *mac,
 				u16 len)
 {
 	if (len < sizeof(*status)) {
-		pr_err("payload is too short\n");
+		pr_err("MAC%u: payload is too short\n", mac->macid);
 		return -EINVAL;
 	}
=20
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/=
net/wireless/quantenna/qtnfmac/pearl/pcie.c
index 70d14aaceb1f..4814d90c8040 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -1037,7 +1037,7 @@ static int qtnf_bringup_fw(struct qtnf_bus *bus)
 		pr_info("Booting FW from flash\n");
=20
 		if (!qtnf_poll_state(&priv->bda->bda_ep_state, QTN_EP_FW_DONE,
-				    QTN_FW_DL_TIMEOUT_MS))
+				     QTN_FW_DL_TIMEOUT_MS))
 			bus->fw_state =3D QTNF_FW_STATE_FW_DNLD_DONE;
=20
 		return 0;
