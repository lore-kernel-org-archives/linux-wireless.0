Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:60601 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab3ACHfv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 02:35:51 -0500
Date: Thu, 3 Jan 2013 08:35:39 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, assaf@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv5 3/8] nl80211/cfg80211: add radar detection
 command/event
Message-ID: <20130103073539.GA20780@pandem0nium> (sfid-20130103_083600_507044_956E4285)
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1355407113-27006-4-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1357133940.9839.26.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
In-Reply-To: <1357133940.9839.26.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 02, 2013 at 02:39:00PM +0100, Johannes Berg wrote:
> On Thu, 2012-12-13 at 14:58 +0100, Simon Wunderlich wrote:
>=20
> > +++ b/include/net/cfg80211.h
> > @@ -133,6 +133,11 @@ enum ieee80211_channel_flags {
> >   *	to enable this, this is useful only on 5 GHz band.
> >   * @orig_mag: internal use
> >   * @orig_mpwr: internal use
> > + * @radar_detect_timeout: this timeout indicates the end of the channel
> > + *	availability check for radar channels (in jiffies), only after this
> > + *	period the user may initiate the tx on the channel.
> > + * @cac_type: indicates that channel availability check is started for=
 this
> > + *	channel type.
> >   */
> >  struct ieee80211_channel {
> >  	enum ieee80211_band band;
> > @@ -145,6 +150,9 @@ struct ieee80211_channel {
> >  	bool beacon_found;
> >  	u32 orig_flags;
> >  	int orig_mag, orig_mpwr;
> > +	unsigned long radar_detect_timeout;
> > +	enum nl80211_channel_type cac_type;
> > +	bool cac_started;
>=20
> Since we lock a channel, all of these should probably move to the
> rdev/wiphy struct, I think.

Hm, but when we have completed CAC on phy A, we could use the same
channel on phy B too, right?=20

That would be handy if one has two WiFi module and uses one only for
CAC/radar detection (e.g. checking other channels), and another one
doing the real AP service.

>=20
> And then the code checking channel contexts needs to be extended to not
> allow another while a channel context is in use:
>=20
> > +	mutex_lock(&rdev->devlist_mtx);
> > +	err =3D cfg80211_can_use_chan(rdev, wdev, chandef.chan,
> > +				    CHAN_MODE_SINGLE_ONLY);
> > +	mutex_unlock(&rdev->devlist_mtx);
>=20
> This only does a spot check, keeping state needs to be handled
> separately.

I've extended cfg80211_can_use_iftype_chan() to check for other contexts
in the patch 1 of this series. This should make sure that only one single
mode context can be added, and it can't be added if other contexts are alre=
ady
present. So you say that is not sufficient?

I guess I'm still not fully understanding the channel context concept ...

Cheers,
	Simon

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDlNMoACgkQrzg/fFk7axYTAwCg76K6o66rY3vh3q82zwtWSgRU
8U4AoM1neXP3BpafaL5C0AbLLjOz8Bpq
=umKE
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
