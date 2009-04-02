Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49183 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbZDBS3I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 14:29:08 -0400
Subject: Re: How does rfkill work?
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>,
	Richard Purdie <rpurdie@rpsys.net>
In-Reply-To: <49D5018E.6050001@lwfinger.net>
References: <49D44635.80306@lwfinger.net>
	 <1238666206.4141.12.camel@johannes.local>  <49D4CF50.2060100@lwfinger.net>
	 <1238684527.4141.63.camel@johannes.local>  <49D4D833.9070107@lwfinger.net>
	 <1238689637.24708.41.camel@johannes.local>  <49D5018E.6050001@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UUL3zvNm/jNzlZeNLx8Z"
Date: Thu, 02 Apr 2009 20:28:33 +0200
Message-Id: <1238696913.6137.4.camel@johannes.local> (sfid-20090402_202913_590283_728D295D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UUL3zvNm/jNzlZeNLx8Z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-02 at 13:18 -0500, Larry Finger wrote:

> The problem is the statement #define TRIG_NAME_MAX 50 in include/linux/le=
ds.h.
> When I make it 60, then the trigger file contains "none ide-disk ADP1-onl=
ine
> BAT0-charging-or-full BAT0-charging BAT0-full phy0rx phy0tx phy0assoc phy=
0radio
> [rfkill0]" as expected.

Woah, that's strange. Richard? Larry is seeing problems where, oddly
depending on a patch I have, he's getting garbage for the selected
trigger when reading the trigger sysfs file.

The trigger's name, should be
	led_trigger.name =3D <something that is NULL> ? : dev_name(&some_dev)

Does this make any sense to you?

> I still have not found where radio gets truncated to rad, but I'm looking=
.

Probably in sysfs or something, don't think it is important.

johannes

--=-UUL3zvNm/jNzlZeNLx8Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ1QPOAAoJEKVg1VMiehFYiTMP/RVGtI0kr7r+ipASm+TOhLJf
3upz30YYkZhuk4kYW/AZTv2R9Cc2ZfRDXxCtvtjgGT4hclb8g2fRteUvPk/UTYEM
etbUAP4jcC7Ng2C29tBHif5I0m5P4Q9YU0RUN6+1yJO5XlO0EJeYt8yuNzvlJM1r
sSRrCiEwN5BCuy+s0mCayT7Z1CTSu9MxSlriusauIOo+7KPCuAUYUUAG3RXm2MvR
FmeLwcYnjrV2xbZWW/K+z+3k4PaEt0ubFZ5OgQfHM4J/IZzxFsgoCjbFL8qwtr6L
4GYBHT0FSIDQtk/JnmnO5L7siGNaD/kzusUTz2ShwPcf4l5wak1p3iWBDTQefAkU
gK/1orjzvoCjk2nBXq1i88vLf61D/DsqQT3TxgKgFfoa/0bBQlYWUFubseAljhHt
dIXZXwtU3XUHW2FR8XeAS7h88c2YHRj5o9GEBzksxJsSsXleKfuyCTSfKzobb+LI
Xk0iQ5BiDqXHIElmsUlu9HUQZL0qT8nfu8tzLodZXoXuO819C5zlYGUtw3WLrce0
/uo+9QnjfCcWDThI4jKFbTV0o9w0Jeo+g6/658e7xxbvrqFAEvePczZfyUfIKf4F
qXeiFnFehK8uMFAAIM7SDSdAKKTQp1+JW7vJjvR/sOBsMuwW+6f7UNtWXeSU8qBO
/5zVFoHVDNDcQcxS3ViJ
=deDB
-----END PGP SIGNATURE-----

--=-UUL3zvNm/jNzlZeNLx8Z--

