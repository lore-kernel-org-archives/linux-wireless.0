Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:56365 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508AbbALKfV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 05:35:21 -0500
Message-ID: <54B3A360.2080003@rempel-privat.de> (sfid-20150112_113524_316370_5B901A5F)
Date: Mon, 12 Jan 2015 11:35:12 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>, Hong Xu <hong@topbug.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath9k_htc: Add a module parameter to disable blink
References: <1421005553-19447-1-git-send-email-hong@topbug.net> <54B39888.2080701@broadcom.com>
In-Reply-To: <54B39888.2080701@broadcom.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0BS59tMm1I8SiDo9TOtVRBA7R9GGUHH47"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0BS59tMm1I8SiDo9TOtVRBA7R9GGUHH47
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 12.01.2015 um 10:48 schrieb Arend van Spriel:
> On 01/11/15 20:45, Hong Xu wrote:
>> Add an option "blink" to enable or disable the LED blink. The default
>> value is set to 1 so that existing users would not experience any
>> unexpected changes.
>>
>> Signed-off-by: Hong Xu<hong@topbug.net>
>> ---
>>   drivers/net/wireless/ath/ath9k/htc.h          | 3 +++
>>   drivers/net/wireless/ath/ath9k/htc_drv_gpio.c | 4 ++++
>>   drivers/net/wireless/ath/ath9k/htc_drv_init.c | 4 ++++
>>   3 files changed, 11 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/htc.h
>> b/drivers/net/wireless/ath/ath9k/htc.h
>> index 9dde265..c43fec5 100644
>> --- a/drivers/net/wireless/ath/ath9k/htc.h
>> +++ b/drivers/net/wireless/ath/ath9k/htc.h
>> @@ -44,6 +44,9 @@
>>
>>   extern struct ieee80211_ops ath9k_htc_ops;
>>   extern int htc_modparam_nohwcrypt;
>> +#ifdef CONFIG_MAC80211_LEDS
>> +extern int led_blink;
>> +#endif
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
>=20
> So is this function/file also conditionally compiled on
> CONFIG_MAC80211_LEDS. In my tree it is not so you will get a warning an=
d
> loading the module will probably fail.

It is conditionally compiled on CONFIG_MAC80211_LEDS.

> Regards,
> Arend
>=20
>>       ath9k_configure_leds(priv);
>>
>>       snprintf(priv->led_name, sizeof(priv->led_name),
>> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>> b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>> index e8fa944..9470127 100644
>> --- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>> @@ -39,6 +39,10 @@ module_param_named(ps_enable, ath9k_ps_enable, int,=

>> 0444);
>>   MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
>>
>>   #ifdef CONFIG_MAC80211_LEDS
>> +int led_blink =3D 1;
>> +module_param_named(blink, led_blink, int, 0444);
>> +MODULE_PARM_DESC(blink, "Enable LED blink on activity");
>> +
>>   static const struct ieee80211_tpt_blink ath9k_htc_tpt_blink[] =3D {
>>       { .throughput =3D 0 * 1024, .blink_time =3D 334 },
>>       { .throughput =3D 1 * 1024, .blink_time =3D 260 },
>=20


--=20
Regards,
Oleksij


--0BS59tMm1I8SiDo9TOtVRBA7R9GGUHH47
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlSzo2AACgkQHwImuRkmbWkKXQD/TeeT42SbSAtoHl1Nq9hpZaK+
Km5NbURGbPSsXald350A/2i7faaB0XXZjjmaN6MH9t1XIeQclOEo5/GvPZMAoHaU
=lf6a
-----END PGP SIGNATURE-----

--0BS59tMm1I8SiDo9TOtVRBA7R9GGUHH47--
