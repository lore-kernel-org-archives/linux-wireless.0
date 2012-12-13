Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:38978 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab2LMN7I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 08:59:08 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, assaf@ti.com,
	igalc@ti.com, nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv5 8/8] nl80211: allow DFS in start_ap
Date: Thu, 13 Dec 2012 14:58:33 +0100
Message-Id: <1355407113-27006-9-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121213_145929_660679_35C930EA)
In-Reply-To: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables DFS within nl80211/cfg80211. start_ap now checks if
DFS is allowed on the channel, and enables it with SINGLE_ONLY channel
mode if appropriate.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 net/wireless/chan.c    |    5 ++++-
 net/wireless/mlme.c    |   11 +++++++++++
 net/wireless/nl80211.c |   28 ++++++++++++++++++++++++++--
 3 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 18888f6..16a5f69 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -344,7 +344,10 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 		break;
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
-		if (wdev->beacon_interval) {
+		if (wdev->dfs_nlportid) {
+			*chan = wdev->channel;
+			*chanmode = CHAN_MODE_SINGLE_ONLY;
+		} else if (wdev->beacon_interval) {
 			*chan = wdev->channel;
 			*chanmode = CHAN_MODE_SHARED;
 		}
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 8cdbdd0e..fec3414 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -709,6 +709,7 @@ int cfg80211_mlme_register_mgmt(struct wireless_dev *wdev, u32 snd_portid,
 void cfg80211_mlme_unregister_socket(struct wireless_dev *wdev, u32 nlportid)
 {
 	struct wiphy *wiphy = wdev->wiphy;
+	struct net_device *dev = wdev->netdev;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct cfg80211_mgmt_registration *reg, *tmp;
 
@@ -733,6 +734,16 @@ void cfg80211_mlme_unregister_socket(struct wireless_dev *wdev, u32 nlportid)
 
 	if (nlportid == wdev->ap_unexpected_nlportid)
 		wdev->ap_unexpected_nlportid = 0;
+
+	if (nlportid == wdev->dfs_nlportid) {
+		if ((dev->ieee80211_ptr->iftype == NL80211_IFTYPE_AP ||
+		     dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO) &&
+		    wdev->beacon_interval)
+			/* DFS userspace controller crashed, stop AP */
+			cfg80211_stop_ap(rdev, dev);
+
+		wdev->dfs_nlportid = 0;
+	}
 }
 
 void cfg80211_mlme_purge_registrations(struct wireless_dev *wdev)
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 898d829..2af9c6e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2600,6 +2600,9 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_ap_settings params;
+	enum nl80211_chan_width dfs_capability = -1;
+	enum cfg80211_chan_mode chanmode;
+	struct ieee80211_channel *chan;
 	int err;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
@@ -2716,13 +2719,34 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	} else if (!nl80211_get_ap_channel(rdev, &params))
 		return -EINVAL;
 
+	if (rdev->wiphy.features & NL80211_FEATURE_20MHZ_DFS &&
+	    rdev->wiphy.features & NL80211_FEATURE_AP_CH_SWITCH)
+		dfs_capability = NL80211_CHAN_WIDTH_20;
+
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef,
-				     -1))
+				     dfs_capability))
 		return -EINVAL;
 
+	chan = params.chandef.chan;
+
+	if (chan->flags & IEEE80211_CHAN_RADAR) {
+		if (!wdev->dfs_nlportid)
+			return -EPERM;
+
+		if (!chan->cac_started)
+			return -EPERM;
+
+		if (time_is_after_jiffies(chan->radar_detect_timeout))
+			return -EPERM;
+
+		chanmode = CHAN_MODE_SINGLE_ONLY;
+	} else {
+		chanmode = CHAN_MODE_SHARED;
+	}
+
 	mutex_lock(&rdev->devlist_mtx);
 	err = cfg80211_can_use_chan(rdev, wdev, params.chandef.chan,
-				    CHAN_MODE_SHARED);
+				    chanmode);
 	mutex_unlock(&rdev->devlist_mtx);
 
 	if (err)
-- 
1.7.10.4

