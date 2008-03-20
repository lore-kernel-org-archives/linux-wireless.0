Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:47195 "EHLO element.ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbYCTMnX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2008 08:43:23 -0400
Message-ID: <47E25BBB.50304@work.ksp.sk> (sfid-20080320_124338_240100_71A87504)
Date: Thu, 20 Mar 2008 13:42:35 +0100
From: Vladimir Koutny <vlado@work.ksp.sk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Vladimir Koutny <vlado@ksp.sk>
Subject: mac80211: stale BSS info in sta_bss_list
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF3A6ECA8B69BE009C93341F2"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF3A6ECA8B69BE009C93341F2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,
I've just hit the '/* TODO: remove expired BSSes */' issue, which
normally isn't visible that much:

-- usecase:
My HW I'm working on doesn't really behave, and it can't tx anything
unless it is associated to an AP. So, it can't send probe requests, just
listen to beacons initially. Except for worse scan results, not really
an issue.

Now, since sta_bss_list is never cleaned up, once I do a proper active sc=
an,
entries for BSSes found will get bss->probe_resp flag set. If I bring the=

interface down and back up (ie, can't send out probe request once again),=

I'm not able to scan (or join) any of those networks, since we prefer
stored probe response info to that of beacons (ieee80211_rx_bss_info;
bss->last_update won't be updated on beacon either). And finally,
ieee80211_sta_scan_result will skip expired BSSes, so even it can receive=

beacons for such networks, they won't be reported back to the user.
-- end of usecase


So, my question is whether this is being worked on (didn't find any note
on this), and if not, what would be the best place to put this to? (I'm n=
ot
that familiar with mac80211 internals, so any input on this is kindly
welcome).

In my case, clearing the list on ifdown/up would help, but periodic
cleanup would be better, so I'd better go that way (or maybe both).
Then, having bss->last_update being updated also by beacons might be a
good idea, otherwise we would expire probed networks, right?


Thanks,
  Vlado


--------------enigF3A6ECA8B69BE009C93341F2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQCVAwUBR+Jbw7rYBI/WS7s0AQLEBAQAtR03++me1oJg8B/drMB8TfWS9tHgQfJB
cXlcFMXKndTDFIgpilQg3NE4MF3uwxIKYBuSdbD1Uog55ZP6U1voe1Fq7GVff3Pa
bq2tQ8ILS7zVtEincdVgEFvK4xaihBgiM/1SRuEd7B+iieycavwzAE2zJusqbO36
iT3IR39W1Gc=
=l/nK
-----END PGP SIGNATURE-----

--------------enigF3A6ECA8B69BE009C93341F2--
