Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60822 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYAXO6l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 09:58:41 -0500
Subject: Re: Kernel Panic in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <47983B31.4020304@lwfinger.net>
References: <47983B31.4020304@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ly0qVG7OdbX4xRK6EDbX"
Date: Thu, 24 Jan 2008 15:33:55 +0100
Message-Id: <1201185235.3454.93.camel@johannes.berg> (sfid-20080124_145844_253019_46EA66AD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ly0qVG7OdbX4xRK6EDbX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-01-24 at 00:16 -0700, Larry Finger wrote:
> I have been having "random" kernel panics where the "Caps Lock" LED is fl=
ashing at ~1 Hz. These=20
> crashes only occur for the wireless-2.6 tree and have been happening for =
roughly 3 weeks. After=20
> running a memory test to ensure that these panics were not caused by a ha=
rdware problem, I enabled=20
> netconsole logging and caught the following crash report for my x86_64 sy=
stem:

> Code: f6 44 02 08 10 74 12 45 85 ed 78 05 44 39 e9 7f 08 89 8f 24
> RIP  [<ffffffff88202940>] :mac80211:rate_control_pid_tx_status+0x426/0x45=
a
>   RSP <ffff810059b77dd0>
> CR2: ffffffff88246288
> ---[ end trace 638a30c2fdaf8180 ]---
> Kernel panic - not syncing: Aiee, killing interrupt handler!
>=20
> I have not yet figured out which instruction is found at mac80211:rate_co=
ntrol_pid_tx_status+0x426,=20
> but I will continue to work on it. I wanted to get this report filed so t=
hat the problem can be=20
> found before 2.6.25-rcX comes out.

Damn, I've seen that too but blamed it on my own patching. Stefano, any
idea? IIRC some sta struct was NULL in pid_tx_status.

johannes

--=-Ly0qVG7OdbX4xRK6EDbX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR5ih0qVg1VMiehFYAQLfdw//flfxls7uQe+HcA+6UAn31ZCDyDAm7qfR
K69WruMSM0BpwGnH9D+HF4le8kkuLbr+cAYk2Xk3jljMqIQjLiXn0RtwpOyitrTF
WTeHWAnmeZSH8fRy70MihEzOzaF6zGhmkC8ojo1+uliu83eZTeBzAXAsspUJyqqc
O3+K7uAJzPFlTUsuBVZPZGfccVm7aoNW7KJLs9KHJa52uRVdi/QoFP1C1bzrBBRC
kFkudQdDs1EQGLM2FMhuvJF+HqMbRS7m/avzIYhXqvKnpTYFGN4X63RQBMYbNHOU
hcIk9IP87qaPiCLRU0njpYOX4804xjm9n48eTbkTNxp18L3iMTBNQedSSuBAJij8
oqpCgHpIYDsXGpa8xhX+KpORFZFPwHfFAy2xVKlDTcoFAfKX0BMHAFuUgC8Gs+J0
ZjmWurNOl9CtVQbw9Szu/ABrRSrkKXk0whCNEwmvVXOK84iHNZTiQu0ujIWXYx4F
d0mBHoEVALyQT//tiWDAG1UEU5GbNHeSUoHKwOXg1uLvut27kXdSEh87+bETDyYS
nE43JZncmxglPfZ4oFqUuGUw0pSVtFyDsrDuVxNroIZ2FI9CTG8T9JpGZ+JqgYwv
rlkZ90KBK9mFCO3xCvM/ud7jNdwb7lTgasxVHNJahF0bdxko9k3V24cvFGfXhwM6
Zh0Zc0vZVr8=
=CLnl
-----END PGP SIGNATURE-----

--=-Ly0qVG7OdbX4xRK6EDbX--

