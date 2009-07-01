Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36638 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZGAKoo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 06:44:44 -0400
Subject: Re: [PATCH 8/8 v3.1] mac80211: re-add HT disabling
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jmalinen@atheros.com>
In-Reply-To: <20090701101336.GD24667@vasanth-laptop>
References: <20090630115245.675553951@sipsolutions.net>
	 <20090630115303.111250594@sipsolutions.net>
	 <20090630132547.GB24667@vasanth-laptop>
	 <1246369077.16643.10.camel@johannes.local>
	 <20090630135207.GC24667@vasanth-laptop>
	 <1246370452.16643.11.camel@johannes.local>
	 <1246433956.16643.35.camel@johannes.local>
	 <20090701101336.GD24667@vasanth-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LstnfwoMtbZ5OkBvYJa9"
Date: Wed, 01 Jul 2009 12:42:39 +0200
Message-Id: <1246444959.4131.15.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LstnfwoMtbZ5OkBvYJa9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-01 at 15:43 +0530, Vasanthakumar Thiagarajan wrote:
> On Wed, Jul 01, 2009 at 01:09:16PM +0530, Johannes Berg wrote:
> > The IEEE80211_STA_TKIP_WEP_USED flag is used internally to
> > disable HT when WEP or TKIP are used. Now that cfg80211 is
> > giving us the required information, we can set the flag
> > appropriately again.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> >  net/mac80211/cfg.c |   10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> >=20
> > --- wireless-testing.orig/net/mac80211/cfg.c    2009-07-01 09:01:25.000=
000000 +0200
> > +++ wireless-testing/net/mac80211/cfg.c 2009-07-01 09:09:01.000000000 +=
0200
> > @@ -1228,7 +1228,7 @@ static int ieee80211_assoc(struct wiphy
> >                            struct cfg80211_assoc_request *req)
> >  {
> >         struct ieee80211_sub_if_data *sdata;
> > -       int ret;
> > +       int ret, i;
> >=20
> >         sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> >=20
> > @@ -1236,6 +1236,14 @@ static int ieee80211_assoc(struct wiphy
> >             !(sdata->u.mgd.flags & IEEE80211_STA_AUTHENTICATED))
> >                 return -ENOLINK; /* not authenticated */
> >=20
> > +       sdata->u.mgd.flags &=3D ~IEEE80211_STA_TKIP_WEP_USED;
> > +
> > +       for (i =3D 0; i < req->crypto.n_ciphers_pairwise; i++)
> > +               if (req->crypto.ciphers_pairwise[i] =3D=3D WLAN_CIPHER_=
SUITE_WEP40 ||
> > +                   req->crypto.ciphers_pairwise[i] =3D=3D WLAN_CIPHER_=
SUITE_TKIP ||
> > +                   req->crypto.ciphers_pairwise[i] =3D=3D WLAN_CIPHER_=
SUITE_WEP104)
> > +                       sdata->u.mgd.flags |=3D IEEE80211_STA_TKIP_WEP_=
USED;
> > +
>=20
> for..loop does not seem to be necessary here as it is very unlikely that
> an assoc req will have more than one cipher suite.

True, but so far we've defined the API that way. Should we redefine the
API? I keep forgetting what is valid where. Jouni?

> I'm not sure if this patch series will get into 2.6.31-rc, if it
> does not, we may need a variant of this patch to fix
> http://bugzilla.kernel.org/show_bug.cgi?id=3D13630, I'll work on it.
> Thanks!.

I don't think we can. Even the above patch relies on wpa_supplicant to
pass us the correct information. Otherwise we would have to parse the
IEs, which is somewhat ugly.

johannes

--=-LstnfwoMtbZ5OkBvYJa9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKSz2cAAoJEODzc/N7+QmaWmkP/iTR0YeM8WIXFKcdRnIfAKIJ
1y9raPN6Zh6LLcJTvNwO2rlAE/+JzKG5HBlEr24ZVsWJJsBTjPsyoysHwR4wxNB/
qfnrzoU+gz3nQr5ORfscphIZW8uEf194wNl1cVPpfnUPuFDkKsbvaE7Bx4VhWC1r
dNSUc04aKwr7tKxjsIPOuKuVETXZvW/WLuchudRVkO2JRsnYMh2b9mr49YgPaNqJ
3g7zuhhvCnQFqLXUu8fSfQ4eaQ2LuDUMpjMxPVxv9HJeHoh6JRSnsrFUYqufqRDP
ZcDVoukaxvJl8jBpTKmeCBKfteMBxSGNNS6mB6agOMskjiate/3+Y33JsSKZW+1H
hyeyVmmjzrli3Wt6NKmcZQSUfemBvgMzYo/Wfi/HbFAzgxsQeetGb0/hfxRjhv4+
l1d79ey/ki0iFsrT61SZiuGv1sn/LmgaWvPxMZ+y11MJ9k1kCwZU4bIsyzSuShXQ
G8Gy0cx6zpmELMW+junD+yXzb5udljYC/yK5k2F5B3JHTlJu17xUgfSiChlSuNpk
+dalDpC0k09I/OVB4w/sXh9HPS/E0ZEJO0pGdtEkNV30geO0B89c+Pi0ziFAvj9t
IqYpXz0N8q9xR+4JPAa3IzyykF/kImWfqUNrg/0SY0clFGVGsnl89W9Ca8XiTTeD
pkd1DxsAQ/y9hrmljj6N
=6tjc
-----END PGP SIGNATURE-----

--=-LstnfwoMtbZ5OkBvYJa9--

