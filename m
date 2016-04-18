Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbcDRPti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 11:49:38 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 13/16] rtl8xxxu: Rename rtl8723a_mac_init_table to rtl8xxxu_gen1_mac_init_table
Date: Mon, 18 Apr 2016 11:49:33 -0400
Message-Id: <1460994576-24091-14-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160418_174953_070298_41FC887A)
In-Reply-To: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

All currently supported gen1 parts use the same mac_init_table, so
rename it to reflect this.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index a2f5609..fb13a77 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -128,7 +128,7 @@ static struct ieee80211_supported_band rtl8xxxu_supported_band = {
 	.n_bitrates = ARRAY_SIZE(rtl8xxxu_rates),
 };
 
-static struct rtl8xxxu_reg8val rtl8723a_mac_init_table[] = {
+static struct rtl8xxxu_reg8val rtl8xxxu_gen1_mac_init_table[] = {
 	{0x420, 0x80}, {0x423, 0x00}, {0x430, 0x00}, {0x431, 0x00},
 	{0x432, 0x00}, {0x433, 0x01}, {0x434, 0x04}, {0x435, 0x05},
 	{0x436, 0x06}, {0x437, 0x07}, {0x438, 0x00}, {0x439, 0x00},
@@ -9899,7 +9899,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.trxff_boundary = 0x27ff,
 	.pbp_rx = PBP_PAGE_SIZE_128,
 	.pbp_tx = PBP_PAGE_SIZE_128,
-	.mactable = rtl8723a_mac_init_table,
+	.mactable = rtl8xxxu_gen1_mac_init_table,
 };
 
 static struct rtl8xxxu_fileops rtl8723bu_fops = {
@@ -9971,7 +9971,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.trxff_boundary = 0x27ff,
 	.pbp_rx = PBP_PAGE_SIZE_128,
 	.pbp_tx = PBP_PAGE_SIZE_128,
-	.mactable = rtl8723a_mac_init_table,
+	.mactable = rtl8xxxu_gen1_mac_init_table,
 };
 
 #endif
-- 
2.5.5

