Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbcB2WGA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:00 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 083/113] rtl8xxxu: Bump TX power arrays to handle larger channel groups
Date: Mon, 29 Feb 2016 17:05:21 -0500
Message-Id: <1456783551-28315-84-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232950_198342_B6CA4449)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Newer generation chips have more channels groups. In order to carry
the larger arrays in common structures, bump the array sizes to
match.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 25 +++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index c7b4c92..92768f5 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -53,7 +53,9 @@
 
 #define RTL8723A_CHANNEL_GROUPS		3
 #define RTL8723A_MAX_RF_PATHS		2
+#define RTL8723B_CHANNEL_GROUPS		6
 #define RTL8723B_MAX_RF_PATHS		4
+#define RTL8XXXU_MAX_CHANNEL_GROUPS	6
 #define RF6052_MAX_TX_PWR		0x3f
 
 #define EFUSE_MAP_LEN			512
@@ -1046,19 +1048,24 @@ struct rtl8xxxu_priv {
 	u8 mac_addr[ETH_ALEN];
 	char chip_name[8];
 	char chip_vendor[8];
-	u8 cck_tx_power_index_A[3];	/* 0x10 */
-	u8 cck_tx_power_index_B[3];
-	u8 ht40_1s_tx_power_index_A[3];	/* 0x16 */
-	u8 ht40_1s_tx_power_index_B[3];
+	u8 cck_tx_power_index_A[RTL8XXXU_MAX_CHANNEL_GROUPS];
+	u8 cck_tx_power_index_B[RTL8XXXU_MAX_CHANNEL_GROUPS];
+	u8 ht40_1s_tx_power_index_A[RTL8XXXU_MAX_CHANNEL_GROUPS];
+	u8 ht40_1s_tx_power_index_B[RTL8XXXU_MAX_CHANNEL_GROUPS];
 	/*
 	 * The following entries are half-bytes split as:
 	 * bits 0-3: path A, bits 4-7: path B, all values 4 bits signed
 	 */
-	struct rtl8723au_idx ht40_2s_tx_power_index_diff[3];
-	struct rtl8723au_idx ht20_tx_power_index_diff[3];
-	struct rtl8723au_idx ofdm_tx_power_index_diff[3];
-	struct rtl8723au_idx ht40_max_power_offset[3];
-	struct rtl8723au_idx ht20_max_power_offset[3];
+	struct rtl8723au_idx ht40_2s_tx_power_index_diff[
+		RTL8XXXU_MAX_CHANNEL_GROUPS];
+	struct rtl8723au_idx ht20_tx_power_index_diff[
+		RTL8XXXU_MAX_CHANNEL_GROUPS];
+	struct rtl8723au_idx ofdm_tx_power_index_diff[
+		RTL8XXXU_MAX_CHANNEL_GROUPS];
+	struct rtl8723au_idx ht40_max_power_offset[
+		RTL8XXXU_MAX_CHANNEL_GROUPS];
+	struct rtl8723au_idx ht20_max_power_offset[
+		RTL8XXXU_MAX_CHANNEL_GROUPS];
 	u32 chip_cut:4;
 	u32 rom_rev:4;
 	u32 is_multi_func:1;
-- 
2.5.0

