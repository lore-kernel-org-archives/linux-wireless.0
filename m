Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3736 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab1HKIq2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 04:46:28 -0400
Date: Thu, 11 Aug 2011 11:46:22 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] nl80211/cfg80211: Make addition of new sinfo fields safer
Message-ID: <20110811084622.GA29055@jouni.qca.qualcomm.com> (sfid-20110811_104632_703884_CF31625D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a comment pointing out the use of enum station_info_flags for
all new struct station_info fields. In addition, memset the sinfo
buffer to zero before use on all paths in the current tree to avoid
leaving uninitialized pointers in the data.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/cfg80211.h  |    5 +++++
 net/mac80211/sta_info.c |    1 +
 net/wireless/nl80211.c  |    1 +
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 96876d3..ab12440 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -563,6 +563,11 @@ struct station_info {
 
 	const u8 *assoc_req_ies;
 	size_t assoc_req_ies_len;
+
+	/*
+	 * Note: Add a new enum station_info_flags value for each new field and
+	 * use it to check which fields are initialized.
+	 */
 };
 
 /**
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 3db78b6..5eaa167 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -330,6 +330,7 @@ static int sta_info_finish_insert(struct sta_info *sta, bool async)
 	ieee80211_sta_debugfs_add(sta);
 	rate_control_add_sta_debugfs(sta);
 
+	memset(&sinfo, 0, sizeof(sinfo));
 	sinfo.filled = 0;
 	sinfo.generation = local->sta_generation;
 	cfg80211_new_sta(sdata->dev, sta->sta.addr, &sinfo, GFP_KERNEL);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 253e563..080fd47 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2267,6 +2267,7 @@ static int nl80211_dump_station(struct sk_buff *skb,
 	}
 
 	while (1) {
+		memset(&sinfo, 0, sizeof(sinfo));
 		err = dev->ops->dump_station(&dev->wiphy, netdev, sta_idx,
 					     mac_addr, &sinfo);
 		if (err == -ENOENT)
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
