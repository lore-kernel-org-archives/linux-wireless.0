Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59604 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbXLHLgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2007 06:36:54 -0500
Subject: Re: [PATCH 1/4] mac80211: Clean up rate selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1197113615.7472.56.camel@localhost> (sfid-20071208_113407_806694_1684F565)
References: <1197112439.7472.34.camel@localhost>
	 <1197112909.7472.49.camel@localhost>
	 (sfid-20071208_112222_400278_02DE29F9)  <1197113375.4171.50.camel@johannes.berg>
	 <1197113615.7472.56.camel@localhost> (sfid-20071208_113407_806694_1684F565)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lBuXevkpZRtwDQxElueL"
Date: Sat, 08 Dec 2007 12:36:52 +0100
Message-Id: <1197113812.4171.53.camel@johannes.berg> (sfid-20071208_113656_336746_ADA6C1DA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lBuXevkpZRtwDQxElueL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sat, 2007-12-08 at 12:33 +0100, Mattias Nissler wrote:
> On Sat, 2007-12-08 at 12:29 +0100, Johannes Berg wrote:
> > > +	/* Send management frames and broadcast/multicast data using lowest
> > > +	 * rate. */
> > > +	fc =3D le16_to_cpu(hdr->frame_control);
> > > +	if ((fc & IEEE80211_FCTL_FTYPE) !=3D IEEE80211_FTYPE_DATA ||
> > > +	    (hdr->addr1[0] & 0x01))
> > > +		sel->rate =3D rate_lowest(local, mode, sta);
> >=20
> > I'm not sure but I don't think we want this. And you should use
> > is_multicast_addr() or whatever it's called.
>=20
> This piece comes directly from the old "simple" algo. You're right about
> is_multicast_addr. I agree this is something we might to get rid of, but
> I leave that decision to you.

Right, but I guess that Intel's algorithms do something different and
this would break it. IMHO that decision should stay in the algorithm
itself.

> Yes. It's after the get_rate() call so the algorithm can override it.
> But if it doesn't we compute it ourselves.

Hmm. Then the algorithm can't specify "no fallback rate", can it? Well,
this will have to be reviewed anyway when the API is changed to support
minstrel.

johannes

--=-lBuXevkpZRtwDQxElueL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR1qB06Vg1VMiehFYAQIjsg//dK13FriSX6ygg8gjhqmdSkoa5Lgefso/
nFjWVKWd4akO4E8JRHjiiKsTSFQw0tEJBMnY2v8KWAKG2RseSqXp4g8Cv9bEe/zH
A/cDUs3hzOlry2vbqNUFKzs/Wa4FUs+lFdI4WLfSCZ+Qxiq6wGIanM8tLQFqTxUw
WStk12R7k1Y1bNP9grE4083Tnhs/4BpeZLTXk38EqvPlpGwlPd7ZJtReMjg77Hu4
mEBj3maHvY3aBDXSZPRk50/kScpt02RlpUvRSzofNg7mR3jrdSfIZhabcIF80Zyp
aKEpIAtGpRHF8QJ8J2ZoiHS/7OjmPcFCdzVIe3L7TqVCIPiUbqzoMOw1DmPL28J5
ST3xQPcWrRDTesL2LE1BhBal5XW5puDXGUmuOmOgF4SQYMcy2i7SP3BJtsrgfq4v
juod8dmnQ6S0I+4yk5X9SP95EsRLeQu21xu6/7X2ctPuMvcD02X/ghKj1MbtH4co
/HZw9jYvelUhW0aVPTbwe1CoQDgPGnjFND6wxeS9DblHhn+EMMH7n7ZywSdneLos
jIbHf7BMiUmoAqp0c2zmtXFRBGFi3tM2/duCG3YK4sG91laV7pP4//FJsUQpcAMS
16AIMJfZ4Nk1l/FidJ98vfxg+AbOzF1ltmvt0ubNsi1PRAFheEVlFf97hVsG6mYX
tzm1z3Weqb0=
=qYPb
-----END PGP SIGNATURE-----

--=-lBuXevkpZRtwDQxElueL--

