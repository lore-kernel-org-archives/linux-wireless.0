Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:43425 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933828AbZLFTAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 14:00:21 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 4/4] ath5k: Implement mac80211 callback set_coverage
Date: Sun, 6 Dec 2009 20:00:26 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org
References: <200912061820.26320.8an@praha12.net> <200912061826.52394.8an@praha12.net> <4B1BF952.1000909@openwrt.org>
In-Reply-To: <4B1BF952.1000909@openwrt.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2874632.cJ9ci6KSje";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200912062000.26851.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2874632.cJ9ci6KSje
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 6.12.2009 19:34 Felix Fietkau wrote:
> This part is wrong. The slot time can be either short or long, based on
> configuration and PHY type.
I did some test, and the value returned by ath5k_hw_get_slot_time was alway=
s=20
9, even when connected to 802.11b-only AP. I didn't try the turbo mode,=20
though. Unfortunately I don't know how to calculate ACK timeouts for
a different slot time - the formula I used is the only one in both Madwifi'=
s=20
and FreeBSD's athctrl.

Also the calculation of initial slot time is not expained anywhere, there a=
re=20
only some magic values in initvals.c.

Lukas Turek

--nextPart2874632.cJ9ci6KSje
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIbBAABAgAGBQJLG/9KAAoJEEBjvk/UOfYwfRoP9RVHVmcFjvAlpiuSnSeZolCf
JiOEgUq3/6P25CZMC4lIx8/Z8ah3WE4s+7x8lHrSvr52K2wdpKx+UkYdVP6iZfCG
j8KzQstOv+4ONSZbbZMkSwZjoSGqmA2mD8SFVAPl6zvOJTGSqgGO6VoJeep9c9b6
fnTOS6FFDkb7OORuEzukI9aRTiyp7C8f4iD+LaG/D34iPQPWwVa6ycJeX8Wh50Jd
DekM+JOvh2SnjNS1TzyZ/eBqN6JngVZ4KixMaxM/6MXlWdP1rQ5+CWwUd+AhJ9aO
4XodjKxfEme0JR537byWV4ycaKAJZy2GDcPqY2LIv5+VMQuj1ZZp2VCI26weo8Da
P82g9OeHkirVS5NfQcyqj5zQg1Y+lupblTyf7fSv5c+IOTHSDgivgOo+ECvQ0170
yd5yEi458MAEYIeAKbTSQ+azRWJEM0nQzanttIMZHDgD4cfMTRAoeuKeCjGKuGVk
pcjs3fjdl7Lg9oR6rqFb1t8RnwTTe25eeOVeU3m1taNYDevPBzSADyAYJ18SKxdq
HuJ7cCAxXIPtK9555JkXOXMSZFNpH+uGTHMAY6wsXEdkHxCteUGYDfSakEm7yJKR
l0VvsOYRs0BzCuh/kcFmDLHkWrq5o58DjD5SpH8mncI6BotBqOyKTgdAU/PZs2a1
IwH++zAwbhetcUZRMzg=
=YDmK
-----END PGP SIGNATURE-----

--nextPart2874632.cJ9ci6KSje--
