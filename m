Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 22/26] rtl8xxxu: Make PBP tuning a fileops parameter
Date: Thu, 14 Apr 2016 14:59:03 -0400
Message-Id: <1460660347-26299-23-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_205933_935905_7D01DB22)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Rather than scattering the code with #ifdefs, use the fileops
structure to hold device specific PBP values.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 17 ++++++++++-------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  2 ++
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index c12a4c8..3e3ca28 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7687,14 +7687,11 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	}
 
 	/*
-	 * Transfer page size is always 128
+	 * The vendor drivers set PBP for all devices, except 8192e.
+	 * There is no explanation for this in any of the sources.
 	 */
-	if (priv->rtl_chip == RTL8723B)
-		val8 = (PBP_PAGE_SIZE_256 << PBP_PAGE_SIZE_RX_SHIFT) |
-			(PBP_PAGE_SIZE_256 << PBP_PAGE_SIZE_TX_SHIFT);
-	else
-		val8 = (PBP_PAGE_SIZE_128 << PBP_PAGE_SIZE_RX_SHIFT) |
-			(PBP_PAGE_SIZE_128 << PBP_PAGE_SIZE_TX_SHIFT);
+	val8 = (priv->fops->pbp_rx << PBP_PAGE_SIZE_RX_SHIFT) |
+		(priv->fops->pbp_tx << PBP_PAGE_SIZE_TX_SHIFT);
 	if (priv->rtl_chip != RTL8192E)
 		rtl8xxxu_write8(priv, REG_PBP, val8);
 
@@ -9728,6 +9725,8 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.adda_2t_path_on_a = 0x04db25a4,
 	.adda_2t_path_on_b = 0x0b1b25a4,
 	.trxff_boundary = 0x27ff,
+	.pbp_rx = PBP_PAGE_SIZE_128,
+	.pbp_tx = PBP_PAGE_SIZE_128,
 	.mactable = rtl8723a_mac_init_table,
 };
 
@@ -9761,6 +9760,8 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.adda_2t_path_on_a = 0x01c00014,
 	.adda_2t_path_on_b = 0x01c00014,
 	.trxff_boundary = 0x3f7f,
+	.pbp_rx = PBP_PAGE_SIZE_256,
+	.pbp_tx = PBP_PAGE_SIZE_256,
 	.mactable = rtl8723b_mac_init_table,
 };
 
@@ -9792,6 +9793,8 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.adda_2t_path_on_a = 0x04db25a4,
 	.adda_2t_path_on_b = 0x0b1b25a4,
 	.trxff_boundary = 0x27ff,
+	.pbp_rx = PBP_PAGE_SIZE_128,
+	.pbp_tx = PBP_PAGE_SIZE_128,
 	.mactable = rtl8723a_mac_init_table,
 };
 
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index b87cd2b..8064b26 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1310,6 +1310,8 @@ struct rtl8xxxu_fileops {
 	u32 adda_2t_path_on_a;
 	u32 adda_2t_path_on_b;
 	u16 trxff_boundary;
+	u8 pbp_rx;
+	u8 pbp_tx;
 	struct rtl8xxxu_reg8val *mactable;
 	u8 total_page_num;
 	u8 page_num_hi;
-- 
2.5.5

