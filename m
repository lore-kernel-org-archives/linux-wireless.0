Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56176 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbYBYK53 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 05:57:29 -0500
Subject: Re: mac80211 locking: tasklet vs. non-tasklet
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	bruno randolf <br1@einfach.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1ba2fa240802250252x753796f7ob071c12c72aec172@mail.gmail.com> (sfid-20080225_105254_843501_AE739B69)
References: <1203676145.26341.39.camel@johannes.berg>
	 <1ba2fa240802240829s7c650ad1yd47c6b25e466a50@mail.gmail.com>
	 <1203933096.13162.54.camel@johannes.berg>
	 <1ba2fa240802250252x753796f7ob071c12c72aec172@mail.gmail.com>
	 (sfid-20080225_105254_843501_AE739B69)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZLoRXOY3NcR2wWrSwQJu"
Date: Mon, 25 Feb 2008 11:57:22 +0100
Message-Id: <1203937042.13162.81.camel@johannes.berg> (sfid-20080225_105732_203616_A9BE06D8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZLoRXOY3NcR2wWrSwQJu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  > Actually alike athk also iwlwifi driver calls tx_status from a taskl=
et
> >  > therfore the irqsafe can be removed. I've tested that it worked so f=
ar
> >
> >  Ok, fine too. Just the mixing is actually bad because of locking.
>=20
> There'll be a patch for it.

Great, thanks. I'll be reposting my sta info rework today and that will
then add documentation about that too.

> >  > In general I'm missing some asynchronous mechanism that driver can
> >  > notify mac80211 about it's state.
> >  > Except BA states there  is  for example  netif_carrier_off/on
> >  > functionality in the driver level. It would be very useful for early
> >  > notification of disconnection.  A disconnection can happen due to
> >  > device resume or internal recoverable error. In this cases I would
> >  > expect mac to try associate again upon such trigger.
> >
> >  I guess that's just missing. You can stop the queues but you can't tel=
l
> >  mac80211 that you reset the hw.
>=20
> If there is no objection we will introduce some notification
> mechanism...suggestions are welcome as well.

I have no objection, though I'm unsure what precisely you want. What,
for example, if you're running hostapd and your hardware resets? Can you
keep station tables etc.?

johannes

--=-ZLoRXOY3NcR2wWrSwQJu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8KfEKVg1VMiehFYAQK3RhAAwjCXzxSdcs/AhvxA+DQqK3hi5V32CNak
QqcshD93JiaxPt/UDFRXuzuoXeJME82N97VmeTpwuDn6diU/y/GM/erlATAjBI33
cXanZ8Ohgi3RJGZCtdBxRMZHK8hE+8HXaaAmkpf+eOIg0Yyz1tvKSblkeR7i3IkF
7By8lFmDopa59lD+MGX0C8HnnDLHzAvdpfToBubqwKEssDv2rqbah3QdFjlafhxi
J9ikRhUB6sNIn7zDu+GDFz9gYMmfy4KnAWG/wh78SAmQ0byMkMVGB+nhAKQyWNfp
pGhPROXput+D3KzLgOHOWL1f5zrd1WZ/o3kjmdGyeBlHGBJnZUuXuLSIA2aztjhf
cDYW1ajNVASI8x8D6qEhfxh5a0nHK+hUhhqZRqjIpQZFDyztGn/a+zx9DCjvDKUW
b/OtTkWu73Dp0CbeDg1hCNBL3zlI1EmaC7i2uieRX8lR1I38HCojaqWgNlxlCBNt
uCKwM8DDShaEpSdR8x3/UXf9MHVmZhuM3Cu5zaJ4vQ1NWJNF8MhwIGEPUviV2Z+T
vQRuihxfnKiQOGDc4OokS2AvIq9in37kt1dWx+cXY1IcFdmb7rGgACfzjVP1pnxb
co7/y8O4cGypasuX0BxeoRqyEVxCSjdGEc72QxWUsETSc5nmg2aZDbgHs1xbUOjj
bJSCnQGcYaE=
=iUcP
-----END PGP SIGNATURE-----

--=-ZLoRXOY3NcR2wWrSwQJu--

