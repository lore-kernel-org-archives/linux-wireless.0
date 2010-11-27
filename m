Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.108.102.1]:35949 "EHLO parez.praha12.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376Ab0K0CF3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 21:05:29 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
To: ath5k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] [PATCH 16/30] ath5k: Set all IFS intervals, not just slot time
Date: Sat, 27 Nov 2010 02:57:03 +0100
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	Jonathan Guerin <jonathan@guerin.id.au>, jirislaby@gmail.com,
	br1@einfach.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
References: <20101123191533.GP4303@makis.mantri> <AANLkTi=QquDgSAYn4HS+vupdNUTNSngt03ZKuakYu6Fd@mail.gmail.com> <AANLkTinC4-N7ACt4_ijTi2rs8TtQkARR1-vcaiSSaH3O@mail.gmail.com>
In-Reply-To: <AANLkTinC4-N7ACt4_ijTi2rs8TtQkARR1-vcaiSSaH3O@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1909943.0cZLHAi8uD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201011270257.09456.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1909943.0cZLHAi8uD
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 27 November 2010 02:31:53 Nick Kossifidis wrote:
> When we convert to core clock units it's what we should do, all
> timings should change the same way. I don't know what this
> aPHY-RX-START-Delay is but if it changes that way we can use absolute
> values as we do for slot time and sifs.

Although aPHY-RX-START-Delay is specified in the standard, it's not needed =
on=20
Atheros hardware, probably the hardware starts the timeout countdown after =
it=20
switches to RX mode (so aPHY-RX-START-Delay is added implicitly). See my=20
discussion with Felix Fietkau a year ago, starting here:
http://www.mail-archive.com/ath5k-devel@lists.ath5k.org/msg02810.html

The calculation used in set_coverage_class is also the same as the one in=20
Madwifi driver. When I wrote that code, I intentionally kept the old initva=
ls=20
when no coverage class was set to prevent regressions (the ACK timeout in=20
initivals is larger than the one for coverage class 0, so a long distance l=
ink=20
that worked before would break). Maybe I was too careful.

Lukas Turek

--nextPart1909943.0cZLHAi8uD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQIcBAABAgAGBQJM8GV1AAoJEEBjvk/UOfYwAosP/jYes1+GUdqUOG3zu9S7uVFe
JSO5dgDFHN+f7joWIsJ8mYy7oRwdKQ4elp9mRK4x6cGSaoQ15hOZQX4LGY4CWRke
d2emc6fuos7nEHhOBvi7Xk7eYiWV7HLb5GUy4gfTqAIzMjPFQrtyEC+wjArMIVGQ
6ykoE9lbjfC9ejFtmgSIqmuBdv5jCP3fVVtsrLH62hE8E9bXogaYATJ2FBj0GP4F
J8uwPC47EI9xH9m7UpQQugrfxuhCZ5VGiLk7kxxtxFo1Vx5zLXCj8dIfYqCrgndu
EtQctbdSOAoRDhzEmEyXhkr3qULc3BqF8trAinFIBDCMspMpSDys2yt+LXEFHib5
YK5UkGENeUG5e6D2qC3bd8BqBHc/6DOuTFoA0eZ6hZlGvBGadq6FMlJ4mFF39uaa
KBMtOU5GHk2Gh4QPaQRH0oyBzlUXLWiNn7BfLuoby7TMXyQChgIrBd+hWuAz5hjB
lqLuwTcFU7VrVnvNM63RiSpVNEwOsxMIl4qbK1lMUSsikw6cdgx1XhfeZt50li5/
gJxbhzI/cOlaKr8ZC0V4E7LS7eu1/HcuH+Noz9wR951uINyHVqMc73NLIRiBUz9N
PJ0JUETH7XIJCj588bVNtebekI+0Z5phSl8gfJyi1vYsIBRpwE33doa2lxjpyFDT
1tayYv2b/2V564UIabRM
=SwZf
-----END PGP SIGNATURE-----

--nextPart1909943.0cZLHAi8uD--
