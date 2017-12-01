Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from james.theweblords.de ([217.11.55.87]:50987 "EHLO
        james.theweblords.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751160AbdLAReu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 12:34:50 -0500
Date: Fri, 1 Dec 2017 18:34:46 +0100
From: Peter =?UTF-8?B?R3Jvw59l?= <pegro@friiks.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Setting TX power on a monitoring interface
Message-ID: <20171201183446.2c5f8504@fem-net.de> (sfid-20171201_183454_527148_F6A8C87B)
In-Reply-To: <1512139742.25588.14.camel@sipsolutions.net>
References: <20171120173415.1ae44829@fem-net.de>
        <1511782993.5456.6.camel@sipsolutions.net>
        <20171127160722.4969cd23@friiks.de>
        <1512139742.25588.14.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/PH/Sg5D831hdnrJmlHGlzhZ"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/PH/Sg5D831hdnrJmlHGlzhZ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Johannes,

On Fri, 01 Dec 2017 15:49:02 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Mon, 2017-11-27 at 16:07 +0100, Peter Gro=C3=9Fe wrote:
>=20
> > > I think if the driver has WANT_MONITOR_VIF, then we can pass that
> > > through and let the driver sort it out.
> > >=20
> > > But if not, we probably just have to reject the configuration? =20
> >=20
> > With passing through you mean calling bss_info_changed on the driver fo=
r the
> > monitor interface? =20
>=20
> I meant to pass the &monitor_sdata.vif pointer instead of the real
> monitor interface that's coming through cfg80211. The former is virtual
> and has no netdev, but the diver is aware of it.

I'm not sure I get where to pass this to what. Do you mean in
drv_bss_info_changed or ieee80211_set_tx_power?

> You can check that
>=20
> 	local->monitor_sdata
>=20
> exists, and use it if yes, and reject if no.

Assuming you meant ieee80211_set_tx_power, then I'd have to check whether w=
dev
is a monitor interface and reject the configuration, if local->monitor_sdata
doesn't exist?

But in ieee80211_set_tx_power no vif pointers get handed around, so I'm
confused. Sorry.

Regards=20
Peter

--Sig_/PH/Sg5D831hdnrJmlHGlzhZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEFBMm5T0HjV/btb+Q2Ws8k4f65hoFAlohkrYACgkQ2Ws8k4f6
5hodQQf/bJ2p0vFXeTwatUF2FloplOwawghesnM8tfLhU80n0BXjP7x+Wc2SCZ2e
XrZ6MYZB0o2l+uq6dxBnuM16dqVy6sd/kBQUbKBChXH4lKd7c5l2vWE7Us2OfV4U
GMGE0QksKz/o8RJmAXbJClGXua5B2t/eCmowB6WDvSU5DDm6JYc8bjseDN5U+yLg
jfHKxNsCkXt+Lt/mnVbmzkXuQMJGiJB1hF9qv9Oed2SMEpDz4/BoU4VJ9hgl4eKV
hxKETW9WV8Dq++CBlY5FBpJejnu6bp+4y1WK+9iPFATQgGfw0pNpVWfLlq2GWQtM
Ond1w4x5QU68cgtyii4Sftv+UP1kEg==
=NLCI
-----END PGP SIGNATURE-----

--Sig_/PH/Sg5D831hdnrJmlHGlzhZ--
