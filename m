Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:59180 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035Ab1EPQkj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 12:40:39 -0400
Date: Mon, 16 May 2011 19:40:15 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Greg KH <greg@kroah.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH] cfg80211: Use consistent BSS matching between scan and sme
Message-ID: <20110516164015.GA24473@jm.kir.nu> (sfid-20110516_184042_986587_2BD75DC9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jouni Malinen <jouni.malinen@atheros.com>

cfg80211 scan code adds separate BSS entries if the same BSS shows up
on multiple channels. However, sme implementation does not use the
frequency when fetching the BSS entry. Fix this by adding channel
information to cfg80211_roamed() and include it in cfg80211_get_bss()
calls.

Please note that drivers using cfg80211_roamed() need to be modified to
fully implement this fix. This commit includes only minimal changes to
avoid compilation issues; it maintains the old (broken) behavior for
most drivers. ath6kl was the only one that I could test, so I updated
it to provide the operating frequency in the roamed event.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
---
 drivers/net/wireless/iwmc3200wifi/rx.c           |    4 ++--
 drivers/net/wireless/rndis_wlan.c                |    3 ++-
 drivers/staging/ath6kl/os/linux/cfg80211.c       |    2 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    4 ++--
 drivers/staging/wlan-ng/cfg80211.c               |    2 +-
 include/net/cfg80211.h                           |    5 ++++-
 net/wireless/core.h                              |    5 ++++-
 net/wireless/sme.c                               |   19 ++++++++++++++-----
 net/wireless/util.c                              |    2 +-
 9 files changed, 31 insertions(+), 15 deletions(-)

This change in cfg80211_roamed() parameters applies both to staging and
non-staging drivers and both of those are being updated with a single
commit. This patch seems to apply to the current snapshots of
wireless-testing.git and staging-2.6.git (staging-next branch), so I
hope that the changes to the staging drivers go through without
conflicts even though those would normally go through a different tree.


--- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/rx.c	2011-05-16 19:28:36.000000000 +0300
+++ wireless-testing/drivers/net/wireless/iwmc3200wifi/rx.c	2011-05-16 19:29:00.000000000 +0300
@@ -565,7 +565,7 @@ static int iwm_mlme_assoc_complete(struc
 		if (!test_and_clear_bit(IWM_STATUS_SME_CONNECTING, &iwm->status)
 		    && iwm->conf.mode == UMAC_MODE_BSS) {
 			cancel_delayed_work(&iwm->disconnect);
-			cfg80211_roamed(iwm_to_ndev(iwm),
+			cfg80211_roamed(iwm_to_ndev(iwm), NULL,
 					complete->bssid,
 					iwm->req_ie, iwm->req_ie_len,
 					iwm->resp_ie, iwm->resp_ie_len,
@@ -586,7 +586,7 @@ static int iwm_mlme_assoc_complete(struc
 						WLAN_STATUS_SUCCESS,
 						GFP_KERNEL);
 		else
-			cfg80211_roamed(iwm_to_ndev(iwm),
+			cfg80211_roamed(iwm_to_ndev(iwm), NULL,
 					complete->bssid,
 					iwm->req_ie, iwm->req_ie_len,
 					iwm->resp_ie, iwm->resp_ie_len,
--- wireless-testing.orig/drivers/net/wireless/rndis_wlan.c	2011-05-16 19:28:36.000000000 +0300
+++ wireless-testing/drivers/net/wireless/rndis_wlan.c	2011-05-16 19:29:00.000000000 +0300
@@ -2830,7 +2830,8 @@ static void rndis_wlan_do_link_up_work(s
 						req_ie_len, resp_ie,
 						resp_ie_len, 0, GFP_KERNEL);
 		else
-			cfg80211_roamed(usbdev->net, bssid, req_ie, req_ie_len,
+			cfg80211_roamed(usbdev->net, NULL, bssid,
+					req_ie, req_ie_len,
 					resp_ie, resp_ie_len, GFP_KERNEL);
 	} else if (priv->infra_mode == NDIS_80211_INFRA_ADHOC)
 		cfg80211_ibss_joined(usbdev->net, bssid, GFP_KERNEL);
--- wireless-testing.orig/drivers/staging/ath6kl/os/linux/cfg80211.c	2011-05-16 19:28:36.000000000 +0300
+++ wireless-testing/drivers/staging/ath6kl/os/linux/cfg80211.c	2011-05-16 19:29:00.000000000 +0300
@@ -570,7 +570,7 @@ ar6k_cfg80211_connect_event(struct ar6_s
                                 WLAN_STATUS_SUCCESS, GFP_KERNEL);
     } else {
         /* inform roam event to cfg80211 */
-        cfg80211_roamed(ar->arNetDev, bssid,
+	cfg80211_roamed(ar->arNetDev, ibss_channel, bssid,
                         assocReqIe, assocReqLen,
                         assocRespIe, assocRespLen,
                         GFP_KERNEL);
--- wireless-testing.orig/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c	2011-05-16 19:28:36.000000000 +0300
+++ wireless-testing/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c	2011-05-16 19:29:00.000000000 +0300
@@ -2630,7 +2630,7 @@ wl_bss_roaming_done(struct wl_priv *wl,
 	wl_get_assoc_ies(wl);
 	memcpy(&wl->bssid, &e->addr, ETH_ALEN);
 	wl_update_bss_info(wl);
-	cfg80211_roamed(ndev,
+	cfg80211_roamed(ndev, NULL,
 			(u8 *)&wl->bssid,
 			conn_info->req_ie, conn_info->req_ie_len,
 			conn_info->resp_ie, conn_info->resp_ie_len, GFP_KERNEL);
@@ -2663,7 +2663,7 @@ wl_bss_connect_done(struct wl_priv *wl,
 		WL_DBG("Report connect result - connection %s\n",
 		       completed ? "succeeded" : "failed");
 	} else {
-		cfg80211_roamed(ndev,
+		cfg80211_roamed(ndev, NULL,
 				(u8 *)&wl->bssid,
 				conn_info->req_ie, conn_info->req_ie_len,
 				conn_info->resp_ie, conn_info->resp_ie_len,
--- wireless-testing.orig/drivers/staging/wlan-ng/cfg80211.c	2011-05-16 19:28:36.000000000 +0300
+++ wireless-testing/drivers/staging/wlan-ng/cfg80211.c	2011-05-16 19:29:00.000000000 +0300
@@ -695,7 +695,7 @@ void prism2_disconnected(wlandevice_t *w
 
 void prism2_roamed(wlandevice_t *wlandev)
 {
-	cfg80211_roamed(wlandev->netdev, wlandev->bssid,
+	cfg80211_roamed(wlandev->netdev, NULL, wlandev->bssid,
 		NULL, 0, NULL, 0, GFP_KERNEL);
 }
 
--- wireless-testing.orig/include/net/cfg80211.h	2011-05-16 19:28:36.000000000 +0300
+++ wireless-testing/include/net/cfg80211.h	2011-05-16 19:29:00.000000000 +0300
@@ -2878,6 +2878,7 @@ void cfg80211_connect_result(struct net_
  * cfg80211_roamed - notify cfg80211 of roaming
  *
  * @dev: network device
+ * @channel: the channel of the new AP
  * @bssid: the BSSID of the new AP
  * @req_ie: association request IEs (maybe be %NULL)
  * @req_ie_len: association request IEs length
@@ -2888,7 +2889,9 @@ void cfg80211_connect_result(struct net_
  * It should be called by the underlying driver whenever it roamed
  * from one AP to another while connected.
  */
-void cfg80211_roamed(struct net_device *dev, const u8 *bssid,
+void cfg80211_roamed(struct net_device *dev,
+		     struct ieee80211_channel *channel,
+		     const u8 *bssid,
 		     const u8 *req_ie, size_t req_ie_len,
 		     const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp);
 
--- wireless-testing.orig/net/wireless/core.h	2011-05-16 19:28:36.000000000 +0300
+++ wireless-testing/net/wireless/core.h	2011-05-16 19:29:00.000000000 +0300
@@ -245,6 +245,7 @@ struct cfg80211_event {
 			u16 status;
 		} cr;
 		struct {
+			struct ieee80211_channel *channel;
 			u8 bssid[ETH_ALEN];
 			const u8 *req_ie;
 			const u8 *resp_ie;
@@ -392,7 +393,9 @@ int __cfg80211_disconnect(struct cfg8021
 int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, u16 reason,
 			bool wextev);
-void __cfg80211_roamed(struct wireless_dev *wdev, const u8 *bssid,
+void __cfg80211_roamed(struct wireless_dev *wdev,
+		       struct ieee80211_channel *channel,
+		       const u8 *bssid,
 		       const u8 *req_ie, size_t req_ie_len,
 		       const u8 *resp_ie, size_t resp_ie_len);
 int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
--- wireless-testing.orig/net/wireless/sme.c	2011-05-16 19:28:36.000000000 +0300
+++ wireless-testing/net/wireless/sme.c	2011-05-16 19:29:00.000000000 +0300
@@ -250,7 +250,8 @@ static struct cfg80211_bss *cfg80211_get
 	if (wdev->conn->params.privacy)
 		capa |= WLAN_CAPABILITY_PRIVACY;
 
-	bss = cfg80211_get_bss(wdev->wiphy, NULL, wdev->conn->params.bssid,
+	bss = cfg80211_get_bss(wdev->wiphy, wdev->conn->params.channel,
+			       wdev->conn->params.bssid,
 			       wdev->conn->params.ssid,
 			       wdev->conn->params.ssid_len,
 			       WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_PRIVACY,
@@ -470,7 +471,10 @@ void __cfg80211_connect_result(struct ne
 	}
 
 	if (!bss)
-		bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
+		bss = cfg80211_get_bss(wdev->wiphy,
+				       wdev->conn ? wdev->conn->params.channel :
+				       NULL,
+				       bssid,
 				       wdev->ssid, wdev->ssid_len,
 				       WLAN_CAPABILITY_ESS,
 				       WLAN_CAPABILITY_ESS);
@@ -538,7 +542,9 @@ void cfg80211_connect_result(struct net_
 }
 EXPORT_SYMBOL(cfg80211_connect_result);
 
-void __cfg80211_roamed(struct wireless_dev *wdev, const u8 *bssid,
+void __cfg80211_roamed(struct wireless_dev *wdev,
+		       struct ieee80211_channel *channel,
+		       const u8 *bssid,
 		       const u8 *req_ie, size_t req_ie_len,
 		       const u8 *resp_ie, size_t resp_ie_len)
 {
@@ -565,7 +571,7 @@ void __cfg80211_roamed(struct wireless_d
 	cfg80211_put_bss(&wdev->current_bss->pub);
 	wdev->current_bss = NULL;
 
-	bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
+	bss = cfg80211_get_bss(wdev->wiphy, channel, bssid,
 			       wdev->ssid, wdev->ssid_len,
 			       WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
 
@@ -603,7 +609,9 @@ void __cfg80211_roamed(struct wireless_d
 #endif
 }
 
-void cfg80211_roamed(struct net_device *dev, const u8 *bssid,
+void cfg80211_roamed(struct net_device *dev,
+		     struct ieee80211_channel *channel,
+		     const u8 *bssid,
 		     const u8 *req_ie, size_t req_ie_len,
 		     const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp)
 {
@@ -619,6 +627,7 @@ void cfg80211_roamed(struct net_device *
 		return;
 
 	ev->type = EVENT_ROAMED;
+	ev->rm.channel = channel;
 	memcpy(ev->rm.bssid, bssid, ETH_ALEN);
 	ev->rm.req_ie = ((u8 *)ev) + sizeof(*ev);
 	ev->rm.req_ie_len = req_ie_len;
--- wireless-testing.orig/net/wireless/util.c	2011-05-16 19:28:36.000000000 +0300
+++ wireless-testing/net/wireless/util.c	2011-05-16 19:29:00.000000000 +0300
@@ -746,7 +746,7 @@ static void cfg80211_process_wdev_events
 				NULL);
 			break;
 		case EVENT_ROAMED:
-			__cfg80211_roamed(wdev, ev->rm.bssid,
+			__cfg80211_roamed(wdev, ev->rm.channel, ev->rm.bssid,
 					  ev->rm.req_ie, ev->rm.req_ie_len,
 					  ev->rm.resp_ie, ev->rm.resp_ie_len);
 			break;

-- 
Jouni Malinen                                            PGP id EFC895FA
