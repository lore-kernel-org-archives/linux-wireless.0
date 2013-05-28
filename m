Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55950 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933624Ab3E1JAE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 05:00:04 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] mac80211: constify ieee802_11_parse_elems() argument
Date: Tue, 28 May 2013 10:59:53 +0200
Message-Id: <1369731594-16303-1-git-send-email-johannes@sipsolutions.net> (sfid-20130528_110009_453825_6AFCD232)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It only returns pointers into the data, so there's no
reason not to mark the input data const.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h | 5 +++--
 net/mac80211/util.c        | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9eed6f1..923e177 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1512,10 +1512,11 @@ static inline void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx_skb_tid(sdata, skb, 7);
 }
 
-u32 ieee802_11_parse_elems_crc(u8 *start, size_t len, bool action,
+u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			       struct ieee802_11_elems *elems,
 			       u64 filter, u32 crc);
-static inline void ieee802_11_parse_elems(u8 *start, size_t len, bool action,
+static inline void ieee802_11_parse_elems(const u8 *start, size_t len,
+					  bool action,
 					  struct ieee802_11_elems *elems)
 {
 	ieee802_11_parse_elems_crc(start, len, action, elems, 0, 0);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 2a8d759..efc06d2 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -661,12 +661,12 @@ void ieee80211_queue_delayed_work(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_queue_delayed_work);
 
-u32 ieee802_11_parse_elems_crc(u8 *start, size_t len, bool action,
+u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			       struct ieee802_11_elems *elems,
 			       u64 filter, u32 crc)
 {
 	size_t left = len;
-	u8 *pos = start;
+	const u8 *pos = start;
 	bool calc_crc = filter != 0;
 	DECLARE_BITMAP(seen_elems, 256);
 	const u8 *ie;
-- 
1.8.0

