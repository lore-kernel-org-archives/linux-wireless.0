Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:55463 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932580AbZLOWwt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 17:52:49 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath5k-devel] [PATCH 1/5] nl80211: Add new WIPHY attribute COVERAGE_CLASS
Date: Tue, 15 Dec 2009 23:52:42 +0100
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1260899813-17585-1-git-send-email-8an@praha12.net> <200912152156.48074.8an@praha12.net> <20091215215855.GC2067@tux>
In-Reply-To: <20091215215855.GC2067@tux>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3532694.1Pi1YPvS0B";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200912152352.45977.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3532694.1Pi1YPvS0B
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 15.12.2009 22:58 you wrote:
> I don't see how this makes sense. Are you saying if we have multiple
> interfaces you must restrict the slot_time, ack_timeout and CTS timeout a=
ll
> to the same values for all of them?
If you have multiple interfaces, they must be all on the same channel and y=
ou=20
can't do anything with it. It's the with slot time: it's a parameter of the=
=20
CSMA/CA method for medium sharing. When stations use a different value of=20
slot time, collisions will happen more likely. It doesn't matter they are=20
connected to different BSS, there's just one shared medium.

There is no such problem with ACK timeout, but there is still another one: =
you=20
can have packets coming from multiple interfaces in hardware queue. And you=
=20
can't change the register value before sending each one, because the hardwa=
re=20
sends them on their own terms and just reports it's done via an interrupt. =
So=20
effectively the ACK timeout has to be the same as well.

> I'd say expose it through debugfs first then instead of adding proper APIs
> for userspace. If the country IE is the way to pass this information alog
> to STAs there would be no need to tweak this on the user end. If you're an
> AP though you are likely going to want to change this though so I see, for
> example hostapd wanting to set this through nl80211. It also seems
> reasonable for IBSS but IBSS won't send country IEs unless I guess we use
> wpa_supplicant and somehow leverage the IE generation from hostapd.
The problem is, I don't know any hardware that really sends the coverage=20
class. There's a lot of hardware that allows setting only the ACK timeout,=
=20
like all the Ubiquity devices, Ovislink 5000 and so on. So the client=20
connecting to these devices will need to specify the coverage class manuall=
y.

When the coverage class is sent in beacons, it should take precedence over =
the=20
user-specified value, I'm not against that. It's just not relevant now, unt=
il=20
there's a hardware that sends it or until the hostap part is done. And I sa=
id=20
I want to do that, just not in this series, it's already problematic=20
enough...

And about the debugfs: originaly I thought i would just implement a simple=
=20
debugfs API for setting ACK/CTS timeout and slot time. However, Johannes Be=
rg=20
recommended me to do this coverage class thing and I didn't envision how mu=
ch=20
trouble it's gonna be...

Lukas Turek

--nextPart3532694.1Pi1YPvS0B
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLKBM9AAoJEEBjvk/UOfYw60gP/24W8nEzbPlMJVIhCD2+be+B
e418Of/5Qa1V98AfSKrNJHfhfC8/Jd0qjk8AHgD7bLO1ZBSjCv4dyHtVM60etCvv
EKLEIl5PO4wLWpHtVVuGdRBQYre9ZvARTFwDof7H/Qu2Ijvz8rdCeRMsFRGfN1aT
cSn6LEOmrlphntDg7Uui6PB+bCk8u6u3mAnsw+enyK7WNpkQwX+T7jvGB+JJD+NC
5ABvhtKcoZkd5Z6QfUHB5VZCJ+cqxmxkJXm+mATTip4Jv6v5zo2XX4qxktnKAiiM
39VxK1Po2BMK2BqoptGhUsenhOP1lXnrqom4FmfZqW1vPDUl7DdSmerNRAoSNdkk
UAlsO+S/buOobXMdjrYlT5otn/ZejacLLHUXLB8aoSQq/T25akKhg9l2j+LBB/TG
g6pqhO0KwkXJ8zh7N9HLfrFfFRH6H7xh8WA0WeYh/ObtwmYsJlCwHCCwulNG9ApD
r22I5W6aV9p1zzxdffxEXDl0IT+fb1nmDRNvAgH3ZU0oB77umKVp2Vy4ObuQKBUC
+ZixSFXiAnH0eqPrVsLW2kYdej3IZtPkyacJSkVnEJqNgFQ2illalLO6K3a+ZSad
qUvGhxChV9v0mURMUgpqYwhBZN7hQp7d2UM5xB+y1m21ea0YBA3TkFq7BFn5FH54
Rvu6/NIfHGvjwKl1D8rN
=2B2W
-----END PGP SIGNATURE-----

--nextPart3532694.1Pi1YPvS0B--
