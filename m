Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59498 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbbAKKIi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jan 2015 05:08:38 -0500
Message-ID: <54B24B9D.9040600@rempel-privat.de> (sfid-20150111_111058_756959_62DF0199)
Date: Sun, 11 Jan 2015 11:08:29 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Hong Xu <hong@topbug.net>
CC: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k_htc: Add a module parameter to disable blink
References: <1420968029-1222-1-git-send-email-hong@topbug.net> <54B24504.60105@broadcom.com> <54B24775.5070905@rempel-privat.de> <87twzxprih.fsf@home.hong.me>
In-Reply-To: <87twzxprih.fsf@home.hong.me>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3tTK84dmJit4KPmIeCHHct3jnbBauT6wA"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3tTK84dmJit4KPmIeCHHct3jnbBauT6wA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 11.01.2015 um 10:59 schrieb Hong Xu:
>=20
> Oleksij Rempel <linux@rempel-privat.de> writes:
>=20
>> Am 11.01.2015 um 10:40 schrieb Arend van Spriel:
>>> On 01/11/15 10:20, Hong Xu wrote:
>>>> Add an option "blink" to enable or disable the LED blink. The defaul=
t
>>>> value is set to 1 so that existing users would not experience any
>>>> unexpected changes.
>>>> ---
>>>>   drivers/net/wireless/ath/ath9k/htc.h          | 1 +
>>>>   drivers/net/wireless/ath/ath9k/htc_drv_gpio.c | 4 ++++
>>>>   drivers/net/wireless/ath/ath9k/htc_drv_init.c | 4 ++++
>>>>   3 files changed, 9 insertions(+)
>>>>
>>>> diff --git a/drivers/net/wireless/ath/ath9k/htc.h
>>>> b/drivers/net/wireless/ath/ath9k/htc.h
>>>> index 9dde265..5697097 100644
>>>> --- a/drivers/net/wireless/ath/ath9k/htc.h
>>>> +++ b/drivers/net/wireless/ath/ath9k/htc.h
>>>> @@ -44,6 +44,7 @@
>>>>
>>>>   extern struct ieee80211_ops ath9k_htc_ops;
>>>>   extern int htc_modparam_nohwcrypt;
>>>> +extern int led_blink;
>>>>
>>>>   enum htc_phymode {
>>>>       HTC_MODE_11NA        =3D 0,
>>>> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
>>>> b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
>>>> index 50f74a2..998b558 100644
>>>> --- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
>>>> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
>>>> @@ -279,6 +279,10 @@ void ath9k_init_leds(struct ath9k_htc_priv *pri=
v)
>>>>       else
>>>>           priv->ah->led_pin =3D ATH_LED_PIN_DEF;
>>>>
>>>> +    if (!led_blink)
>>>> +        priv->led_cdev.default_trigger =3D
>>>> +            ieee80211_get_radio_led_name(priv->hw);
>>>> +
>>>>       ath9k_configure_leds(priv);
>>>>
>>>>       snprintf(priv->led_name, sizeof(priv->led_name),
>>>> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>>>> b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>>>> index e8fa944..c762d84 100644
>>>> --- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>>>> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>>>> @@ -38,6 +38,10 @@ static int ath9k_ps_enable;
>>>>   module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
>>>>   MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
>>>>
>>>> +int led_blink =3D 1;
>>>> +module_param_named(blink, led_blink, int, 0444);
>>>> +MODULE_PARM_DESC(blink, "Enable LED blink on activity");
>>>> +
>>>
>>> Seems like this module parameter is only applicable if
>>> CONFIG_MAC80211_LEDS is set.
>>
>> This patch is copy&paste of ath9k version. So if some one really care,=

>> then it can be fixed in this patch and ath9k as well.
>>
> True, I also noticed parameter btcoex_enabled is also only applicable
> if CONFIG_ATH9K_BTCOEX_SUPPORT is set, for both ath9k and ath9k_htc.

I prefer to keep ath9k_htc close to ath9k as possible, including bugs.
Process of merging this two drivers is not finished, and i didn't gave
up on it.

--=20
Regards,
Oleksij


--3tTK84dmJit4KPmIeCHHct3jnbBauT6wA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlSyS50ACgkQHwImuRkmbWl3agD9EJfMSXZCxDqXdXVR3wi08ifs
2/+TpUp9THsCpzHwjCgA/3vlHnavImIGt4pots8xmOY9xX+3xxmBY89XEY+KOgS1
=LM+s
-----END PGP SIGNATURE-----

--3tTK84dmJit4KPmIeCHHct3jnbBauT6wA--
