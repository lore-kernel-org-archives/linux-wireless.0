Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48989 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416AbYJMSEI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 14:04:08 -0400
Subject: Re: [RFC] mac80211: fix short preamble determination
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>, Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <20081013175457.GB30095@jm.kir.nu>
References: <1223713593.29811.38.camel@johannes.berg>
	 <20081013155938.GA30095@jm.kir.nu> <1223919110.10113.1.camel@johannes.berg>
	 <20081013175457.GB30095@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sJdN70Z7ohcxQgkrsRHd"
Date: Mon, 13 Oct 2008 20:03:32 +0200
Message-Id: <1223921012.10113.5.camel@johannes.berg> (sfid-20081013_200413_659718_AA561AE4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sJdN70Z7ohcxQgkrsRHd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-13 at 20:54 +0300, Jouni Malinen wrote:

> > I don't see how it cannot be -- you need stations not capable of
> > short-preamble to correctly update their NAV, no?
>=20
> Well, if you have many such devices, yes, but one might try to live
> without such protection if there are some with very limited transmit
> needs.

Would you then announce short preamble as the AP? That'd mean all other
stations would use short preamble and the poor non-short-preamble STA
would be left completely in the dark wrt. its NAV.

>  I don't know whether it would make much sense in most cases and
> anyway, it would be possible to make APs reject all associations from
> such devices. For example, I could see an attempt to dedicate one
> channel for 11g (ERP) and short preamble supported STAs and make the
> more modern implementations get somewhat better throughput there.

Indeed, that is possible, I think there's even a status code allocated
for this.

> I'll try to remember to file a comment to TGmb on this (they are still
> collecting comments for fixing issues in 802.11 and published
> amendments). Probe Request with this does not make much sense (unless
> you are either only interested in BSSes that support short preamble
> and/or you know that the AP you're interested is able to receive this).
> Authentication, association, and public action frames might be more
> likely candidates for this.

Ohh. Just a few days ago I sent an email with a request for
interpretation (there really just is a typo in 802.11-2007 but...) That
got forwarded around a lot, but I guess at least TGmb will see it :)

johannes

--=-sJdN70Z7ohcxQgkrsRHd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI841wAAoJEKVg1VMiehFYws8P/12uMjRaoOT2k4E9uYku4iPx
/Eoi5ojVzGlkFfj06NN8j/8VNN0W9NLWbFn+5h1YhsbQ4jkoI2i+3z8V7Jy+IoiI
v3as1CZnanFHCMUu9vpR9oU3boIcEucJskuHOJSoB43eI4YPLvGxVKKJoCVcazuO
cofpr0Eirz57q9wlfspQp/FV4x6tR/JvY4knLBIxiv+oOKKSPYizBz3aNZS1P8Wd
cp5+zbHf5Bw11E/BTogULPt3NY6gaKeYyLQHEFpUjt1qzzp3kxuKiYXUI7S9Ae7Z
sVhKicAKASi8rpnqVU3JJJs64WVOZtdIv197uG8lN49rj3Zw6f1poCXQS4geLlyT
QAjHJlGT3HxeynWC8tmz7ssrnYl6wGkpqSXxm7l3Ee4PQOjZdOyWYx5IpBspFMvE
wH+58dny35GIBcDmHQy/TgrCYqLw7QbHXiAJRiX2lEMu7OxsUp0u8ogvTG4Qmf7h
pUylM5zF5LMbk7pIt8753JcZzowjLDnjYoGLeun1gdjH2//aeG8ZgQu2sqjGDp7B
5OmGGOWCMRWUeWTzRlVdZgIsQ6LY3Qt5hf7b6eMzTHnerq/+yWSm20bKm9URi8vM
vXV5NmZZ7TgEM7U4ZgzBgOsU7PourcZPosR4xpi58q74cPNSHRhFxl4sKlc7g7mV
XEAx9hK8a6A8cNgV/BsJ
=MyNW
-----END PGP SIGNATURE-----

--=-sJdN70Z7ohcxQgkrsRHd--

