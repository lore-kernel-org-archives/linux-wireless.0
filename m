Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:52764 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab2ADQvs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jan 2012 11:51:48 -0500
Date: Wed, 4 Jan 2012 17:51:44 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [PATCH 2/2] mac80211: add support for mcs masks
Message-ID: <20120104165144.GA3381@pandem0nium> (sfid-20120104_175152_022862_24CBC9BC)
References: <1324304099-18327-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1324304099-18327-3-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1325600690.3316.12.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
In-Reply-To: <1325600690.3316.12.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Johannes,

thanks for all the comments, I can agree to all points you made in this mail
and for the other one and will provide a PATCHv2 which should fix this.

One issue is left which I'd like to discuss, please see below.

On Tue, Jan 03, 2012 at 03:24:50PM +0100, Johannes Berg wrote:
> > @@ -358,10 +462,14 @@ void rate_control_get_rate(struct ieee80211_sub_i=
f_data *sdata,
> >  	 * the common case.
> >  	 */
> >  	mask =3D sdata->rc_rateidx_mask[info->band];
> > +	memcpy(mcs_mask, sdata->rc_rateidx_mcs_mask[info->band],
> > +	       sizeof(mcs_mask));
>=20
> Do we really have to do this? Might not a pointer be better?
>=20
> >  	if (mask !=3D (1 << txrc->sband->n_bitrates) - 1) {
> >  		if (sta) {
> >  			/* Filter out rates that the STA does not support */
> >  			mask &=3D sta->sta.supp_rates[info->band];
> > +			for (i =3D 0; i < sizeof(mcs_mask); i++)
> > +				mcs_mask[i] &=3D sta->sta.ht_cap.mcs.rx_mask[i];
>=20
> Oh, so it's filtered by station ... hm ok I guess unless we tie
> lifetimes together we have to do this.
>=20
> Maybe we could update all stations in the slow-path (changes in the HT
> mask) and then just use the already masked version in the sta entry in
> the fastpath here?

You are right that this definitly adds some load on the fastpath (Although
I don't know how much the compiler optimizes here anyway, its only 10 bytes
which are set and masked).

Currently I see two approaches here:

1.) move the masking into the station handling code (when a new station joi=
ns).
    We would also need to iterate over the connected station when changing
    the mcs_mask while the interface is up.
    --> this will probably need to change at quite some palces and might be=
 race-risky
2.) keep the masking in the rate_control_get_rate() function, but mask only
    once (first time) and keep the result in the station struct. Next time =
we
    enter it, we use the already masked result. We could then use a flag to
    remember that we already computed the mask and just use it, and another
    flag to signalize if the mcs_mask was modified externally
    --> this is not racy and rather simple, but adds some flags

Maybe you have an even better idea, please let me know what you think. :)

Cheers,
	Simon

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8Eg6AACgkQrzg/fFk7axahsACfTg4Jd1o4+FRVETq5PBSwuoe4
TXoAnjTIoSyQC5Jc27CsCT8+eBc5waJ9
=yr7O
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
