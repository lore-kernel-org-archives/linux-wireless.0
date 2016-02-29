Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbcB2WFy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:54 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 040/113] rtl8xxxu: Remove backing up certain registers, which was never used
Date: Mon, 29 Feb 2016 17:04:38 -0500
Message-Id: <1456783551-28315-41-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230624_257759_339C99EF)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This was inspired by the vendor driver, but in the end never used for
anything.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 14 --------------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  3 ---
 2 files changed, 17 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index a8385c7..e3e08da 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5815,20 +5815,6 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	/* Init BT hw config. */
 	rtl8xxxu_init_bt(priv);
 
-	/*
-	 * Not sure if we really need to save these parameters, but the
-	 * vendor driver does
-	 */
-	val32 = rtl8xxxu_read32(priv, REG_FPGA0_XA_HSSI_PARM2);
-	if (val32 & FPGA0_HSSI_PARM2_CCK_HIGH_PWR)
-		priv->path_a_hi_power = 1;
-
-	val32 = rtl8xxxu_read32(priv, REG_OFDM0_TRX_PATH_ENABLE);
-	priv->path_a_rf_paths = val32 & OFDM_RF_PATH_RX_MASK;
-
-	val32 = rtl8xxxu_read32(priv, REG_OFDM0_XA_AGC_CORE1);
-	priv->path_a_ig_value = val32 & OFDM0_X_AGC_CORE1_IGI_MASK;
-
 	/* Set NAV_UPPER to 30000us */
 	val8 = ((30000 + NAV_UPPER_UNIT - 1) / NAV_UPPER_UNIT);
 	rtl8xxxu_write8(priv, REG_NAV_UPPER, val8);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 4a974a6..7b76e11 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -785,13 +785,10 @@ struct rtl8xxxu_priv {
 	u32 ep_tx_high_queue:1;
 	u32 ep_tx_normal_queue:1;
 	u32 ep_tx_low_queue:1;
-	u32 path_a_hi_power:1;
-	u32 path_a_rf_paths:4;
 	unsigned int pipe_interrupt;
 	unsigned int pipe_in;
 	unsigned int pipe_out[TXDESC_QUEUE_MAX];
 	u8 out_ep[RTL8XXXU_OUT_ENDPOINTS];
-	u8 path_a_ig_value;
 	u8 ep_tx_count;
 	u8 rf_paths;
 	u8 rx_paths;
-- 
2.5.0

