Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60093 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbXH1Ijo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 04:39:44 -0400
Subject: Re: port of my recent patches to net-2.6.24
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200708271945.55384.flamingice@sourmilk.net>
References: <1188027470.9529.5.camel@johannes.berg>
	 <200708271945.55384.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-t/q7yz4nCc4u5RM67L0M"
Date: Tue, 28 Aug 2007 10:40:59 +0200
Message-Id: <1188290459.7837.55.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-t/q7yz4nCc4u5RM67L0M
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-27 at 19:45 -0400, Michael Wu wrote:
> On Saturday 25 August 2007 03:37, Johannes Berg wrote:
> > http://johannes.sipsolutions.net/patches/net-2.6.24/
> >
> Patch 22:
> +		ap =3D sta_info_get(key->local, key->sdata->u.sta.bssid);
> How does this work when we're setting a multicast/broadcast key on an AP=20
> interface?

Hmm. I don't think that ever worked correctly for when we ourselves are
using WMM. I can fix that.

>=20
> +	list_add(&key->list, &sdata->key_list);
> Should we be holding the key mutex here?

Yeah.

> This patch does too many things. If you can split some things out into=20
> separate patches, like moving code into key.c, it would be easier to revi=
ew.

Not easily since it's really intermingled with the ioctl code. Have you
looked at the original?

johannes

--=-t/q7yz4nCc4u5RM67L0M
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG09+b/ETPhpq3jKURAg4mAJ9noKcBKA0wf3oNlv+MJMyLs7WeOQCfTgom
A6OGLhxTfi/C0qQjy3dCYuY=
=9PJN
-----END PGP SIGNATURE-----

--=-t/q7yz4nCc4u5RM67L0M--

