Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:43064 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab3F0O16 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 10:27:58 -0400
Date: Thu, 27 Jun 2013 16:27:54 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv4 02/18] mac80211/rc80211: add chandef to rate
 initialization
Message-ID: <20130627142754.GA19965@pandem0nium> (sfid-20130627_162806_745256_B5DE3F3E)
References: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1372337064-19254-3-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1372337940.8160.3.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
In-Reply-To: <1372337940.8160.3.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 27, 2013 at 02:59:00PM +0200, Johannes Berg wrote:
> On Thu, 2013-06-27 at 14:44 +0200, Simon Wunderlich wrote:
>=20
> >  static void ath_rate_init(void *priv, struct ieee80211_supported_band =
*sband,
> > +			  struct cfg80211_chan_def *chandef,
>=20
> I'd argue you can remove the sband pointer now, since the band is known
> from the chandef?

Not really, these rate algos usually access sband->bitrates, and sband can =
not be
derived from just the band and these others parameters (at least I miss to =
see how).
>=20
> Also, I'm not sure why you'd need this in rate_update, it should be good
> enough in rate_init, no?

Hm, minstrel_ht seems to be the only use of this function anyway. It calls
minstrel_ht_update_caps() for both rate_init and rate_update, and since both
calls had the same parameter it felt naturally and more easy to change both
the same way. Also this function calls rate_init from minstrel as fallback.

I don't really care, if you think it's akward I can certainly teach minstre=
l_ht
to store the chandef in its private memory.

Cheers,
	Simon

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlHMS+oACgkQrzg/fFk7axZLIwCeOM7Vy0HKIxwZ8dKP+4Ym7f2s
08IAn1K9BuZIi83X0sfeB/y5GJeMA+1g
=kDvf
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
