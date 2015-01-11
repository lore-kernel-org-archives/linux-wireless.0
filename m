Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:52768 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbbAKJu6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jan 2015 04:50:58 -0500
Message-ID: <54B24775.5070905@rempel-privat.de> (sfid-20150111_105247_453591_91A05066)
Date: Sun, 11 Jan 2015 10:50:45 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>, Hong Xu <hong@topbug.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k_htc: Add a module parameter to disable blink
References: <1420968029-1222-1-git-send-email-hong@topbug.net> <54B24504.60105@broadcom.com>
In-Reply-To: <54B24504.60105@broadcom.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KPHmoUA5kLOUfKNps5MmbwskuTApP0IFJ"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KPHmoUA5kLOUfKNps5MmbwskuTApP0IFJ
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 11.01.2015 um 10:40 schrieb Arend van Spriel:
> On 01/11/15 10:20, Hong Xu wrote:
>> Add an option "blink" to enable or disable the LED blink. The default
>> value is set to 1 so that existing users would not experience any
>> unexpected changes.
>> ---
>>   drivers/net/wireless/ath/ath9k/htc.h          | 1 +
>>   drivers/net/wireless/ath/ath9k/htc_drv_gpio.c | 4 ++++
>>   drivers/net/wireless/ath/ath9k/htc_drv_init.c | 4 ++++
>>   3 files changed, 9 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/htc.h
>> b/drivers/net/wireless/ath/ath9k/htc.h
>> index 9dde265..5697097 100644
>> --- a/drivers/net/wireless/ath/ath9k/htc.h
>> +++ b/drivers/net/wireless/ath/ath9k/htc.h
>> @@ -44,6 +44,7 @@
>>
>>   extern struct ieee80211_ops ath9k_htc_ops;
>>   extern int htc_modparam_nohwcrypt;
>> +extern int led_blink;
>>
>>   enum htc_phymode {
>>       HTC_MODE_11NA        =3D 0,
>> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
>> b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
>> index 50f74a2..998b558 100644
>> --- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
>> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
>> @@ -279,6 +279,10 @@ void ath9k_init_leds(struct ath9k_htc_priv *priv)=

>>       else
>>           priv->ah->led_pin =3D ATH_LED_PIN_DEF;
>>
>> +    if (!led_blink)
>> +        priv->led_cdev.default_trigger =3D
>> +            ieee80211_get_radio_led_name(priv->hw);
>> +
>>       ath9k_configure_leds(priv);
>>
>>       snprintf(priv->led_name, sizeof(priv->led_name),
>> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>> b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>> index e8fa944..c762d84 100644
>> --- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>> @@ -38,6 +38,10 @@ static int ath9k_ps_enable;
>>   module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
>>   MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
>>
>> +int led_blink =3D 1;
>> +module_param_named(blink, led_blink, int, 0444);
>> +MODULE_PARM_DESC(blink, "Enable LED blink on activity");
>> +
>=20
> Seems like this module parameter is only applicable if
> CONFIG_MAC80211_LEDS is set.

This patch is copy&paste of ath9k version. So if some one really care,
then it can be fixed in this patch and ath9k as well.


> Regards,
> Arend
>=20
>>   #ifdef CONFIG_MAC80211_LEDS
>>   static const struct ieee80211_tpt_blink ath9k_htc_tpt_blink[] =3D {
>>       { .throughput =3D 0 * 1024, .blink_time =3D 334 },
>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Regards,
Oleksij


--KPHmoUA5kLOUfKNps5MmbwskuTApP0IFJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlSyR3sACgkQHwImuRkmbWlpbAD+I8G1NGcSG7J4VDOU5s+CydyR
rnCrC5M2xgt18t7oE/QA/1EVQc2bNtq+cPTYzdiez4sbnCJDbumMkFjkdJN4Auyf
=DtOO
-----END PGP SIGNATURE-----

--KPHmoUA5kLOUfKNps5MmbwskuTApP0IFJ--
