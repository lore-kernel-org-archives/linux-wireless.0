Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:57850 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759304Ab3KMSNQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 13:13:16 -0500
Received: by mail-wg0-f54.google.com with SMTP id y10so820214wgg.9
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 10:13:15 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 5/5] cfg80211: DFS check dfs_region before usage
Date: Wed, 13 Nov 2013 19:12:59 +0100
Message-Id: <1384366379-25301-6-git-send-email-mcgrof@do-not-panic.com> (sfid-20131113_191321_609202_D5F6ECA8)
In-Reply-To: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check the DFS region before channel availability check
or declaring a channel as DFS usable.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/chan.c    | 8 ++++++++
 net/wireless/nl80211.c | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 78559b5..4e6eaa0 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -517,10 +517,18 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 	struct ieee80211_sta_ht_cap *ht_cap;
 	struct ieee80211_sta_vht_cap *vht_cap;
 	u32 width, control_freq;
+	enum nl80211_dfs_regions dfs_region;
 
 	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
 		return false;
 
+	rtnl_lock();
+	dfs_region = reg_get_dfs_region(wiphy);
+	rtnl_unlock();
+
+	if (dfs_region == NL80211_DFS_UNSET)
+		return false;
+
 	ht_cap = &wiphy->bands[chandef->chan->band]->ht_cap;
 	vht_cap = &wiphy->bands[chandef->chan->band]->vht_cap;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dcbc083..1acf45c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5641,8 +5641,13 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_chan_def chandef;
+	enum nl80211_dfs_regions dfs_region;
 	int err;
 
+	dfs_region = reg_get_dfs_region(wdev->wiphy);
+	if (dfs_region == NL80211_DFS_UNSET)
+		 return -EINVAL;
+
 	err = nl80211_parse_chandef(rdev, info, &chandef);
 	if (err)
 		return err;
-- 
1.8.4.rc3

