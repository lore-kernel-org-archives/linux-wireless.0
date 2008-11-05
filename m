Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56124 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398AbYKEUOC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 15:14:02 -0500
Subject: Re: [PATCH 7/7] cfg80211/mac80211: Add Country IE parsing/802.11d
	support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <43e72e890811051210x499dab3bhd4195f592c2aeaf2@mail.gmail.com> (sfid-20081105_211036_848548_C996DD5F)
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-5-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-6-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-7-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-8-git-send-email-lrodriguez@atheros.com>
	 <1225887783.3619.108.camel@johannes.berg>
	 <43e72e890811050857p7a6e371dq96880853dc310741@mail.gmail.com>
	 <1225908658.3619.135.camel@johannes.berg>
	 <43e72e890811051124g3931e244i3e29c413a05c08f3@mail.gmail.com>
	 <1225914733.3619.150.camel@johannes.berg>
	 <43e72e890811051210x499dab3bhd4195f592c2aeaf2@mail.gmail.com>
	 (sfid-20081105_211036_848548_C996DD5F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xdGbdTPZ+TmF8zoybKlW"
Date: Wed, 05 Nov 2008 21:14:01 +0100
Message-Id: <1225916041.3619.168.camel@johannes.berg> (sfid-20081105_211408_421976_52F38905)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xdGbdTPZ+TmF8zoybKlW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-05 at 12:10 -0800, Luis R. Rodriguez wrote:

> > Ok, checksums are nice to avoid having to memcmp large things, but
> > afaict we're talking about maybe 12 bytes, right?
>=20
> Depends on the number of triplets, but since we only support 32 reg
> rules this means we only support 32 triplets and therefore we only
> support a max IE of size of 99 bytes (32 * 3 + 3). Realistically in JP
> I expect there to be around 3, 4, or 5 or maybe even 6 triplets which
> is 21 bytes.

Alright, not so bad either though.

> > If so, why don't we
> > just keep a copy of the country IE and compare it fully every time?
>=20
> Eh. I'm inclined to leave the checksum then. We'd then have to bother
> with freeing yet another thing later.

Yeah, ok, I don't really care much, it just seemed the checksum
complicated the code a bit. I guess much of that was due to the somewhat
unnatural split between cfg80211 and mac80211 though.

johannes

--=-xdGbdTPZ+TmF8zoybKlW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEf6CAAoJEKVg1VMiehFYM+cQAKtxyt8l59HBerdmYjeQPVmE
6WSLaxQtFLLPKJJ/rNsRQrPvMg6W00cNtfDx1yOs59/5sU6jv6kPvhCaHRoIFXKu
Wj/hU/e5aPFzvZkEwXMkv7lPj9LpbVto/RqiwUzHGZ9YmjPYs8UwfG2dXDX3Sxjd
W1HIsir6wEdsgpTkCMIvGatQcVvOcc1ORBFsZFxkEGpDz6OEXBtgVyitkYq5B96U
COdG3UlVgzTYWZNZfqsZvQ/QvKmuChd6Nl3RNtYgcA4/TTVrVBr9t9r3WJ0aHl4n
I2u2UFVRvmhmjZQKCwvFVoeTb2E7dFGFHWl9bQEXDEPN3zry3SpfqkcdsOFQSdvC
yhQ8vuUfnVNwFSmfHFICzgr/pzYkUo3QBgnMiRDWGX1Kaa0Yuw587vD3ixEvHDPe
g4nR2Rku3ptQgmQ12IBE+AUumEZaCh227bO+9wHwncNp5aGMR647BpG+HD8kZgMC
Y3Hqme8axtbSn7PypnT8wJ7l1q3vQqkieAzU1bRL9YDW9LkRSQrmVOK6MIhyEKT1
5EGrMGtVqRvzdAe4xLnVcyRH0yDh3wX7APoTR7TVd/fiG4D2IOiPjtIBEOr83Za7
1faXsO9wuUsBXBEpTwNsYLd4HBOqeV9gP06a+uDJgHBPLbVK8HI1J5/p2JOy3zMr
xYHXVerDGEjYuYhYSrJh
=CyIf
-----END PGP SIGNATURE-----

--=-xdGbdTPZ+TmF8zoybKlW--

