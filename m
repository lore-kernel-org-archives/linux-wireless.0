Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 20/26] rtl8xxxu: Store device specific TRXFF boundary in the fileops
Date: Thu, 14 Apr 2016 14:59:01 -0400
Message-Id: <1460660347-26299-21-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_205941_632125_DF85B229)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This removes another case of ugly if () clutter

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 11 +++++------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  1 +
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 4ef8a05..ef93f62 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7552,12 +7552,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	/*
 	 * Set RX page boundary
 	 */
-	if (priv->rtl_chip == RTL8723B)
-		rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, 0x3f7f);
-	else if (priv->rtl_chip == RTL8192E)
-		rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, 0x3cff);
-	else
-		rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, 0x27ff);
+	rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, priv->fops->trxff_boundary);
 
 	ret = rtl8xxxu_download_firmware(priv);
 	dev_dbg(dev, "%s: download_fiwmare %i\n", __func__, ret);
@@ -9735,6 +9730,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.adda_1t_path_on = 0x0bdb25a0,
 	.adda_2t_path_on_a = 0x04db25a4,
 	.adda_2t_path_on_b = 0x0b1b25a4,
+	.trxff_boundary = 0x27ff,
 	.mactable = rtl8723a_mac_init_table,
 };
 
@@ -9767,6 +9763,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.adda_1t_path_on = 0x01c00014,
 	.adda_2t_path_on_a = 0x01c00014,
 	.adda_2t_path_on_b = 0x01c00014,
+	.trxff_boundary = 0x3f7f,
 	.mactable = rtl8723b_mac_init_table,
 };
 
@@ -9797,6 +9794,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.adda_1t_path_on = 0x0bdb25a0,
 	.adda_2t_path_on_a = 0x04db25a4,
 	.adda_2t_path_on_b = 0x0b1b25a4,
+	.trxff_boundary = 0x27ff,
 	.mactable = rtl8723a_mac_init_table,
 };
 
@@ -9828,6 +9826,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.adda_1t_path_on = 0x0fc01616,
 	.adda_2t_path_on_a = 0x0fc01616,
 	.adda_2t_path_on_b = 0x0fc01616,
+	.trxff_boundary = 0x3cff,
 	.mactable = rtl8192e_mac_init_table,
 	.total_page_num = TX_TOTAL_PAGE_NUM_8192E,
 	.page_num_hi = TX_PAGE_NUM_HI_PQ_8192E,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 28874fa..f66e20d 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1310,6 +1310,7 @@ struct rtl8xxxu_fileops {
 	u32 adda_1t_path_on;
 	u32 adda_2t_path_on_a;
 	u32 adda_2t_path_on_b;
+	u16 trxff_boundary;
 	struct rtl8xxxu_reg8val *mactable;
 	u8 total_page_num;
 	u8 page_num_hi;
-- 
2.5.5

