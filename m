Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47228 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbXD1N60 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2007 09:58:26 -0400
Subject: Re: [PATCH] mac80211: optimise ieee80211_get_hdrlen
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jkm@devicescape.com>
In-Reply-To: <20070428154049.313d5491@logostar.upir.cz>
References: <1175011305.9282.10.camel@johannes.berg>
	 <20070328191116.GJ6036@devicescape.com>
	 <1177686617.3565.27.camel@johannes.berg>
	 <20070428154049.313d5491@logostar.upir.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ha16+kfw/Cqpyr+Rie+F"
Date: Sat, 28 Apr 2007 15:58:37 +0200
Message-Id: <1177768717.5102.11.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ha16+kfw/Cqpyr+Rie+F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-04-28 at 15:40 +0200, Jiri Benc wrote:
> On Fri, 27 Apr 2007 17:10:17 +0200, Johannes Berg wrote:
> > --- wireless-dev.orig/net/mac80211/ieee80211.c	2007-04-27 12:03:38.3349=
87898 +0200
> > +++ wireless-dev/net/mac80211/ieee80211.c	2007-04-27 12:03:43.034987898=
 +0200
> > @@ -255,21 +255,32 @@ int ieee80211_get_hdrlen(u16 fc)
> > =20
> >  	switch (fc & IEEE80211_FCTL_FTYPE) {
> >  	case IEEE80211_FTYPE_DATA:
> > -		if ((fc & IEEE80211_FCTL_FROMDS) && (fc & IEEE80211_FCTL_TODS))
> > +		if (unlikely((fc & IEEE80211_FCTL_FROMDS) && (fc & IEEE80211_FCTL_TO=
DS)))
>=20
> This is not unlikely if you have a WDS link set up. I wouldn't change the
> condition.

Good point. Want me to resend of do you want to just remove the
unlikely?

johannes

--=-Ha16+kfw/Cqpyr+Rie+F
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGM1MN/ETPhpq3jKURAqihAKCHsKgsPyO4q11adC83vauKc1NIQgCgrVrM
RaDLaiblA1nNcasN0RRvbkk=
=OR5m
-----END PGP SIGNATURE-----

--=-Ha16+kfw/Cqpyr+Rie+F--

