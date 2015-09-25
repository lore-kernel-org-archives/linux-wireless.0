Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46461 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890AbbIYMUW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2015 08:20:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 2/2] mac80211: allow driver to prevent two stations w/ same address
Date: Fri, 25 Sep 2015 14:20:17 +0200
Message-Id: <1443183617-23181-2-git-send-email-johannes@sipsolutions.net> (sfid-20150925_142026_061461_D0CC6F70)
In-Reply-To: <1443183617-23181-1-git-send-email-johannes@sipsolutions.net>
References: <1443183617-23181-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some devices or drivers cannot deal with having the same station
address for different virtual interfaces, say as a client to two
virtual AP interfaces. Rather than requiring each driver with a
limitation like that to enforce it, add a hardware flag for it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h  | 6 ++++++
 net/mac80211/debugfs.c  | 1 +
 net/mac80211/sta_info.c | 4 ++++
 3 files changed, 11 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 301fceb2fd10..a16c3e92a592 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1901,6 +1901,11 @@ struct ieee80211_txq {
  * @IEEE80211_HW_BEACON_TX_STATUS: The device/driver provides TX status
  *	for sent beacons.
  *
+ * @IEEE80211_HW_NEEDS_UNIQUE_STA_ADDR: Hardware (or driver) requires that each
+ *	station has a unique address, i.e. each station entry can be identified
+ *	by just its MAC address; this prevents, for example, the same station
+ *	from connecting to two virtual AP interfaces at the same time.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -1936,6 +1941,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TDLS_WIDER_BW,
 	IEEE80211_HW_SUPPORTS_AMSDU_IN_AMPDU,
 	IEEE80211_HW_BEACON_TX_STATUS,
+	IEEE80211_HW_NEEDS_UNIQUE_STA_ADDR,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 3636b45440ab..78fe7f611d6a 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -125,6 +125,7 @@ static const char *hw_flag_names[NUM_IEEE80211_HW_FLAGS + 1] = {
 	FLAG(TDLS_WIDER_BW),
 	FLAG(SUPPORTS_AMSDU_IN_AMPDU),
 	FLAG(BEACON_TX_STATUS),
+	FLAG(NEEDS_UNIQUE_STA_ADDR),
 
 	/* keep last for the build bug below */
 	(void *)0x1
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index c54dbcaa97b6..0cb6d026ea99 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -306,6 +306,10 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	struct timespec uptime;
 	int i, ret;
 
+	if (ieee80211_hw_check(hw, NEEDS_UNIQUE_STA_ADDR) &&
+	    ieee80211_find_sta_by_ifaddr(hw, addr, NULL))
+		return ERR_PTR(-ENOTUNIQ);
+
 	sta = kzalloc(sizeof(*sta) + hw->sta_data_size, gfp);
 	if (!sta)
 		return ERR_PTR(-ENOMEM);
-- 
2.5.1

