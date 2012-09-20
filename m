Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:22810 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab2ITPEC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 11:04:02 -0400
Message-ID: <1348153746.2388.25.camel@sauron.fi.intel.com> (sfid-20120920_170406_385652_63383D21)
Subject: Re: regression: tethering fails in 3.5 with iwlwifi
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Date: Thu, 20 Sep 2012 18:09:06 +0300
In-Reply-To: <1348152971.31352.140.camel@edumazet-glaptop>
References: <1347361823.26457.3.camel@sauron.fi.intel.com>
	 <1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
	 <1347631355.5263.19.camel@sauron.fi.intel.com>
	 <1347640763.5263.24.camel@sauron.fi.intel.com>
	 <1347892887.7112.9.camel@sauron.fi.intel.com>
	 <1348142775.2388.10.camel@sauron.fi.intel.com>
	 <1348144524.4161.26.camel@jlt4.sipsolutions.net>
	 <CANn89iJkXrZPB14KU8xA-Dn8_n=H3J4-R60BTZFV+STF9_ASdA@mail.gmail.com>
	 <CANn89iKStHAwVZtpgQMzEpByGYG2FKpjSQsJFT-9qQmjw+KJ8g@mail.gmail.com>
	 <1348145936.2388.18.camel@sauron.fi.intel.com>
	 <CANn89i+9Th=xVgDgoy7tHwKtLNpOC8rgJkA09nQ1Yf0zvqBw6w@mail.gmail.com>
	 <1348147353.2388.19.camel@sauron.fi.intel.com>
	 <1348151149.31352.109.camel@edumazet-glaptop>
	 <1348151876.2388.24.camel@sauron.fi.intel.com>
	 <1348152971.31352.140.camel@edumazet-glaptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-TQXa6hhPnJKigFt67HgM"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TQXa6hhPnJKigFt67HgM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-09-20 at 16:56 +0200, Eric Dumazet wrote:
> On Thu, 2012-09-20 at 17:37 +0300, Artem Bityutskiy wrote:
> > On Thu, 2012-09-20 at 16:25 +0200, Eric Dumazet wrote:
> > > Please remove this hack and try the following bugfix in raw handler
> > >=20
> > > icmp_filter() should not modify skb, or else its caller should not
> > > assume ip_hdr() is unchanged.
> >=20
> > Did not help :(
> >=20
>=20
> What gives (after some failures)
>=20
> cat /proc/net/raw

-sh-4.1# cat /proc/net/raw
  sl  local_address rem_address   st tx_queue rx_queue tr tm->when retrnsmt=
   uid  timeout inode ref pointer drops


--=20
Best Regards,
Artem Bityutskiy

--=-TQXa6hhPnJKigFt67HgM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQWzGSAAoJECmIfjd9wqK0FcwP/0ohCK2xcawjxkCuw06F3JeT
wOYd8l44PuUreE/uUcZqJ9NTpjWK5Gu4VJAVpzKpbcHTv695VTjH/psEGxp0ERv9
sdzzKSnyIEA+1x/zB3i0Bf12QHV8OOA7ly5nBciFkQKF+L4v/ZTNI+DpHGVZLOYP
QbG/cYzG7vnt1GWQU5Mt/NZNoArbCx4dLsjtkLE5itJrYSv4hkQaG6m/1MlYmhwL
N08jR6i201CPZzkMOFRentHsQAK5ReOfnlad571T7oBl9iYSjyXoqgJmWyi2v8eD
SZ/KivTxwMSudoJ+/sSfn8F4FCrVFizGvujLcHIIBNajhhm3WCQKHwYO2l/Lz/eH
sqGTeDETd1hWCLIkHTNaj6IlZ+QGKPsd60nZl5faNbkTQFio2wZ1dHEYUKtjws61
xWBeQWBKj6gx7AsRqaVGAjJt27tkigblAGr+lc6FPRQuypQTuKI8heu1mlKwy9Xp
Cu52VprFWt6QVUt1yerSOlH3JtfSw+XV3Z+7T6xF/mirh7GKlnViBzt6swRzXtrR
WV3CpJcECyeA+SOfKkyPRzarnzR06Lp+GQaxKFJxViioMT21hik03g988zIC78BK
BwZ0sapjz2NBncyDaZy28jCq+YVhj37acq5SCx3az87WZCZXMXjMd0RXjGbHEjH7
JRo1TY9Wb8PctRbohxU8
=aTFN
-----END PGP SIGNATURE-----

--=-TQXa6hhPnJKigFt67HgM--

