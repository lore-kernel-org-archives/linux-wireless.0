Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44324 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbXH3Lyc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 07:54:32 -0400
Subject: bridge packets option
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>, Michael Wu <flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-T4FdlnpYODogZCJPX1b8"
Date: Wed, 29 Aug 2007 18:31:11 +0200
Message-Id: <1188405071.1757.5.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-T4FdlnpYODogZCJPX1b8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hey,

Looking through the receive code, the bridge_packets config option has
the effect of copying multicast traffic to the air right away and
passing frames to a station without having them go all the way through
the network stack.

I think there's a flaw with this: when you turn it off, nothing will
copy multicast frames to the network as expected by an AP, as far as I
can tell. Hence, I think that the bridge_packets must not be honoured
for multicast packets.

OTOH, for multicast, is it actually correct? Doesn't the AP need to
rewrite some fields?

As for unicast packets, what is the gain? There's obviously the loss
that netfilter won't see the packet which is generally very much frowned
upon. Is the performance benefit really that high?

I really need more devices for testing :/

johannes

--=-T4FdlnpYODogZCJPX1b8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1Z9P/ETPhpq3jKURAnCSAKCDukurUaptJ9YeQUfmrdqKbOc2rgCdHB//
Zy/bcK1ig/WEoKyw0qHKrkY=
=SFmc
-----END PGP SIGNATURE-----

--=-T4FdlnpYODogZCJPX1b8--

