Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38720 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbZGPOVP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 10:21:15 -0400
Subject: Re: [RFC/RFT 5/5] mac80211: implement basic background scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200907161150.54237.helmut.schaa@gmail.com>
References: <200907161104.41975.helmut.schaa@gmail.com>
	 <200907161109.40471.helmut.schaa@gmail.com>
	 <1247736318.24433.10.camel@johannes.local>
	 <200907161150.54237.helmut.schaa@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fHbpJPhkwXfDBgUArt3F"
Date: Thu, 16 Jul 2009 16:20:43 +0200
Message-Id: <1247754043.30529.26.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fHbpJPhkwXfDBgUArt3F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-16 at 11:50 +0200, Helmut Schaa wrote:

> > > +	if (ieee80211_hw_config(local,
> > > +					IEEE80211_CONF_CHANGE_CHANNEL))
> >=20
> > That looks weird. I don't think you really need to care about the retur=
n
> > value anyway, now that we have rfkill integrated it shouldn't ever be
> > nonzero (and if it is, while rfkill is being activated, it doesn't
> > really matter since we're taking down interfaces)
>=20
> Ok, will change that.

Oh and you can also pass 0 as the change flags, the routine will detect
scan_channel and set the flag accordingly. Doesn't matter much, except
in the case where you're not actually changing the channel because it's
the same as the operational channel (which would be easy to optimise
away by just sending probes on the current oper_channel)

johannes

--=-fHbpJPhkwXfDBgUArt3F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXzc4AAoJEODzc/N7+QmaptcP/0fkp2gEIbbmF1/Lb47ShXGA
lyhQPyLFA9YRN0fc1j3KBJTDv70HMAlwCkarQxgpIXYHpejwvjJ7F/or+a9mpuKt
YPkpcs5sDgfNM+SfR/p6a2gnyfGszoSWAulMM4SY7J+mx/dRbcp9/dXgSd9InUsE
aqZLLtypPnjrSnCJllzBuLpEkSyvoMiwYFp8YYDPKwcBEzJ3Un4/tSmpDS2E/hBS
u2L9phouTRUkMhyFL4kclaak08RngME4HP5TpivtpytBPL0oFD80+439OueJAiWL
+a6JSn1U1/dfzSZOXOTcsCiJbn87viBH7SkSsM9FYF9S1OXK2WyH7dSMNi5chlgL
BtRCXFIVl7hfLc6944qDIWtD0bGPeC0Y5nAitKbB9jCpyo6pVp/fwl9y8asm8KZ6
rB4viQFnSinXPI+9qZ/hgRE6dGM8wd4SLMwhXuyCj9Q21dM5nZc0CFSJ6n1WyPZ0
xOP06NcJiyrlYCOVidV1N19ag+hA7mNQUBFEpcJAjxP9FRheZc59cLx+o8XzIS7D
N87JESihrJME5k3ddr5RklJ5ATTns8mrdt16uGyXhklVQwaTJsiwtrV0qjTuYVFO
a7+gDHePlIhe5UyBO1gi4150dQe8VzlONcAjm2Eazisls4pm/9YrDLGoLFBau8sC
qkcUjaqMHSksujSqq/3Q
=wnr6
-----END PGP SIGNATURE-----

--=-fHbpJPhkwXfDBgUArt3F--

