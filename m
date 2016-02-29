Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbcB2WF4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:56 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 080/113] rtl8xxxu: Correct struct rtl8723bu_efuse to list power bases correctly
Date: Mon, 29 Feb 2016 17:05:18 -0500
Message-Id: <1456783551-28315-81-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230815_902149_4F9E907B)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Correct TX power definitions in rtl8723bu_efuse

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 10 ----------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 23 ++++++++++++++++++-----
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 9caee4dc..0afa9a9 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2338,16 +2338,6 @@ static int rtl8723bu_parse_efuse(struct rtl8xxxu_priv *priv)
 
 	ether_addr_copy(priv->mac_addr, efuse->mac_addr);
 
-	memcpy(priv->cck_tx_power_index_A, efuse->cck_tx_power_index_A,
-	       sizeof(priv->cck_tx_power_index_A));
-	memcpy(priv->cck_tx_power_index_B, efuse->cck_tx_power_index_B,
-	       sizeof(priv->cck_tx_power_index_B));
-
-	memcpy(priv->ht40_1s_tx_power_index_A, efuse->ht40_1s_tx_power_index_A,
-	       sizeof(priv->ht40_1s_tx_power_index_A));
-	memcpy(priv->ht40_1s_tx_power_index_B, efuse->ht40_1s_tx_power_index_B,
-	       sizeof(priv->ht40_1s_tx_power_index_B));
-
 	priv->has_xtalk = 1;
 	priv->xtalk = priv->efuse_wifi.efuse8723bu.xtal_k & 0x3f;
 
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index ac8f47f..6d56581 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -53,6 +53,7 @@
 
 #define RTL8723A_CHANNEL_GROUPS		3
 #define RTL8723A_MAX_RF_PATHS		2
+#define RTL8723B_MAX_RF_PATHS		4
 #define RF6052_MAX_TX_PWR		0x3f
 
 #define EFUSE_MAP_LEN			512
@@ -631,14 +632,26 @@ struct rtl8192cu_efuse {
 	u8 customer_id;
 };
 
+struct rtl8723bu_efuse_tx_power {
+	u8 cck_base[6];
+	u8 ht40_base[5];
+	struct rtl8723au_idx ht20_ofdm_1s_diff;
+	struct rtl8723au_idx ht40_ht20_2s_diff;
+	struct rtl8723au_idx ofdm_cck_2s_diff; /* not used */
+	struct rtl8723au_idx ht40_ht20_3s_diff;
+	struct rtl8723au_idx ofdm_cck_3s_diff; /* not used */
+	struct rtl8723au_idx ht40_ht20_4s_diff;
+	struct rtl8723au_idx ofdm_cck_4s_diff; /* not used */
+	u8 dummy5g[24]; /* max channel group (14) + power diff offset (10) */
+};
+
 struct rtl8723bu_efuse {
 	__le16 rtl_id;
 	u8 res0[0x0e];
-	u8 cck_tx_power_index_A[3];	/* 0x10 */
-	u8 cck_tx_power_index_B[3];
-	u8 ht40_1s_tx_power_index_A[3];	/* 0x16 */
-	u8 ht40_1s_tx_power_index_B[3];
-	u8 res1[0x9c];
+	struct rtl8723bu_efuse_tx_power tx_power_index_A;	/* 0x10 */
+	struct rtl8723bu_efuse_tx_power tx_power_index_B;	/* 0x3a */
+	struct rtl8723bu_efuse_tx_power tx_power_index_C;	/* 0x64 */
+	struct rtl8723bu_efuse_tx_power tx_power_index_D;	/* 0x8e */
 	u8 channel_plan;		/* 0xb8 */
 	u8 xtal_k;
 	u8 thermal_meter;
-- 
2.5.0

