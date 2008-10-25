Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:38418 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYJYOJr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2008 10:09:47 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] p54: fix build warnings
Date: Sat, 25 Oct 2008 16:14:14 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>, mcgrof <mcgrof@gmail.com>
References: <1224923050.27353.1.camel@johannes.berg>
In-Reply-To: <1224923050.27353.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200810251614.14514.chunkeey@web.de> (sfid-20081025_160951_210624_99B8521F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 25 October 2008 10:24:10 Johannes Berg wrote:
> just FYI in case you haven't seen them. the p54 one looks like a genu=
ine
> problem.
>
> drivers/net/wireless/p54/p54common.c: In function =E2=80=98p54_parse_=
eeprom=E2=80=99:
> drivers/net/wireless/p54/p54common.c:325: warning: =E2=80=98synth=E2=80=
=99 may be used uninitialized in this function

There you go. Yes, it is a genuine problem, if the device's eeprom is s=
crewed really up.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireles=
s/p54/p54common.c
index 360f35b..02a306d 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -322,7 +322,7 @@ static int p54_parse_eeprom(struct ieee80211_hw *de=
v, void *eeprom, int len)
 	void *tmp;
 	int err;
 	u8 *end =3D (u8 *)eeprom + len;
-	u16 synth;
+	u16 synth =3D 0;
 	DECLARE_MAC_BUF(mac);
=20
 	wrap =3D (struct eeprom_pda_wrap *) eeprom;
@@ -425,7 +425,8 @@ static int p54_parse_eeprom(struct ieee80211_hw *de=
v, void *eeprom, int len)
 		entry =3D (void *)entry + (entry_len + 1)*2;
 	}
=20
-	if (!priv->iq_autocal || !priv->output_limit || !priv->curve_data) {
+	if (!synth || !priv->iq_autocal || !priv->output_limit ||
+	    !priv->curve_data) {
 		printk(KERN_ERR "p54: not all required entries found in eeprom!\n");
 		err =3D -EINVAL;
 		goto err;
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
