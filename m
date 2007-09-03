Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36453 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbXICOL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2007 10:11:27 -0400
Subject: more mac80211 bugs with interfaces down
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michael Wu <flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kYwQRNF4ECRaBuNDDgOk"
Date: Mon, 03 Sep 2007 15:27:47 +0200
Message-Id: <1188826067.14564.48.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kYwQRNF4ECRaBuNDDgOk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Just did the following:
 (1) start wpa_supplicant
 (2) wait for it to associate
 (3) ip link set wlan0 down
 (4) abort wpa_supplicant

This leads to a deauth frame being enqueued after the hardware has been
turned off, I don't think this is desirable. Any ideas how to solve it
in a race-free manner?

johannes

--=-kYwQRNF4ECRaBuNDDgOk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG3AvS/ETPhpq3jKURApDRAKCM7c1sXVKmfsXmRQrhcmkpvbM/dgCbBqHm
m3DSzdhdEFNPwlPD+5QCrlc=
=MGAz
-----END PGP SIGNATURE-----

--=-kYwQRNF4ECRaBuNDDgOk--

