Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbcDNUh2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 16:37:28 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 15/16] rtl8xxxu: Pause TX before calling disable_rf()
Date: Thu, 14 Apr 2016 16:37:20 -0400
Message-Id: <1460666241-5365-16-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_223733_426133_02CF6946)
In-Reply-To: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

All the disable_rf() functions were setting REG_TXPAUSE to 0xff to
stop transmission. Do it centrally before calling disable_rf()
instead.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index a86b5c4..928ca56 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2125,8 +2125,6 @@ static void rtl8723a_disable_rf(struct rtl8xxxu_priv *priv)
 	u8 sps0;
 	u32 val32;
 
-	rtl8xxxu_write8(priv, REG_TXPAUSE, 0xff);
-
 	sps0 = rtl8xxxu_read8(priv, REG_SPS0_CTRL);
 
 	/* RF RX code for preamble power saving */
@@ -7665,8 +7663,6 @@ static void rtl8723b_disable_rf(struct rtl8xxxu_priv *priv)
 {
 	u32 val32;
 
-	rtl8xxxu_write8(priv, REG_TXPAUSE, 0xff);
-
 	val32 = rtl8xxxu_read32(priv, REG_RX_WAIT_CCA);
 	val32 &= ~(BIT(22) | BIT(23));
 	rtl8xxxu_write32(priv, REG_RX_WAIT_CCA, val32);
@@ -9591,6 +9587,8 @@ static void rtl8xxxu_stop(struct ieee80211_hw *hw)
 	if (priv->usb_interrupts)
 		usb_kill_anchored_urbs(&priv->int_anchor);
 
+	rtl8xxxu_write8(priv, REG_TXPAUSE, 0xff);
+
 	priv->fops->disable_rf(priv);
 
 	/*
-- 
2.5.5

