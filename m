Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:32846 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758018AbXIUOfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2007 10:35:36 -0400
Subject: scanning implementation and sta matching
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Michael Wu <flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FIdhOM4EvFwgjFqRimoj"
Date: Fri, 21 Sep 2007 01:20:46 +0200
Message-Id: <1190330446.18521.120.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FIdhOM4EvFwgjFqRimoj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Looking at the code for scanning, it seems overly complicated. In fact,
I actually broke scanning and associating, but more on that later.

As for scanning, is there any reason we do it per-interface? After all,
we deny a second scan attempt on another interface when one is in
progress, and it seems not very useful to queue the frames to all the
different devices. I think we should be able to split off scanning from
the mlme implementation and I think we could benefit from that if only
because it reduces complexity of the mlme code.

Basically, I'm thinking of directing all beacons and probe responses to
some scanning queue while scanning (and probably drop all other frames)
and handle it centrally. When not scanning, of course the MLME needs to
get them to eventually be able to implement "beacon miss" etc. Do you
see any problems with that?

The other thing, why I broke it, is that I noticed that when we have
many interfaces (say VLANs) then we can end up copying frames *a lot*.
So I have patches to
 (1) make sta_info structs per-sub-if for corner cases
 (2) iterate all sta_info structs when we receive a frame from a certain
     station (instead of iterating the interfaces)

There's still a change in behaviour with this: previously we'd see
frames other stations in our BSS transmitted if (and only if) they were
clear/WEP encrypted and we were in promisc mode. By matching on the TA
we lose that, you'll only see those frames on monitors.

Maybe in some cases (toDS and "no DS bits" frames or so?) we should
match on the BSSID instead of the TA. I need to think about that more,
but it would fix that problem. WDS frames are easy, but fromDS/toDS
differ when we are an AP or a client which is a bit harder to handle.

In any case, this is how I broke scanning, we know nothing about the
stations we're scanning so the frames are directed to no interface. And
thus I came to look at the scanning code and think it would be
advantageous to separate it out from the rest of the MLME.

The other change that my approach above would require is that we add a
sta_info struct for the AP we're trying to associate to *before* sending
the first auth request frame. I don't see any problem with that but
maybe I'm missing something? wpa_supplicant as userspace MLME wouldn't
have such a requirement of course since it would use the "junk frame"
device as well.

johannes

--=-FIdhOM4EvFwgjFqRimoj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG8wBO/ETPhpq3jKURAi5NAJ9aiJbavVoXZcWr/Bk6rShKNeTe+wCeKwrN
VmM0SQ3o4DSx+Rnr2UsqmUc=
=DOBu
-----END PGP SIGNATURE-----

--=-FIdhOM4EvFwgjFqRimoj--

