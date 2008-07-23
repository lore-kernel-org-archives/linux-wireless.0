Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50864 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbYGWQaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 12:30:14 -0400
Subject: Re: [PATCH] rfkill: detect bogus double-registering
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <20080723152759.GC4684@khazad-dum.debian.net>
References: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br>
	 <1216775046-9506-2-git-send-email-hmh@hmh.eng.br>
	 <1216784519.13587.4.camel@johannes.berg>
	 <20080723152759.GC4684@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yTUaYlXe0Qcm3Cv2IrcA"
Date: Wed, 23 Jul 2008 18:30:07 +0200
Message-Id: <1216830607.13587.20.camel@johannes.berg> (sfid-20080723_183017_554077_9A48D560)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yTUaYlXe0Qcm3Cv2IrcA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-23 at 12:27 -0300, Henrique de Moraes Holschuh wrote:
> On Wed, 23 Jul 2008, Johannes Berg wrote:
> > > +	list_for_each_entry(p, &rfkill_list, node) {
> > > +		if (p =3D=3D rfkill)
> > > +			return -EEXIST;
> > > +		set_bit(p->type, &seen);
> >=20
> > You should WARN_ON so it can get fixed.
>=20
> I'd rather make rfkill_register __must_check, actually.  With or without
> WARN_ON.
>=20
> In fact, lots of stuff in rfkill should be __must_check.  Ivo, what do yo=
u
> think?  Add __must_check?  Add WARN_ON?  Add both?

Do both then. __must_check annotations get ignored regularly, or
"handled" like this:

if (...)
	// nothing we can do.

johannes

--=-yTUaYlXe0Qcm3Cv2IrcA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIh1yMAAoJEKVg1VMiehFYbMQQAMKKebSx2L/Ru6WVtJ4aXbMc
sMrp4EdfbX6hubxbq5Ir1HapZKH8tR2wn3C6YmeNBjnjK/+FqHFZnYp/rP5+zv+C
pmbcBUB25V2TLBuDkSjNfRqkkYyI0eetv0WCXvFtNmplUQ1XGitMCXQiZcf0/ah4
97WHx4+jt7u63JK3FoJ+Zk56K2MUuOQ7f8HtkT0e4J8v829pdDDfSpE8TaJrXXGg
UdZ8+On7kdXi4exFetrXoB5aExDjmi43lukKDFi10QDixqjh3ai/8KwhS79o3W/K
vLTEMj6oge0uf8W621zujz2/4is6DWzmvC83tjp6CvUOAPiofzoYaAPkk8FprYXX
oMID0TK736b0EJL4xtE7QZEzuBObPxAkgi+u8QKQUezTPlT2q8C+f6XpKh8hP3ND
5N9VnrPP3rsET5t4maoEb9uLEUksuSZ30rQetIdZN/JPR4NuClPO9wI7rcMxXsd0
iKAFdQsc+V8VZNgkBeJdzIwY5Cse25Ovqsd8y/Qrc+nfw/C8em1QP/VCBg7kF+d9
v6L6fq0brnR0iCxzdfDJzPCSXRXNnQH1muP4FXujnKHb5V9g165UdixGvfFqlc3z
8SLviYxWoYGZ7BXOy7tUrFBY607l+5+Sy3LY+XQLYDxPnC4hQzK6FmzB5uvS8/xE
3MwKFaC9+AqshfrtJMlC
=kpcH
-----END PGP SIGNATURE-----

--=-yTUaYlXe0Qcm3Cv2IrcA--

