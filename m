Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39822 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755223AbcHSVrY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 17:47:24 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 12/20] rtl8xxxu: Use flag to indicate whether device has TX report timer support
Date: Fri, 19 Aug 2016 17:46:34 -0400
Message-Id: <1471643202-26250-13-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160819_234845_256637_B4A3398E)
In-Reply-To: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Use a fileops flag to indicate whether the device has TX report timer
support. This will make it easier to include future devices such as
8188eu to use the TX report timer.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h       | 1 +
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c | 1 +
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 5 ++---
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index da4f148..c8d7075 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1341,6 +1341,7 @@ struct rtl8xxxu_fileops {
 	char tx_desc_size;
 	char rx_desc_size;
 	char has_s0s1;
+	char has_tx_report;
 	u32 adda_1t_init;
 	u32 adda_1t_path_on;
 	u32 adda_2t_path_on_a;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
index c1323f0..0b6a6ca 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
@@ -1666,6 +1666,7 @@ struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.tx_desc_size = sizeof(struct rtl8xxxu_txdesc40),
 	.rx_desc_size = sizeof(struct rtl8xxxu_rxdesc24),
 	.has_s0s1 = 1,
+	.has_tx_report = 1,
 	.adda_1t_init = 0x01c00014,
 	.adda_1t_path_on = 0x01c00014,
 	.adda_2t_path_on_a = 0x01c00014,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 7a697c0..81b9582 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4000,10 +4000,9 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		priv->fops->usb_quirks(priv);
 
 		/*
-		 * Presumably this is for 8188EU as well
-		 * Enable TX report and TX report timer
+		 * Enable TX report and TX report timer for 8723bu/8188eu/...
 		 */
-		if (priv->rtl_chip == RTL8723B) {
+		if (priv->fops->has_tx_report) {
 			val8 = rtl8xxxu_read8(priv, REG_TX_REPORT_CTRL);
 			val8 |= TX_REPORT_CTRL_TIMER_ENABLE;
 			rtl8xxxu_write8(priv, REG_TX_REPORT_CTRL, val8);
-- 
2.7.4
