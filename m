Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35680 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbXL2L7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Dec 2007 06:59:44 -0500
Subject: Re: Warning emited by 2.6.24-rc6-git5
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: chris2553@googlemail.com, linux-wireless@vger.kernel.org
In-Reply-To: <200712291247.54258.IvDoorn@gmail.com> (sfid-20071229_114741_608186_9052827A)
References: <200712290942.37396.chris2553@googlemail.com>
	 <200712291121.31120.IvDoorn@gmail.com>
	 <1198924603.4172.34.camel@johannes.berg>
	 <200712291247.54258.IvDoorn@gmail.com>
	 (sfid-20071229_114741_608186_9052827A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jhWWtJw60xh/wxDiabPR"
Date: Sat, 29 Dec 2007 12:59:28 +0100
Message-Id: <1198929568.4172.37.camel@johannes.berg> (sfid-20071229_115956_865583_DD21EB42)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jhWWtJw60xh/wxDiabPR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> but since the payload should be aligned to a 4 byte boundrary anyway

That's not true. The "payload" in terms of "802.11 frame" shouldn't be
aligned on a four-byte boundary for QoS or 4-addr frames.

> can't predict what header length the frame will contain. :(

Well, good hardware inserts padding, cf.
http://bcm-v4.sipsolutions.net/802.11/RX

> Although it would safe the initial allocation of the DMA buffer...
> I'll look into it to see if it would be useful.

More importantly, it'd save you the copy if your hardware is decent and
inserts two bytes padding for QoS/WDS frames.

johannes

--=-jhWWtJw60xh/wxDiabPR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3Y2n6Vg1VMiehFYAQJ2gw//XVIQyvAs3Xni8YmIhpdknQd7w5CyU0cu
yEXPUVT4+ZKKs8naMSkvsti9d39p4xHaQFqWFOmhd1bBkATeqK8BOGurKYoAhv6B
4QrfV2eNlekRutonb1q4rJoKY1eklBveLmwHzbB8e71DVNN4lWLxLFk5PwCRxctf
HEtf8sLHuLw3RjrULJSaY/HhgcA6ONKrMT53ArHdapmmisXQxBDL6d1zFNsysk0P
qSZZplDgK0gxkki/uEPD43c0CyDNnzqi3uj1mVhSVjDi2AXBcbe67vQDp/R8Lc57
DKxIz4ERUNJZUTmamaHQoS6nVYRITt2zZq9yVZfrnspJhyA6dWiEK+oFxWoXPvkD
1cSLBwkkYb/L8GzpSzmd8gWMjmdKEvEUk1EQbCK0YVES7UTOSMXRbIID3RmpFe1X
5Kqstfu69iJCGenHt1JAsUekrEo221BWOFDLKYa7lnYF21MytgKma6CXvwaJlvYA
iBURARSBLsNa/5rpcUKaQiIdYI/+ln3fztVpPN1WFTTo4ClvgteVYL/ugJV/YOmp
Ucf3xp+fw+989HkyIRDlOU+nZnkToHYKNT0uhgEoF2kQ8O9F9v6yVbxjW/DGVEKo
udJf/tt194kRFIgCbjd2FrHLeVIJKDmVE9Pof9ZhYzK351OfMQ+KfzCZY16jO9Hx
4MUCu0kr5ng=
=7ppD
-----END PGP SIGNATURE-----

--=-jhWWtJw60xh/wxDiabPR--

