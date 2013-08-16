Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:47321 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3HPNgg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 09:36:36 -0400
Date: Fri, 16 Aug 2013 15:36:29 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv2 4/6] mac80211: add support for CSA in IBSS mode
Message-ID: <20130816133629.GA9932@pandem0nium> (sfid-20130816_153640_747447_8A33AE12)
References: <1376058920-17779-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1376058920-17779-5-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1376649188.15299.11.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
In-Reply-To: <1376649188.15299.11.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Johannes,

thanks for the comments!

On Fri, Aug 16, 2013 at 12:33:08PM +0200, Johannes Berg wrote:
> On Fri, 2013-08-09 at 16:35 +0200, Simon Wunderlich wrote:
> > Ths
>=20
> This ;-)
>=20

yeah ... ;)

>=20
> > +	case NL80211_IFTYPE_ADHOC:
> > +		if (!sdata->vif.bss_conf.ibss_joined)
> > +			return -EINVAL;
> > +
> > +		if (params->chandef.width !=3D sdata->u.ibss.chandef.width)
> > +			return -EINVAL;
> > +
> > +		switch (params->chandef.width) {
> > +		case NL80211_CHAN_WIDTH_40:
> > +			if (cfg80211_get_chandef_type(&params->chandef) !=3D
> > +			    cfg80211_get_chandef_type(&sdata->u.ibss.chandef))
> > +				return -EINVAL;
>=20
> Is that really correct? It seems that you should be able to switch from
> HT40- to HT40+ and vice versa when switching the channel?

Hmm ... changing HT40+/- can only be represented by using either ECSA (whic=
h i did not
implement) or secondary channel offsets in action frames (which comes in a =
later
patch, but could be merged ...). Secondary channel offsets are not allowed =
in
beacon/presp, and therefore the client would keep the current mode (HT40+ o=
r HT40-)
as announced in the HT IEs of the beacon/presp. If I add support for second=
ary channel
offsets in the action frames, the beacons and action frames would contradic=
t, and that
would not be good either.

So I thought it is easier to forbid this case and avoid this mess. :)
>=20
> And why disallow switching bandwidth (was above this code)? That doesn't
> seem right either?

IEEE 802.11-2012 10.9.8.3 says:

"A 20/40 MHz IBSS cannot be changed to a 20 MHz IBSS, and a 20 MHz IBSS can=
not be changed to a 20/40 MHz IBSS."

Also I don't want to allow to switch to a 5 MHz/10 MHz channel or other fun=
ky stuff.

=20
> > +/* must hold sdata lock */
>=20
> pretty useless comment if you have the assert in the function :)
>=20

Right, I'll remove it. :)

> > +	rcu_read_lock();
> > +	ies =3D rcu_dereference(cbss->ies);
> > +	tsf =3D ies->tsf;
> > +	rcu_read_unlock();
> > +	cfg80211_put_bss(sdata->local->hw.wiphy, cbss);
> > +
> > +	old_presp =3D rcu_dereference_protected(ifibss->presp,
> > +					  lockdep_is_held(&sdata->wdev.mtx));
> > +
> > +	presp =3D ieee80211_ibss_build_presp(sdata,
> > +					   sdata->vif.bss_conf.beacon_int,
> > +					   sdata->vif.bss_conf.basic_rates,
> > +					   capability, tsf, &ifibss->chandef,
> > +					   NULL, csa_settings);
>=20
> This is pretty odd - why does the TSF have to go here? It needs to be
> set by the device when transmitting anyway, no?
>=20

TBH I don't understand the TSF magic completely, but as far as I know it is
used for IBSS cell merging. What we don't want is to change the tsf when
generating the new beacon and therefore (accidently) kick of some merging p=
rocess.
Therefore I'm keeping the TSF just as in ieee80211_sta_join_ibss().

ieee80211_ibss_build_presp() needs to put in the beacon, so I need to suppl=
y some
valid TSF, don't I?


> > +static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sd=
ata)
> > +{
>=20
> Is this some refactoring that should be separate? I don't see how it's
> really related to CSA? Maybe I'm missing something?

The only relation is that I need it refactored for IBSS/CSA. Disconnecting =
for
some reason and going back to search mode wasn't required so far.

I can put that in a separate patchset.

Thanks,
	Simon

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlIOKt0ACgkQrzg/fFk7axZarwCeLGQ5GgbgugkAErrk7FOy/ly2
AxcAoNtY3yJZwqbc2KtQ57NgKmb2LVGz
=lOst
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
