Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:55795 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbbAKJ7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jan 2015 04:59:32 -0500
Received: by mail-pa0-f52.google.com with SMTP id eu11so26799707pac.11
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jan 2015 01:59:31 -0800 (PST)
References: <1420968029-1222-1-git-send-email-hong@topbug.net> <54B24504.60105@broadcom.com> <54B24775.5070905@rempel-privat.de>
From: Hong Xu <hong@topbug.net>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k_htc: Add a module parameter to disable blink
In-reply-to: <54B24775.5070905@rempel-privat.de>
Date: Sun, 11 Jan 2015 01:59:18 -0800
Message-ID: <87twzxprih.fsf@home.hong.me> (sfid-20150111_105937_289549_D29C0979)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Oleksij Rempel <linux@rempel-privat.de> writes:

> Am 11.01.2015 um 10:40 schrieb Arend van Spriel:
>> On 01/11/15 10:20, Hong Xu wrote:
>>> Add an option "blink" to enable or disable the LED blink. The default
>>> value is set to 1 so that existing users would not experience any
>>> unexpected changes.
>>> ---
>>>   drivers/net/wireless/ath/ath9k/htc.h          | 1 +
>>>   drivers/net/wireless/ath/ath9k/htc_drv_gpio.c | 4 ++++
>>>   drivers/net/wireless/ath/ath9k/htc_drv_init.c | 4 ++++
>>>   3 files changed, 9 insertions(+)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath9k/htc.h
>>> b/drivers/net/wireless/ath/ath9k/htc.h
>>> index 9dde265..5697097 100644
>>> --- a/drivers/net/wireless/ath/ath9k/htc.h
>>> +++ b/drivers/net/wireless/ath/ath9k/htc.h
>>> @@ -44,6 +44,7 @@
>>>
>>>   extern struct ieee80211_ops ath9k_htc_ops;
>>>   extern int htc_modparam_nohwcrypt;
>>> +extern int led_blink;
>>>
>>>   enum htc_phymode {
>>>       HTC_MODE_11NA        =3D 0,
>>> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
>>> b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
>>> index 50f74a2..998b558 100644
>>> --- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
>>> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
>>> @@ -279,6 +279,10 @@ void ath9k_init_leds(struct ath9k_htc_priv *priv)
>>>       else
>>>           priv->ah->led_pin =3D ATH_LED_PIN_DEF;
>>>
>>> +    if (!led_blink)
>>> +        priv->led_cdev.default_trigger =3D
>>> +            ieee80211_get_radio_led_name(priv->hw);
>>> +
>>>       ath9k_configure_leds(priv);
>>>
>>>       snprintf(priv->led_name, sizeof(priv->led_name),
>>> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>>> b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>>> index e8fa944..c762d84 100644
>>> --- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>>> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
>>> @@ -38,6 +38,10 @@ static int ath9k_ps_enable;
>>>   module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
>>>   MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
>>>
>>> +int led_blink =3D 1;
>>> +module_param_named(blink, led_blink, int, 0444);
>>> +MODULE_PARM_DESC(blink, "Enable LED blink on activity");
>>> +
>>=20
>> Seems like this module parameter is only applicable if
>> CONFIG_MAC80211_LEDS is set.
>
> This patch is copy&paste of ath9k version. So if some one really care,
> then it can be fixed in this patch and ath9k as well.
>
True, I also noticed parameter btcoex_enabled is also only applicable
if CONFIG_ATH9K_BTCOEX_SUPPORT is set, for both ath9k and ath9k_htc.

Best,
Hong

>> Regards,
>> Arend
>>=20
>>>   #ifdef CONFIG_MAC80211_LEDS
>>>   static const struct ieee80211_tpt_blink ath9k_htc_tpt_blink[] =3D {
>>>       { .throughput =3D 0 * 1024, .blink_time =3D 334 },
>>=20

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUskl2AAoJECZsfTOCL4R4uqMP/3wT/DLSv3ZqLhJtqOdnfkUL
qkDRJR/C8/+ArZz9GmFtmx4zjyoIYJChpuWFf3LxPLZXV4KRRf7y9I4MmxNot/+6
ItL5OCpMP735u3lCwuKFbYF8LPnnl/8rKSq8DkoFj/enJAR6Z6MJWwNuLm24tOpV
efxHa5pLaXa0JYz7Mgupsz18V1Db4BRgmbh0F5ad31v0wLMSSKYxvLNUPVMF4dh8
nTUgv3+ogmIDDvCDCOtKpEuaNPMA27KxR4qtPlmDT7pF1KdjV6C07nxNrmbsF0Nj
AWzm/99DXRlWQpK/WymLqgOpFUGTEfewwZ+ppTg6JWiu11aQFGga9RrV9KVXb6+2
OeFDyU1JY+p5Bk+IKxkZnMfH2W3cgGL/pC7LUNHje6TSkQ0dq45K+hvfdgbecF5i
KzFY7OaXxIXe1Yh7ThSLUfoHAywK8sbEU/eXNoUdfokiFqfx316QmN2DBv9gacIc
kp0N7e37ObKtFhnqa/BFd8es8zEaV7oPcyn4kHGRBxWE6SNuF5b+4cZf6OUeR4iG
mYeuHKq6ciGqnU0GzAOLr3yOo/QYZKrEh8jHoFwBdkcbzynJs/V1lmNDOoW0q8AN
smWyG833MjtXlGnQcqL9gu3t+tx3Rl4KhBdaz9rEkELy786dshGIDQSFeLLuqo43
ghgbJgoDS7aXHRpePm+n
=bdVd
-----END PGP SIGNATURE-----
--=-=-=--
