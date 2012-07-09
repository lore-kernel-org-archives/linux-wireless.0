Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34207 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab2GIMiM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 08:38:12 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 8/8] nl80211: move scan API to wdev
Date: Mon,  9 Jul 2012 14:38:03 +0200
Message-Id: <1341837483-18001-9-git-send-email-johannes@sipsolutions.net> (sfid-20120709_143826_869732_1835D71E)
In-Reply-To: <1341837483-18001-1-git-send-email-johannes@sipsolutions.net>
References: <1341837483-18001-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The new P2P Device will have to be able to scan for
P2P search, so move scanning to use struct wireless_dev
instead of struct net_device.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |    6 ++--
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    3 +-
 drivers/net/wireless/iwmc3200wifi/cfg80211.c       |    3 +-
 drivers/net/wireless/libertas/cfg.c                |    1 -
 drivers/net/wireless/mwifiex/cfg80211.c            |    3 +-
 drivers/net/wireless/orinoco/cfg.c                 |    2 +-
 drivers/net/wireless/rndis_wlan.c                  |    5 ++--
 include/net/cfg80211.h                             |    7 +++--
 net/mac80211/cfg.c                                 |    5 ++--
 net/wireless/core.c                                |    2 +-
 net/wireless/nl80211.c                             |   31 +++++++++++---------
 net/wireless/nl80211.h                             |    6 ++--
 net/wireless/scan.c                                |   24 ++++++++-------
 net/wireless/sme.c                                 |    6 ++--
 14 files changed, 57 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 88bed02..86aeef4 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -966,11 +966,11 @@ static int ath6kl_set_probed_ssids(struct ath6kl *ar,
 	return 0;
 }
 
-static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
+static int ath6kl_cfg80211_scan(struct wiphy *wiphy,
 				struct cfg80211_scan_request *request)
 {
-	struct ath6kl *ar = ath6kl_priv(ndev);
-	struct ath6kl_vif *vif = netdev_priv(ndev);
+	struct ath6kl_vif *vif = ath6kl_vif_from_wdev(request->wdev);
+	struct ath6kl *ar = ath6kl_priv(vif->ndev);
 	s8 n_channels = 0;
 	u16 *channels = NULL;
 	int ret = 0;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index d13ae9c..c6a10ca 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -691,9 +691,10 @@ scan_out:
 }
 
 static s32
-brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
+brcmf_cfg80211_scan(struct wiphy *wiphy,
 		 struct cfg80211_scan_request *request)
 {
+	struct net_device *ndev = request->wdev->netdev;
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index 48e8218..523dd64 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -353,9 +353,10 @@ static int iwm_cfg80211_change_iface(struct wiphy *wiphy,
 	return 0;
 }
 
-static int iwm_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
+static int iwm_cfg80211_scan(struct wiphy *wiphy,
 			     struct cfg80211_scan_request *request)
 {
+	struct net_device *ndev = request->wdev->netdev;
 	struct iwm_priv *iwm = ndev_to_iwm(ndev);
 	int ret;
 
diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index f4a2030..7067813 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -805,7 +805,6 @@ void lbs_scan_done(struct lbs_private *priv)
 }
 
 static int lbs_cfg_scan(struct wiphy *wiphy,
-	struct net_device *dev,
 	struct cfg80211_scan_request *request)
 {
 	struct lbs_private *priv = wiphy_priv(wiphy);
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 1e8024e..6ca571a 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1376,9 +1376,10 @@ mwifiex_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
  * it also informs the results.
  */
 static int
-mwifiex_cfg80211_scan(struct wiphy *wiphy, struct net_device *dev,
+mwifiex_cfg80211_scan(struct wiphy *wiphy,
 		      struct cfg80211_scan_request *request)
 {
+	struct net_device *dev = request->wdev->netdev;
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	int i;
 	struct ieee80211_channel *chan;
diff --git a/drivers/net/wireless/orinoco/cfg.c b/drivers/net/wireless/orinoco/cfg.c
index e156755..7b751fb 100644
--- a/drivers/net/wireless/orinoco/cfg.c
+++ b/drivers/net/wireless/orinoco/cfg.c
@@ -138,7 +138,7 @@ static int orinoco_change_vif(struct wiphy *wiphy, struct net_device *dev,
 	return err;
 }
 
-static int orinoco_scan(struct wiphy *wiphy, struct net_device *dev,
+static int orinoco_scan(struct wiphy *wiphy,
 			struct cfg80211_scan_request *request)
 {
 	struct orinoco_private *priv = wiphy_priv(wiphy);
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index dfcd02a..241162e 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -484,7 +484,7 @@ static int rndis_change_virtual_intf(struct wiphy *wiphy,
 					enum nl80211_iftype type, u32 *flags,
 					struct vif_params *params);
 
-static int rndis_scan(struct wiphy *wiphy, struct net_device *dev,
+static int rndis_scan(struct wiphy *wiphy,
 			struct cfg80211_scan_request *request);
 
 static int rndis_set_wiphy_params(struct wiphy *wiphy, u32 changed);
@@ -1941,9 +1941,10 @@ static int rndis_get_tx_power(struct wiphy *wiphy, int *dbm)
 }
 
 #define SCAN_DELAY_JIFFIES (6 * HZ)
-static int rndis_scan(struct wiphy *wiphy, struct net_device *dev,
+static int rndis_scan(struct wiphy *wiphy,
 			struct cfg80211_scan_request *request)
 {
+	struct net_device *dev = request->wdev->netdev;
 	struct usbnet *usbdev = netdev_priv(dev);
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	int ret;
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index aaaa3a2..5a67165 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -999,7 +999,7 @@ struct cfg80211_ssid {
  * @ie_len: length of ie in octets
  * @rates: bitmap of rates to advertise for each band
  * @wiphy: the wiphy this was for
- * @dev: the interface
+ * @wdev: the wireless device to scan for
  * @aborted: (internal) scan request was notified as aborted
  * @no_cck: used to send probe requests at non CCK rate in 2GHz band
  */
@@ -1012,9 +1012,10 @@ struct cfg80211_scan_request {
 
 	u32 rates[IEEE80211_NUM_BANDS];
 
+	struct wireless_dev *wdev;
+
 	/* internal */
 	struct wiphy *wiphy;
-	struct net_device *dev;
 	bool aborted;
 	bool no_cck;
 
@@ -1700,7 +1701,7 @@ struct cfg80211_ops {
 				       struct ieee80211_channel *chan,
 				       enum nl80211_channel_type channel_type);
 
-	int	(*scan)(struct wiphy *wiphy, struct net_device *dev,
+	int	(*scan)(struct wiphy *wiphy,
 			struct cfg80211_scan_request *request);
 
 	int	(*auth)(struct wiphy *wiphy, struct net_device *dev,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a752c73..cfdc03f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1763,10 +1763,11 @@ static int ieee80211_resume(struct wiphy *wiphy)
 #endif
 
 static int ieee80211_scan(struct wiphy *wiphy,
-			  struct net_device *dev,
 			  struct cfg80211_scan_request *req)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_sub_if_data *sdata;
+
+	sdata = IEEE80211_WDEV_TO_SUB_IF(req->wdev);
 
 	switch (ieee80211_vif_type_p2p(&sdata->vif)) {
 	case NL80211_IFTYPE_STATION:
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 2781a41..0557bb1 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -708,7 +708,7 @@ static void wdev_cleanup_work(struct work_struct *work)
 
 	cfg80211_lock_rdev(rdev);
 
-	if (WARN_ON(rdev->scan_req && rdev->scan_req->dev == wdev->netdev)) {
+	if (WARN_ON(rdev->scan_req && rdev->scan_req->wdev == wdev)) {
 		rdev->scan_req->aborted = true;
 		___cfg80211_scan_done(rdev, true);
 	}
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dfd6e28..459fc10 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4120,7 +4120,7 @@ static int validate_scan_freqs(struct nlattr *freqs)
 static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
-	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = info->user_ptr[1];
 	struct cfg80211_scan_request *request;
 	struct nlattr *attr;
 	struct wiphy *wiphy;
@@ -4280,15 +4280,16 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	request->no_cck =
 		nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
 
-	request->dev = dev;
+	request->wdev = wdev;
 	request->wiphy = &rdev->wiphy;
 
 	rdev->scan_req = request;
-	err = rdev->ops->scan(&rdev->wiphy, dev, request);
+	err = rdev->ops->scan(&rdev->wiphy, request);
 
 	if (!err) {
-		nl80211_send_scan_start(rdev, dev);
-		dev_hold(dev);
+		nl80211_send_scan_start(rdev, wdev);
+		if (wdev->netdev)
+			dev_hold(wdev->netdev);
 	} else {
  out_free:
 		rdev->scan_req = NULL;
@@ -7056,7 +7057,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_trigger_scan,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -7448,7 +7449,7 @@ static int nl80211_add_scan_req(struct sk_buff *msg,
 
 static int nl80211_send_scan_msg(struct sk_buff *msg,
 				 struct cfg80211_registered_device *rdev,
-				 struct net_device *netdev,
+				 struct wireless_dev *wdev,
 				 u32 pid, u32 seq, int flags,
 				 u32 cmd)
 {
@@ -7459,7 +7460,9 @@ static int nl80211_send_scan_msg(struct sk_buff *msg,
 		return -1;
 
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
-	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex))
+	    (wdev->netdev && nla_put_u32(msg, NL80211_ATTR_IFINDEX,
+					 wdev->netdev->ifindex)) ||
+	    nla_put_u64(msg, NL80211_ATTR_WDEV, wdev_id(wdev)))
 		goto nla_put_failure;
 
 	/* ignore errors and send incomplete event anyway */
@@ -7496,7 +7499,7 @@ nl80211_send_sched_scan_msg(struct sk_buff *msg,
 }
 
 void nl80211_send_scan_start(struct cfg80211_registered_device *rdev,
-			     struct net_device *netdev)
+			     struct wireless_dev *wdev)
 {
 	struct sk_buff *msg;
 
@@ -7504,7 +7507,7 @@ void nl80211_send_scan_start(struct cfg80211_registered_device *rdev,
 	if (!msg)
 		return;
 
-	if (nl80211_send_scan_msg(msg, rdev, netdev, 0, 0, 0,
+	if (nl80211_send_scan_msg(msg, rdev, wdev, 0, 0, 0,
 				  NL80211_CMD_TRIGGER_SCAN) < 0) {
 		nlmsg_free(msg);
 		return;
@@ -7515,7 +7518,7 @@ void nl80211_send_scan_start(struct cfg80211_registered_device *rdev,
 }
 
 void nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
-			    struct net_device *netdev)
+			    struct wireless_dev *wdev)
 {
 	struct sk_buff *msg;
 
@@ -7523,7 +7526,7 @@ void nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
 	if (!msg)
 		return;
 
-	if (nl80211_send_scan_msg(msg, rdev, netdev, 0, 0, 0,
+	if (nl80211_send_scan_msg(msg, rdev, wdev, 0, 0, 0,
 				  NL80211_CMD_NEW_SCAN_RESULTS) < 0) {
 		nlmsg_free(msg);
 		return;
@@ -7534,7 +7537,7 @@ void nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
 }
 
 void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
-			       struct net_device *netdev)
+			       struct wireless_dev *wdev)
 {
 	struct sk_buff *msg;
 
@@ -7542,7 +7545,7 @@ void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
 	if (!msg)
 		return;
 
-	if (nl80211_send_scan_msg(msg, rdev, netdev, 0, 0, 0,
+	if (nl80211_send_scan_msg(msg, rdev, wdev, 0, 0, 0,
 				  NL80211_CMD_SCAN_ABORTED) < 0) {
 		nlmsg_free(msg);
 		return;
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 0469303..89ce996 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -7,11 +7,11 @@ int nl80211_init(void);
 void nl80211_exit(void);
 void nl80211_notify_dev_rename(struct cfg80211_registered_device *rdev);
 void nl80211_send_scan_start(struct cfg80211_registered_device *rdev,
-			     struct net_device *netdev);
+			     struct wireless_dev *wdev);
 void nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
-			    struct net_device *netdev);
+			    struct wireless_dev *wdev);
 void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
-			       struct net_device *netdev);
+			       struct wireless_dev *wdev);
 void nl80211_send_sched_scan(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev, u32 cmd);
 void nl80211_send_sched_scan_results(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index af2b1ca..848523a 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -23,7 +23,7 @@
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
 {
 	struct cfg80211_scan_request *request;
-	struct net_device *dev;
+	struct wireless_dev *wdev;
 #ifdef CONFIG_CFG80211_WEXT
 	union iwreq_data wrqu;
 #endif
@@ -35,29 +35,31 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
 	if (!request)
 		return;
 
-	dev = request->dev;
+	wdev = request->wdev;
 
 	/*
 	 * This must be before sending the other events!
 	 * Otherwise, wpa_supplicant gets completely confused with
 	 * wext events.
 	 */
-	cfg80211_sme_scan_done(dev);
+	if (wdev->netdev)
+		cfg80211_sme_scan_done(wdev->netdev);
 
 	if (request->aborted)
-		nl80211_send_scan_aborted(rdev, dev);
+		nl80211_send_scan_aborted(rdev, wdev);
 	else
-		nl80211_send_scan_done(rdev, dev);
+		nl80211_send_scan_done(rdev, wdev);
 
 #ifdef CONFIG_CFG80211_WEXT
-	if (!request->aborted) {
+	if (wdev->netdev && !request->aborted) {
 		memset(&wrqu, 0, sizeof(wrqu));
 
-		wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
+		wireless_send_event(wdev->netdev, SIOCGIWSCAN, &wrqu, NULL);
 	}
 #endif
 
-	dev_put(dev);
+	if (wdev->netdev)
+		dev_put(wdev->netdev);
 
 	rdev->scan_req = NULL;
 
@@ -955,7 +957,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 	}
 
 	creq->wiphy = wiphy;
-	creq->dev = dev;
+	creq->wdev = dev->ieee80211_ptr;
 	/* SSIDs come after channels */
 	creq->ssids = (void *)&creq->channels[n_channels];
 	creq->n_channels = n_channels;
@@ -1024,12 +1026,12 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 			creq->rates[i] = (1 << wiphy->bands[i]->n_bitrates) - 1;
 
 	rdev->scan_req = creq;
-	err = rdev->ops->scan(wiphy, dev, creq);
+	err = rdev->ops->scan(wiphy, creq);
 	if (err) {
 		rdev->scan_req = NULL;
 		/* creq will be freed below */
 	} else {
-		nl80211_send_scan_start(rdev, dev);
+		nl80211_send_scan_start(rdev, dev->ieee80211_ptr);
 		/* creq now owned by driver */
 		creq = NULL;
 		dev_hold(dev);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index dec9798..6f39cb8 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -136,15 +136,15 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 		wdev->conn->params.ssid_len);
 	request->ssids[0].ssid_len = wdev->conn->params.ssid_len;
 
-	request->dev = wdev->netdev;
+	request->wdev = wdev;
 	request->wiphy = &rdev->wiphy;
 
 	rdev->scan_req = request;
 
-	err = rdev->ops->scan(wdev->wiphy, wdev->netdev, request);
+	err = rdev->ops->scan(wdev->wiphy, request);
 	if (!err) {
 		wdev->conn->state = CFG80211_CONN_SCANNING;
-		nl80211_send_scan_start(rdev, wdev->netdev);
+		nl80211_send_scan_start(rdev, wdev);
 		dev_hold(wdev->netdev);
 	} else {
 		rdev->scan_req = NULL;
-- 
1.7.10.4

