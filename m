Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:34647 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040Ab2HIJcx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 05:32:53 -0400
Date: Thu, 9 Aug 2012 11:32:46 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: add sta_update_rates callback
Message-ID: <20120809093245.GG6767@ritirata.org> (sfid-20120809_113258_091456_2423ED7E)
References: <1344474712-22561-1-git-send-email-ordex@autistici.org>
 <1344492897.4494.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oox5VnwalALFvA7"
In-Reply-To: <1344492897.4494.1.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--2oox5VnwalALFvA7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 09, 2012 at 08:14:57AM +0200, Johannes Berg wrote:
> On Thu, 2012-08-09 at 03:11 +0200, Antonio Quartulli wrote:
> > some drivers need to be notified in case of rates update. This callback=
 tells
> > the driver that something has been changed in the supported rates set o=
f the
> > station passed as argument and that it needs to update its internal tab=
les
> >=20
> > Reported-by: Guido Iribarren <guidoiribarren@buenosaireslibre.org>
> > Tested-by: Guido Iribarren <guidoiribarren@buenosaireslibre.org>
> > Signed-off-by: Antonio Quartulli <ordex@autistici.org>
> > ---
> >=20
> > ** This is the first time that I play with trace.h, so it could be the =
case that
> > I made something completely wrong! Sorry :)
> >=20
> >=20
> >=20
> >=20
> >  include/net/mac80211.h    |    4 ++++
> >  net/mac80211/driver-ops.h |   14 ++++++++++++++
> >  net/mac80211/ibss.c       |    4 +++-
> >  net/mac80211/trace.h      |   27 +++++++++++++++++++++++++++
> >  4 files changed, 48 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> > index bb86aa6..c5dc725 100644
> > --- a/include/net/mac80211.h
> > +++ b/include/net/mac80211.h
> > @@ -2284,6 +2284,10 @@ struct ieee80211_ops {
> >  				 struct ieee80211_vif *vif,
> >  				 struct ieee80211_bss_conf *info,
> >  				 u32 changed);
> > +	void (*sta_update_rates)(struct ieee80211_hw *hw,
> > +				 struct ieee80211_sta *sta,
> > +				 struct ieee80211_vif *vif,
> > +				 struct ieee80211_bss_conf *info);
>=20
> Passing bss_conf doesn't make a lot of sense, it hasn't changed when the
> rate changes...?

Right. I approached this the other way around..starting from the ath9k_htc
driver and I wrongly exposed useless arguments. Will fix this.

>=20
> Also there's already an update call sta_rc_update() so I think you
> should just define a new change flag for that?

mh, at the very beginning I thought it was not correct what you said, but i=
ndeed
we should be able to do the job in sta_rc_update().

But then why does the ath9k_htc driver implement ath9k_htc_update_rate() to
update the rate used to talk to the AP? Should it use sta_rc_update() as we=
ll?

Cheers,


>=20
> johannes

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--2oox5VnwalALFvA7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlAjg70ACgkQpGgxIkP9cwfCBgCgnI1vTq16O4ubKehntlVNMkoM
K60An1b21DXuaSzeOF8jfstSKoVVZidJ
=TUy1
-----END PGP SIGNATURE-----

--2oox5VnwalALFvA7--
