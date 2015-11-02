Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:34846 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbbKBIWK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 03:22:10 -0500
Received: by lbbes7 with SMTP id es7so82664692lbb.2
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2015 00:22:09 -0800 (PST)
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
	Jakub Sitnicki <jsitnicki@gmail.com>
Subject: [PATCH] rtl8xxxu: rtl8192eu: Map out EFUSE TX power area
Date: Mon,  2 Nov 2015 09:21:57 +0100
Message-Id: <1446452517-14920-1-git-send-email-jsitnicki@gmail.com> (sfid-20151102_092237_793024_799F543B)
In-Reply-To: <wrfjh9ld34ng.fsf@redhat.com>
References: <wrfjh9ld34ng.fsf@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TX power values are laid out differently in EFUSE found in RTL8192EU &
RTL8188EU devices.  TX power indices and differences for each RF path
are not interleaved (A, B, A, B), as in other chips, but follow one
another (A, B, C, D).

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
---

Jes,

I reckon this is as "pretty" as it gets.  I even took the time to draw
it out:

  https://github.com/jsitnicki/realtek-notes/blob/master/efuse-tx-power.pdf

The whole TX power area is aligned to a multiple of 8, but subareas
for each RF path are not aligned (they are 18 bytes long each).

Patch is for rtl8xxxu-nextgen, of course.  Anything you would rename?

Cheers,
Jakub

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c |  4 ++--
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 22 +++++++++++++++++-----
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 8c7d2da..6a89710 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2300,7 +2300,7 @@ static int rtl8192eu_parse_efuse(struct rtl8xxxu_priv *priv)
 		return -EINVAL;
 
 	ether_addr_copy(priv->mac_addr, efuse->mac_addr);
-
+#if 0
 	memcpy(priv->cck_tx_power_index_A, efuse->cck_tx_power_index_A,
 	       sizeof(priv->cck_tx_power_index_A));
 	memcpy(priv->cck_tx_power_index_B, efuse->cck_tx_power_index_B,
@@ -2310,7 +2310,7 @@ static int rtl8192eu_parse_efuse(struct rtl8xxxu_priv *priv)
 	       sizeof(priv->ht40_1s_tx_power_index_A));
 	memcpy(priv->ht40_1s_tx_power_index_B, efuse->ht40_1s_tx_power_index_B,
 	       sizeof(priv->ht40_1s_tx_power_index_B));
-#if 0
+
 	memcpy(priv->ht40_2s_tx_power_index_diff,
 	       efuse->ht40_2s_tx_power_index_diff,
 	       sizeof(priv->ht40_2s_tx_power_index_diff));
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 4b8431d..b223831 100644
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
2.1.0

