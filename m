Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49652 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbXFHTgV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 15:36:21 -0400
Subject: Re: mac80211 "wme.c:398" error
From: Johannes Berg <johannes@sipsolutions.net>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: zergavis <zergavis@o2.pl>, linux-wireless@vger.kernel.org
In-Reply-To: <466992FD.4050608@linux.intel.com>
References: <1279688715.20070608205031@o2.pl>
	 <1181330294.6533.81.camel@johannes.berg> <466992FD.4050608@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9+6rSjSCf9M9l1e2CK/f"
Date: Fri, 08 Jun 2007 21:36:32 +0200
Message-Id: <1181331393.6533.90.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9+6rSjSCf9M9l1e2CK/f
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-06-08 at 10:33 -0700, James Ketrenos wrote:
> Johannes Berg wrote:
> > On Fri, 2007-06-08 at 20:50 +0200, zergavis wrote:
> >=20
> >> net/mac80211/wme.c: In function 'wme_qdiscop_destroy':
> >> net/mac80211/wme.c:358: warning: implicit declaration of function=20
> >> 'tcf_destroy_chain'
> >> net/mac80211/wme.c: In function 'wme_qdiscop_init':
> >> net/mac80211/wme.c:398: warning: dereferencing 'void *' pointer
> >> net/mac80211/wme.c:398: error: request for member 'wiphy' in something=
 not=20
> >> a structure or union
> >>
> >> Could someone help me handle with this?
> >=20
> > enable CONFIG_NET_SCHED for now.
> >=20
> > johannes
>=20
> CONFIG_NET_SCHED being set is the problem w/ older kernels.  We missed
> backporting tcf_destroy_chain and missed an ieee80211_ptr reference
> (and that code path is only included if CONFIG_NET_SCHED=3Dy).
>=20
> If you turn *off* CONFIG_NET_SCHED, it should build and run fine
> (which is what I'm doing on 2.6.18 and 2.6.20 systems currently)

Uh, oops, sorry about that. I figured since the symbol wasn't really
declared properly it would be missing, not too much :)

johannes

--=-9+6rSjSCf9M9l1e2CK/f
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGaa/A/ETPhpq3jKURAvR7AKC1GMmb2pGV0sY/5VKTIbvIuJvFnwCghefO
vI115+zXHj/pqM0DSS/liKQ=
=tRIX
-----END PGP SIGNATURE-----

--=-9+6rSjSCf9M9l1e2CK/f--

