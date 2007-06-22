Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33052 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbXFVUTI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 16:19:08 -0400
Subject: Re: [WIP] mac80211: kill mgmt interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: Andy Green <andy@warmcat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070622174953.500817e0@griffin.suse.cz>
References: <1182418939.10821.8.camel@johannes.berg>
	 <20070621143558.68fc8e4a@griffin.suse.cz>
	 <1182429920.21939.1.camel@johannes.berg>
	 <20070621151441.500d62d5@griffin.suse.cz>
	 <20070622154545.29eeebdb@griffin.suse.cz> <467BDCB1.1010604@warmcat.com>
	 <1182526221.21939.94.camel@johannes.berg>
	 <20070622174953.500817e0@griffin.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0nAm+vuGxvY6ODMP5klE"
Date: Fri, 22 Jun 2007 22:20:20 +0200
Message-Id: <1182543620.21939.98.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0nAm+vuGxvY6ODMP5klE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-06-22 at 17:49 +0200, Jiri Benc wrote:
> On Fri, 22 Jun 2007 17:30:21 +0200, Johannes Berg wrote:
> > In addition, we still have the problem with receiving encrypted eapol
> > frames etc. that we really need to see unencrypted but can't make it to
> > the network interface.
>=20
> Hm, are you able to get such management frames if you're not root (or
> has CAP_NET_RAW capabilities)?

Currently? You need CAP_NET_ADMIN for PF_PACKET, but I'm not sure what
would happen if we passed them up instead of dropping them. There must
be a reason we currently drop them.


> I think netlink is fine if it is used for injection too (at least of
> management frames and WPA stuff).

I don't disagree. I'd even say that having both injection interfaces is
fine since they really cover different use cases.

johannes

--=-0nAm+vuGxvY6ODMP5klE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGfC8E/ETPhpq3jKURAnbFAJoD+WLGUEBTaEGdq88V54LYVvlyXgCgiX28
a2eQ8ZXXdVMwiUSsADm8G8w=
=YkHd
-----END PGP SIGNATURE-----

--=-0nAm+vuGxvY6ODMP5klE--

