Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:35723 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab3FRR1I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 13:27:08 -0400
Date: Tue, 18 Jun 2013 19:27:04 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [PATCHv2 4/5] mac80211: add channel switch command and beacon
 callbacks
Message-ID: <20130618172704.GA28351@pandem0nium> (sfid-20130618_192714_168088_48415006)
References: <1371212124-26264-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1371212124-26264-5-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1371567628.8318.43.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
In-Reply-To: <1371567628.8318.43.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Johannes,

I'm skipping the "style" comments (you were right most of the time anyway) =
and will
only comment on the design stuff, see below:

On Tue, Jun 18, 2013 at 05:00:28PM +0200, Johannes Berg wrote:
> On Fri, 2013-06-14 at 14:15 +0200, Simon Wunderlich wrote:
> > @@ -2818,6 +2830,8 @@ struct ieee80211_ops {
> >  				 struct ieee80211_vif *vif,
> >  				 struct inet6_dev *idev);
> >  #endif
> > +	void (*channel_switch_beacon)(struct ieee80211_hw *hw,
> > +				      struct ieee80211_vif *vif);
>=20
> What about channel contexts? Actually I don't really understand this?
> Shouldn't it say which channel to switch to?
>=20

My first implementation (ath9k) does rely on mac80211 to complete the
channel switch, so it does not even need to know which channel is switched
to. I can add that as we can assume other drivers will behave differently .=
=2E.

> >  /**
> > + * ieee80211_csa_finish - notify mac80211 about channel switch
> > + * @vif: &struct ieee80211_vif pointer from the add_interface callback.
> > + *
> > + * After a channel switch announcement was scheduled and the counter i=
n this
> > + * announcement hit zero, this function must be called by the driver to
> > + * notify mac80211 that the channel can be changed.
> > + */
> > +void ieee80211_csa_finish(struct ieee80211_vif *vif);
>=20
> If there are multiple interfaces, should it be called multiple times?
> etc. Maybe it should be on a channel context instead?
>=20

Multiple interfaces are not supported - and I don't know how this should be
handled anyway. CSAs are triggered on a per-interface base from userspace,
and multiple CSAs would clash with each other (could be different channels,
different counters, etc ...).

Or would you have a suggestion how to handle this differently?

> > +	netif_carrier_off(sdata->dev);
> > +	err =3D ieee80211_vif_use_channel(sdata, &local->csa_chandef,
> > +					IEEE80211_CHANCTX_SHARED);
> > +	netif_carrier_on(sdata->dev);
>=20
> That seems like a really bad idea, deleting a channel context might tear
> down all kinds of device state and might require deleting the interface
> first ... I think the chan context API needs to be extended to switch
> instead.
>=20

Hm, yeah I can do that.

> > +	if (WARN_ON(err < 0))
> > +		return;
>=20
> This can fail _easily_ too, e.g. if some other vif stays on the channel
> and you're now using too many channel contexts.
>=20
> > +	/* don't handle if chanctx is used */
> > +	if (local->use_chanctx)
> > +		return -EBUSY;
>=20
> Still don't really like the way you've implemented it :-)
>=20

Why not? :)

> > +	vif->csa_active =3D 0;
>=20
> is that a counter, or should it be a bool?

It should be bool.

> > +static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
> > +				 struct beacon_data *beacon)
> > +{
> > +	struct probe_resp *resp;
> > +	int counter_beacon =3D sdata->csa_counter_offset_beacon;
> > +	int counter_presp =3D sdata->csa_counter_offset_presp;
> > +
> > +	if (WARN_ON(counter_beacon > beacon->tail_len))
> > +		return;
> > +
> > +	if (WARN_ON(((u8 *)beacon->tail)[counter_beacon] =3D=3D 0))
> > +		return;
>=20
> How can these happen?
>=20

Maybe when the beacon is re-assigned - although add a check for that
and remove these warnings ...

> > +	((u8 *)beacon->tail)[counter_beacon]--;
> > +
> > +	if (counter_presp && sdata->vif.type =3D=3D NL80211_IFTYPE_AP) {
> > +		resp =3D rcu_dereference(sdata->u.ap.probe_resp);
>=20
> Who guarantees RCU protection?
>=20

Hmm ... should add that.

> > +		if (WARN_ON(!resp))
> > +			return;
>=20
> That can legimitately happen, no? At least userspace is allowed to not
> set probe_resp now, if you want to change that ...
>=20

If there is no presp then also counter_presp should not be set.

Cheers,
	Simon

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlHAmGgACgkQrzg/fFk7axYFTQCeLW47XhHLTc5rto7P8T6U2l4c
ZmAAnAkL9jEzIT62sn+Bj/0TmK9f3N/Y
=AQmg
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
