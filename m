Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36473 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751039AbcI0K5b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 06:57:31 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>, <hostap@lists.shmoo.com>
CC: <yangzy@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        lihz <lihz@marvell.com>, Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] cfg80211: add key management offload feature
Date: Tue, 27 Sep 2016 16:26:35 +0530
Message-ID: <1474973796-1873-1-git-send-email-akarwar@marvell.com> (sfid-20160927_125737_815734_5AE7ADB1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: lihz <lihz@marvell.com>

This patch adds key management offload feature. It needs to be
advertised through NL80211_EXT_FEATURE_KEY_MGMT_OFFLOAD flag.
Existing cfg80211_roamed API has been extended to report keys
for roaming offload.

Signed-off-by: Huazeng Li <lihz@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |  3 ++-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  3 ++-
 drivers/net/wireless/rndis_wlan.c                  |  3 ++-
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c  |  2 +-
 drivers/staging/wlan-ng/cfg80211.c                 |  2 +-
 include/linux/ieee80211.h                          |  3 +++
 include/net/cfg80211.h                             |  8 +++++--
 include/uapi/linux/nl80211.h                       | 11 +++++++++
 net/wireless/core.h                                |  8 ++++++-
 net/wireless/nl80211.c                             | 19 ++++++++++++++--
 net/wireless/nl80211.h                             |  4 +++-
 net/wireless/sme.c                                 | 26 +++++++++++++++++-----
 net/wireless/util.c                                |  4 +++-
 13 files changed, 79 insertions(+), 17 deletions(-)
 mode change 100644 => 100755 net/wireless/nl80211.c

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index b7fe0af..9511f73 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -809,7 +809,8 @@ void ath6kl_cfg80211_connect_event(struct ath6kl_vif *vif, u16 channel,
 	} else if (vif->sme_state == SME_CONNECTED) {
 		/* inform roam event to cfg80211 */
 		cfg80211_roamed_bss(vif->ndev, bss, assoc_req_ie, assoc_req_len,
-				    assoc_resp_ie, assoc_resp_len, GFP_KERNEL);
+				    assoc_resp_ie, assoc_resp_len, GFP_KERNEL,
+				    NULL, NULL, NULL, 0);
 	}
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 748eaa6..5934b77 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5450,7 +5450,8 @@ done:
 	kfree(buf);
 	cfg80211_roamed(ndev, notify_channel, (u8 *)profile->bssid,
 			conn_info->req_ie, conn_info->req_ie_len,
-			conn_info->resp_ie, conn_info->resp_ie_len, GFP_KERNEL);
+			conn_info->resp_ie, conn_info->resp_ie_len, GFP_KERNEL,
+			NULL, NULL, NULL, 0);
 	brcmf_dbg(CONN, "Report roaming result\n");
 
 	set_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state);
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 603c904..ad9535f 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2838,7 +2838,8 @@ static void rndis_wlan_do_link_up_work(struct usbnet *usbdev)
 			cfg80211_roamed(usbdev->net,
 					get_current_channel(usbdev, NULL),
 					bssid, req_ie, req_ie_len,
-					resp_ie, resp_ie_len, GFP_KERNEL);
+					resp_ie, resp_ie_len, GFP_KERNEL,
+					NULL, NULL, NULL, 0);
 	} else if (priv->infra_mode == NDIS_80211_INFRA_ADHOC)
 		cfg80211_ibss_joined(usbdev->net, bssid,
 				     get_current_channel(usbdev, NULL),
diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
index d0ba377..e74216a 100644
--- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
@@ -341,7 +341,7 @@ void rtw_cfg80211_indicate_connect(struct rtw_adapter *padapter)
 				sizeof(struct ieee80211_hdr_3addr) + 6,
 				pmlmepriv->assoc_rsp_len -
 				sizeof(struct ieee80211_hdr_3addr) - 6,
-				GFP_ATOMIC);
+				GFP_ATOMIC, NULL, NULL, NULL, 0);
 	} else {
 		cfg80211_connect_result(padapter->pnetdev,
 					cur_network->network.MacAddress,
diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index f46dfe6..178d955 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -722,7 +722,7 @@ void prism2_disconnected(wlandevice_t *wlandev)
 void prism2_roamed(wlandevice_t *wlandev)
 {
 	cfg80211_roamed(wlandev->netdev, NULL, wlandev->bssid,
-		NULL, 0, NULL, 0, GFP_KERNEL);
+		NULL, 0, NULL, 0, GFP_KERNEL, NULL, NULL, NULL, 0);
 }
 
 /* Structures for declaring wiphy interface */
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index a80516f..8cf3535 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2312,6 +2312,9 @@ enum ieee80211_sa_query_action {
 #define WLAN_CIPHER_SUITE_BIP_CMAC_256	0x000FAC0D
 
 #define WLAN_CIPHER_SUITE_SMS4		0x00147201
+#define WLAN_CIPHER_SUITE_PMK           0x00147202
+#define WLAN_CIPHER_SUITE_PMK_R0        0x00147203
+#define WLAN_CIPHER_SUITE_PMK_R0_NAME   0x00147204
 
 /* AKM suite selectors */
 #define WLAN_AKM_SUITE_8021X		0x000FAC01
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ed37304..817df07 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4865,7 +4865,9 @@ void cfg80211_roamed(struct net_device *dev,
 		     struct ieee80211_channel *channel,
 		     const u8 *bssid,
 		     const u8 *req_ie, size_t req_ie_len,
-		     const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp);
+		     const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp,
+		     const u8 *key_replay_ctr, const u8 *ptk_kck,
+		     const u8 *ptk_kek, const u8 authorized);
 
 /**
  * cfg80211_roamed_bss - notify cfg80211 of roaming
@@ -4891,7 +4893,9 @@ void cfg80211_roamed(struct net_device *dev,
  */
 void cfg80211_roamed_bss(struct net_device *dev, struct cfg80211_bss *bss,
 			 const u8 *req_ie, size_t req_ie_len,
-			 const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp);
+			 const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp,
+			 const u8 *key_replay_ctr, const u8 *ptk_kck,
+			 const u8 *ptk_kek, const u8 authorized);
 
 /**
  * cfg80211_disconnected - notify cfg80211 that connection was dropped
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index ec10d1b..c56df53 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1873,6 +1873,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_MESH_PEER_AID: Association ID for the mesh peer (u16). This is
  *	used to pull the stored data for mesh peer in power save state.
  *
+ * @NL80211_ATTR_AUTHORIZED: flag attribute, if set indicates that the
+ *      connection is authorized.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2267,6 +2270,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MESH_PEER_AID,
 
+	NL80211_ATTR_AUTHORIZED,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3687,6 +3692,9 @@ enum nl80211_key_attributes {
 	NL80211_KEY_DEFAULT_MGMT,
 	NL80211_KEY_TYPE,
 	NL80211_KEY_DEFAULT_TYPES,
+	NL80211_KEY_REPLAY_CTR,
+	NL80211_KEY_KCK,
+	NL80211_KEY_KEK,
 
 	/* keep last */
 	__NL80211_KEY_AFTER_LAST,
@@ -4563,6 +4571,8 @@ enum nl80211_feature_flags {
  *	configuration (AP/mesh) with HT rates.
  * @NL80211_EXT_FEATURE_BEACON_RATE_VHT: Driver supports beacon rate
  *	configuration (AP/mesh) with VHT rates.
+ * @NL80211_EXT_FEATURE_KEY_MGMT_OFFLOAD: This driver supports key management
+ *	auth offload.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -4577,6 +4587,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_BEACON_RATE_LEGACY,
 	NL80211_EXT_FEATURE_BEACON_RATE_HT,
 	NL80211_EXT_FEATURE_BEACON_RATE_VHT,
+	NL80211_EXT_FEATURE_KEY_MGMT_OFFLOAD,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 5555e3c..bd9914b2 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -231,8 +231,12 @@ struct cfg80211_event {
 		struct {
 			const u8 *req_ie;
 			const u8 *resp_ie;
+			const u8 *key_replay_ctr;
+			const u8 *key_kck;
+			const u8 *key_kek;
 			size_t req_ie_len;
 			size_t resp_ie_len;
+			u8 authorized;
 			struct cfg80211_bss *bss;
 		} rm;
 		struct {
@@ -396,7 +400,9 @@ int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 void __cfg80211_roamed(struct wireless_dev *wdev,
 		       struct cfg80211_bss *bss,
 		       const u8 *req_ie, size_t req_ie_len,
-		       const u8 *resp_ie, size_t resp_ie_len);
+		       const u8 *resp_ie, size_t resp_ie_len,
+		       const u8 authorized, const u8 *key_replay_ctr,
+		       const u8 *key_kck, const u8 *key_kek);
 int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
old mode 100644
new mode 100755
index b8441e6..06754f9
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -928,7 +928,9 @@ static int nl80211_key_allowed(struct wireless_dev *wdev)
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
-		if (!wdev->current_bss)
+		if (!wdev->current_bss &&
+		    !wiphy_ext_feature_isset(wdev->wiphy,
+		    NL80211_EXT_FEATURE_KEY_MGMT_OFFLOAD))
 			return -ENOLINK;
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
@@ -12481,7 +12483,9 @@ void nl80211_send_connect_result(struct cfg80211_registered_device *rdev,
 void nl80211_send_roamed(struct cfg80211_registered_device *rdev,
 			 struct net_device *netdev, const u8 *bssid,
 			 const u8 *req_ie, size_t req_ie_len,
-			 const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp)
+			 const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp,
+			 const u8 authorized, const u8 *key_replay_ctr,
+			 const u8 *key_kck, const u8 *key_kek)
 {
 	struct sk_buff *msg;
 	void *hdr;
@@ -12505,6 +12509,17 @@ void nl80211_send_roamed(struct cfg80211_registered_device *rdev,
 	     nla_put(msg, NL80211_ATTR_RESP_IE, resp_ie_len, resp_ie)))
 		goto nla_put_failure;
 
+	if (wiphy_ext_feature_isset(&rdev->wiphy,
+				    NL80211_EXT_FEATURE_KEY_MGMT_OFFLOAD) &&
+	    (nla_put_u8(msg, NL80211_ATTR_AUTHORIZED, authorized) ||
+	    (key_replay_ctr && nla_put(msg, NL80211_KEY_REPLAY_CTR,
+	     NL80211_REPLAY_CTR_LEN, key_replay_ctr)) ||
+	    (key_kck &&
+	     nla_put(msg, NL80211_KEY_KCK, NL80211_KCK_LEN, key_kck)) ||
+	    (key_kek &&
+	     nla_put(msg, NL80211_KEY_KEK, NL80211_KEK_LEN, key_kek))))
+		goto nla_put_failure;
+
 	genlmsg_end(msg, hdr);
 
 	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 7e3821d..5d2fe3a 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -62,7 +62,9 @@ void nl80211_send_connect_result(struct cfg80211_registered_device *rdev,
 void nl80211_send_roamed(struct cfg80211_registered_device *rdev,
 			 struct net_device *netdev, const u8 *bssid,
 			 const u8 *req_ie, size_t req_ie_len,
-			 const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp);
+			 const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp,
+			 const u8 authorized, const u8 *key_replay_ctr,
+			 const u8 *key_kck, const u8 *key_kek);
 void nl80211_send_disconnected(struct cfg80211_registered_device *rdev,
 			       struct net_device *netdev, u16 reason,
 			       const u8 *ie, size_t ie_len, bool from_ap);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index c08a3b5..a6ddbb4 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -807,7 +807,9 @@ EXPORT_SYMBOL(cfg80211_connect_bss);
 void __cfg80211_roamed(struct wireless_dev *wdev,
 		       struct cfg80211_bss *bss,
 		       const u8 *req_ie, size_t req_ie_len,
-		       const u8 *resp_ie, size_t resp_ie_len)
+		       const u8 *resp_ie, size_t resp_ie_len,
+		       const u8 authorized, const u8 *key_replay_ctr,
+		       const u8 *key_kck, const u8 *key_kek)
 {
 #ifdef CONFIG_CFG80211_WEXT
 	union iwreq_data wrqu;
@@ -831,7 +833,8 @@ void __cfg80211_roamed(struct wireless_dev *wdev,
 	nl80211_send_roamed(wiphy_to_rdev(wdev->wiphy),
 			    wdev->netdev, bss->bssid,
 			    req_ie, req_ie_len, resp_ie, resp_ie_len,
-			    GFP_KERNEL);
+			    GFP_KERNEL, authorized, key_replay_ctr,
+			    key_kck, key_kek);
 
 #ifdef CONFIG_CFG80211_WEXT
 	if (req_ie) {
@@ -865,7 +868,9 @@ void cfg80211_roamed(struct net_device *dev,
 		     struct ieee80211_channel *channel,
 		     const u8 *bssid,
 		     const u8 *req_ie, size_t req_ie_len,
-		     const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp)
+		     const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp,
+		     const u8 *key_replay_ctr, const u8 *ptk_kck,
+		     const u8 *ptk_kek, const u8 authorized)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_bss *bss;
@@ -877,7 +882,8 @@ void cfg80211_roamed(struct net_device *dev,
 		return;
 
 	cfg80211_roamed_bss(dev, bss, req_ie, req_ie_len, resp_ie,
-			    resp_ie_len, gfp);
+			    resp_ie_len, gfp, key_replay_ctr, ptk_kck,
+			    ptk_kek, authorized);
 }
 EXPORT_SYMBOL(cfg80211_roamed);
 
@@ -885,7 +891,9 @@ EXPORT_SYMBOL(cfg80211_roamed);
 void cfg80211_roamed_bss(struct net_device *dev,
 			 struct cfg80211_bss *bss, const u8 *req_ie,
 			 size_t req_ie_len, const u8 *resp_ie,
-			 size_t resp_ie_len, gfp_t gfp)
+			 size_t resp_ie_len, gfp_t gfp,
+			 const u8 *key_replay_ctr, const u8 *ptk_kck,
+			 const u8 *ptk_kek, const u8 authorized)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
@@ -908,6 +916,14 @@ void cfg80211_roamed_bss(struct net_device *dev,
 	ev->rm.resp_ie = ((u8 *)ev) + sizeof(*ev) + req_ie_len;
 	ev->rm.resp_ie_len = resp_ie_len;
 	memcpy((void *)ev->rm.resp_ie, resp_ie, resp_ie_len);
+	ev->rm.key_replay_ctr = ((u8 *)ev) + sizeof(*ev) + resp_ie_len;
+	memcpy((void *)ev->rm.key_replay_ctr, key_replay_ctr,
+	       NL80211_REPLAY_CTR_LEN);
+	ev->rm.key_kck = ((u8 *)ev) + sizeof(*ev) + NL80211_REPLAY_CTR_LEN;
+	memcpy((void *)ev->rm.key_kck, ptk_kck, NL80211_KCK_LEN);
+	ev->rm.key_kek = ((u8 *)ev) + sizeof(*ev) + NL80211_KCK_LEN;
+	memcpy((void *)ev->rm.key_kek, ptk_kek, NL80211_KEK_LEN);
+	ev->rm.authorized = authorized;
 	ev->rm.bss = bss;
 
 	spin_lock_irqsave(&wdev->event_lock, flags);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 9e6e2aa..30c4628 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -960,7 +960,9 @@ void cfg80211_process_wdev_events(struct wireless_dev *wdev)
 		case EVENT_ROAMED:
 			__cfg80211_roamed(wdev, ev->rm.bss, ev->rm.req_ie,
 					  ev->rm.req_ie_len, ev->rm.resp_ie,
-					  ev->rm.resp_ie_len);
+					  ev->rm.resp_ie_len, ev->rm.authorized,
+					  ev->rm.key_replay_ctr, ev->rm.key_kck,
+					  ev->rm.key_kek);
 			break;
 		case EVENT_DISCONNECTED:
 			__cfg80211_disconnected(wdev->netdev,
-- 
1.9.1
