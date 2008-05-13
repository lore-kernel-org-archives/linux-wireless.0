Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36165 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767AbYEMI3B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 04:29:01 -0400
Subject: Re: 11n + wpa_supplicant
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Jouni Malinen <j@w1.fi>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <8704f27d0805130118p6f597743sebed5a2cdb6d59cb@mail.gmail.com> (sfid-20080513_101831_391958_FBACC8FF)
References: <8704f27d0805130118p6f597743sebed5a2cdb6d59cb@mail.gmail.com>
	 (sfid-20080513_101831_391958_FBACC8FF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LlCyh3UoN2v+rG7YgIDf"
Date: Tue, 13 May 2008 10:28:48 +0200
Message-Id: <1210667328.3646.24.camel@johannes.berg> (sfid-20080513_102906_735744_B044D81A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LlCyh3UoN2v+rG7YgIDf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> the spec of 11n makes the support on AES mandatory, but not TKIP.
> Meaning that a NIC can support WPA2 and 11n separately, but not TKIP
> in 11n. The RC4 encryption machine has a delay that makes difficult to
> encrypt in TKIP (or WEP) in 11n rates. Intel's 11n are such NICs, 11n
> + TKIP/WEP is not supported.
>=20
> The problem here is that the association (which can be 11n or not)
> occurs before the 4-way handshake. Let's say that I have an AP that
> publishes only TKIP in its WPA IE and 11n IE, I can understand that
> there is no way I should do 11n association. But what happens with an
> AP that publishes TKIP + AES in its RSN IE and 11n IE ? I could
> associate in 11n, but then wpa_supplicant might be configured to
> associate in TKIP (although the AP support AES), and I would be in an
> unsupported mode.
>=20
> One solution would be to make wpa_supplicant understand what 11n is,
> but that's not it's job.

I would think that, indeed, it *is* its job since its job is
key/algorithm selection and 11n limits the choices.

How about we simply put the 11n information element into the generic IE
and have mac80211 use that?

johannes

--=-LlCyh3UoN2v+rG7YgIDf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASClRP6Vg1VMiehFYAQKwThAAoxrj7/Itf553kxPn54E4U5EX+wO1GHcZ
GAXoZLDVvKcc85jEDQDxr/ssRc4H1gtz2Mv+cGxGFZuHix7Z6/bpw8DxWbhVsxr1
CRDHJ3XimkRuOhNoaLv45U3jWXgRrNCwauO+pbMI5J7weYfNhoi1VWeAOpnNRwVQ
hUUhhmskyhR055zdL/uAl2nfvjwBLga6QG+DEyHIRVbRcT2dd2ypHBw7x1s1Lot9
kE8ajk4QbUqlIKp/T6BZ6wCAgf+IZ4Mb5fG1gl7ppohfcPrYdCGwb/S4hd/mmEk1
gyNRcHk9boV3TySpcWnxJAkQwXD9DohNojH7fwKUnX/EeWltHpLHsiPW83pev3KS
Wxv4/QP+mWliYW3HLgT0vCVsC/VM/SUBFXjAMtWWUsf446/fKmUTw+TQDieeP623
NYEuKUULbFXM/eqiZJzBKKOSK4IbUbARPaTqUELgthITlvmMUy2KXiJwjCtwmeRo
UrvU0cZcU4jO6tpuQ/5y1ALFVM1F1tB6GRehv4xxJVxkQZVvAJE3JI3v+vu1E6al
6mnyFFiTzVixt2FihClqEW3aUYBeA41CPicBRIe46KLROnv7zzYroUq9r5c+sPBJ
rCqby0qNpO69EKRf/bh7tQjHJj5syl+P6ODQdZCf3iyGEkROV5WrpJbdMcN4+XXq
MLshRmmMy9g=
=YrPf
-----END PGP SIGNATURE-----

--=-LlCyh3UoN2v+rG7YgIDf--

