Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39686 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYGWQch (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 12:32:37 -0400
Subject: Re: [PATCH] rt2x00mac: In error case stop netdev queue, free skb
	and return NETDEV_TX_OK
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Daniel Wagner <wagi@monom.org>, linux-wireless@vger.kernel.org
In-Reply-To: <200807231822.04895.IvDoorn@gmail.com> (sfid-20080723_180457_288184_B4DD3DAF)
References: <1216805279-19149-1-git-send-email-wagi@monom.org>
	 <200807231822.04895.IvDoorn@gmail.com>
	 (sfid-20080723_180457_288184_B4DD3DAF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bHsiW0/9rUbypr49XV+G"
Date: Wed, 23 Jul 2008 18:32:30 +0200
Message-Id: <1216830750.13587.25.camel@johannes.berg> (sfid-20080723_183239_583752_E5C805BA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bHsiW0/9rUbypr49XV+G
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-23 at 18:22 +0200, Ivo van Doorn wrote:
> On Wednesday 23 July 2008, Daniel Wagner wrote:
> > It is not allowed to use NETDEV_TX_BUSY in tx path anymore.
>=20
> If not, then why is mac80211 checking and handling the return value
> and is tx() still a function returning an int. mac80211 is actually reque=
ueing
> the frame when the hardware fails to send it, so why should that be compl=
etely blocked?

Well, we want to remove that code from mac80211 because it's horribly
ugly. But yes, if you stop queues it _should_ work.

> >  		WARNING(rt2x00dev, "Failed to create RTS/CTS frame.\n");
> > -		return NETDEV_TX_BUSY;
> > +		return -1;
>=20
> I am kind of missing the point here, this patch seems to come down to:
> 	We can't return TX_BUSY so we return a random other value

Yeah that's fishy. But I think this error code is just in this rts/cts
function and getting handled in ->tx()

johannes

--=-bHsiW0/9rUbypr49XV+G
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIh10bAAoJEKVg1VMiehFYTacP/iwqFqTcPF5smd/0vAm9jh23
a6GwGICU7SOaO04IrqJzmxTIL5jl0MK9POAXAqtDbNH4G/kU9yPv29DPVUEeHtAj
7ia1z5E3CREPKdqNjPzB8pNGOINy2t+z3MFpU5vLiXIyGqbI8PhvuihllMGOZp7N
c/cN/xkltWG2BXvFlKYGH7y+LJCh4ZS4yA7Mjr4SvphHOx9Pdyp3sUzUgEgok8hT
u0JkMR3sj7foa74kkQVw7dnnemDNRLkp/86bE285jsb14f5a0q9ZOWviWEOEzcPB
5FaO46aYvQvqgnaZ4qrQT0q2a8f3AurmybzXlqjSLd3On0A1E0w4XJpL2/fmW0t3
0rYBeT7zF+JOZLzeJ6G/K/CQkCaZUQTxK66DXft1+2gEDj79GjcxBl4CDGPpjpda
IGgQmfLhCWYys2jRD7IQa0kzSkRE2CWJ9b7GcElbbXRqAw9xVtMsTBdth41IH3H7
RfVV3TMLeQFO7qstjdh/EK1kQTxpy48b8b+KJoLcMLCN8A4BSBsUYkY6CEOwRUZn
OcnDnxsZbqTtyKX42tX/egBs+wsqy6XbFTRb3g9XHf936/AhpmZ6im3MsWNQNH+9
CMOfHSNvNMuWCHZngOWhHvlw7+LXPdp9KTeHdqLUn9Mlkj4KkII/c0EuPPrLqkFx
lcQO73m8fL+xpx/7f7kT
=iLOa
-----END PGP SIGNATURE-----

--=-bHsiW0/9rUbypr49XV+G--

