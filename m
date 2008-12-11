Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36112 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbYLKSXZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 13:23:25 -0500
Subject: Re: [RFC] mac80211: Add HT rates into RX status reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org,
	Henning Rogge <hrogge@googlemail.com>
In-Reply-To: <20081211181545.GB32500@jm.kir.nu>
References: <20081211161741.GA27460@jm.kir.nu>
	 <1229015789.8081.40.camel@johannes.berg> <20081211181545.GB32500@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-U65UZge6LqXjnmqDXViV"
Date: Thu, 11 Dec 2008 19:22:48 +0100
Message-Id: <1229019768.8081.53.camel@johannes.berg> (sfid-20081211_192329_513799_D7209E8A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-U65UZge6LqXjnmqDXViV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-11 at 20:15 +0200, Jouni Malinen wrote:

> > Can we just leave off the bitrate for HT for now?
>=20
> Yes. FreeBSD radiotap definition uses 0x80 as a flag in the rate field
> for indicating that it is an MCS index, not bitrate. That works fine
> here, too, and I'll update my patch to use the same style. No more
> bitrate calculation for HT rates in mac80211 after that..

Ugh. Nobody will dissect that properly. Do you actually need this
information in userland _now_? Otherwise, Dave Young is moving the list
elsewhere and then we can properly define this in radiotap rather than
going with some other set. 0x80 in flags (not rate) is used to indicate
short-GI in wireshark, and it's all very confusing... I'd rather see a
new "HT rate" field added to radiotap.

> I did not want to think about anything for IBSS.. ;-)  One should just
> probe the other STA if you want to learn what it can do..

Right. Who cares about IBSS :)

johannes

--=-U65UZge6LqXjnmqDXViV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQVp0AAoJEKVg1VMiehFYhQwP/RO2TaV0ul5YAX5oL0/pqXUM
5jtHEUxwMIz3gVJZVNecjViES6L0bnIMI/NgRfOcxr9Z90N9oWQKb7UpbChZBNZh
afnUQzmk3s41V68eNK8nF0yp96xXBVyZBhMQIzBkYVkdAy4bjAxzJoo4TKhUty4J
fEH8nR18buKigNXBB7xhVNfgjoVf09iZZqrIizz+nuN6M5kePwD3maJ1a9UQWK/2
u8FYv289/SLyZOQ9UMpYjFU+wa/+dO0lyrhcpqd9Z61lHy4MVXlRJ6xyhuzaHMkG
QbzRn0HSX0PTLEfYbUa00GycKrlJ1PI7aiTVWyLzGXaYFTMzQJtxs7qBMgzeijsS
d3d2LKLUtjTVCiSOxaeUi9+ww31e+U5Q2XW8vPrnPh9Q8EHpeDCspeiQ1vYaPVEd
CnDWLqhU59veLz8Tr6ivzRK0zq/Ra8kA0mMhkJ5Qa8RbL7eqK1GvKdhrMV6MS8ey
GsQIW3J1PzzcvXZT2i4l19aHAAUvKVdXTbzFYCxHJUKp4TWbMsbBjPXMYDnaeJCd
tl/Pwofpps2nGq83eqv+5467gYoZssOSkkG1SmkpHwViHQMnUw4PeIRImFsbvuYF
162gI1DIsfrs8lLSzsn+quOKcbsyYp+iWAgJWIC5zzQ0iEBhY82yH9C/8ysmx/mN
xC/6T1yH0KNqdqfkZT8G
=Axyz
-----END PGP SIGNATURE-----

--=-U65UZge6LqXjnmqDXViV--

