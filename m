Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-roam.Stanford.EDU ([171.64.10.152]:45684 "EHLO
	smtp-roam.Stanford.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033AbYD3HlR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 03:41:17 -0400
Received: from localhost (SW-90-728-259-1.Stanford.EDU [171.66.159.123])
	(authenticated bits=0)
	by smtp-roam.Stanford.EDU (8.12.11/8.12.11) with ESMTP id m3U7fET8030086
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 30 Apr 2008 00:41:16 -0700
Date: Wed, 30 Apr 2008 00:41:13 -0700
From: Gautam Iyer <gi1242@stanford.edu>
To: linux-wireless@vger.kernel.org
Subject: Re: b43 LED status
Message-ID: <20080430074113.GA24394@stanford.edu> (sfid-20080430_094113_922600_AA3C4FB1)
References: <20080429215629.GC17790@stanford.edu> <4817A28E.2050309@lwfinger.net> <20080429233045.GA26484@stanford.edu> <4817B548.30303@lwfinger.net> <20080430010502.GA17871@stanford.edu> <4817E1FE.30407@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
In-Reply-To: <4817E1FE.30407@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2008 at 10:05:34PM -0500, Larry Finger wrote:

>>>> I don't have Windows so can't compare to it. But even though I use b43
>>>> by default, I sometimes have to revert to ndiswrapper on weak signals =
or
>>>> large file transfers. Also ndiswrapper has the power management and
>>>> LED's working correctly, which I could not get working with the b43
>>>> driver.
>>> What LEDS does your interface, and what do they not do? If the only
>>> LED you have is the one attached to the rfkill switch, then you have
>>> not properly configured the LED parameters.
>> Yes, the only LED I have is attached to my rfkill switch. It becomes
>> blue when I load the b43 kernel module, and becomes red when I unload
>> it. I was hoping I could set it so that it becomes blue when in use
>> (i.e. associated), and red otherwise. (This happens with ndiswrapper).
>> I remember messing with the LED power / brightness files in /sys. But
>> nothing I echoed in there changed the state of the LED. Is there some
>> parameter I'm missing?
>
> You need the following LED- and rfkill-related parameters in your=20
> configuration:
>
> CONFIG_MAC80211_LEDS=3Dy
> CONFIG_RFKILL=3Dm
> CONFIG_RFKILL_INPUT=3Dm
> CONFIG_RFKILL_LEDS=3Dy
> CONFIG_B43_LEDS=3Dy
> CONFIG_B43_RFKILL=3Dy
> CONFIG_NEW_LEDS=3Dy
> CONFIG_LEDS_CLASS=3Dm
> CONFIG_LEDS_TRIGGERS=3Dy
>
> The last one may not be necessary, but the others are. With this
> setup, the LED will be blue when b43 is loaded _AND_ the rfkill switch
> is on, and red when the rfkill switch is off, or b43 is unloaded.

Woah! That worked *perfectly*. Super thanks! (It took quite a bit of
searching to figure out B43_RFKILL. There's no kernel prompt for it.
Once I grepped through, enabling INPUT_POLLDEV set this option).

Thanks! It works great now!!

My bandwidth isn't really that much of an issue, since at home my WiFi
is a lot faster than my download speed or the speed of my NAS server.
Good bye ndiswrapper ... :)

GI

--=20
'Psychologist' -- Someone who looks at everyone else when an attractive
woman enters the room.

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkgYIpkACgkQ6plSLtsExHGmNACeNq4t/DCtrnZxHs1OQ2Au9jQL
t08AoJfx2DxbgrNY3ivkO/wP8apYVT5g
=TfiG
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
