Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60224 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752366AbcKRVoa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 16:44:30 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 4/7] rtl8xxxu: Fix rtl8192eu driver reload issue
Date: Fri, 18 Nov 2016 16:44:25 -0500
Message-Id: <1479505468-29383-5-git-send-email-Jes.Sorensen@redhat.com> (sfid-20161118_224434_052142_48FB45B5)
In-Reply-To: <1479505468-29383-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1479505468-29383-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The 8192eu suffered from two issues when reloading the driver.

The same problems as with the 8723bu where REG_RX_WAIT_CCA bits 22 and
23 didn't get set in rtl8192e_enable_rf().

In addition it also seems prone to issues when setting REG_RF_CTRL to
0 intead of just disabling the RF_ENABLE bit. Similar to what was
causing issues with the 8188eu.

With this patch I can successfully reload the driver and reassociate
to an APi with an 8192eu dongle.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
index df54d27..a793fed 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
@@ -1461,7 +1461,9 @@ static int rtl8192eu_active_to_emu(struct rtl8xxxu_priv *priv)
 	int count, ret = 0;
 
 	/* Turn off RF */
-	rtl8xxxu_write8(priv, REG_RF_CTRL, 0);
+	val8 = rtl8xxxu_read8(priv, REG_RF_CTRL);
+	val8 &= ~RF_ENABLE;
+	rtl8xxxu_write8(priv, REG_RF_CTRL, val8);
 
 	/* Switch DPDT_SEL_P output from register 0x65[2] */
 	val8 = rtl8xxxu_read8(priv, REG_LEDCFG2);
@@ -1593,6 +1595,10 @@ static void rtl8192e_enable_rf(struct rtl8xxxu_priv *priv)
 	u32 val32;
 	u8 val8;
 
+	val32 = rtl8xxxu_read32(priv, REG_RX_WAIT_CCA);
+	val32 |= (BIT(22) | BIT(23));
+	rtl8xxxu_write32(priv, REG_RX_WAIT_CCA, val32);
+
 	val8 = rtl8xxxu_read8(priv, REG_GPIO_MUXCFG);
 	val8 |= BIT(5);
 	rtl8xxxu_write8(priv, REG_GPIO_MUXCFG, val8);
-- 
2.7.4
