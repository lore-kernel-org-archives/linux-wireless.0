Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44292 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762903AbXHCWMb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 18:12:31 -0400
Received: from [84.135.224.6] (helo=[10.0.0.4])
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1IH5Nl-0006th-9F
	for linux-wireless@vger.kernel.org; Fri, 03 Aug 2007 23:12:30 +0100
Subject: further plan wrt. monitor interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-p5+nBdMxneF2Lg0PY7lz"
Date: Sat, 04 Aug 2007 00:09:19 +0200
Message-Id: <1186178959.13315.30.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-p5+nBdMxneF2Lg0PY7lz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

After my recent patch drivers can now tell the stack that a frame was
damaged. That doesn't do much good, however, if the user cannot tell the
stack to generate such frames. But we need to go level by level so first
mac80211 needs to know about it.

After some discussion and review of Daniel's document (thanks!) we came
up with the following ideas:

1)
Define new filter flags
 * FIF_PROMISC_IN_BSS	(BSS filters still on, but otherwise promisc)
 * FIF_ALLMULTI		(all multicast frames are allowed through)
 * FIF_BROADCAST	(broadcast frames are allowed through)
 * FIF_FCSFAIL		(frames with bad FCS are allowed through)
 * FIF_PLCPFAIL		(frames with bad PLCP checksum are allowed through)
 * FIF_CONTROL		(control frames are shown)
 * FIF_OTHER_BSS	(frames from other BSSes are shown, subject to the
			 other filters)
[missing anything?]

It should be permitted to silently 'upgrade', say if a driver can't
support PROMISC_IN_BSS but only get all packets then it does that
instead, but PROMISC_IN_BSS is still useful if possible.

2)
Remove IEEE80211_HW_MONITOR_DURING_OPER, it becomes useless; same with
soft monitor mode interface stuff

3)
When a monitor interface is added, set FIF_OTHER_BSS and FIF_CONTROL;
depending on the interface flags set FIF_PROMISC_IN_BSS, FIF_MCAST,
FIF_BCAST. No longer tell drivers about monitor interfaces with
add_interface/remove_interface, but rather call set_multicast_list()
with changed flags when a monitor interface comes on.

4)
Change the "int flags" argument to the set_multicast_list callback to
"int *flags" so drivers can indicate whether they supported a flag or
not by clearing all flags they did not honour. Additional advantage:
drivers break and people will be forced to re-examine their code to use
the new flags.

5) [FUTURE]
Introduce cfg80211/nl80211 API to ask for bad FCS/bad PLCP on a monitor
interface.

johannes

--=-p5+nBdMxneF2Lg0PY7lz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGs6eP/ETPhpq3jKURAvxrAKCUAopa3tZ7HX6xoJMxybgSEOiTCwCgh4ww
M7W6Ls38jytMyfqwCux1wK0=
=pQ08
-----END PGP SIGNATURE-----

--=-p5+nBdMxneF2Lg0PY7lz--

