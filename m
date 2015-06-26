Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40365 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbbFZI6V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 04:58:21 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: shrink struct ieee80211_fragment_entry
Date: Fri, 26 Jun 2015 10:58:19 +0200
Message-Id: <1435309099-8774-1-git-send-email-johannes@sipsolutions.net> (sfid-20150626_105826_944272_A55D9543)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Most of the fields in this struct use too wide types, change
that to shrink the struct from 64 to 48 bytes (on 64-bit.)

This results in a total saving of 64 bytes for each sta_info.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index dd131e9b41d7..52930e91c0fd 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -84,13 +84,13 @@ struct ieee80211_local;
 #define IEEE80211_DEAUTH_FRAME_LEN	(24 /* hdr */ + 2 /* reason */)
 
 struct ieee80211_fragment_entry {
-	unsigned long first_frag_time;
-	unsigned int seq;
-	unsigned int rx_queue;
-	unsigned int last_frag;
-	unsigned int extra_len;
 	struct sk_buff_head skb_list;
-	int ccmp; /* Whether fragments were encrypted with CCMP */
+	unsigned long first_frag_time;
+	u16 seq;
+	u16 extra_len;
+	u16 last_frag;
+	u8 rx_queue;
+	bool ccmp; /* Whether fragments were encrypted with CCMP */
 	u8 last_pn[6]; /* PN of the last fragment if CCMP was used */
 };
 
-- 
2.1.4

