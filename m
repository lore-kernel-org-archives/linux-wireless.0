Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40540 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZFRACh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 20:02:37 -0400
Subject: Re: [PATCH] wireless extensions: play with netns
From: Johannes Berg <johannes@sipsolutions.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: John Linville <linville@tuxdriver.com>,
	Netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@aristanetworks.com>,
	Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <m17hzato0r.fsf@fess.ebiederm.org>
References: <1245263058.31588.38.camel@johannes.local>
	 <m1y6rqwpur.fsf@fess.ebiederm.org>
	 <1245276899.31588.57.camel@johannes.local>
	 <m1r5xitpdh.fsf@fess.ebiederm.org>
	 <1245282099.31588.69.camel@johannes.local>
	 <m17hzato0r.fsf@fess.ebiederm.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-r63WaNt1gsUUaBg4KPBB"
Date: Thu, 18 Jun 2009 02:02:06 +0200
Message-Id: <1245283327.31588.74.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-r63WaNt1gsUUaBg4KPBB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-17 at 16:54 -0700, Eric W. Biederman wrote:

> > Subject: net: make namespace iteration possible under RCU
> >
> > We already call rcu_barrier(), so all we need to take
> > care of is using proper RCU list add/del primitives.
>=20
> This of course gives you a network namespace that can be found by for_eac=
h_net rcu
> while the per net exit functions are running.  I think that opens up to r=
aces
> that I don't want to think about.

Indeed. Can we move the rcu_barrier() up? Or we could insert a
synchronize_rcu() (which is sufficient for rcu_read_lock) before the
exit functions are run?

> I still haven't tracked down how I am occasionally getting time wait sock=
ets
> with an invalid network namespace.

Ouch.

johannes

--=-r63WaNt1gsUUaBg4KPBB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKOYP6AAoJEODzc/N7+QmaX2AQAL1fupDuQBJQV+iCimB+r8Ek
V9Bzl15XtroN6Rqd6wwTxLQLKzJS4ifwfRSjLTofgeXEKV9hxBuyDp+ZZEa2A/FB
a9RKZZ0tsf4+lhT1AzXl+tWl8bXGFvPTz1Fo7Rx5i/b5JkRQrVJgwF6K6DP14yTj
aZb+2n1ttbdH1bcmL+teaRZH7GOFaNbKaav/ryu3RWuAa6mVAS/TrO3gKfVb2s6I
yBNp7qN7bfbX3d8HbTFsvhmK/ZrOad4+kxh/YJdA2DUHywD8SkH2x9j+Br6zG6Vg
frUprJK9bpE3uC/4n1JbkLKlO5OGyeulqWgtipnM/imG8hcXkipBrxPb/lSMuRzB
0LCXOlOdBDEKYw4J5qug+lUaIvsQNm/jSyCk82ihViiWfe/4WODH78uTahyrw45R
g5fInk5c/pWHJowBEsGSdZv9OFuFZHZYXdjm/HfbyYEat/Boi1GpzsA/CMqHvpSv
+SySw0NX8TDWgSjd9epIIsJoasQ8KsB3vYSsAKOHIioycwa32DBEHsFfaeEzi4qq
/t/3Wh8+KXb5Y/DMqDVwjLqxPYfF6COkNRZP/XbhQrQEXC986miiRml05bdexKQv
Gyvz2Xy/SQbS3mXi/rFn04wJ0DdZLuwHR6JOGvHRdXraZp0soCJC85wtnIPzPC+Q
l9OccWf08uafbvWOpUqN
=Lbm6
-----END PGP SIGNATURE-----

--=-r63WaNt1gsUUaBg4KPBB--

