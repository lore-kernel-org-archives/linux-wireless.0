Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40977 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347AbYKGQGZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 11:06:25 -0500
Subject: Re: Thoughts about mac80211 client PS implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1225969259.3619.202.camel@johannes.berg> (sfid-20081106_120106_811231_EB10DE82)
References: <87k5bhkjf1.fsf@nokia.com>
	 <1225917235.3619.180.camel@johannes.berg> <87fxm5ki6s.fsf@nokia.com>
	 <1225919146.3619.190.camel@johannes.berg>  <877i7hkgpn.fsf@nokia.com>
	 <1225969259.3619.202.camel@johannes.berg>
	 (sfid-20081106_120106_811231_EB10DE82)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dzzTC8XA87MLfcBOPrqS"
Date: Fri, 07 Nov 2008 17:06:24 +0100
Message-Id: <1226073984.11203.3.camel@johannes.berg> (sfid-20081107_170643_637427_642C5F74)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dzzTC8XA87MLfcBOPrqS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-06 at 12:00 +0100, Johannes Berg wrote:

> > > Maybe we don't want to disable PS for a single frame though
> >=20
> > Actually I think we do. The reason why I'm interested in dynamic PS is
> > the receive latency (transmit latency minimal is in practise). For
> > example, let's think about DNS request. In the best scenario only one
> > frame is transmitted, and if we don't come out receiving the reply to
> > the dns request will take a long time. If DTIM is 3 and beacon
> > interval 100 ms, the RTT for the DNS request/reply would be 300 ms.
> > That's a long delay to a case where user has pressed a link in the
> > browser and the browser starts to load a web page.
>=20
> Good point. So set my M to 1 and N to 0 ;) Well, in that case you don't
> need a timer at all but can just schedule the work right away.

Another thought I just had: you could catch the frame in
subif_start_xmit, stop the master interface queues, xmit the frame to
the master interface, schedule the PS off work, and after that turns PS
on you wake the master queues.

johannes

--=-dzzTC8XA87MLfcBOPrqS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJFGd9AAoJEKVg1VMiehFYwW8P/0C1bPQmn0PLwvkWXROj0vSS
Dv//UVhZ/aWVV3/WCua19AdtQrS3iOCjtEn5HPBj49q7VMq2hOVkumxYaQsaZ+FL
TR5wKIXrExDjAmdjqXsao3V5eq7owbh9+SPeY5h7KQcGn63fodR/uAK59dJuG+y4
X8x0ri96m/qmE8FEo/VMFnUDrMTGLnYNUoWEf7clnvD2iBFf0fJ5g3mv2LwM2Bdk
Yp9p95AV96PNrZ+sPZRcEebCs0oRBLtH/jlgOwUmvqccR3LS0/SE/cDesiWY0Qnn
Uu/7IQAL3fWDI5mGHJdUwE01lLz0HJ7WIafpKp3elk5aXKtVL8anlxrYnqukEq+h
OD65jCfAefvQmFd7yLi/exm+IR3buCuryuAvPYCl24dLZJYlU/l5mu98o4eVy5Fi
WC7nGuZoRIgQHcbHbVlT3C03jDnnVsymap+6oS5wEymfbBM2jWaXg9aFSzu1oHzU
lja8krMeFxrSH3k1n6Ld35JxB0l74j1QWBQz4h4eVCJx+33XA6KcchanT7anhe8M
MqGmIEFJsD+AP3vF1yZZMmdHy9Y9jmqWJgsZ3oazgnI6QAkPJqFV80IE0H+bw7LQ
TgmpG9NjCr+cXMwoEAGYMpqRwnVP68wsdfJ7msDTBnStI+YXO9qqSk3ZFZNywTiw
DEjF9jQNsS+eqGh+6wOR
=MeJo
-----END PGP SIGNATURE-----

--=-dzzTC8XA87MLfcBOPrqS--

