Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42137 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbZCKRNv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 13:13:51 -0400
Subject: Re: [PATCH v5 1/4] ath9k: implement IO serialization
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20090311160740.GB5669@tesla>
References: <1236739953-17701-1-git-send-email-lrodriguez@atheros.com>
	 <1236739953-17701-2-git-send-email-lrodriguez@atheros.com>
	 <1236762611.9658.87.camel@johannes.local>  <20090311160740.GB5669@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WQ+3gp5I0umoUf117NqZ"
Date: Wed, 11 Mar 2009 18:13:46 +0100
Message-Id: <1236791626.20266.37.camel@johannes.local> (sfid-20090311_181354_593630_30206087)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WQ+3gp5I0umoUf117NqZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-11 at 09:07 -0700, Luis R. Rodriguez wrote:

> > This is utterly insane. Just make it _always_ do the spinlock, and get
> > rid of the hotplug notifier and all that crap.
>=20
> That is certainly an option as well but we would obviously be incurring
> the lock on all reads/writes regardless of what bus you use which is
> not necessary. We'll review this and determine whether its worth it.

Hmm. I really don't understand this at all. Most operations won't be
single writes and reads, and if you need multiple like a write+read for
indirect register accesses then I'm sure you need to serialise them
against each other in some other way too, no?

johannes

--=-WQ+3gp5I0umoUf117NqZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJt/FHAAoJEKVg1VMiehFYs3AP/1y2XDbvUG9tOUhvxiqTnBxI
mRXI9Yz3cCHCXMRVlm7DUSt9i5DrI9g/cze5FakzK8FhFLvxm6T2z/l3yYpo+nNC
GVJimh2nLvr7xxwU/lXLa8lmY8TQV7k6/uwHJUDfhR6oFV9Tp09+fTcfOmyB5N+V
OGjqWK/oxjblDmgqh9q+dAAb02ZkYFxAP72BAKKPIuz1gUS7F8UGfpiopYL0cvyZ
G0WPG6GrMftPmShvM5QEcuX41PKqzO1eqdhy1fprOO2lgan/VhIH763wBtntdLFa
c1cULOXQ1LPH6J2idQhJJDiGIEcAr7q4ln7OmTEDcVMaNf76hsLBoSaIvAHiVtev
TDuAnJBc+UPiG7qvTKHQCSHo9IILdmUK2RqSw3x+3vrbN6lSALkzrLVaI/TZkwLV
l9+FxZLspJd9148OpBx26OYM/oFLPkYyOGQUEv2nLrP9Wu4yRSgjwHSxSb5p6SaG
QQvnvjZjh4bgXk2FEdUDlsGD/ulcGUnLJ8gMY0LQCn0hb7S5Q0Di5RPcXdz1KN1y
5i5KnDAst0KhmJfqijZF1hdLhWwDxbOxPkOVWoyFVOfLJP9/64xhrtXVQQR9zk1w
2BJWVBj59a8oGf9yhmJ8zXBEw8VQR9mI1TNJ/GMaRAcVG+rN5uXFxiTV1qXrMyF+
EYTqug27J8hZN0yyqSXD
=gXUK
-----END PGP SIGNATURE-----

--=-WQ+3gp5I0umoUf117NqZ--

