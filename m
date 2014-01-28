Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:6345 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaA1Mxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jan 2014 07:53:49 -0500
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Antonio Quartulli <antonio@open-mesh.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>,
	Bing Zhao <bzhao@marvell.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	libertas-dev@lists.infradead.org,
	Antonio Quartulli <antonio@meshcoding.com>
Subject: [PATCH RESEND mac80211] cfg80211: fix channel configuration in IBSS join
Date: Tue, 28 Jan 2014 13:52:20 +0100
Message-Id: <1390913540-2127-1-git-send-email-antonio@meshcoding.com> (sfid-20140128_135353_319892_3430B32A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

When receiving an IBSS_JOINED event select the BSS object
based on the {bssid, channel} couple rather than the bssid
only.

With the current approach if another cell having the same
BSSID (but using a different channel) exists then cfg80211
picks up the wrong BSS object.
The result is a mismatching channel configuration between
cfg80211 and the driver, that can lead to any sort of
problem.

The issue can be triggered by having an IBSS sitting on
given channel and then asking the driver to create a new
cell using the same BSSID but with a different frequency.

By passing the channel to cfg80211_get_bss() we can solve
this ambiguity and retrieve/create the correct BSS object.

All the users of cfg80211_ibss_joined() have been changed
accordingly.

Cc: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Arend van Spriel <arend@broadcom.com>
Cc: Bing Zhao <bzhao@marvell.com>
Cc: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: libertas-dev@lists.infradead.org
Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>
---

- Patch is getting resent because I did not CC'd the linux-wireless mailing list in
my previous attempt. :)

- patch is based on:
"cfg80211: use the proper union member when sending a IBSS_JOINED event"

 drivers/net/wireless/ath/ath6kl/cfg80211.c            |  4 ++--
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |  4 +++-
 drivers/net/wireless/libertas/cfg.c                   |  3 ++-
 drivers/net/wireless/mwifiex/cfg80211.c               |  3 ++-
 drivers/net/wireless/rndis_wlan.c                     |  4 +++-
 include/net/cfg80211.h                                |  4 +++-
 net/mac80211/ibss.c                                   |  2 +-
 net/wireless/core.h                                   |  4 +++-
 net/wireless/ibss.c                                   | 10 ++++++----
 net/wireless/util.c                                   |  3 ++-
 10 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index eba32f5..ef10fce 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -790,7 +790,7 @@ void ath6kl_cfg80211_connect_event(struct ath6kl_vif *vif, u16 channel,
 	if (nw_type & ADHOC_NETWORK) {
 		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "ad-hoc %s selected\n",
 			   nw_type & ADHOC_CREATOR ? "creator" : "joiner");
-		cfg80211_ibss_joined(vif->ndev, bssid, GFP_KERNEL);
+		cfg80211_ibss_joined(vif->ndev, bssid, chan, GFP_KERNEL);
 		cfg80211_put_bss(ar->wiphy, bss);
 		return;
 	}
@@ -867,7 +867,7 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl_vif *vif, u8 reason,
 			return;
 		}
 		memset(bssid, 0, ETH_ALEN);
-		cfg80211_ibss_joined(vif->ndev, bssid, GFP_KERNEL);
+		cfg80211_ibss_joined(vif->ndev, bssid, NULL, GFP_KERNEL);
 		return;
 	}
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 711524e..cb2e3e2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4655,6 +4655,7 @@ brcmf_notify_connect_status(struct brcmf_if *ifp,
 	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
 	struct net_device *ndev = ifp->ndev;
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
+	struct ieee80211_channel *chan;
 	s32 err = 0;
 
 	if (ifp->vif->mode == WL_MODE_AP) {
@@ -4662,9 +4663,10 @@ brcmf_notify_connect_status(struct brcmf_if *ifp,
 	} else if (brcmf_is_linkup(e)) {
 		brcmf_dbg(CONN, "Linkup\n");
 		if (brcmf_is_ibssmode(ifp->vif)) {
+			chan = ieee80211_get_channel(cfg->wiphy, cfg->channel);
 			memcpy(profile->bssid, e->addr, ETH_ALEN);
 			wl_inform_ibss(cfg, ndev, e->addr);
-			cfg80211_ibss_joined(ndev, e->addr, GFP_KERNEL);
+			cfg80211_ibss_joined(ndev, e->addr, chan, GFP_KERNEL);
 			clear_bit(BRCMF_VIF_STATUS_CONNECTING,
 				  &ifp->vif->sme_state);
 			set_bit(BRCMF_VIF_STATUS_CONNECTED,
diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 32f7500..2d72a6b 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -1766,7 +1766,8 @@ static void lbs_join_post(struct lbs_private *priv,
 	memcpy(priv->wdev->ssid, params->ssid, params->ssid_len);
 	priv->wdev->ssid_len = params->ssid_len;
 
-	cfg80211_ibss_joined(priv->dev, bssid, GFP_KERNEL);
+	cfg80211_ibss_joined(priv->dev, bssid, params->chandef.chan,
+			     GFP_KERNEL);
 
 	/* TODO: consider doing this at MACREG_INT_CODE_LINK_SENSED time */
 	priv->connect_status = LBS_CONNECTED;
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 648e2ff..e10a99b 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1872,7 +1872,8 @@ mwifiex_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 				     params->privacy);
 done:
 	if (!ret) {
-		cfg80211_ibss_joined(priv->netdev, priv->cfg_bssid, GFP_KERNEL);
+		cfg80211_ibss_joined(priv->netdev, priv->cfg_bssid,
+				     params->chandef.chan, GFP_KERNEL);
 		dev_dbg(priv->adapter->dev,
 			"info: joined/created adhoc network with bssid"
 			" %pM successfully\n", priv->cfg_bssid);
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index c3cdda1..dd2bae8 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2836,7 +2836,9 @@ static void rndis_wlan_do_link_up_work(struct usbnet *usbdev)
 					bssid, req_ie, req_ie_len,
 					resp_ie, resp_ie_len, GFP_KERNEL);
 	} else if (priv->infra_mode == NDIS_80211_INFRA_ADHOC)
-		cfg80211_ibss_joined(usbdev->net, bssid, GFP_KERNEL);
+		cfg80211_ibss_joined(usbdev->net, bssid,
+				     get_current_channel(usbdev, NULL),
+				     GFP_KERNEL);
 
 	kfree(info);
 
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 459700e..c23f6a4 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3895,6 +3895,7 @@ void cfg80211_michael_mic_failure(struct net_device *dev, const u8 *addr,
  *
  * @dev: network device
  * @bssid: the BSSID of the IBSS joined
+ * @channel: the channel of the IBSS joined
  * @gfp: allocation flags
  *
  * This function notifies cfg80211 that the device joined an IBSS or
@@ -3904,7 +3905,8 @@ void cfg80211_michael_mic_failure(struct net_device *dev, const u8 *addr,
  * with the locally generated beacon -- this guarantees that there is
  * always a scan result for this IBSS. cfg80211 will handle the rest.
  */
-void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid, gfp_t gfp);
+void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
+			  struct ieee80211_channel *channel, gfp_t gfp);
 
 /**
  * cfg80211_notify_new_candidate - notify cfg80211 of a new mesh peer candidate
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index ed7eec3..d5821ee 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -386,7 +386,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 					      presp->head_len, 0, GFP_KERNEL);
 	cfg80211_put_bss(local->hw.wiphy, bss);
 	netif_carrier_on(sdata->dev);
-	cfg80211_ibss_joined(sdata->dev, ifibss->bssid, GFP_KERNEL);
+	cfg80211_ibss_joined(sdata->dev, ifibss->bssid, chan, GFP_KERNEL);
 }
 
 static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 37ec16d..8a820f9 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -210,6 +210,7 @@ struct cfg80211_event {
 		} dc;
 		struct {
 			u8 bssid[ETH_ALEN];
+			struct ieee80211_channel *channel;
 		} ij;
 	};
 };
@@ -257,7 +258,8 @@ int __cfg80211_leave_ibss(struct cfg80211_registered_device *rdev,
 			  struct net_device *dev, bool nowext);
 int cfg80211_leave_ibss(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, bool nowext);
-void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid);
+void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
+			    struct ieee80211_channel *channel);
 int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 			    struct wireless_dev *wdev);
 
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 3fce17e..93d0919 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -14,7 +14,8 @@
 #include "rdev-ops.h"
 
 
-void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid)
+void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
+			    struct ieee80211_channel *channel)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_bss *bss;
@@ -28,8 +29,7 @@ void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid)
 	if (!wdev->ssid_len)
 		return;
 
-	bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
-			       wdev->ssid, wdev->ssid_len,
+	bss = cfg80211_get_bss(wdev->wiphy, channel, bssid, NULL, 0,
 			       WLAN_CAPABILITY_IBSS, WLAN_CAPABILITY_IBSS);
 
 	if (WARN_ON(!bss))
@@ -54,7 +54,8 @@ void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid)
 #endif
 }
 
-void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid, gfp_t gfp)
+void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
+			  struct ieee80211_channel *channel, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -69,6 +70,7 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid, gfp_t gfp)
 
 	ev->type = EVENT_IBSS_JOINED;
 	memcpy(ev->ij.bssid, bssid, ETH_ALEN);
+	ev->ij.channel = channel;
 
 	spin_lock_irqsave(&wdev->event_lock, flags);
 	list_add_tail(&ev->list, &wdev->event_list);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index d39c371..7526a4d 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -820,7 +820,8 @@ void cfg80211_process_wdev_events(struct wireless_dev *wdev)
 						ev->dc.reason, true);
 			break;
 		case EVENT_IBSS_JOINED:
-			__cfg80211_ibss_joined(wdev->netdev, ev->ij.bssid);
+			__cfg80211_ibss_joined(wdev->netdev, ev->ij.bssid,
+					       ev->ij.channel);
 			break;
 		}
 		wdev_unlock(wdev);
-- 
1.8.5.3

