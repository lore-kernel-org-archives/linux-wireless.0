Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbcDNUhX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 16:37:23 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 07/16] rtl8xxxu: Match 8723bu power down sequence to vendor driver
Date: Thu, 14 Apr 2016 16:37:12 -0400
Message-Id: <1460666241-5365-8-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_225529_923657_598930F6)
In-Reply-To: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

In particular set APS_FSMCO_WLON_RESET in the right register, and do
not overwrite too much of REG_CR.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 8bf9a74..5685fd7 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6510,9 +6510,9 @@ static int rtl8723bu_active_to_emu(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write16(priv, REG_GPIO_INTM, val16);
 
 	/* Release WLON reset 0x04[16]= 1*/
-	val32 = rtl8xxxu_read32(priv, REG_GPIO_INTM);
+	val32 = rtl8xxxu_read32(priv, REG_APS_FSMCO);
 	val32 |= APS_FSMCO_WLON_RESET;
-	rtl8xxxu_write32(priv, REG_GPIO_INTM, val32);
+	rtl8xxxu_write32(priv, REG_APS_FSMCO, val32);
 
 	/* 0x0005[1] = 1 turn off MAC by HW state machine*/
 	val8 = rtl8xxxu_read8(priv, REG_APS_FSMCO + 1);
@@ -7376,7 +7376,7 @@ static void rtl8723bu_power_off(struct rtl8xxxu_priv *priv)
 	val8 &= ~TX_REPORT_CTRL_TIMER_ENABLE;
 	rtl8xxxu_write8(priv, REG_TX_REPORT_CTRL, val8);
 
-	rtl8xxxu_write16(priv, REG_CR, 0x0000);
+	rtl8xxxu_write8(priv, REG_CR, 0x0000);
 
 	rtl8xxxu_active_to_lps(priv);
 
@@ -7393,7 +7393,15 @@ static void rtl8723bu_power_off(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write8(priv, REG_MCU_FW_DL, 0x00);
 
 	rtl8723bu_active_to_emu(priv);
-	rtl8xxxu_emu_to_disabled(priv);
+
+	val8 = rtl8xxxu_read8(priv, REG_APS_FSMCO + 1);
+	val8 |= BIT(3); /* APS_FSMCO_HW_SUSPEND */
+	rtl8xxxu_write8(priv, REG_APS_FSMCO + 1, val8);
+
+	/* 0x48[16] = 1 to enable GPIO9 as EXT wakeup */
+	val8 = rtl8xxxu_read8(priv, REG_GPIO_INTM + 2);
+	val8 |= BIT(0);
+	rtl8xxxu_write8(priv, REG_GPIO_INTM + 2, val8);
 }
 
 #ifdef NEED_PS_TDMA
-- 
2.5.5

