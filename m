Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:52399 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2LWQoM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2012 11:44:12 -0500
Date: Sun, 23 Dec 2012 11:44:09 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Bartosz Markowski <markowski.bartosz@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: Re: [PATCH 06/17] cw1200: Mini-AP implementation
Message-ID: <20121223164408.GA3624@shaftnet.org> (sfid-20121223_174417_308414_597C8FFF)
References: <1356191120-5280-1-git-send-email-pizza@shaftnet.org>
 <1356191120-5280-7-git-send-email-pizza@shaftnet.org>
 <50D61117.8020009@gmail.com>
 <CAM8CFPgJu5CR9tU_mMw1_0yDUEj-dLk2G+6W91W1-H4LMa+BUw@mail.gmail.com>
 <20121223124734.GB29607@shaftnet.org>
 <CAM8CFPj==UdTjCe0=hPRtT_BC1E4TvRFDjqBZUD4=c+PbkncVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
In-Reply-To: <CAM8CFPj==UdTjCe0=hPRtT_BC1E4TvRFDjqBZUD4=c+PbkncVA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 23, 2012 at 04:49:05PM +0100, Bartosz Markowski wrote:
> Are you using this bss loss evt subscription? It was under STE_EXTENSIONS
> if I good remember. This is part of STE CQM design. But answering to the
> question FW should not spam with loss/regained events like that and if I
> good remember (I do not work with this for more than 6 months now) this
> behave quite well those days. I do not know lmac internals however , Ive
> used to work with the driver only.

This "spamming" isn't a problem using the GPL driver thanks to its=20
hysterisis and delays.

=46rom my own investigations into the LMAC sources, that event is=20
triggered by an internal LMAC timer if it hasn't received a beacon at=20
all in that time.  Disabling powersave operation makes the problem go=20
away entirely, so I suspect what's happening is that the LMAC is=20
consistently waking up a little too late (or going back to sleep too=20
early) to hear the beacons.

My guess is that the LMAC is pushing its powersaving margins too close.

> Btw. how old is the fw bin you have?

I'm using WSM395 currently, dated June 18 2012.  (It fixed a problem=20
that a client of ours observed with WSM392 and WSM385; the LMAC would=20
lock up on noisy environments when block acks were in use)

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFQ1zTYPuLgii2759ARAiwIAJ9glSBkmPflaSxKPs25SFzHuDUqwQCfb67E
s6wcnGo2ETzjZmXGQqiHyK8=
=JZTg
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
