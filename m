Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50681 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbYIRTOy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 15:14:54 -0400
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <20080918184709.GN1583@khazad-dum.debian.net> (sfid-20080918_204723_031094_B6AF070E)
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net>
	 <200809181716.24355.IvDoorn@gmail.com>
	 <20080918160803.GK1583@khazad-dum.debian.net>
	 <200809181851.59182.IvDoorn@gmail.com>
	 <20080918184709.GN1583@khazad-dum.debian.net>
	 (sfid-20080918_204723_031094_B6AF070E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-g3EoeA8huqUO/B6T0zub"
Date: Thu, 18 Sep 2008 21:14:15 +0200
Message-Id: <1221765255.20772.26.camel@johannes.berg> (sfid-20080918_211458_237516_E2394796)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-g3EoeA8huqUO/B6T0zub
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-18 at 15:47 -0300, Henrique de Moraes Holschuh wrote:

> Passing rfkill state around using the input layer is broken, and caused r=
eal
> issues.  That is what cannot be done, that is what was fixed in the new A=
PI.
> But that does not preclude, e.g., b43, from also exporting input events..=
.
> *as long as* it is done correctly.

[...]

I don't get it.

We only have a few things to control:

 * radio state for each device

and a few mechanisms:
 1) mac80211-internal (TPC, ..., iwconfig txpower off)
 2) per-hardware input button (soft)
 3) per-hardware rfkill button (hard)
 4) platform input buttons (soft)
 5) platform rfkill buttons (hard)

b43, for example, 1, 2 and 3 (where connected, this is unknown to the
driver) and may live on a platform that also has 4, 5 is very unlikely.

The way I see it, we should have about this architecture:

input layer        userspace      mac80211     driver     rfkill
  2 ----------------->|
                     (a)----------------------------------->|
  4 ----------------->|                                     |
                                      (b)<------------------|
                                       |
                                       +-------->(c)

                                      (e)<-------(d)
                                       |
                                       +------------------->|
                                                            |
                    (f)<------------------------------------|


(a) synthesize rfkill state for each driver out of the various input
    events you can get, depending on whether the platform button is
    bluetooth, wlan, all, ...
(b) take rfkill state and transform it into conf.radio_enabled along
    with the internal conf.radio_enabled state that mac80211 may decide
    on based on iwconfig txpower off. assume that users know what
    they're doing if they iwconfig txpower off, I think it's pretty
    pointless to have in light of rfkill and for all I care we can
    remove it
(c) take conf.radio_enabled and enable/disable radio
(d) notify mac80211 about _HARD_ rfkill state
(e) take that into account for internal state machine and report to
    rfkill subsystem
(f) display to user

Driver only has to follow conf.radio_enabled and inform mac80211 of the
hard state.

Where's the flaw?

johannes

--=-g3EoeA8huqUO/B6T0zub
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI0qiEAAoJEKVg1VMiehFY5kEP/1boSqLK1+85qHWOc2EgzhAQ
zAi4tcZKSBKxt4dOoN1CgV68xKtKgEYA9tTNh6gM+ex4aXFKpKGdB0ur0qUPNpD2
ALtwTbAth83o/sMKV/qN8yDCnzGCF90+FzBfxMsQpU0UHfnT7jX8UNlEpmfMuMKm
VpZwGPMtJuaVfbU/f2uqG/oDwcFwf0Bf3D//v8mRN+TEHDWRgHouBVjXYlgWVMfL
pedqIDgI4GTnSvd256UnGRfMl/HloVLv99H3V2u+wPM1nHQSjfEDjAh6sm0uG/WO
dQ/3I4dGT+DrHLgMvc3S6scxOIb2fGI9rPQt3gknORDfhqeZNctr5RCS3Vrdoxpl
5IjSs9Ne9Vc3wZOO7iVqLgcOLj1tfRmbvYKkpLM+TugnCOLnz9dx5vaNJl8+WC6W
HYeQ9z8tlyMaA0ct2FgasaOjy1k44lIjQglnMp6P61DT3k7QeP/vtNp0HU/WbDcO
4HUvbkAAYk+Fpzww3K1ORmZEW0/ffthHVWuqYtbCG3ZjjWNjdkaUS8OcOutf/8AY
/akxRC1fTp20sZhZGGuMeaAvuaXc2WMr3FVzzLt1YvNM1zMZuhPqTzlwOle0ZJUi
d1ciBWGp5+tqji5g3+W5L5GNm8Bep3hmgd43aOCM1xdhTabzQI8t3pMiqY0v2euJ
vIImNrzKQSotdIviN2dm
=Oc0j
-----END PGP SIGNATURE-----

--=-g3EoeA8huqUO/B6T0zub--

