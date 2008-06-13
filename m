Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33782 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458AbYFMOnd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 10:43:33 -0400
Subject: Re: [PATCH] mac80211_hwsim: 802.11 radio simulator for mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080613142658.GI4919@jm.kir.nu>
References: <20080611074230.GA4919@jm.kir.nu>
	 <1213356074.3860.26.camel@johannes.berg>  <20080613142658.GI4919@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PpesqNcCBSNQ7wv+cGmX"
Date: Fri, 13 Jun 2008 16:43:18 +0200
Message-Id: <1213368198.3860.36.camel@johannes.berg> (sfid-20080613_164354_415377_B1C730F8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PpesqNcCBSNQ7wv+cGmX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > > +Please note that the current Linux kernel does not enable AP mode, s=
o a
> > > +simple patch is needed to enable AP mode selection:
> > > +http://johannes.sipsolutions.net/patches/kernel/all/LATEST/006-allow=
-ap-vlan-modes.patch
> >=20
> > Ok, once this code is in I'll add a hunk to my patch there that removes
> > this note.
>=20
> By the way, what's the current plan on applying this patch to allow AP
> modes to be enabled? I would assume they are still disabled because AP
> functionality is not yet complete, but is there a clear set of features
> that need to be added/fixed before this change goes in?

Well mostly the channel stuff, basic rate sets, rts/cts, short slot and
stuff like that. See
http://wireless.kernel.org/en/developers/todo-list#APsupport

> > Since you never set "ack" anywhere else, you could just say
> > 	ack =3D memcmp(...) =3D=3D 0;
>=20
> This is in a loop, so ack must not be cleared back to zero if it was
> once set to 1 for an earlier radio..

Oh, right, sorry.

> > > +static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
> > > +				     struct ieee80211_vif *vif)
>=20
> > Maybe there should be a helper function for all this? It seems mostly
> > duplicated.
>=20
> Yes, I was hoping to do this first, but there were some differences that
> I did not want to deal with at the time. I'll take a closer look at
> moving that to a shared function. It will likely make this bit slower,
> but then again, I'm not really concerned about how fast this sort of
> simulation code will work; it'll be much faster than actually going over
> the air to another host for sure ;-).

Heh. Well I didn't look too closely so if this isn't easy to do I guess
you shouldn't bother, it just seemed to be very similar to me on first
sight.

johannes

--=-PpesqNcCBSNQ7wv+cGmX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIUoeCAAoJEKVg1VMiehFYEfEP/A6hBw/tHiKseDPCFPINu0qI
s3tm8jUWg92s5Do5Z8WKU1h/M00HEQFdu9YWHr5qc+5uxQcKBUKAzJaH/f8b8Du4
eKPowk4jmlhis3sRELAKpeqcun+CuCs6qPoxrHx5Cd1uOPkian8o+7/aJCr4tYKC
9Fx5q7bDOmMSFOPImYlZ3FTnEHPXAmPKwkaVMohUb4FHVkVL2/rzV21EUMs/Dvx2
zJTpAOV2sAFMzPx+uagHrIIupuPfgK8InYUYmZPqWDKxLwFsPbbpvWfHdv46kU+Z
Ep1/FwwZFYyK0mKQTRe9hsMYvEpaq85k12mC/SaXn6WzSgOYiU7a1Yf66MMllMAi
qi4eaG8xO9m6GL5micodLgAh7S4OgYlrH2iK/aJ8TCFgph6VyF0D+50xoD8VaiFx
EpT+Bz2DtcO8pX5KQBKeveu7kRtl9NEjIIGeH19nNy5k22zs3rNPF8C15LskAd81
uKqSyFGv3v7SLTq9qGvvDfTWfwu2RFajwLuODWnOwEjORmvVpxOlh5GY+j8OxSOb
rqcd/nb3GIXd2Ovdolq7khDs4LXXu17DBnwENEyR87oeN9yKTWsTJ4TlABL9bHg3
RUSP1CwA0boBs/WI7gGMasWRCsZwd3wME/XVZxc8nzWA5U/h/1QBV+np0ci88440
0xh8s0EdGqYRNg+VKJq9
=cYhD
-----END PGP SIGNATURE-----

--=-PpesqNcCBSNQ7wv+cGmX--

