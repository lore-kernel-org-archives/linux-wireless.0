Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbcB2WFy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:54 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jakub Sitnicki <jsitnicki@gmail.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 041/113] rtl8xxxu: rtl8192eu: Map out EFUSE TX power area
Date: Mon, 29 Feb 2016 17:04:39 -0500
Message-Id: <1456783551-28315-42-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230608_734812_C6DDCF83)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jakub Sitnicki <jsitnicki@gmail.com>

TX power values are laid out differently in EFUSE found in RTL8192EU &
RTL8188EU devices.  TX power indices and differences for each RF path
are not interleaved (A, B, A, B), as in other chips, but follow one
another (A, B, C, D).

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 10 ----------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 22 +++++++++++++++++-----
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index e3e08da..cd13524 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2293,16 +2293,6 @@ static int rtl8192eu_parse_efuse(struct rtl8xxxu_priv *priv)
 
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
 	dev_info(&priv->udev->dev, "Vendor: %.7s\n", efuse->vendor_name);
 	dev_info(&priv->udev->dev, "Product: %.11s\n", efuse->device_name);
 	dev_info(&priv->udev->dev, "Serial: %.11s\n", efuse->serial);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 7b76e11..6c6bac2 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -543,14 +543,26 @@ struct rtl8723bu_efuse {
 	u8 res12[0x4];
 };
 
+struct rtl8192eu_efuse_tx_power {
+	u8 cck_base[6];
+	u8 ht40_base[5];
+	struct rtl8723au_idx ht20_ofdm_1s_diff;
+	struct rtl8723au_idx ht40_ht20_2s_diff;
+	struct rtl8723au_idx ofdm_cck_2s_diff; /* not used */
+	struct rtl8723au_idx ht40_ht20_3s_diff;
+	struct rtl8723au_idx ofdm_cck_3s_diff; /* not used */
+	struct rtl8723au_idx ht40_ht20_4s_diff;
+	struct rtl8723au_idx ofdm_cck_4s_diff; /* not used */
+};
+
 struct rtl8192eu_efuse {
 	__le16 rtl_id;
 	u8 res0[0x0e];
-	u8 cck_tx_power_index_A[3];	/* 0x10 */
-	u8 cck_tx_power_index_B[3];
-	u8 ht40_1s_tx_power_index_A[3];	/* 0x16 */
-	u8 ht40_1s_tx_power_index_B[3];
-	u8 res1[0x9c];
+	struct rtl8192eu_efuse_tx_power tx_power_index_A;	/* 0x10 */
+	struct rtl8192eu_efuse_tx_power tx_power_index_B;	/* 0x22 */
+	struct rtl8192eu_efuse_tx_power tx_power_index_C;	/* 0x34 */
+	struct rtl8192eu_efuse_tx_power tx_power_index_D;	/* 0x46 */
+	u8 res1[0x60];
 	u8 channel_plan;		/* 0xb8 */
 	u8 xtal_k;
 	u8 thermal_meter;
-- 
2.5.0

