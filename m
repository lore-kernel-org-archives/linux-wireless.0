Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:51548 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab3ABOqE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:46:04 -0500
Date: Wed, 2 Jan 2013 15:45:55 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, assaf@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv5 2/8] cfg/mac80211: add dfs capability to
 cfg80211_reg_can_beacon()
Message-ID: <20130102144555.GB7794@pandem0nium> (sfid-20130102_154608_572782_49275E05)
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1355407113-27006-3-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1357133818.9839.24.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5/uDoXvLw7AC5HRs"
In-Reply-To: <1357133818.9839.24.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 02, 2013 at 02:36:58PM +0100, Johannes Berg wrote:
> On Thu, 2012-12-13 at 14:58 +0100, Simon Wunderlich wrote:
>=20
> >   * @chandef: the channel definition
> > + * @dfs_capab: supported DFS bandwidth
> >   *
> >   * This function returns true if there is no secondary channel or the =
secondary
> >   * channel(s) can be used for beaconing (i.e. is not a radar channel e=
tc.)
> >   */
> >  bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
> > -			     struct cfg80211_chan_def *chandef);
> > +			     struct cfg80211_chan_def *chandef,
> > +			     enum nl80211_chan_width dfs_capab);
>=20
> Hm how does that make sense? The chandef contains a width? It seems like
> the check whether or not DFS is supported (should be a bitfield btw)
> should be outside of this function?

I'll change the DFS support capabilities to a bitfield and drop this patch.=
 The
bitfield can be part of wiphy, and thus doesn't need to be passed down,
making this patch obsolete.

Cheers,
	Simon

--5/uDoXvLw7AC5HRs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDkSCMACgkQrzg/fFk7axaUZACg6c44J2nQNbrhSP/8xOuh4CpN
BNAAoLkCM8uSud4WiDv7vy5j5lNIyYV3
=KwZH
-----END PGP SIGNATURE-----

--5/uDoXvLw7AC5HRs--
