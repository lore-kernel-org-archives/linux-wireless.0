Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58088 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628AbXIKKQF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2007 06:16:05 -0400
Subject: mac80211 sta_info->dev race
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-URf2ZbHM5gvP9g4/OfLL"
Date: Tue, 11 Sep 2007 11:00:03 +0200
Message-Id: <1189501203.4506.110.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-URf2ZbHM5gvP9g4/OfLL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hey,

I'm working on making sta_info a per-virtual-interface structure for the
rare case where we have multiple virtual stations associated to the same
AP or for example WDS links.

Working through the code I notice that struct sta_info has a "dev"
pointer (which I will change to "sdata"), but as far as I can tell
nothing guarantees that we don't do sta_info_get(), then down the
interface, and then try to dereference sta_info->dev.

I see two ways to avoid this:
 (1) in sta_info_flush(), wait until each sta is actually released,
     don't just put it
 (2) with each sta_info_get() also do a dev_hold()

johannes

--=-URf2ZbHM5gvP9g4/OfLL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG5lkT/ETPhpq3jKURAsmaAJ9vxH08hwJIXKVbc3ZC/LFUyoPgEQCdGcBk
UIwlcDBzZmGtp48PxJFgsyw=
=Y5P4
-----END PGP SIGNATURE-----

--=-URf2ZbHM5gvP9g4/OfLL--

