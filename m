Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52516 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030622AbXB0M7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 07:59:25 -0500
Subject: Re: [RFC] Penumbra - Enabling unencrypted broadcasts alongside  normal  traffic
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <45E41A9E.2020908@warmcat.com>
References: <45E41A9E.2020908@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yTQ8a0wFX9ivwm5G9h5r"
Date: Tue, 27 Feb 2007 13:59:03 +0100
Message-Id: <1172581143.3870.259.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yTQ8a0wFX9ivwm5G9h5r
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Just a few comments. I'll leave aside the issues with 802.11 here hoping
you've thought about that. There are issues with admission control and
similar things, for example.

First, allow me to comment on some things from other sources:

> The payload is protected using a 255:223 Reed-Solomon? Forward Error
> Correction coding. This is capable to correct any 16 symbol errors
> over each 223 bytes of payload. To maximize the benefit of this
> protection, bulk data packets are limited to 213 bytes of actual
> payload (and a 10-byte header), giving a 255 byte encoded packet
> payload so each fragment fits inside a single error correction coding
> cycle. The Reed-Solomon? coding also means there is no need for a
> payload CRC.

802.11 frames are always protected by a 32-bit CRC and will be discarded
by hardware (in most cases) if that doesn't match. This is unnecessary
overhead.

> The unencrypted broadcast packets are indicated by having a "Magic MAC"=20
> address in their IEEE80211 Header Addr<n> fields.  The Magic MAC for=20
> Penumbra is 13:22:33:44:55:66 (the IEEE had something to say about our=20
> original choice of 11:22.. :-O ).

How about registering a OUI or getting someone to donate a MAC address
instead of using a locally administered one?

>   - Userspace transmits by creating a PF_PACKET / SOCK_RAW socket and=20
> prepending an Ethernet header with the Magic MAC in it and send()ing it.=20

I don't see why you couldn't use the packet injection stuff we'll be
needing anyway for userspace MLME.

>   - The wireless driver gets the packet for transmission, recognizes the=20
> Magic MAC, disables retries and sets the transmission rate (currently=20
> fixed 54Mbps, but this will change) and transmits the packet as a broadca=
st

You'd be able to control these parameters then.

>   - When an incoming packet is seen with the magic MAC it has a fake=20
> fixed Ethernet, IP and UDP header prepended to it.  IP and UDP checksums=20
> are inserted so the packet is clean.  The packet always looks like it is=20
> coming from UDP 0.0.0.0:61441 (port 0xF001) and is directed to=20
> 255.255.255.255:61442 (port 0xF002).  The packet is subject to iptables=20
> rules as usual.

Similarly, why not have userspace use a monitor interface directly?

> To get any kind of widespread use, the capability=20
> needs to be already available in stock kernels and drivers so that the=20
> user only needs to open iptables and run a userspace daemon rather than=20
> patch his wireless drivers and stack.

I don't think that once we have packet injection in place for userspace
MLME (well, we even have it now) you'll need to do any modifications at
all. You'll just need to do more stuff in userspace. I also don't see
why iptables should see these packets that are explicitly not IP. In
fact, I think such packets should not be seen by the networking stack at
all.

johannes

--=-yTQ8a0wFX9ivwm5G9h5r
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5CsX/ETPhpq3jKURAhqpAJ4qHjXKhM6pS31m/LBXW6fz0IK9PgCeKzhN
dzN+nJlJlABPGh9iw4beaNs=
=bUDz
-----END PGP SIGNATURE-----

--=-yTQ8a0wFX9ivwm5G9h5r--

