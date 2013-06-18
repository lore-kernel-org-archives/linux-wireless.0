Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:42326 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933069Ab3FRQ2D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 12:28:03 -0400
Date: Tue, 18 Jun 2013 18:27:57 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv3 05/18] mac80211: fix timing for 5 MHz and 10 MHz
 channels
Message-ID: <20130618162757.GA28106@pandem0nium> (sfid-20130618_182811_240430_DEE81417)
References: <1368702045-27598-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1368702045-27598-6-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1371565283.8318.21.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
In-Reply-To: <1371565283.8318.21.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 18, 2013 at 04:21:23PM +0200, Johannes Berg wrote:
>=20
> > +static inline int
> > +ieee80211_hw_get_divisor(struct ieee80211_hw *hw)
> > +{
> > +	switch (hw->conf.chandef.width) {
> > +	case NL80211_CHAN_WIDTH_5:
> > +		return 4;
> > +	case NL80211_CHAN_WIDTH_10:
> > +		return 2;
> > +	default:
> > +		return 1;
> > +	}
> > +}
>=20
> Using this function will break with drivers that use channel contexts,
> you really shouldn't do that.
Hmm ... yeah, you are right. I've used this a lot in the following patches,=
 argh.

Will find another solution.

>=20
> Also, you're disabling HT so why bother changing minstrel_ht?

Mhm, yeah that is probably not neccesary. I'll remove that, however we reme=
mber
it once HT support should be added. ;)

Thanks,
	Simon

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlHAio0ACgkQrzg/fFk7axb6dgCeKiARJMvnGfDMuVXA8Rvh3onu
qsEAoJmzLAfNlcuCAQKxWUqMd7XHX36R
=RB7Q
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
