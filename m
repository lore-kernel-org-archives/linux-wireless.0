Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54259 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbZCKJKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 05:10:16 -0400
Subject: Re: [PATCH v5 1/4] ath9k: implement IO serialization
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1236739953-17701-2-git-send-email-lrodriguez@atheros.com> (sfid-20090311_035323_043986_25539888)
References: <1236739953-17701-1-git-send-email-lrodriguez@atheros.com>
	 <1236739953-17701-2-git-send-email-lrodriguez@atheros.com>
	 (sfid-20090311_035323_043986_25539888)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-J90tW8nuj23VMHLQEM5q"
Date: Wed, 11 Mar 2009 10:10:11 +0100
Message-Id: <1236762611.9658.87.camel@johannes.local> (sfid-20090311_101020_756321_54782647)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-J90tW8nuj23VMHLQEM5q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-10 at 22:52 -0400, Luis R. Rodriguez wrote:

> +	if (ah->config.serialize_regmode =3D=3D SER_REG_MODE_ON) {
> +		unsigned long flags;
> +		spin_lock_irqsave(&ah->ah_sc->sc_serial_rw, flags);
> +		iowrite32(val, ah->ah_sc->mem + reg_offset);
> +		spin_unlock_irqrestore(&ah->ah_sc->sc_serial_rw, flags);
> +	} else
> +		iowrite32(val, ah->ah_sc->mem + reg_offset);

This is utterly insane. Just make it _always_ do the spinlock, and get
rid of the hotplug notifier and all that crap.

johannes

--=-J90tW8nuj23VMHLQEM5q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJt3/wAAoJEKVg1VMiehFYgagQAJ8myrHAKpwUGuKpDgIxPqNS
HI6sEo2L1A4IkguxMXaKdKcKTQk9e0Yr3vcC+5q0Wr8S2xin/XZfgdZqzJOtwnWk
saDM4MEz/uAS9xKKD/RtfJNHBNHZSi38RHm2gQYxQJotLVTXPZ77DPOkzgjv3lxP
xGp8rSHk9+rJFbGS7jlihx4hoizibc1KcSvBmfpLdy1QJ/NVMgNfeCqeJ29br8bP
hyIz4JhQloSWl55nxufEpulo84k/8dFcTkFaI3lCkwZAadNdTnkFQBPAlQ3h1Q9E
VDX1j+vm3OSQfMxW0eulPzSWv8LaCDsiLbPYDlwLQmwVlIizMZK+yJVpVDwTMQOK
ingauohxmjS/jPdzTU+S17lkBMQ9Jp0kaNNNpMUEUv2erc/Bx5bEqEjSg3TIw+aJ
b5kmdfOD0oa34ekJ1JT0+SmDfMSzebbB7mgGY3y7Fbk0aYNlBxU/ukz1jgMF5FsT
vS9AazYfXM1Cj4tGhRyvFK0SbuUGa5dw2TRtkPojq19lg/NLpAPAYhDqoPrWqIvT
w/IyKnaBdZTDHlCsYeFi7Io59URwKRzFGEuCPDNdJpdYt3BnN9GB6xzuMffNMdYS
u/q+oM9n05Hd9C6cQMLUMywjLiQRBixF+GVeqwBt4PrW081Niwc27YfijN1xS9My
Uued5yGS9qVP+O/L3iXB
=/njE
-----END PGP SIGNATURE-----

--=-J90tW8nuj23VMHLQEM5q--

