Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33438 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365AbZDGTrE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 15:47:04 -0400
Subject: Re: mac80211: changing number of queues in ops->start
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
In-Reply-To: <200904072140.23318.mb@bu3sch.de>
References: <200904072024.41910.mb@bu3sch.de>
	 <200904072133.21296.mb@bu3sch.de> <1239133078.7187.3.camel@johannes.local>
	 <200904072140.23318.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0ZqcXt0SE/xHvLFsT8Ry"
Date: Tue, 07 Apr 2009 21:46:29 +0200
Message-Id: <1239133589.7475.3.camel@johannes.local> (sfid-20090407_214710_343478_FDCFAFB7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0ZqcXt0SE/xHvLFsT8Ry
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-07 at 21:40 +0200, Michael Buesch wrote:

> Ok I see. So you say it's OK to lower hw->queues after ieee80211_register=
.

Let's say it's acceptable ;)

> Should I reset hw->queues back to the value ieee80211_register was called=
 with, before
> I call unregister/free? Are there resources allocated by the number of qu=
eues?

There are resources allocated, notably the qdiscs etc. in
alloc_ether_mq() or whatever it's called in register_hw(). But the
networking core should keep track of those so it shouldn't matter what
the value is. OTOH if it can switch back and forth the pending packets
are done per queue... for example ieee80211_clear_tx_pending will be
called at unregister times, so if it's possible to be up with 4 queues,
and later be up with 1, you will want to unregister with 4.

johannes

--=-0ZqcXt0SE/xHvLFsT8Ry
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ262SAAoJEKVg1VMiehFYvPcQAIcqaNfNz0FijmK9BO54L7xQ
gb2DL6anXdB7JYUNO4QJ4nNR5cVFtjpZY6M1P1MMo1YrVTrx1k1M4QHfe/PuuSIE
En4uTmH8hGU/hMvnmj8bWOU/2COdo9MGqW03uGUC54jU7/1tCI8YDcylhR7+fFRg
juYgtD2WMwDUGbSSJHoj5Kwyaf4pCgzC57Kd74r4FdiWLUdankM6Qk6oIQk+N8Ub
vbi7QiXR/p6CpiN6G33Og1dKiqSCcIfT5AFXLLBF7Jx94uKRHaTyAcyQb9JyY3ND
8Mssqfu24TEb1A+UrIk7WoUSdE3+YkoqXCLRx/JhupQhjxsYxk4Q2QimWIMKLYF3
c64AVvq96eJ34qmQSQX8uccdB/G+Bz0bYh+l7O9rZuNwtVPIbn1xGLDaE1WQXXwZ
HgOMtC684nViIveSUM9CuCesGxDXcGUYnWFfnv2DlXxwHgBdn4vMGe6HmcDmo+EM
9hhD3Nup8FBWfSwxTJlaxr33jrdJZZX7297k9o/yyrgX73LAHiewhQZYDuvfiZtG
vSuF/9R+at27jYMd0aZ8zAEF5MlJpS24GF5QOgNtiRQB8IbF5rpUzfgoVtA887Rm
WFbKG4iaGrFhVDgMbb6aCQyaeduo0dF1J5FUpGQp5a34C09jS1B4plSudnuTMh+/
hXzc736yBPJwWpL2TFlW
=Wab0
-----END PGP SIGNATURE-----

--=-0ZqcXt0SE/xHvLFsT8Ry--

