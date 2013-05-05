Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:56819 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab3EET6T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 May 2013 15:58:19 -0400
Date: Sun, 5 May 2013 21:58:00 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Thommy Jakobsson <thommyj@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	piotras@gmail.com, Larry.Finger@lwfinger.net
Subject: Re: [PATCH] B43: Handle DMA RX descriptor underrun
Message-ID: <20130505215800.65ae7aea@milhouse> (sfid-20130505_215822_945607_4A8C695A)
In-Reply-To: <CACna6rz+PsN1GyniJL7JZJmb7T6Fnk_g101M8DeePr29LsAXaA@mail.gmail.com>
References: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net>
	<CACna6rxWPOqQPNUaASaj=v=O+Wjt0okjX4jNwE3tv-=etfATCg@mail.gmail.com>
	<CACna6rwk0akD0x+sWTmjDDoaQqF0Y=NQ58rzqgZH92GCug6CeQ@mail.gmail.com>
	<CACna6ry+F45PhCXahPpJtzu-w+vLE29ksHo9njXfTcfY3Av6LA@mail.gmail.com>
	<20130505192405.0cf4350e@milhouse>
	<CACna6rz+PsN1GyniJL7JZJmb7T6Fnk_g101M8DeePr29LsAXaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AmY5NkYK6eft/GXb_OHDW/6"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/AmY5NkYK6eft/GXb_OHDW/6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 5 May 2013 21:50:33 +0200
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> 2013/5/5 Michael B=C3=BCsch <m@bues.ch>:
> > On Sun, 5 May 2013 18:31:20 +0200
> > Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:
> >
> >> Still worth considering is my previous e-mail. Why writing (for
> >> example) 1 to RXSTOPINDEX doesn't stop firmware from using slot 1?
> >
> > What makes you think this register does not work?
>=20
> Take a look at this:
>=20
> [  327.224976] [DBG] old current:5      new current:6
> [  327.224982] [DBG] reading slot 5
> [  327.224997] [DBG] writing stop slot 6
>=20
> In above ring->slot was 5, but IRQ was generated, and we read new
> "current" using get_current_rxslot. It appeared to be 6. So we read
> packet from slot 5 and then called
> ops->set_current_rxslot(ring, 6);
> AFAIU hardware shouldn't use slot 6, right? But take a look at what
> happens next:
>=20
> [  327.319582] [DBG] old current:6      new current:7
> [  327.319590] [DBG] reading slot 6
> [  327.319619] [DBG] writing stop slot 7
>=20
> Hardware generated IRQ and we get_current_rxslot returned 7. It means
> we're allowed to read slots up to 7 (excluding). It other words it
> means firmware used slot 6... but 100ms earlier we forbid firmware to
> use slot 6!

I'd rather say that this is a race condition between your testing code
and the firmware.

--=20
Michael

--Sig_/AmY5NkYK6eft/GXb_OHDW/6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRhrnIAAoJEPUyvh2QjYsOjeIP/jrcdjx0HTjWRZLOn4Vv0u97
eAJPWY4PSrqynfNEH+J01YDOyqASkw+yCjCKcyhzZMgHWcLIJe7gJNmURKVEO4Fu
1Q+bn9CcWwcUzyGOPM5zQlm3daKGm1Ax8jKg8VYipaV+fe/hfS+F1K0C8e6+vw7K
F3Lr6VcJsNqp2mZO5Hb4klnSSyZeKRcTvUop3Po5F2aKaYnHq+qjzbhIvMNPEayX
aUMmu6Lvy/zAyhUQ+c905iDDJ3waVqHgcPLmoA3BS2lWm3XxCdVUAM2IY4fduzbL
263TXlbgh0F8QQKUG7A2mwwTfe51aGtdr5zDJd0O9FDaxA1nHKkifKJWNrnrjxvv
SJiel1HVwiZjOo2QMB3c7VlZYl7cxryGo8DXHXTQek/4qANYc8l/g5JbBLAFaR0W
/+D+qXUkydSOfY4BKKqtKxmXBy82CKUQd6AyClS9M2vL7FKq1iuEMCcnqYTZyYYl
IGNdBcI7k7n6zkqmzDlf9aDt4NSi4M/yVZSR2E1WlZLTPIyZRmvbPuoxcbJfDkLm
n9ni8gQWGkzvl6PQLwqNguF8XnvKTVequ63c1qSQGOGj8j7bWq0uJbIssYMzpnJa
Zel8FioPRG1HdF++daUQ7+MT6OC610uFhjeqMBvQXlzD1DQiRWp8xV0ALSd2jt2+
H/8NGcOiaZHZal3pFWJ+
=D1Z2
-----END PGP SIGNATURE-----

--Sig_/AmY5NkYK6eft/GXb_OHDW/6--
