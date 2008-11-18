Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57424 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbYKRXZo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2008 18:25:44 -0500
Subject: Re: mac80211 MLME and user space
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Johnson <johnsonzjo@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <147a89290811181216i66a5a22cv77e6d06180b7b312@mail.gmail.com> (sfid-20081118_211653_660920_9AC85271)
References: <147a89290811181216i66a5a22cv77e6d06180b7b312@mail.gmail.com>
	 (sfid-20081118_211653_660920_9AC85271)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FpCtY1yplDkeqY/f/+HD"
Date: Wed, 19 Nov 2008 00:25:07 +0100
Message-Id: <1227050707.4014.82.camel@johannes.berg> (sfid-20081119_002546_847530_BF9D33AF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FpCtY1yplDkeqY/f/+HD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[disclosure: I just got back home from debating club :)]

> My question is : why?

Let me first ask the opposite question: What value do you see in moving
more of the MLME, especially in AP mode, into the kernel? [1]

One of the most important arguments for putting the MLME into userspace
is "because we can". Remember that developing userspace code is much
simpler than kernel code, there's often no need to care about SMP
scenarios [2], memory allocations and stack size limitations etc.

Another important argument is that having this code in userspace makes
it a lot more replaceable, and allows experimentation with it. Consider,
for instance, new 802.11 working groups like 802.11r. Fast roaming,
specified by 802.11r, could, if we had the station MLME entirely in
userspace already, be implemented entirely in userspace. In fact, it is
(being) implemented there for experimentation. This is great for
multiple reasons: One, for the developer, it is much easier to test new
code in userspace, and if it crashes they can just go on working rather
than needing to reboot the test machine. Secondly, it allows deploying
that code to users much faster as it is almost always much easier to
replace a single userspace program than to replace the entire OS kernel.

Also, keeping things in userspace means that there can be competition in
that field. You can fork hostapd and use your own version for special
things without going to the hassle of patching the kernel every time. Of
course, right now the APIs are not entirely stable, but that would still
be much easier to follow.

johannes


[1] I don't buy the argument that this makes it magically more stable,
and yes, I've heard that before

[2] kernel code must consider SMP in almost all cases, while userspace
code can be written as a single thread

--=-FpCtY1yplDkeqY/f/+HD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJI07QAAoJEKVg1VMiehFYRwkP/3iSUJ0flniTDkbeGqJh/1Fn
q42eWeRhATYzXp18ZdWd8zsyuh3mXrQiiC6uqw6Cujg4bXm3Nxerbl8GomsGvxCW
lbRoxGROESDDW3W5H7YdIEwaUUvT74hiKrV5umX5obb9Xezzwq3g+nHaSPzlMrK6
i0N3IZYbDgV351MzEitwK+b8UfMw6rt3korXNihAK6EDZ6M4AK5FZNRIaDBfU9ix
6vVJWYOvFztbYRuAdBULR+nRLYGpZaxL8OqHQKOLHyQthwdwnQBegwJmjzI2GL6/
d6a1Q+ZGm0sChc3c6+HQe3KzCXj8I8uuRBsW1J4SCCOOYh8MxJlALtVGvIOTaceb
ORyGt2/q9yz0H6RETWTWjYNwoG+g8xBbNIGITHuIhkmN4lXxBjquMBQBCtwXWpgV
i698/nPoCkqqxVlZ1vsEywsg+SGka9k9VMs3DsPj4oeJZ45lG1Mt/Ti71n5QwQ0e
nF50qHaD3ykaiddPW1ep9kk98g8+cU+mfZTKgzQdyzEmLVnA44oH4tK5jha4D+fN
N96pgP/hCINLI26we3a7ajym0AeVl5nyaA5/puY1kYlqgw1MR/2pEtuWpFyQTCNk
Kp3TTrn4yZYZk20lxuzP3ACpgC9Z2hTAAwlRUxjNw1ayTuaJmOAl1ulwQulbhrhp
nlR+whVo3gtaMyB51TKP
=h9Qi
-----END PGP SIGNATURE-----

--=-FpCtY1yplDkeqY/f/+HD--

