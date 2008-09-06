Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54266 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbYIFWm0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 18:42:26 -0400
Subject: Re: [RFC PATCH 1/3] mac80211: restructure disassoc/deauth flows
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240809061532s4f8e08c1xe59f99768ce440c0@mail.gmail.com> (sfid-20080907_003248_257597_C680198E)
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220739259-16918-2-git-send-email-tomas.winkler@intel.com>
	 <1220739930.21016.6.camel@johannes.berg>
	 <1ba2fa240809061532s4f8e08c1xe59f99768ce440c0@mail.gmail.com>
	 (sfid-20080907_003248_257597_C680198E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uvLKHoF+7c5MzWvBIaBr"
Date: Sun, 07 Sep 2008 00:42:19 +0200
Message-Id: <1220740939.21016.19.camel@johannes.berg> (sfid-20080907_004228_352066_B86A0A77)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uvLKHoF+7c5MzWvBIaBr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-09-07 at 01:32 +0300, Tomas Winkler wrote:
> On Sun, Sep 7, 2008 at 1:25 AM, Johannes Berg <johannes@sipsolutions.net>=
 wrote:
> >
> >>
> >> +static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdat=
a,
> >> +                                  struct ieee80211_if_sta *ifsta, int=
 deauth,
> >> +                                  int self_disconnected, u16 reason)
> >
> > I think you should use bool for those two (deauth, self)
>=20
> I'm thinking rather using some enum values just for readability
> foo(DEAUTH, ORIGIN_SELF) vs foo(tree,true)
> foo(DISASSOC, ORIGIN_PEER)  vs foo(false, false)

That works too, sure, though seems a little overkill, the function is
called what, three times? Anyway, whatever you prefer, I just don't like
bare "int" as a bool.

johannes

--=-uvLKHoF+7c5MzWvBIaBr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIwwdHAAoJEKVg1VMiehFYGmgQAJX9favRRXAbM3klJNHDfxRp
EPc6NGNrgDW7hrlLPBa5hl1OXjtmb4OD+G04DDAhqRsrTEi6vQ9gwpp31K4sKQ7t
+sZgP6+7KWeYF3tgnVR5cvpeAgKRiGsC+u7/NDElxwaspikVz0sAJCDJqKI7rJ/p
EAvLiPde3dKRMEe7acl3FgkJwlJIDYGCkOv5m5A+pgCIyWVd2/GPfZR20HbcqIiW
NUoEJfBoYr9csEuz2ItBp9pi6gHiwfCBRmKzA1VgZ+FZrJG4KxgautQXFXLYn60w
Mli+2/p2038i0JNHv3vpGpHV4q7P4RkIrA6I9KKT6AsY+kZtOhfWP7nnO/IQVSqd
WicsyweJWRyfyvLL7KVsUp6Qg6RVKbDiKmhZUBk8jieTTMR+sAhSFsPha0pSK2MP
F0m+5O/yLFGGVImK/nOM+vD0qcONR008x1w4dj34w/m5wAbKj6pXa8YKoDxRncvs
yB8AyNAgXZAQpgfvk/JrwExYz3rrCW+jItIJ5arPctwHiKV3Eb9LhYZSktScfUZ6
f4lRVLWk5FkzYeLQF3O8pQ2EubTHwTSj8c3hSNE3Nkd10qJwb8hPaawt/1VKYRRG
GtqkiEvTBbYtskgma8QiIQFGw4aUs8+nzs9CshIjGTnpSNFMw8gD0vI5q/+X9OQy
5CdiA3K9e/4wESA4AnSL
=KpBq
-----END PGP SIGNATURE-----

--=-uvLKHoF+7c5MzWvBIaBr--

