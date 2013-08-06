Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:51214 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153Ab3HFByK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 21:54:10 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/4] mwifiex: rename mef macros
Date: Mon, 5 Aug 2013 18:51:57 -0700
Message-ID: <1375753920-10100-1-git-send-email-bzhao@marvell.com> (sfid-20130806_035415_942560_832F2422)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Their names were generic. We need to define similar macros
for coalesce feature. Hence they are renamed here.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 17 +++++++++--------
 drivers/net/wireless/mwifiex/ioctl.h    |  8 ++++----
 drivers/net/wireless/mwifiex/sta_cmd.c  |  4 ++--
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index c5e21ed..326f4d9 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2327,12 +2327,12 @@ mwifiex_is_pattern_supported(struct cfg80211_pkt_pattern *pat, s8 *byte_seq)
 					dont_care_byte = true;
 			}
 
-			if (valid_byte_cnt > MAX_BYTESEQ)
+			if (valid_byte_cnt > MWIFIEX_MEF_MAX_BYTESEQ)
 				return false;
 		}
 	}
 
-	byte_seq[MAX_BYTESEQ] = valid_byte_cnt;
+	byte_seq[MWIFIEX_MEF_MAX_BYTESEQ] = valid_byte_cnt;
 
 	return true;
 }
@@ -2345,7 +2345,7 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 	struct mwifiex_mef_entry *mef_entry;
 	int i, filt_num = 0, ret;
 	bool first_pat = true;
-	u8 byte_seq[MAX_BYTESEQ + 1];
+	u8 byte_seq[MWIFIEX_MEF_MAX_BYTESEQ + 1];
 	const u8 ipv4_mc_mac[] = {0x33, 0x33};
 	const u8 ipv6_mc_mac[] = {0x01, 0x00, 0x5e};
 	struct mwifiex_private *priv =
@@ -2383,16 +2383,16 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 
 		if (!wowlan->patterns[i].pkt_offset) {
 			if (!(byte_seq[0] & 0x01) &&
-			    (byte_seq[MAX_BYTESEQ] == 1)) {
+			    (byte_seq[MWIFIEX_MEF_MAX_BYTESEQ] == 1)) {
 				mef_cfg.criteria |= MWIFIEX_CRITERIA_UNICAST;
 				continue;
 			} else if (is_broadcast_ether_addr(byte_seq)) {
 				mef_cfg.criteria |= MWIFIEX_CRITERIA_BROADCAST;
 				continue;
 			} else if ((!memcmp(byte_seq, ipv4_mc_mac, 2) &&
-				    (byte_seq[MAX_BYTESEQ] == 2)) ||
+				    (byte_seq[MWIFIEX_MEF_MAX_BYTESEQ] == 2)) ||
 				   (!memcmp(byte_seq, ipv6_mc_mac, 3) &&
-				    (byte_seq[MAX_BYTESEQ] == 3))) {
+				    (byte_seq[MWIFIEX_MEF_MAX_BYTESEQ] == 3))) {
 				mef_cfg.criteria |= MWIFIEX_CRITERIA_MULTICAST;
 				continue;
 			}
@@ -2418,7 +2418,8 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 		mef_entry->filter[filt_num].repeat = 16;
 		memcpy(mef_entry->filter[filt_num].byte_seq, priv->curr_addr,
 		       ETH_ALEN);
-		mef_entry->filter[filt_num].byte_seq[MAX_BYTESEQ] = ETH_ALEN;
+		mef_entry->filter[filt_num].byte_seq[MWIFIEX_MEF_MAX_BYTESEQ] =
+								ETH_ALEN;
 		mef_entry->filter[filt_num].offset = 14;
 		mef_entry->filter[filt_num].filt_type = TYPE_EQ;
 		if (filt_num)
@@ -2491,7 +2492,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 #ifdef CONFIG_PM
 static const struct wiphy_wowlan_support mwifiex_wowlan_support = {
 	.flags = WIPHY_WOWLAN_MAGIC_PKT,
-	.n_patterns = MWIFIEX_MAX_FILTERS,
+	.n_patterns = MWIFIEX_MEF_MAX_FILTERS,
 	.pattern_min_len = 1,
 	.pattern_max_len = MWIFIEX_MAX_PATTERN_LEN,
 	.max_pkt_offset = MWIFIEX_MAX_OFFSET_LEN,
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 7f27e45..5ecda45 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -362,13 +362,13 @@ struct mwifiex_ds_misc_subsc_evt {
 	struct subsc_evt_cfg bcn_h_rssi_cfg;
 };
 
-#define MAX_BYTESEQ		6	/* non-adjustable */
-#define MWIFIEX_MAX_FILTERS	10
+#define MWIFIEX_MEF_MAX_BYTESEQ		6	/* non-adjustable */
+#define MWIFIEX_MEF_MAX_FILTERS		10
 
 struct mwifiex_mef_filter {
 	u16 repeat;
 	u16 offset;
-	s8 byte_seq[MAX_BYTESEQ + 1];
+	s8 byte_seq[MWIFIEX_MEF_MAX_BYTESEQ + 1];
 	u8 filt_type;
 	u8 filt_action;
 };
@@ -376,7 +376,7 @@ struct mwifiex_mef_filter {
 struct mwifiex_mef_entry {
 	u8 mode;
 	u8 action;
-	struct mwifiex_mef_filter filter[MWIFIEX_MAX_FILTERS];
+	struct mwifiex_mef_filter filter[MWIFIEX_MEF_MAX_FILTERS];
 };
 
 struct mwifiex_ds_mef_cfg {
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 9b75ed8..448baf1 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1070,7 +1070,7 @@ mwifiex_cmd_append_rpn_expression(struct mwifiex_private *priv,
 	int i, byte_len;
 	u8 *stack_ptr = *buffer;
 
-	for (i = 0; i < MWIFIEX_MAX_FILTERS; i++) {
+	for (i = 0; i < MWIFIEX_MEF_MAX_FILTERS; i++) {
 		filter = &mef_entry->filter[i];
 		if (!filter->filt_type)
 			break;
@@ -1079,7 +1079,7 @@ mwifiex_cmd_append_rpn_expression(struct mwifiex_private *priv,
 		*stack_ptr = TYPE_DNUM;
 		stack_ptr += 1;
 
-		byte_len = filter->byte_seq[MAX_BYTESEQ];
+		byte_len = filter->byte_seq[MWIFIEX_MEF_MAX_BYTESEQ];
 		memcpy(stack_ptr, filter->byte_seq, byte_len);
 		stack_ptr += byte_len;
 		*stack_ptr = byte_len;
-- 
1.8.2.3

