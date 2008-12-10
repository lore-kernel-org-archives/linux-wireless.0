Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37987 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbYLJRYN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 12:24:13 -0500
Subject: Re: [RFC] b43: rework rfkill code
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	hmh@hmh.eng.br
In-Reply-To: <1228929529.15837.34.camel@johannes.berg> (sfid-20081210_181928_441073_38D73A3E)
References: <20081210150935.GA10927@srcf.ucam.org>
	 (sfid-20081210_160955_698729_A777A57C)  <1228922997.15837.6.camel@johannes.berg>
	 <1228927898.19553.164.camel@violet.holtmann.net>
	 <1228929529.15837.34.camel@johannes.berg>
	 (sfid-20081210_181928_441073_38D73A3E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uQPBk0qMXFTkiWljydDv"
Date: Wed, 10 Dec 2008 18:23:40 +0100
Message-Id: <1228929820.15837.40.camel@johannes.berg> (sfid-20081210_182416_953060_7D937844)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uQPBk0qMXFTkiWljydDv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-10 at 18:18 +0100, Johannes Berg wrote:

> We really need to disentangle the state tracking rfkill does. People
> have said this a million times before, but nobody cares: drivers need to
> register hard-blocked and get soft-block states independently, not in a
> single enum; API for drivers needs to be, above all, EASY to use.

Also, the rfkill struct itself is a mess. What's get_state() for? Why is
this not layered? How can get_state() work correctly, it doesn't poll
the device so it doesn't look like software will ever get a state
update.

Then there's user_claim_unsupported which is set by all drivers but
rt2x00, probably because they have hardware kill switches and thus they
have to set it even if it's not strictly true, because of the lacking
separation between these things (that I pointed out)

johannes

--=-uQPBk0qMXFTkiWljydDv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJP/sYAAoJEKVg1VMiehFYrpMP/RKHLIH4xZeS1r+rXO3xLTcx
OfEhu9qp/kXIW1eypH0yrWcrXvGW0ydXiJfaJtUUzKmOJisYDRzLQhOh6rNxWztd
LjPAPJDEvfiJY4yA1PLN9NPAVn8nZ19x9yhF4JhnaccwEg3Fgf83WLmUyhHQu3+9
T+sjbrUN6Q3iiaiHxVWjSCHEk50cSr6m0kREfkobB5cFn/aNxoQE8i7ezRwn2jHX
TT1Y8gCJZy++WwTJFUPP5Rj3GmxRZC85VhJKne+crTw2Q4CBK4fX3s20M1wPP+Ny
yzosG7Cx0f56XPlVPdW1mTyzEvZuF0xKB3YJzxt+WvEY+8ozKCJch+yxIPQTxqg0
Zqf1qoyAIdlkz5a/uMtPk8JRewYhbfb6T5XpU5hgB6x6PecKvUbBca4FCr03i5y7
htAn7XbgRQSs42XxdZsgeL8+poX6OQv9DGxMntvpMjRo38iYWNgePz5MbRTi9gbt
ohUHpl407kMKTG4S1I7jySwWkzEnxGzkgAy1U/nPiHkCwkkhl3udjzUoy9Ji8bqy
p10bPVR2ngAII0GA7PXGxRFZHMt4ZuM1lfupdTCFol+mWsco3ZgnNXZDVT/+L3ON
jkTsRPwy5MMJovB2GerNHCni1yqqSoenNvw6kPsuJE13M51rR908BLymGj/mdJBD
mVaVUaVUo3ugCFnAJbHq
=iHcY
-----END PGP SIGNATURE-----

--=-uQPBk0qMXFTkiWljydDv--

