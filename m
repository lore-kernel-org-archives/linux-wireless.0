Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:60544 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567Ab3FRPO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 11:14:29 -0400
Date: Tue, 18 Jun 2013 17:14:25 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [PATCHv2 2/5] nl80211/cfg80211: add channel switch command
Message-ID: <20130618151424.GA27492@pandem0nium> (sfid-20130618_171433_116827_539B4E22)
References: <1371212124-26264-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1371212124-26264-3-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1371566890.8318.32.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
In-Reply-To: <1371566890.8318.32.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 18, 2013 at 04:48:10PM +0200, Johannes Berg wrote:
>=20
> > +/* struct cfg80211_csa_settings - channel switch settings
> > + *
>=20
> /**
>  * struct ...
>  * ...
>=20
OK

> > + * @NL80211_ATTR_CH_SWITCH_COUNT: u32 attribute specifying the number =
of TBTT's
> > + *	until the channel switch event.
> > + * @NL80211_ATTR_CH_SWITCH_BLOCK_TX: flag attribute specifying that tr=
ansmission
> > + *	must be blocked on the current channel (before the channel switch
> > + *	operation).
> > + * @NL80211_ATTR_CSA_IES: Nested set of attributes containing the IE i=
nformation
> > + *	for the time while performing a channel switch.
> > + * @NL80211_ATTR_CSA_C_OFF_BEACON: Offset of the channel switch counter
> > + *	field in the beacons tail (%NL80211_ATTR_BEACON_TAIL).
> > + * @NL80211_ATTR_CSA_C_OFF_PRESP: Offset of the channel switch counter
> > + *	field in the probe response (%NL80211_ATTR_PROBE_RESP).
>=20
> Shouldn't the offset be into the CSA_IES?
>=20

Hmm ... yeah you are right, that would be better. Will fix that.

> > +	struct nlattr *csa_ies[NL80211_ATTR_MAX+1];
>=20
> Hmm, this doesn't seem right.
>=20

Why? If it's about namespace, see below. :)

> > +	err =3D nla_parse_nested(csa_ies, NL80211_ATTR_MAX,
> > +				   info->attrs[NL80211_ATTR_CSA_IES],
> > +				   nl80211_policy);
>=20
> (Indentation)

oops...

>=20
> If you're going to use nested IEs, shouldn't you define a separate
> namespace to be used within the nesting?

The idea was to recycle the nl80211_parse_beacon() function for the CSA IEs,
but if you prefer I can define an own namespace and create a separate funct=
ion
to check.

Cheers,
	Simon=20


--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlHAeVAACgkQrzg/fFk7axYybACgw8yONWf4ER74bN0rl1mG77Mk
xfYAn0+bvQQ8n7XQ+l1+TzhafjE0Z7Gr
=WtnU
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
