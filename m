Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34219 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaLUM4x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 07:56:53 -0500
Received: by mail-wi0-f182.google.com with SMTP id h11so5720240wiw.15
        for <linux-wireless@vger.kernel.org>; Sun, 21 Dec 2014 04:56:52 -0800 (PST)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: hal: rtl8723au_led.c:  Remove some unused functions
Date: Sun, 21 Dec 2014 13:59:39 +0100
Message-Id: <1419166779-2619-1-git-send-email-rickard_strandqvist@spectrumdigital.se> (sfid-20141221_135657_149175_581B4797)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removes some functions that are not used anywhere:
rtl8723au_DeInitSwLeds() rtl8723au_InitSwLeds()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8723au/hal/rtl8723au_led.c    |   23 ----------------------
 drivers/staging/rtl8723au/include/rtl8723a_led.h |    2 --
 2 files changed, 25 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723au_led.c b/drivers/staging/rtl8723au/hal/rtl8723au_led.c
index b946636..99d627a7 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723au_led.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723au_led.c
@@ -99,26 +99,3 @@ exit:
 
 /*  Interface to manipulate LED objects. */
 
-/*	Description: */
-/*		Initialize all LED_871x objects. */
-void
-rtl8723au_InitSwLeds(struct rtw_adapter	*padapter)
-{
-	struct led_priv *pledpriv = &padapter->ledpriv;
-
-	pledpriv->LedControlHandler = LedControl871x23a;
-	/* 8723as-vau wifi used led2 */
-	InitLed871x23a(padapter, &pledpriv->SwLed0, LED_PIN_LED2);
-
-/*	InitLed871x23a(padapter,&pledpriv->SwLed1, LED_PIN_LED2); */
-}
-
-/*	Description: */
-/*		DeInitialize all LED_819xUsb objects. */
-void
-rtl8723au_DeInitSwLeds(struct rtw_adapter *padapter)
-{
-	struct led_priv	*ledpriv = &padapter->ledpriv;
-
-	DeInitLed871x23a(&ledpriv->SwLed0);
-}
diff --git a/drivers/staging/rtl8723au/include/rtl8723a_led.h b/drivers/staging/rtl8723au/include/rtl8723a_led.h
index 1623d18..c83efe6 100644
--- a/drivers/staging/rtl8723au/include/rtl8723a_led.h
+++ b/drivers/staging/rtl8723au/include/rtl8723a_led.h
@@ -22,8 +22,6 @@
 /*  */
 /*  Interface to manipulate LED objects. */
 /*  */
-void rtl8723au_InitSwLeds(struct rtw_adapter *padapter);
-void rtl8723au_DeInitSwLeds(struct rtw_adapter *padapter);
 void SwLedOn23a(struct rtw_adapter *padapter, struct led_8723a * pLed);
 void SwLedOff23a(struct rtw_adapter *padapter, struct led_8723a * pLed);
 
-- 
1.7.10.4

