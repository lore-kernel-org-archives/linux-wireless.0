Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36637 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965522AbXCGQlf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2007 11:41:35 -0500
Subject: using keys service for wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: wireless <linux-wireless@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PF8uPtkn9E5DklTGfDjH"
Date: Tue, 06 Mar 2007 19:58:12 +0100
Message-Id: <1173207492.3503.13.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PF8uPtkn9E5DklTGfDjH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi all,

Months later... I finally thought about whether we should be using the
key service (Documentation/keys.txt) for wireless. I think I've decided
against that but want to present my thoughts here just in case someone
jumps in to tell me where I'm wrong :)

So let me start with an analysis of how we currently use keys. Normally,
when we set up an encrypted wireless connection, we do two things at the
same time: we tell the driver (or mac80211 stack) to use encryption and
hand it a key. There are keys of various types based on which we decided
what kind of encryption userspace is trying to set up.

After the key has been set we encrypt all frames that go out with that
key. Oh, there's an issue with group keys vs. pairwise keys which means
that a single connection can have multiple keys and for outgoing packets
we choose one of them to do the encryption with, same for incoming
packets.

For master mode (access point), we have a key per station and possibly
some more keys, but the basic principle is the same: we hand the
stack/driver a key and it uses it for en- and decryption.

There's basically no lifetime management going on, the key is usually
valid until removed by userspace. In some cases there needs to be key
renegotiation, but this is handled entirely in userspace anyway.

Looking at this, I notice that if we wanted to use the key service we'd
still have to tell the stack/driver about the encryption type [1] we
want to use as well as when to start using it. Since we have no lifetime
issues here, using the key service doesn't seem to really gain us
anything and makes the userspace interface more complicated (the actual
key data would be transported out of band while the command to use it
still is in nl80211)

Does anybody have a differing opinion? If not, I'll add the required
primitives to nl80211.

johannes

[1] we could of course use many many key types or the key description
for this

--=-PF8uPtkn9E5DklTGfDjH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF7bnE/ETPhpq3jKURAgeFAKC2Mck8fDvhDXsWItE0CA9e3DzrdwCeMiYA
wSs376ZiGGgbT0hz28c1CEU=
=ab5h
-----END PGP SIGNATURE-----

--=-PF8uPtkn9E5DklTGfDjH--

