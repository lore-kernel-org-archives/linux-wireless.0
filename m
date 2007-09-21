Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46228 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbXIUPQr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2007 11:16:47 -0400
Subject: promisc interface behaviour, matching frames to interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>, Michael Wu <flamingice@sourmilk.net>,
	Jiri Benc <jbenc@suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NSIZRS9GLreZo0FkNtPW"
Date: Fri, 21 Sep 2007 17:18:00 +0200
Message-Id: <1190387880.18521.150.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NSIZRS9GLreZo0FkNtPW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hey,

Thinking more about how to match frames to interfaces, I'm a bit worried
about promisc behaviour.

Currently, we have code for one dubious optimisation: if the sender is
known, not a WDS peer or an AP we're associated to, the frame is not
multicast and we don't have promisc interfaces, we push the frame to the
interface  the sender is associated to assuming that we're actually the
right destination. I believe that last part is simply wrong, shouldn't
we at least check the RA?

In any case, I think that it's also not as good as it could be. It only
seems to catch STAs that are associated to us as an AP, but then why
the !promisc check?

However, when thinking about how to improve (see also my previous mail),
I noticed that there's no clear definition of how promisc should work.
In the STA/IBSS case it's not too bad: see frames from the same BSS but
not necessarily addressed to us. But what about an AP/VLAN interface? Or
WDS? I tend to think that for those, promisc makes no sense at all,
which is sort of what is implemented today. Anybody have a differing
opinion?

Once we have that sorted out, let's take a step back and see what sort
of frames we can get, here's a table:

ToDS    FromDS  A1(RA)  A2(TA)  A3      A4      Use
---------------------------------------------------
0       0      DA      SA      BSSID   -       IBSS and DLS
0       1      DA      BSSID   SA      -       AP -> STA
1       0      BSSID   SA      DA      -       AP <- STA
1       1      RA      TA      DA      SA      unspecified (WDS)

Now, the easiest way to do good matching from frames to interfaces seems
to look like this:

First handle the IBSS interface (if present) [1] by checking whether the
frame is an IBSS frame destined to us with the right BSSID and adding
the transmitter to the station table.

Secondly, iterate over all [2] known sta_info structures with matching
TA. The device they belong to is most likely the right device, but you
need to consider the DS bits.

Except for the scanning problem mentioned earlier which I believe I can
fix with some cleanups, this still has the problem that promisc stops
working.

I suppose the real question is: is promisc really useful on an 802.3
framed interface? Personally, I always use monitor interfaces and then
also get to see the right frames if it wasn't encrypted (or WEP,
wireshark can decrypt WEP.)

johannes

[1] we can really only allow one IBSS interface on a single hardware
because they could try to be in the same BSS and that leads to trouble

[2] technically, this requires my patch to make sta_info structures
per-interface, but unless you need corner cases it works fine right now
as well, only you iterate over a single one


--=-NSIZRS9GLreZo0FkNtPW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG8+Co/ETPhpq3jKURAp8RAKCPPtWLztB5ZwtNgGh+paJIA0gmlACdFxIs
hcb5oOR0JOKiSOD7XFxVP1o=
=CZM3
-----END PGP SIGNATURE-----

--=-NSIZRS9GLreZo0FkNtPW--

