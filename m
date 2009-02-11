Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45572 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbZBKSVK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 13:21:10 -0500
Subject: Re: [PATCH] mac80211: Make sure non-HT connection when
	IEEE80211_STA_TKIP_WEP_USED is set
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090211180417.GA21695@vasanth-laptop>
References: <1234370929-19519-1-git-send-email-vasanth@atheros.com>
	 <1234371464.16004.11.camel@johannes.local>
	 <20090211180417.GA21695@vasanth-laptop>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bLnaj+PI6Z9PvoWIxaky"
Date: Wed, 11 Feb 2009 19:20:34 +0100
Message-Id: <1234376434.16004.33.camel@johannes.local> (sfid-20090211_192113_633564_60B4360A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bLnaj+PI6Z9PvoWIxaky
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-11 at 23:34 +0530, Vasanthakumar Thiagarajan wrote:
> On Wed, Feb 11, 2009 at 10:27:44PM +0530, Johannes Berg wrote:
> > On Wed, 2009-02-11 at 22:18 +0530, Vasanthakumar Thiagarajan wrote:
> > > It is possible that some broken AP might send HT IEs in it's
> > > assoc response even though the STA has not sent them in assoc req
> > > when WEP/TKIP is used as pairwise cipher suite. Also it is important
> > > to check this bit before enabling ht mode in beacon receive path.
> > >=20
> > > Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> > > ---
> > >  net/mac80211/mlme.c |    6 ++++--
> > >  1 files changed, 4 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> > > index 169f10c..e7aafb0 100644
> > > --- a/net/mac80211/mlme.c
> > > +++ b/net/mac80211/mlme.c
> > > @@ -1532,7 +1532,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct=
 ieee80211_sub_if_data *sdata,
> > >  					 elems.wmm_param_len);
> > > =20
> > >  	if (elems.ht_info_elem && elems.wmm_param &&
> > > -	    (ifsta->flags & IEEE80211_STA_WMM_ENABLED))
> > > +	    (ifsta->flags & IEEE80211_STA_WMM_ENABLED) &&
> > > +	    !(ifsta->flags & IEEE80211_STA_TKIP_WEP_USED))
> >=20
> > Maybe we should have a separate flag for _REQUESTED_HT? I'm thinking
> > here that possibly we might be adding more conditions under which we do
> > not request HT?
> >=20
> > Otherwise, looks ok to me.
>=20
> That's right. We can even remove IEEE80211_STA_TKIP_WEP_USED if we
> introduce a generic flag to enable ht, but this cleanup can be in a
> separate patch. Thanks for the comments.

Good point, if we identify another reason to disable HT later then we
can just rename this flag.

johannes

--=-bLnaj+PI6Z9PvoWIxaky
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJkxbvAAoJEKVg1VMiehFYTdkP/1T7bjrOr6zuQQMUMerOK8en
FgW/HcMPwsCPxrM5ygfUOpMG/TmkDQgY+uYcRxOJl5pGXg49HPutQZDfA+VkhCGJ
UWb7GsEl/Kd5jjTBuRQO0P3xqNowS5mitelnf2dnmW27Q0KRxJ2crALgHc0mp6CM
E4B3W7SxvgqW+xebtUhxYANbWITFiTMREr+eAi3+Etx5CfSpLqmjFAri7qMaPMY0
LCLzyLd08e1VY+6rwcUJr+QtzH3W/VMF+3oz03VsJ4dFl6BrJEZBGOeIolkbRBE8
1wCuRurcAkCfz+PkNIeR300Bl1mHfshicAB9vficF12TP9ohHAgSqFxdtooqAlvT
ph12/GEnfV2fKWtKw9MMk7jllL/zGPqcV6PuS0KVU3g+uPh3KOmDwdkWtuAJV7X7
eAqr22QBMJ0UGjolB+qxrI4yhY/k6JA3vUU8x+P45/jzT8Qy26zNCPxAbW3Rx0NX
OmwURT4A+cp45PtzGsmyS5LcoWDPiymjqTNhYWG3TEXTDXmO2n6KOX5s/f221wDT
12E2Six7i+0CMpdpFs6MkyhLBX9XYF8HH5ApCiuRoHNhj0kn3ihKiSp6vWj7ZrDh
LLAvZgxSH9bFKIyXlTUdrXAviFkN1GYFb80B07BtqIgpbFsqeU6tv8/3etjXFw/t
tD840Rzpl8wv9VvfI+9F
=1zaN
-----END PGP SIGNATURE-----

--=-bLnaj+PI6Z9PvoWIxaky--

