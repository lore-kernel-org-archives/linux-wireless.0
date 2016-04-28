Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbcD1TTR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2016 15:19:17 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 11/11] rtl8xxxu: Remove the now obsolete mbox_ext_reg info from rtl8xxxu_fileops
Date: Thu, 28 Apr 2016 15:19:15 -0400
Message-Id: <1461871155-11826-12-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160428_213721_552202_27DC0E1C)
In-Reply-To: <1461871155-11826-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1461871155-11826-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

With two different h2c_cmd() functions, mbox_ext_reg and
mbox_ext_width are no longer needed.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h       | 2 --
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c | 2 --
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 2 --
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c | 2 --
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c | 2 --
 5 files changed, 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 1edb3ad..870c9cd 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1329,8 +1329,6 @@ struct rtl8xxxu_fileops {
 	void (*report_connect) (struct rtl8xxxu_priv *priv,
 				u8 macid, bool connect);
 	int writeN_block_size;
-	u16 mbox_ext_reg;
-	char mbox_ext_width;
 	char tx_desc_size;
 	char rx_desc_size;
 	char has_s0s1;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
index 242bf0e..2c86b55 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
@@ -572,8 +572,6 @@ struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.update_rate_mask = rtl8xxxu_update_rate_mask,
 	.report_connect = rtl8xxxu_gen1_report_connect,
 	.writeN_block_size = 128,
-	.mbox_ext_reg = REG_HMBOX_EXT_0,
-	.mbox_ext_width = 2,
 	.tx_desc_size = sizeof(struct rtl8xxxu_txdesc32),
 	.rx_desc_size = sizeof(struct rtl8xxxu_rxdesc16),
 	.adda_1t_init = 0x0b1b25a0,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
index 98f4ba3..fe19ace 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
@@ -1509,8 +1509,6 @@ struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.update_rate_mask = rtl8xxxu_gen2_update_rate_mask,
 	.report_connect = rtl8xxxu_gen2_report_connect,
 	.writeN_block_size = 128,
-	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
-	.mbox_ext_width = 4,
 	.tx_desc_size = sizeof(struct rtl8xxxu_txdesc40),
 	.rx_desc_size = sizeof(struct rtl8xxxu_rxdesc24),
 	.has_s0s1 = 0,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
index 7c347ba..a8e172c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
@@ -384,8 +384,6 @@ struct rtl8xxxu_fileops rtl8723au_fops = {
 	.update_rate_mask = rtl8xxxu_update_rate_mask,
 	.report_connect = rtl8xxxu_gen1_report_connect,
 	.writeN_block_size = 1024,
-	.mbox_ext_reg = REG_HMBOX_EXT_0,
-	.mbox_ext_width = 2,
 	.tx_desc_size = sizeof(struct rtl8xxxu_txdesc32),
 	.rx_desc_size = sizeof(struct rtl8xxxu_rxdesc16),
 	.adda_1t_init = 0x0b1b25a0,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
index 3472f6c..4186e7c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
@@ -1668,8 +1668,6 @@ struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.update_rate_mask = rtl8xxxu_gen2_update_rate_mask,
 	.report_connect = rtl8xxxu_gen2_report_connect,
 	.writeN_block_size = 1024,
-	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
-	.mbox_ext_width = 4,
 	.tx_desc_size = sizeof(struct rtl8xxxu_txdesc40),
 	.rx_desc_size = sizeof(struct rtl8xxxu_rxdesc24),
 	.has_s0s1 = 1,
-- 
2.5.5

