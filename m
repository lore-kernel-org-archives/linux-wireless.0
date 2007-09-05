Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54983 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977AbXIELTY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2007 07:19:24 -0400
Subject: [RFC] per-sta reassembly buffers
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jouni Malinen <j@w1.fi>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Dd5sH++FnZFQLM/C+cPv"
Date: Wed, 05 Sep 2007 12:28:22 +0200
Message-Id: <1188988102.9942.89.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Dd5sH++FnZFQLM/C+cPv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hey,

I was looking through the defragmentation code and noticed that we only
allow four fragmented frames to be in flight at the same time. It seems
that in a somewhat contended QoS network where fragmentation is enabled
this is far from enough since as far as I can tell from the standard
each source STA may be sending fragmented frames in the various access
categories (think starting in background and then preempting by best
effort etc.)

We could easily increase this by using per-sta reassembly buffers at no
CPU cost [1] but that has the obvious disadvantage of having much higher
worst-case memory usage. Thoughts?

johannes

[1] the reassembly code can even be made faster then: instead of looking
through all four reassembly buffers whether they match we already know
that the source MAC matches, and by default we can hash into the four
slots by the lowest two bits of the sequence number and only if no match
continue to look in the other slots, this shouldn't really ever happen
as far as I can tell.

--=-Dd5sH++FnZFQLM/C+cPv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG3oTG/ETPhpq3jKURAoYGAJ4yr/Bqs/OeJ/8nU3PDEwpVS1NlmACcDKax
vtJTS5WPk/v5Goz7+NVWLI4=
=5ePF
-----END PGP SIGNATURE-----

--=-Dd5sH++FnZFQLM/C+cPv--

