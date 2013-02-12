Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:52032 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752041Ab3BLH47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 02:56:59 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] nl80211: add packet offset information for wowlan pattern
Date: Mon, 11 Feb 2013 23:56:41 -0800
Message-Id: <1360655802-21515-2-git-send-email-bzhao@marvell.com> (sfid-20130212_085702_656862_FB3378DD)
In-Reply-To: <1360655802-21515-1-git-send-email-bzhao@marvell.com>
References: <1360655802-21515-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

If user knows the location of a wowlan pattern to be matched in
Rx packet, he can provide an offset with the pattern. This will
help drivers to ignore initial bytes and match the pattern
efficiently.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 include/net/cfg80211.h       |  2 ++
 include/uapi/linux/nl80211.h |  3 +++
 net/wireless/nl80211.c       | 12 +++++++++---
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 77686ca..a5b0ea3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1576,6 +1576,7 @@ struct cfg80211_pmksa {
  *	one bit per byte, in same format as nl80211
  * @pattern: bytes to match where bitmask is 1
  * @pattern_len: length of pattern (in bytes)
+ * @pkt_offset: packet offset (in bytes)
  *
  * Internal note: @mask and @pattern are allocated in one chunk of
  * memory, free @mask only!
@@ -1583,6 +1584,7 @@ struct cfg80211_pmksa {
 struct cfg80211_wowlan_trig_pkt_pattern {
 	u8 *mask, *pattern;
 	int pattern_len;
+	int pkt_offset;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b233211..14da5b3 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2910,6 +2910,8 @@ enum nl80211_tx_power_setting {
  *	Note that the pattern matching is done as though frames were not
  *	802.11 frames but 802.3 frames, i.e. the frame is fully unpacked
  *	first (including SNAP header unpacking) and then matched.
+ * @NL80211_WOWLAN_PKTPAT_OFFSET: packet offset, pattern is matched after
+ *	these fixed number of bytes of received packet
  * @NUM_NL80211_WOWLAN_PKTPAT: number of attributes
  * @MAX_NL80211_WOWLAN_PKTPAT: max attribute number
  */
@@ -2917,6 +2919,7 @@ enum nl80211_wowlan_packet_pattern_attr {
 	__NL80211_WOWLAN_PKTPAT_INVALID,
 	NL80211_WOWLAN_PKTPAT_MASK,
 	NL80211_WOWLAN_PKTPAT_PATTERN,
+	NL80211_WOWLAN_PKTPAT_OFFSET,
 
 	NUM_NL80211_WOWLAN_PKTPAT,
 	MAX_NL80211_WOWLAN_PKTPAT = NUM_NL80211_WOWLAN_PKTPAT - 1,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 93bc63e..c512596 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6953,8 +6953,11 @@ static int nl80211_get_wowlan(struct sk_buff *skb, struct genl_info *info)
 					    DIV_ROUND_UP(pat_len, 8),
 					    rdev->wowlan->patterns[i].mask) ||
 				    nla_put(msg, NL80211_WOWLAN_PKTPAT_PATTERN,
-					    pat_len,
-					    rdev->wowlan->patterns[i].pattern))
+					  pat_len,
+					  rdev->wowlan->patterns[i].pattern) ||
+				    nla_put_u32(msg,
+					  NL80211_WOWLAN_PKTPAT_OFFSET,
+					  rdev->wowlan->patterns[i].pkt_offset))
 					goto nla_put_failure;
 				nla_nest_end(msg, nl_pat);
 			}
@@ -7070,7 +7073,8 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 				  nla_data(pat), nla_len(pat), NULL);
 			err = -EINVAL;
 			if (!pat_tb[NL80211_WOWLAN_PKTPAT_MASK] ||
-			    !pat_tb[NL80211_WOWLAN_PKTPAT_PATTERN])
+			    !pat_tb[NL80211_WOWLAN_PKTPAT_PATTERN] ||
+			    !pat_tb[NL80211_WOWLAN_PKTPAT_OFFSET])
 				goto error;
 			pat_len = nla_len(pat_tb[NL80211_WOWLAN_PKTPAT_PATTERN]);
 			mask_len = DIV_ROUND_UP(pat_len, 8);
@@ -7096,6 +7100,8 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 			memcpy(new_triggers.patterns[i].pattern,
 			       nla_data(pat_tb[NL80211_WOWLAN_PKTPAT_PATTERN]),
 			       pat_len);
+			new_triggers.patterns[i].pkt_offset = nla_get_u32(
+					pat_tb[NL80211_WOWLAN_PKTPAT_OFFSET]);
 			i++;
 		}
 	}
-- 
1.8.0

