Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:40503 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326Ab3AHNEz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 08:04:55 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv6 6/6] nl80211: allow DFS in start_ap
Date: Tue,  8 Jan 2013 14:04:11 +0100
Message-Id: <1357650251-17425-7-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130108_140500_758416_146D0D34)
In-Reply-To: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables DFS within nl80211/cfg80211. start_ap now checks if
DFS is allowed on the channel with the selected channel width.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
Changes to PATCHv5:
 * check radar detection width
---
 net/wireless/mlme.c    |    1 +
 net/wireless/nl80211.c |   23 +++++++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 6b63ffb..153c4ed 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -709,6 +709,7 @@ int cfg80211_mlme_register_mgmt(struct wireless_dev *wdev, u32 snd_portid,
 void cfg80211_mlme_unregister_socket(struct wireless_dev *wdev, u32 nlportid)
 {
 	struct wiphy *wiphy = wdev->wiphy;
+	struct net_device *dev = wdev->netdev;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct cfg80211_mgmt_registration *reg, *tmp;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d98c1d3..2bb9889 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2600,7 +2600,9 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_ap_settings params;
+	struct ieee80211_channel *chan;
 	int err;
+	u8 radar_detect_width = 0;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
@@ -2719,9 +2721,26 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
 		return -EINVAL;
 
+	chan = params.chandef.chan;
+
+	if (chan->flags & IEEE80211_CHAN_RADAR) {
+		if (!(rdev->wiphy.features & NL80211_FEATURE_DFS))
+			return -EINVAL;
+
+		if (!chan->cac_started)
+			return -EPERM;
+
+		if (time_is_after_jiffies(chan->radar_detect_timeout))
+			return -EPERM;
+
+		radar_detect_width = BIT(params.chandef.width);
+	}
+
 	mutex_lock(&rdev->devlist_mtx);
-	err = cfg80211_can_use_chan(rdev, wdev, params.chandef.chan,
-				    CHAN_MODE_SHARED);
+	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
+					   params.chandef.chan,
+					   CHAN_MODE_SHARED,
+					   radar_detect_width);
 	mutex_unlock(&rdev->devlist_mtx);
 
 	if (err)
-- 
1.7.10.4

