Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:51677 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759184Ab3EWVfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 17:35:47 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Luciano Coelho <coelho@ti.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 1/2] cfg80211/nl80211: rename packet pattern related structures and enums
Date: Thu, 23 May 2013 14:35:07 -0700
Message-ID: <1369344908-11184-1-git-send-email-bzhao@marvell.com> (sfid-20130523_233552_809470_5B7A2076)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Currently packet patterns and it's enum/structures are used only
for WoWLAN feature. As we intend to reuse them for new feature
packet coalesce, they are renamed in this patch.

Older names are kept for backward compatibility purpose.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v2: more details about the renames in commit log (Luis R. Rodriguez)
    don't break the API with existing applications (Johannes Berg)

 drivers/net/wireless/ath/ath9k/main.c   |  2 +-
 drivers/net/wireless/mwifiex/cfg80211.c |  3 +--
 drivers/net/wireless/ti/wlcore/main.c   | 10 ++++----
 include/net/cfg80211.h                  |  6 ++---
 include/uapi/linux/nl80211.h            | 45 ++++++++++++++++++++-------------
 net/wireless/nl80211.c                  | 34 ++++++++++++-------------
 6 files changed, 53 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6963862..57e290e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2123,7 +2123,7 @@ static void ath9k_wow_add_pattern(struct ath_softc *sc,
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath9k_wow_pattern *wow_pattern = NULL;
-	struct cfg80211_wowlan_trig_pkt_pattern *patterns = wowlan->patterns;
+	struct cfg80211_pkt_pattern *patterns = wowlan->patterns;
 	int mask_len;
 	s8 i = 0;
 
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index d3c8ece..7a06f51 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2250,8 +2250,7 @@ EXPORT_SYMBOL_GPL(mwifiex_del_virtual_intf);
 
 #ifdef CONFIG_PM
 static bool
-mwifiex_is_pattern_supported(struct cfg80211_wowlan_trig_pkt_pattern *pat,
-			     s8 *byte_seq)
+mwifiex_is_pattern_supported(struct cfg80211_pkt_pattern *pat, s8 *byte_seq)
 {
 	int j, k, valid_byte_cnt = 0;
 	bool dont_care_byte = false;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 953111a..db3653f 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1328,7 +1328,7 @@ static struct sk_buff *wl12xx_alloc_dummy_packet(struct wl1271 *wl)
 
 #ifdef CONFIG_PM
 static int
-wl1271_validate_wowlan_pattern(struct cfg80211_wowlan_trig_pkt_pattern *p)
+wl1271_validate_wowlan_pattern(struct cfg80211_pkt_pattern *p)
 {
 	int num_fields = 0, in_field = 0, fields_size = 0;
 	int i, pattern_len = 0;
@@ -1471,9 +1471,9 @@ void wl1271_rx_filter_flatten_fields(struct wl12xx_rx_filter *filter,
  * Allocates an RX filter returned through f
  * which needs to be freed using rx_filter_free()
  */
-static int wl1271_convert_wowlan_pattern_to_rx_filter(
-	struct cfg80211_wowlan_trig_pkt_pattern *p,
-	struct wl12xx_rx_filter **f)
+static int
+wl1271_convert_wowlan_pattern_to_rx_filter(struct cfg80211_pkt_pattern *p,
+					   struct wl12xx_rx_filter **f)
 {
 	int i, j, ret = 0;
 	struct wl12xx_rx_filter *filter;
@@ -1575,7 +1575,7 @@ static int wl1271_configure_wowlan(struct wl1271 *wl,
 
 	/* Translate WoWLAN patterns into filters */
 	for (i = 0; i < wow->n_patterns; i++) {
-		struct cfg80211_wowlan_trig_pkt_pattern *p;
+		struct cfg80211_pkt_pattern *p;
 		struct wl12xx_rx_filter *filter = NULL;
 
 		p = &wow->patterns[i];
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 32a2f1b..4585b63 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1661,7 +1661,7 @@ struct cfg80211_pmksa {
 };
 
 /**
- * struct cfg80211_wowlan_trig_pkt_pattern - packet pattern
+ * struct cfg80211_pkt_pattern - packet pattern
  * @mask: bitmask where to match pattern and where to ignore bytes,
  *	one bit per byte, in same format as nl80211
  * @pattern: bytes to match where bitmask is 1
@@ -1671,7 +1671,7 @@ struct cfg80211_pmksa {
  * Internal note: @mask and @pattern are allocated in one chunk of
  * memory, free @mask only!
  */
-struct cfg80211_wowlan_trig_pkt_pattern {
+struct cfg80211_pkt_pattern {
 	u8 *mask, *pattern;
 	int pattern_len;
 	int pkt_offset;
@@ -1733,7 +1733,7 @@ struct cfg80211_wowlan {
 	bool any, disconnect, magic_pkt, gtk_rekey_failure,
 	     eap_identity_req, four_way_handshake,
 	     rfkill_release;
-	struct cfg80211_wowlan_trig_pkt_pattern *patterns;
+	struct cfg80211_pkt_pattern *patterns;
 	struct cfg80211_wowlan_tcp *tcp;
 	int n_patterns;
 };
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 0632071..1fa2bf4 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3041,11 +3041,11 @@ enum nl80211_tx_power_setting {
 };
 
 /**
- * enum nl80211_wowlan_packet_pattern_attr - WoWLAN packet pattern attribute
- * @__NL80211_WOWLAN_PKTPAT_INVALID: invalid number for nested attribute
- * @NL80211_WOWLAN_PKTPAT_PATTERN: the pattern, values where the mask has
+ * enum nl80211_packet_pattern_attr - packet pattern attribute
+ * @__NL80211_PKTPAT_INVALID: invalid number for nested attribute
+ * @NL80211_PKTPAT_PATTERN: the pattern, values where the mask has
  *	a zero bit are ignored
- * @NL80211_WOWLAN_PKTPAT_MASK: pattern mask, must be long enough to have
+ * @NL80211_PKTPAT_MASK: pattern mask, must be long enough to have
  *	a bit for each byte in the pattern. The lowest-order bit corresponds
  *	to the first byte of the pattern, but the bytes of the pattern are
  *	in a little-endian-like format, i.e. the 9th byte of the pattern
@@ -3056,23 +3056,23 @@ enum nl80211_tx_power_setting {
  *	Note that the pattern matching is done as though frames were not
  *	802.11 frames but 802.3 frames, i.e. the frame is fully unpacked
  *	first (including SNAP header unpacking) and then matched.
- * @NL80211_WOWLAN_PKTPAT_OFFSET: packet offset, pattern is matched after
+ * @NL80211_PKTPAT_OFFSET: packet offset, pattern is matched after
  *	these fixed number of bytes of received packet
- * @NUM_NL80211_WOWLAN_PKTPAT: number of attributes
- * @MAX_NL80211_WOWLAN_PKTPAT: max attribute number
+ * @NUM_NL80211_PKTPAT: number of attributes
+ * @MAX_NL80211_PKTPAT: max attribute number
  */
-enum nl80211_wowlan_packet_pattern_attr {
-	__NL80211_WOWLAN_PKTPAT_INVALID,
-	NL80211_WOWLAN_PKTPAT_MASK,
-	NL80211_WOWLAN_PKTPAT_PATTERN,
-	NL80211_WOWLAN_PKTPAT_OFFSET,
+enum nl80211_packet_pattern_attr {
+	__NL80211_PKTPAT_INVALID,
+	NL80211_PKTPAT_MASK,
+	NL80211_PKTPAT_PATTERN,
+	NL80211_PKTPAT_OFFSET,
 
-	NUM_NL80211_WOWLAN_PKTPAT,
-	MAX_NL80211_WOWLAN_PKTPAT = NUM_NL80211_WOWLAN_PKTPAT - 1,
+	NUM_NL80211_PKTPAT,
+	MAX_NL80211_PKTPAT = NUM_NL80211_PKTPAT - 1,
 };
 
 /**
- * struct nl80211_wowlan_pattern_support - pattern support information
+ * struct nl80211_pattern_support - packet pattern support information
  * @max_patterns: maximum number of patterns supported
  * @min_pattern_len: minimum length of each pattern
  * @max_pattern_len: maximum length of each pattern
@@ -3082,13 +3082,22 @@ enum nl80211_wowlan_packet_pattern_attr {
  * that is part of %NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED in the
  * capability information given by the kernel to userspace.
  */
-struct nl80211_wowlan_pattern_support {
+struct nl80211_pattern_support {
 	__u32 max_patterns;
 	__u32 min_pattern_len;
 	__u32 max_pattern_len;
 	__u32 max_pkt_offset;
 } __attribute__((packed));
 
+/* only for backward compatibility */
+#define __NL80211_WOWLAN_PKTPAT_INVALID __NL80211_INVALID,
+#define NL80211_WOWLAN_PKTPAT_MASK NL80211_PKTPAT_MASK
+#define NL80211_WOWLAN_PKTPAT_PATTERN NL80211_PKTPAT_PATTERN
+#define NL80211_WOWLAN_PKTPAT_OFFSET NL80211_PKTPAT_OFFSET
+#define NUM_NL80211_WOWLAN_PKTPAT NUM_NL80211_PKTPAT
+#define MAX_NL80211_WOWLAN_PKTPAT MAX_NL80211_PKTPAT
+#define nl80211_wowlan_pattern_support nl80211_pattern_support
+
 /**
  * enum nl80211_wowlan_triggers - WoWLAN trigger definitions
  * @__NL80211_WOWLAN_TRIG_INVALID: invalid number for nested attributes
@@ -3108,7 +3117,7 @@ struct nl80211_wowlan_pattern_support {
  *	pattern matching is done after the packet is converted to the MSDU.
  *
  *	In %NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED, it is a binary attribute
- *	carrying a &struct nl80211_wowlan_pattern_support.
+ *	carrying a &struct nl80211_pattern_support.
  *
  *	When reporting wakeup. it is a u32 attribute containing the 0-based
  *	index of the pattern that caused the wakeup, in the patterns passed
@@ -3265,7 +3274,7 @@ struct nl80211_wowlan_tcp_data_token_feature {
  * @NL80211_WOWLAN_TCP_WAKE_PAYLOAD: wake packet payload, for advertising a
  *	u32 attribute holding the maximum length
  * @NL80211_WOWLAN_TCP_WAKE_MASK: Wake packet payload mask, not used for
- *	feature advertising. The mask works like @NL80211_WOWLAN_PKTPAT_MASK
+ *	feature advertising. The mask works like @NL80211_PKTPAT_MASK
  *	but on the TCP payload only.
  * @NUM_NL80211_WOWLAN_TCP: number of TCP attributes
  * @MAX_NL80211_WOWLAN_TCP: highest attribute number
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5f10f7a..5f640de 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1014,7 +1014,7 @@ static int nl80211_send_wowlan(struct sk_buff *msg,
 		return -ENOBUFS;
 
 	if (dev->wiphy.wowlan.n_patterns) {
-		struct nl80211_wowlan_pattern_support pat = {
+		struct nl80211_pattern_support pat = {
 			.max_patterns = dev->wiphy.wowlan.n_patterns,
 			.min_pattern_len = dev->wiphy.wowlan.pattern_min_len,
 			.max_pattern_len = dev->wiphy.wowlan.pattern_max_len,
@@ -7570,12 +7570,11 @@ static int nl80211_send_wowlan_patterns(struct sk_buff *msg,
 		if (!nl_pat)
 			return -ENOBUFS;
 		pat_len = rdev->wowlan->patterns[i].pattern_len;
-		if (nla_put(msg, NL80211_WOWLAN_PKTPAT_MASK,
-			    DIV_ROUND_UP(pat_len, 8),
+		if (nla_put(msg, NL80211_PKTPAT_MASK, DIV_ROUND_UP(pat_len, 8),
 			    rdev->wowlan->patterns[i].mask) ||
-		    nla_put(msg, NL80211_WOWLAN_PKTPAT_PATTERN,
-			    pat_len, rdev->wowlan->patterns[i].pattern) ||
-		    nla_put_u32(msg, NL80211_WOWLAN_PKTPAT_OFFSET,
+		    nla_put(msg, NL80211_PKTPAT_PATTERN, pat_len,
+			    rdev->wowlan->patterns[i].pattern) ||
+		    nla_put_u32(msg, NL80211_PKTPAT_OFFSET,
 				rdev->wowlan->patterns[i].pkt_offset))
 			return -ENOBUFS;
 		nla_nest_end(msg, nl_pat);
@@ -7915,7 +7914,7 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 		struct nlattr *pat;
 		int n_patterns = 0;
 		int rem, pat_len, mask_len, pkt_offset;
-		struct nlattr *pat_tb[NUM_NL80211_WOWLAN_PKTPAT];
+		struct nlattr *pat_tb[NUM_NL80211_PKTPAT];
 
 		nla_for_each_nested(pat, tb[NL80211_WOWLAN_TRIG_PKT_PATTERN],
 				    rem)
@@ -7934,26 +7933,25 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 
 		nla_for_each_nested(pat, tb[NL80211_WOWLAN_TRIG_PKT_PATTERN],
 				    rem) {
-			nla_parse(pat_tb, MAX_NL80211_WOWLAN_PKTPAT,
-				  nla_data(pat), nla_len(pat), NULL);
+			nla_parse(pat_tb, MAX_NL80211_PKTPAT, nla_data(pat),
+				  nla_len(pat), NULL);
 			err = -EINVAL;
-			if (!pat_tb[NL80211_WOWLAN_PKTPAT_MASK] ||
-			    !pat_tb[NL80211_WOWLAN_PKTPAT_PATTERN])
+			if (!pat_tb[NL80211_PKTPAT_MASK] ||
+			    !pat_tb[NL80211_PKTPAT_PATTERN])
 				goto error;
-			pat_len = nla_len(pat_tb[NL80211_WOWLAN_PKTPAT_PATTERN]);
+			pat_len = nla_len(pat_tb[NL80211_PKTPAT_PATTERN]);
 			mask_len = DIV_ROUND_UP(pat_len, 8);
-			if (nla_len(pat_tb[NL80211_WOWLAN_PKTPAT_MASK]) !=
-			    mask_len)
+			if (nla_len(pat_tb[NL80211_PKTPAT_MASK]) != mask_len)
 				goto error;
 			if (pat_len > wowlan->pattern_max_len ||
 			    pat_len < wowlan->pattern_min_len)
 				goto error;
 
-			if (!pat_tb[NL80211_WOWLAN_PKTPAT_OFFSET])
+			if (!pat_tb[NL80211_PKTPAT_OFFSET])
 				pkt_offset = 0;
 			else
 				pkt_offset = nla_get_u32(
-					pat_tb[NL80211_WOWLAN_PKTPAT_OFFSET]);
+					pat_tb[NL80211_PKTPAT_OFFSET]);
 			if (pkt_offset > wowlan->max_pkt_offset)
 				goto error;
 			new_triggers.patterns[i].pkt_offset = pkt_offset;
@@ -7967,11 +7965,11 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 			new_triggers.patterns[i].pattern =
 				new_triggers.patterns[i].mask + mask_len;
 			memcpy(new_triggers.patterns[i].mask,
-			       nla_data(pat_tb[NL80211_WOWLAN_PKTPAT_MASK]),
+			       nla_data(pat_tb[NL80211_PKTPAT_MASK]),
 			       mask_len);
 			new_triggers.patterns[i].pattern_len = pat_len;
 			memcpy(new_triggers.patterns[i].pattern,
-			       nla_data(pat_tb[NL80211_WOWLAN_PKTPAT_PATTERN]),
+			       nla_data(pat_tb[NL80211_PKTPAT_PATTERN]),
 			       pat_len);
 			i++;
 		}
-- 
1.8.0

