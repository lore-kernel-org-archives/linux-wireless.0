Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193AbcB2WF4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:56 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 084/113] rtl8xxxu: Parse efuse power indices for 8723bu
Date: Mon, 29 Feb 2016 17:05:22 -0500
Message-Id: <1456783551-28315-85-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230758_467612_333E627D)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This should (hopefully) parse the power indices correctly for the
8723bu.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 43 ++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 43 +++++++++++++++---------
 2 files changed, 71 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 39c6322..970f0ec 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2358,12 +2358,55 @@ static int rtl8723au_parse_efuse(struct rtl8xxxu_priv *priv)
 static int rtl8723bu_parse_efuse(struct rtl8xxxu_priv *priv)
 {
 	struct rtl8723bu_efuse *efuse = &priv->efuse_wifi.efuse8723bu;
+	int i;
 
 	if (efuse->rtl_id != cpu_to_le16(0x8129))
 		return -EINVAL;
 
 	ether_addr_copy(priv->mac_addr, efuse->mac_addr);
 
+	memcpy(priv->cck_tx_power_index_A, efuse->tx_power_index_A.cck_base,
+	       sizeof(efuse->tx_power_index_A.cck_base));
+	memcpy(priv->cck_tx_power_index_B, efuse->tx_power_index_B.cck_base,
+	       sizeof(efuse->tx_power_index_B.cck_base));
+
+	memcpy(priv->ht40_1s_tx_power_index_A,
+	       efuse->tx_power_index_A.ht40_base,
+	       sizeof(efuse->tx_power_index_A.ht40_base));
+	memcpy(priv->ht40_1s_tx_power_index_B,
+	       efuse->tx_power_index_B.ht40_base,
+	       sizeof(efuse->tx_power_index_B.ht40_base));
+
+	priv->ofdm_tx_power_diff[0].a =
+		efuse->tx_power_index_A.ht20_ofdm_1s_diff.a;
+	priv->ofdm_tx_power_diff[0].b =
+		efuse->tx_power_index_B.ht20_ofdm_1s_diff.a;
+
+	priv->ht20_tx_power_diff[0].a =
+		efuse->tx_power_index_A.ht20_ofdm_1s_diff.b;
+	priv->ht20_tx_power_diff[0].b =
+		efuse->tx_power_index_B.ht20_ofdm_1s_diff.b;
+
+	priv->ht40_tx_power_diff[0].a = 0;
+	priv->ht40_tx_power_diff[0].b = 0;
+
+	for (i = 1; i < RTL8723B_TX_COUNT; i++) {
+		priv->ofdm_tx_power_diff[i].a =
+			efuse->tx_power_index_A.pwr_diff[i - 1].ofdm;
+		priv->ofdm_tx_power_diff[i].b =
+			efuse->tx_power_index_B.pwr_diff[i - 1].ofdm;
+
+		priv->ht20_tx_power_diff[i].a =
+			efuse->tx_power_index_A.pwr_diff[i - 1].ht20;
+		priv->ht20_tx_power_diff[i].b =
+			efuse->tx_power_index_B.pwr_diff[i - 1].ht20;
+
+		priv->ht40_tx_power_diff[i].a =
+			efuse->tx_power_index_A.pwr_diff[i - 1].ht40;
+		priv->ht40_tx_power_diff[i].b =
+			efuse->tx_power_index_B.pwr_diff[i - 1].ht40;
+	}
+
 	priv->has_xtalk = 1;
 	priv->xtalk = priv->efuse_wifi.efuse8723bu.xtal_k & 0x3f;
 
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 92768f5..fe23561 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -54,6 +54,7 @@
 #define RTL8723A_CHANNEL_GROUPS		3
 #define RTL8723A_MAX_RF_PATHS		2
 #define RTL8723B_CHANNEL_GROUPS		6
+#define RTL8723B_TX_COUNT		4
 #define RTL8723B_MAX_RF_PATHS		4
 #define RTL8XXXU_MAX_CHANNEL_GROUPS	6
 #define RF6052_MAX_TX_PWR		0x3f
@@ -634,16 +635,25 @@ struct rtl8192cu_efuse {
 	u8 customer_id;
 };
 
+struct rtl8723bu_pwr_idx {
+#ifdef __LITTLE_ENDIAN
+	int	ht20:4;
+	int	ht40:4;
+	int	ofdm:4;
+	int	cck:4;
+#else
+	int	cck:4;
+	int	ofdm:4;
+	int	ht40:4;
+	int	ht20:4;
+#endif
+} __attribute__((packed));
+
 struct rtl8723bu_efuse_tx_power {
 	u8 cck_base[6];
 	u8 ht40_base[5];
 	struct rtl8723au_idx ht20_ofdm_1s_diff;
-	struct rtl8723au_idx ht40_ht20_2s_diff;
-	struct rtl8723au_idx ofdm_cck_2s_diff; /* not used */
-	struct rtl8723au_idx ht40_ht20_3s_diff;
-	struct rtl8723au_idx ofdm_cck_3s_diff; /* not used */
-	struct rtl8723au_idx ht40_ht20_4s_diff;
-	struct rtl8723au_idx ofdm_cck_4s_diff; /* not used */
+	struct rtl8723bu_pwr_idx pwr_diff[3];
 	u8 dummy5g[24]; /* max channel group (14) + power diff offset (10) */
 };
 
@@ -1057,15 +1067,18 @@ struct rtl8xxxu_priv {
 	 * bits 0-3: path A, bits 4-7: path B, all values 4 bits signed
 	 */
 	struct rtl8723au_idx ht40_2s_tx_power_index_diff[
-		RTL8XXXU_MAX_CHANNEL_GROUPS];
-	struct rtl8723au_idx ht20_tx_power_index_diff[
-		RTL8XXXU_MAX_CHANNEL_GROUPS];
-	struct rtl8723au_idx ofdm_tx_power_index_diff[
-		RTL8XXXU_MAX_CHANNEL_GROUPS];
-	struct rtl8723au_idx ht40_max_power_offset[
-		RTL8XXXU_MAX_CHANNEL_GROUPS];
-	struct rtl8723au_idx ht20_max_power_offset[
-		RTL8XXXU_MAX_CHANNEL_GROUPS];
+		RTL8723A_CHANNEL_GROUPS];
+	struct rtl8723au_idx ht20_tx_power_index_diff[RTL8723A_CHANNEL_GROUPS];
+	struct rtl8723au_idx ofdm_tx_power_index_diff[RTL8723A_CHANNEL_GROUPS];
+	struct rtl8723au_idx ht40_max_power_offset[RTL8723A_CHANNEL_GROUPS];
+	struct rtl8723au_idx ht20_max_power_offset[RTL8723A_CHANNEL_GROUPS];
+	/*
+	 * Newer generation chips only keep power diffs per TX count,
+	 * not per channel group.
+	 */
+	struct rtl8723au_idx ofdm_tx_power_diff[RTL8723B_TX_COUNT];
+	struct rtl8723au_idx ht20_tx_power_diff[RTL8723B_TX_COUNT];
+	struct rtl8723au_idx ht40_tx_power_diff[RTL8723B_TX_COUNT];
 	u32 chip_cut:4;
 	u32 rom_rev:4;
 	u32 is_multi_func:1;
-- 
2.5.0

