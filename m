Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:36442 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbbJTGq2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 02:46:28 -0400
Received: by lbcao8 with SMTP id ao8so7728962lbc.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2015 23:46:26 -0700 (PDT)
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: Jes.Sorensen@redhat.com
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
	Jakub Sitnicki <jsitnicki@gmail.com>
Subject: [RFC 10/16] rtl8xxxu: Rename struct rtl8723au_idx
Date: Tue, 20 Oct 2015 08:45:40 +0200
Message-Id: <1445323546-12807-11-git-send-email-jsitnicki@gmail.com> (sfid-20151020_084635_021325_205E6356)
In-Reply-To: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 16 +++++-----
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 38 ++++++++++++------------
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 992bcda..d48db87 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1505,21 +1505,21 @@ rtl8723a_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 	ofdm[0] = tx_power->ht40_1s_index_A[group];
 	ofdm[1] = tx_power->ht40_1s_index_B[group];
 
-	ofdmbase[0] = ofdm[0] +	tx_power->ofdm_index_diff[group].a;
-	ofdmbase[1] = ofdm[1] +	tx_power->ofdm_index_diff[group].b;
+	ofdmbase[0] = ofdm[0] +	tx_power->ofdm_index_diff[group].low;
+	ofdmbase[1] = ofdm[1] +	tx_power->ofdm_index_diff[group].high;
 
 	mcsbase[0] = ofdm[0];
 	mcsbase[1] = ofdm[1];
 	if (!ht40) {
-		mcsbase[0] += tx_power->ht20_index_diff[group].a;
-		mcsbase[1] += tx_power->ht20_index_diff[group].b;
+		mcsbase[0] += tx_power->ht20_index_diff[group].low;
+		mcsbase[1] += tx_power->ht20_index_diff[group].high;
 	}
 
 	if (priv->tx_paths > 1) {
-		if (ofdm[0] > tx_power->ht40_2s_index_diff[group].a)
-			ofdm[0] -= tx_power->ht40_2s_index_diff[group].a;
-		if (ofdm[1] > tx_power->ht40_2s_index_diff[group].b)
-			ofdm[1] -= tx_power->ht40_2s_index_diff[group].b;
+		if (ofdm[0] > tx_power->ht40_2s_index_diff[group].low)
+			ofdm[0] -= tx_power->ht40_2s_index_diff[group].low;
+		if (ofdm[1] > tx_power->ht40_2s_index_diff[group].high)
+			ofdm[1] -= tx_power->ht40_2s_index_diff[group].high;
 	}
 
 	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_CHANNEL)
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 23bf4c0..2f5f903 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -407,13 +407,13 @@ struct rtl8xxxu_firmware_header {
 /*
  * The 8723au has 3 channel groups: 1-3, 4-9, and 10-14
  */
-struct rtl8723au_idx {
+struct nibble_pair {
 #ifdef __LITTLE_ENDIAN
-	int	a:4;
-	int	b:4;
+	int	low:4;
+	int	high:4;
 #else
-	int	b:4;
-	int	a:4;
+	int	high:4;
+	int	low:4;
 #endif
 } __attribute__((packed));
 
@@ -428,10 +428,10 @@ struct rtl8723au_efuse {
 	 * The following entries are half-bytes split as:
 	 * bits 0-3: path A, bits 4-7: path B, all values 4 bits signed
 	 */
-	struct rtl8723au_idx ht20_tx_power_index_diff[3];
-	struct rtl8723au_idx ofdm_tx_power_index_diff[3];
-	struct rtl8723au_idx ht40_max_power_offset[3];
-	struct rtl8723au_idx ht20_max_power_offset[3];
+	struct nibble_pair ht20_tx_power_index_diff[3];
+	struct nibble_pair ofdm_tx_power_index_diff[3];
+	struct nibble_pair ht40_max_power_offset[3];
+	struct nibble_pair ht20_max_power_offset[3];
 	u8 channel_plan;		/* 0x28 */
 	u8 tssi_a;
 	u8 thermal_meter;
@@ -482,11 +482,11 @@ struct rtl8192cu_efuse {
 	 * The following entries are half-bytes split as:
 	 * bits 0-3: path A, bits 4-7: path B, all values 4 bits signed
 	 */
-	struct rtl8723au_idx ht40_2s_tx_power_index_diff[3];
-	struct rtl8723au_idx ht20_tx_power_index_diff[3];	/* 0x69 */
-	struct rtl8723au_idx ofdm_tx_power_index_diff[3];
-	struct rtl8723au_idx ht40_max_power_offset[3];		/* 0x6f */
-	struct rtl8723au_idx ht20_max_power_offset[3];
+	struct nibble_pair ht40_2s_tx_power_index_diff[3];
+	struct nibble_pair ht20_tx_power_index_diff[3];		/* 0x69 */
+	struct nibble_pair ofdm_tx_power_index_diff[3];
+	struct nibble_pair ht40_max_power_offset[3];		/* 0x6f */
+	struct nibble_pair ht20_max_power_offset[3];
 	u8 channel_plan;					/* 0x75 */
 	u8 tssi_a;
 	u8 tssi_b;
@@ -573,11 +573,11 @@ struct rtl8723au_tx_power {
 	 * The following entries are half-bytes split as:
 	 * bits 0-3: path A, bits 4-7: path B, all values 4 bits signed
 	 */
-	struct rtl8723au_idx ht40_2s_index_diff[3];
-	struct rtl8723au_idx ht20_index_diff[3];
-	struct rtl8723au_idx ofdm_index_diff[3];
-	struct rtl8723au_idx ht40_max_offset[3];
-	struct rtl8723au_idx ht20_max_offset[3];
+	struct nibble_pair ht40_2s_index_diff[3];
+	struct nibble_pair ht20_index_diff[3];
+	struct nibble_pair ofdm_index_diff[3];
+	struct nibble_pair ht40_max_offset[3];
+	struct nibble_pair ht20_max_offset[3];
 };
 
 struct rtl8xxxu_priv {
-- 
2.1.0

