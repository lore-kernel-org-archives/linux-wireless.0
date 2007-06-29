Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58389 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbXF2F6Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2007 01:58:25 -0400
Subject: Re: [PATCH] mac80211: separate monitor/subif_start_xmit
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Andy Green <andy@warmcat.com>
In-Reply-To: <200706282235.46522.flamingice@sourmilk.net>
References: <1182433144.21939.6.camel@johannes.berg>
	 <200706282235.46522.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ywN9XkYw2FiPkzk1Q19p"
Date: Fri, 29 Jun 2007 07:58:49 +0200
Message-Id: <1183096729.4089.7.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ywN9XkYw2FiPkzk1Q19p
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-06-28 at 22:35 -0700, Michael Wu wrote:
> On Thursday 21 June 2007 06:39, Johannes Berg wrote:
> > +	skb_set_network_header(skb, len + sizeof(struct ieee80211_hdr));
> > +	skb_set_transport_header(skb, len + sizeof(struct ieee80211_hdr));
> > +
> Hm, just noticed a potential problem with this. sizeof(struct ieee80211_h=
dr)=20
> can't be used since ieee80211 headers are variable sized and the smallest=
=20
> frames can end up being smaller than the 4 addr header.

Uh, let me think, yeah sounds about right, we'll have to get the actual
header length. There's a function for that though.

johannes

--=-ywN9XkYw2FiPkzk1Q19p
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGhJ+Y/ETPhpq3jKURAjzRAJ9eDUfvO+i4PDQiCJabhONEKKHxMACbBb8T
dLlrgSAmJDChaqMumAUeKOc=
=mzs8
-----END PGP SIGNATURE-----

--=-ywN9XkYw2FiPkzk1Q19p--

