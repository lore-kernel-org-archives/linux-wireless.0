Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58920 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbZFFRog (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2009 13:44:36 -0400
Subject: Re: [RFC V2] b43/legacy: port to cfg80211 rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
In-Reply-To: <4A298C37.9030503@lwfinger.net>
References: <4a2961a7.RxVbjEA4JdOf01BF%Larry.Finger@lwfinger.net>
	 <200906052101.47168.mb@bu3sch.de>  <4A298C37.9030503@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GA8MuBDRV4a034OjMN6f"
Date: Sat, 06 Jun 2009 19:44:34 +0200
Message-Id: <1244310274.17485.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GA8MuBDRV4a034OjMN6f
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-06-05 at 16:20 -0500, Larry Finger wrote:

> The problem is that while the interface is down the switch status
> cannot be interrogated. If you try, you get a fatal SSB error. Thus
> the only way to bring it back up is to flip the switch, then
> rmmod/insmod the driver. If you want hardware rfkill to be one-way,
> then take Johannes's patch. We would save a little power by calling
> b43_wireless_exit() if we brought it up to test the switch, and the
> switch was still off. That would leave everything off most of the time.

Actually we should do that all the time, since after the user pushes the
button he might still not actually want to use the device.

> > I really do hate all that rfkill crap and I'm still refusing to sign of=
f on anything that's
> > related to rfkill (like I did for the past year or so). If people want =
this merged,
> > somebody else maintain and sign it off, please.
>=20
> I'm sick of rfkill as well and really detest the endless discussions
> that have taken place; however, I do want the stuff to work.
>=20
> As I see it, we have several options (presented in my order of
> preference):
>=20
> 1. We switch to the cfg80211 rfkill and use this patch modified to
> turn the interface back off if the switch is still off.

I'll do that.

> 2. We continue to use the old rfkill mechanism. It works just fine,
> but this method runs the risk of the old method being deprecated and
> eliminated.

It won't be, but you won't get proper userspace integration, NM will not
integrate properly and then we will continue having to rely on users
reading dmesg saying something like "rfkill off, press button before
wireless will connect" and mac80211 will at the same time try to connect
and do things unsuccessfully.

> 3. We get new callbacks that will only power down/up the radio when it
> is blocked. That saves a little power.

Less so than actually turning off most things most of the time, I'd
think.

johannes

--=-GA8MuBDRV4a034OjMN6f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKKqr+AAoJEODzc/N7+Qma59EP/2TgSNfryAx6o8hbKoBGEqx/
07n3+GbHj/7U8CesVb5Pq2lWsPs8uEoD7Bm7ET/VjavN9N1/lmtCe9IFPrWq+sCC
0aHCKnl58HEPV9Z1X/DmsptE1tALlcJUX1fpEohSSGbHRVR5x0Urmy+weOGbCwgD
pyhNiNGprzTWCVrQpmqrynFFfwONW4ImSRnFmkJtGe5x50kn6H3oR41Qasrcmr5k
VqfYCh+2iLygQRImCj8XtH3wxkymvlOK+tNLZbNLpvIKPHrxRNR27gWJ1ylgfBZK
OOCuYn5frQRk4c/spoeFBW+q7k4GJOKr69UyacYC8ioPQB4o4GwWvXKYagP9E4R/
CUdXBOmRTOz9NQzexQxrTxsJtw6lJOUnw8DSawsi91wYZ2PYAECePIGTECVR7Z/r
1+Fsx0vG3M+mmhZ9T1/Nz9NVQnzepXkr8O2hw1q2B8pg6fSF6w0+I84sd/J8bBxG
Posy1TbA1/syGzPCZo9k+vMUsF/VRzmA7ROQmN935vW0HTRHGC+TpeqmcV8/Vk/M
Ci2I67DfM8HuBaLhBpMml2SMGNHi8L4eG5pjDGTjicxcOxVITf7BetJgDZHS9qfP
k2JPRP9X7eY7+87QT9Xydg2vKzPdDcC1B6BbzTdUpFIP95iHbQkDvUAgDuHBTchH
R5KGe+SsLWchqDb2tH1F
=TBgr
-----END PGP SIGNATURE-----

--=-GA8MuBDRV4a034OjMN6f--

