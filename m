Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50394 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbYEFJ5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 05:57:32 -0400
Subject: Re: [Rt2400-devel] rt2500usb current git BUG
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Luis Correia <luis.f.correia@gmail.com>,
	rt2400-devel@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <a32f33a40805060249s2e20455fk88825329386b7475@mail.gmail.com> (sfid-20080506_114818_275791_199DF463)
References: <efe7343f0804291454p40914cadpf06846270d080e2@mail.gmail.com>
	 <a32f33a40805060206l1af71db0tced88dd3d3d08c30@mail.gmail.com>
	 <1210066571.8012.73.camel@johannes.berg>
	 <a32f33a40805060249s2e20455fk88825329386b7475@mail.gmail.com>
	 (sfid-20080506_114818_275791_199DF463)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-av0rlY9eP/N4wLV3ofd0"
Date: Tue, 06 May 2008 11:56:50 +0200
Message-Id: <1210067810.8012.80.camel@johannes.berg> (sfid-20080506_115645_663089_B7B87CCD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-av0rlY9eP/N4wLV3ofd0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> But hadn't you removed the RTNL locking to make the multi-BSS code easier=
?

Well, yes, but that applies mostly to mac80211's internal BSS/interface
list handling. We still use the RTNL for list updates so iterating the
list holding the RTNL is the way to go if you need schedulable access.

> I think I can code around the problem to make the ERP configuration do
> a simple check if any interface has short preamble, and if that is the
> case all interfaces will have short preamble. The same would go for
> short slot time.
> Apparently the current code was broken in that respect anyway since it
> would assume the timing of the last interface in the list.

I think that's not going to currently happen at all since we have no API
for hostapd to set short slot/preamble at all! :) And this sort of
complication is why we have no such setting, some hardware like b43 is
able to set short preamble per frame (!) so there the setting could be
per BSS, but hostapd would have to know.

> As for the beaconing, the only location I cannot get around updating
> the beacon in the driver from scheduled context is in the
> suspend/resume path. And I believe resuming a mac80211 network
> interface is already a source of problems anyway...
> Well I'll dive a bit deeper into this and see what can be done about this=
.

Feel free to add an iterator to mac80211 that uses the rtnl if that
helps, adding more code to workaround the fact that it doesn't exist
doesn't seem too hot since this was exactly added for that reason (and I
think you're the only user of that iterator...)

johannes

--=-av0rlY9eP/N4wLV3ofd0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCArYaVg1VMiehFYAQLaUA//a2OH5jDZPkIOhGb/y0tYK+PS5uN3Xtg7
eI50aEVb2UNrD4Ni5gr9XWVNaRJ4+huF4WzAaW06JP8Ir0H9r7wb8aA1cgGC0Rgu
m4BRikZAmHnfsR+KDiEMJYvCbzrMmAAPkQcDn2H3N7pPMVmdoN/mj6WXwJ23NXgn
OsIXE9rzkPnBhDBJj90NHHdaSFCrc3VI1LS+hyv1eBvplxDNtI/W61Lh6cNbjfHN
Ewf1umO+zm9UwGC5N53SnZRXOBvEGG4P0Vo3usUtjHh5JAeRjVeNaIjhaKz76TH9
AoCuZmK66SZjVu4t2nHRakWwWsm9KAa9//dIf1HZU5QmijbsfrlAcJVLwQ/yjZrU
oO2RLgjERSXTV1tpb1+rTL8VGDleiPeyRpqVMwM8uh7TQXLDWKzp0KwJBtNomaep
JZTwPtNFV1qHm4Lk1ep3ZF2HFamWPbgJaKLq9wDjcMOY5cPtvqTfX4QmnIqkUBET
9MKYSDe5vxUgNWLp5gPsFfLy/gpIwWVP4aMVYGbCpeigQrMDh31ql69z6j+ATdsT
LRqStkv1AftB9laEX+0+mvkx+I14AzlOW4Fwc7QW4qLGw8/nYK1kGxWyimn73EBB
87KaMgwme9VoK7fzvJoaVViCKCKquUeOFNIuO+TeGKg6cCmQzEeQtPM0nDZ/Zi1u
5S5E7o2c1EA=
=R+AA
-----END PGP SIGNATURE-----

--=-av0rlY9eP/N4wLV3ofd0--

