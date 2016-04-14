Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940AbcDNS7O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:14 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 21/26] rtl8xxxu: Do not backup RF_MODE_AG when it's never being used
Date: Thu, 14 Apr 2016 14:59:02 -0400
Message-Id: <1460660347-26299-22-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_205918_465810_154A18DF)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This was expired by the vendor driver, but we never ended up using the
backed up value.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 3 ---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index ef93f62..c12a4c8 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7667,9 +7667,6 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	if (priv->rtl_chip != RTL8192E)
 		rtl8xxxu_write32(priv, REG_FPGA0_XA_RF_INT_OE, 0x66f60210);
 
-	priv->rf_mode_ag[0] = rtl8xxxu_read_rfreg(priv, RF_A,
-						  RF6052_REG_MODE_AG);
-
 	if (!macpower) {
 		/*
 		 * Set TX buffer boundary
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index f66e20d..b87cd2b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1228,7 +1228,6 @@ struct rtl8xxxu_priv {
 	u8 rf_paths;
 	u8 rx_paths;
 	u8 tx_paths;
-	u32 rf_mode_ag[2];
 	u32 rege94;
 	u32 rege9c;
 	u32 regeb4;
-- 
2.5.5

