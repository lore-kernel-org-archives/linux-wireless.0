Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:33560 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbbGVC7X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 22:59:23 -0400
Received: by obdeg2 with SMTP id eg2so30970864obd.0
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2015 19:59:22 -0700 (PDT)
From: Taahir Ahmed <ahmed.taahir@gmail.com>
To: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Reply-To: ahmed.taahir@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] Support python 3 in utils/key2pub.py.
Date: Tue, 21 Jul 2015 21:59:16 -0500
Message-ID: <2988720.J8nzy94PWW@basis> (sfid-20150722_045926_128490_BE88842D)
In-Reply-To: <20150722045045.30642c25@mir>
References: <1437525466-27512-1-git-send-email-ahmed.taahir@gmail.com> <1437525466-27512-2-git-send-email-ahmed.taahir@gmail.com> <20150722045045.30642c25@mir>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart9803875.RJTeOcanib"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart9803875.RJTeOcanib
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Wednesday 22 July 2015 04:50:45 Stefan Lippers-Hollmann wrote:
> You omit $(pwd) from ./utils/key2pub.py, while /utils/key2pub.py
> won't exist.

Wow, that's a really bad mistake on my part.  It should indeed probably
be './utils/key2pub.py'.  I made this change after my general testing,
simply because emacs was undoing the execute bit every time I saved
key2pub.py.

It's not really a material change, so I'll probably just put it back the
way it was.

The rest of the patch is tested, I pinky-swear :)
 
> As little as I know about python packaging policies in Debian
> (and probably Fedora), /usr/bin/python is never supposed to point
> to python3 - afaik the interpreter should always be called python3
> there, so I don't really see how that's going to work there.

I'm not assuming that the system interpreter is any particular version:
key2pub.py has been modified so it runs under either 2.7 or 3.x.

Some more simplification might be possible if 2.7 support is dropped,
but not much, and I didn't want to rock the boat.

Thanks for the prompt review!

Taahir

--nextPart9803875.RJTeOcanib
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABAgAGBQJVrwcJAAoJEP0dGB2mOaLGRngIAIeswxfwlLWr7lGkozTftZ2d
0DeEaS//7PL8MUudWBa6VGEUXUQLmw9cP8/Og5forCBH0E9XuAJ0dfUMKLfHzDp/
fpHPu8Aplpn1ztR4fXNGGLl6yK35vDzyFBXyU837EHnTYV1Ht1GTZYP2A2jSC3DX
pMNpq5ACEpLFtSzw3ELNCE/IUYTAU4C1XQXak5wnIXcJdLDj2njue2tGh/aTGv7u
r2wpo+nwN6vZTErGo/nrSPf01/nEiul7ftSVeRblfplsLtDxNTkTdPltsOKWyo96
RgdknTL6hF5JPfoyDwHoJg+MDdBlMdE5g6hOr6x3h8YoR1q2ZbifM3MYq3M12Io=
=1kYc
-----END PGP SIGNATURE-----

--nextPart9803875.RJTeOcanib--

