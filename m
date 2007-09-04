Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33070 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbXIDOVD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 10:21:03 -0400
Subject: Re: bridge packets option
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <20070903235714.GT1835@jm.kir.nu>
References: <1188405071.1757.5.camel@johannes.berg>
	 <20070903235714.GT1835@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uP2DxyktaVdrLKhgUU6m"
Date: Tue, 04 Sep 2007 16:22:22 +0200
Message-Id: <1188915742.9942.33.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uP2DxyktaVdrLKhgUU6m
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-03 at 16:57 -0700, Jouni Malinen wrote:

> This is by design and in most cases you would not disable
> bridge_packets. This option is to allow the AP to be configured in a
> mode where wireless stations are more isolated from each other, i.e., if
> the multicast source were indeed the wireless client associated to the
> AP, other associated clients would not see these frames (unless
> something else in the network stack were configured to push them back to
> the same interface which is less likely to happen).

Ah, I see, ok.

> Multicast packets
> from other interfaces (e.g., wired Ethernet) would go through to the
> wireless clients regardless of the bridge_packets option.

Right, if bridged with wireless.

> The gain of what? Enabling bridge_packets? Disabling bridge_packets? The
> benefit of enabling it is to make things actually work ;-).=20

Heh, right.

> Kernel
> bridging code does not (or at least did not the last time I looked)
> allow packets to be bridged back to the same interface which would be
> needed for the case of two wireless stations which are associated to the
> same AP sending packets to each other.

I was thinking more of routing in the unicast case, if a packet comes in
you'd have to route it back to wireless if the destination is there.
Isn't that possible?

> If the bridging code were to be changed to be more aware of 802.11
> interface, I would be happy to get rid of the bridge_packet=3D1 code in
> mac80211. If I remember correctly, a patch for doing this was submitted
> long time ago and there has been some discussions on this topic, but not
> much progress on this area has happened. Consequently, all 802.11 AP
> implementations will need to continue doing this in the 802.11 code (or
> by using a patched bridge code or custom module for doing this somewhere
> else).

Thanks, I'll look it up.

johannes

--=-uP2DxyktaVdrLKhgUU6m
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG3Woe/ETPhpq3jKURAla2AKCnmsHWfNa5Gs5lfuVIIWi2fKKnlQCcCnju
i1hvU/vcmL9+0jQ1TJXoykI=
=FPwi
-----END PGP SIGNATURE-----

--=-uP2DxyktaVdrLKhgUU6m--

