Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:35111 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758758Ab3BLUl4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 15:41:56 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2] nl80211: add packet offset information for wowlan pattern
Date: Tue, 12 Feb 2013 12:16:26 -0800
Message-Id: <1360700187-22806-1-git-send-email-bzhao@marvell.com> (sfid-20130212_214448_809259_F4E540F8)
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
v2: a) Driver can advertise supported max_pkt_offset during
       initialization (Johannes Berg)
    b) Set request will be rejected if packet offset from user
       exceeds supported max_pkt_offset (Johannes Berg)
    c) Updated documentation in nl80211.h with packet offset info
       (Johannes Berg)

 include/net/cfg80211.h       |  4 ++++
 include/uapi/linux/nl80211.h | 12 +++++++++---
 net/wireless/nl80211.c       | 20 +++++++++++++++++---
 3 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 77686ca..d3a7381 100644
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
@@ -2290,12 +2292,14 @@ enum wiphy_wowlan_support_flags {
  *	(see nl80211.h for the pattern definition)
  * @pattern_max_len: maximum length of each pattern
  * @pattern_min_len: minimum length of each pattern
+ * @max_pkt_offset: maximum Rx packet offset
  */
 struct wiphy_wowlan_support {
 	u32 flags;
 	int n_patterns;
 	int pattern_max_len;
 	int pattern_min_len;
+	int max_pkt_offset;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b233211..eb7b322 100644
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
@@ -2927,6 +2930,7 @@ enum nl80211_wowlan_packet_pattern_attr {
  * @max_patterns: maximum number of patterns supported
  * @min_pattern_len: minimum length of each pattern
  * @max_pattern_len: maximum length of each pattern
+ * @max_pkt_offset: maximum Rx packet offset
  *
  * This struct is carried in %NL80211_WOWLAN_TRIG_PKT_PATTERN when
  * that is part of %NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED in the
@@ -2936,6 +2940,7 @@ struct nl80211_wowlan_pattern_support {
 	__u32 max_patterns;
 	__u32 min_pattern_len;
 	__u32 max_pattern_len;
+	__u32 max_pkt_offset;
 } __attribute__((packed));
 
 /**
@@ -2951,9 +2956,10 @@ struct nl80211_wowlan_pattern_support {
  * @NL80211_WOWLAN_TRIG_PKT_PATTERN: wake up on the specified packet patterns
  *	which are passed in an array of nested attributes, each nested attribute
  *	defining a with attributes from &struct nl80211_wowlan_trig_pkt_pattern.
- *	Each pattern defines a wakeup packet. The matching is done on the MSDU,
- *	i.e. as though the packet was an 802.3 packet, so the pattern matching
- *	is done after the packet is converted to the MSDU.
+ *	Each pattern defines a wakeup packet. Packet offset is associated with
+ *	each pattern which is used while matching the pattern. The matching is
+ *	done on the MSDU, i.e. as though the packet was an 802.3 packet, so the
+ *	pattern matching is done after the packet is converted to the MSDU.
  *
  *	In %NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED, it is a binary attribute
  *	carrying a &struct nl80211_wowlan_pattern_support.
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 93bc63e..7c1ced32 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1238,6 +1238,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 portid, u32 seq, int flag
 					dev->wiphy.wowlan.pattern_min_len,
 				.max_pattern_len =
 					dev->wiphy.wowlan.pattern_max_len,
+				.max_pkt_offset =
+					dev->wiphy.wowlan.max_pkt_offset,
 			};
 			if (nla_put(msg, NL80211_WOWLAN_TRIG_PKT_PATTERN,
 				    sizeof(pat), &pat))
@@ -6953,8 +6955,11 @@ static int nl80211_get_wowlan(struct sk_buff *skb, struct genl_info *info)
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
@@ -7046,7 +7051,7 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 	if (tb[NL80211_WOWLAN_TRIG_PKT_PATTERN]) {
 		struct nlattr *pat;
 		int n_patterns = 0;
-		int rem, pat_len, mask_len;
+		int rem, pat_len, mask_len, pkt_offset;
 		struct nlattr *pat_tb[NUM_NL80211_WOWLAN_PKTPAT];
 
 		nla_for_each_nested(pat, tb[NL80211_WOWLAN_TRIG_PKT_PATTERN],
@@ -7081,6 +7086,15 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 			    pat_len < wowlan->pattern_min_len)
 				goto error;
 
+			if (!pat_tb[NL80211_WOWLAN_PKTPAT_OFFSET])
+				pkt_offset = 0;
+			else
+				pkt_offset = nla_get_u32(
+					pat_tb[NL80211_WOWLAN_PKTPAT_OFFSET]);
+			if (pkt_offset > wowlan->max_pkt_offset)
+				goto error;
+			new_triggers.patterns[i].pkt_offset = pkt_offset;
+
 			new_triggers.patterns[i].mask =
 				kmalloc(mask_len + pat_len, GFP_KERNEL);
 			if (!new_triggers.patterns[i].mask) {
-- 
1.8.0

