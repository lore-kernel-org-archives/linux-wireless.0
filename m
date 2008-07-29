Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:54332 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbYG2TD0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 15:03:26 -0400
From: Andreas Schwab <schwab@suse.de>
To: linux-wireless@vger.kernel.org
Subject: Fix iwlwifi compilation without CONFIG_IWLWIFI_DEBUG
Cc: ipw3945-devel@lists.sourceforge.net
Date: Tue, 29 Jul 2008 21:03:24 +0200
Message-ID: <jebq0g8qdf.fsf@sykes.suse.de> (sfid-20080729_210330_222534_8E97F484)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/iwlwifi/iwl-led.c: In function =E2=80=98iwl_led_br=
ightness_set=E2=80=99:
drivers/net/wireless/iwlwifi/iwl-led.c:198: error: =E2=80=98led_type_st=
r=E2=80=99 undeclared (first use in this function)
drivers/net/wireless/iwlwifi/iwl-led.c:198: error: (Each undeclared ide=
ntifier is reported only once
drivers/net/wireless/iwlwifi/iwl-led.c:198: error: for each function it=
 appears in.)

Signed-off-by: Andreas Schwab <schwab@suse.de>
---
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wirel=
ess/iwlwifi/iwl-led.c
index 899d7a2..a58571c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -195,8 +195,10 @@ static void iwl_led_brightness_set(struct led_clas=
sdev *led_cdev,
 		return;
=20
=20
+#ifdef CONFIG_IWLWIFI_DEBUG
 	IWL_DEBUG_LED("Led type =3D %s brightness =3D %d\n",
 			led_type_str[led->type], brightness);
+#endif
 	switch (brightness) {
 	case LED_FULL:
 		if (led->type =3D=3D IWL_LED_TRG_ASSOC)

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Ge=
rmany
PGP key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4=
ED5
"And now for something completely different."
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
