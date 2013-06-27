Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:46139 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab3F0P3V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 11:29:21 -0400
Date: Thu, 27 Jun 2013 17:29:13 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv4 02/18] mac80211/rc80211: add chandef to rate
 initialization
Message-ID: <20130627152913.GB19965@pandem0nium> (sfid-20130627_172924_113402_CA7B4C0E)
References: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1372337064-19254-3-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1372337940.8160.3.camel@jlt4.sipsolutions.net>
 <20130627142754.GA19965@pandem0nium>
 <1372343457.8160.10.camel@jlt4.sipsolutions.net>
 <1372343489.8160.11.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
In-Reply-To: <1372343489.8160.11.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 27, 2013 at 04:31:29PM +0200, Johannes Berg wrote:
> On Thu, 2013-06-27 at 16:30 +0200, Johannes Berg wrote:
> > On Thu, 2013-06-27 at 16:27 +0200, Simon Wunderlich wrote:
> > > On Thu, Jun 27, 2013 at 02:59:00PM +0200, Johannes Berg wrote:
> > > > On Thu, 2013-06-27 at 14:44 +0200, Simon Wunderlich wrote:
> > > >=20
> > > > >  static void ath_rate_init(void *priv, struct ieee80211_supported=
_band *sband,
> > > > > +			  struct cfg80211_chan_def *chandef,
> > > >=20
> > > > I'd argue you can remove the sband pointer now, since the band is k=
nown
> > > > from the chandef?
> > >=20
> > > Not really, these rate algos usually access sband->bitrates, and sban=
d can not be
> > > derived from just the band and these others parameters (at least I mi=
ss to see how).
> >=20
> > sband =3D hw->wiphy->bands[chandef->chan.band];
>=20
> might be more efficient to just pass it though :)
>=20
> johannes

Not all RCs have hw saved in their private storage, e.g. PID does not. Anyw=
ay, I'd
opt for the lazy approach and leave it like that, effiency is a good argume=
nt. ;)

Cheers,
	Simon

--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlHMWkkACgkQrzg/fFk7axb02ACgp1vMmQcSe3RaeulZFbic5Tdz
G/EAn04z1pGjD2NMi0QaHq9ZUuvO775B
=fWgG
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--
