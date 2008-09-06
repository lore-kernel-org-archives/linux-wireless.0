Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42747 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbYIFUCo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 16:02:44 -0400
Subject: Re: [PATCH] b43legacy: Fix failure in rate-adjustment mechanism
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <48C2E13B.9020203@lwfinger.net>
References: <48c2cd1a.pA60sTEK0WsW6wtt%Larry.Finger@lwfinger.net>
	 <200809062055.51797.mb@bu3sch.de> <1220727470.10102.9.camel@johannes.berg>
	 <200809062104.15274.mb@bu3sch.de>  <48C2DBCB.1030706@lwfinger.net>
	 <1220730115.10102.15.camel@johannes.berg>  <48C2E13B.9020203@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UdZx3vX4oInH1CMBbny2"
Date: Sat, 06 Sep 2008 22:02:39 +0200
Message-Id: <1220731359.10102.16.camel@johannes.berg> (sfid-20080906_220248_434255_CA0D8F51)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UdZx3vX4oInH1CMBbny2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-09-06 at 14:59 -0500, Larry Finger wrote:

> In the V3 specs, I found
>=20
> "Transmit Status
>=20
> When this interrupt is set, the retrieve the TransmitStatus. Note that=20
> on cores with revision < 5, the last DMA controller or PIO queue can=20
> also also get the DMA recieve done interrupt, which also triggers the=20
> TransmitStatus retrieval process. The driver should be prepared to=20
> deal with both interrupts at any time, on any revision. In AP mode,=20
> this interrupt also initiates the sending of powersave responses."

Yeah, this isn't entirely correct, when the core revision is < 5 then
the register-based TX status doesn't actually exist and the firmware
always uses the FIFO-based mechanism.

> The implication is that the interrupt will only be generated if we use=20
> the last (i.e. #5) DMA controller. As we are only using #3, no=20
> interrupts and handle_irq_status() is dead code.

Right, only core revisions 2 and 4 are supported here.

johannes

--=-UdZx3vX4oInH1CMBbny2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIwuHbAAoJEKVg1VMiehFYdt8QAJpPjc71W/xus6Op1qK7c58c
ghCY1c0NPQR/LfmsRB/oofQNHklWEiXIM7IFiZfmhb3CQZOdUULAgx446bBuhjeX
JDoXGPvdA8i6NQ3T/JiCQ2dlt6LoPtG1tFT7yHJsiO/3UhOs3pg/2OFLtfHmgWt2
x7n1vOHcv/5puVqETqPk53gswy+Uu16VGP/Q+ezfLJ0OjhnCe6/IY6/tMGqP9rIf
XMUuO2WPr2sTYrJgIluPUwMPYuYTDvV9cG04EppRGe4Q3QniNYo+57xbaNf/3GFa
FlmI80TXXRPhHDA6AW3a4113DdjiGDAYd+000p6k97ofj5OwfR6WqjiujSEHX1cP
W+G8cmuUUkLlzjHc4XI0P8pvsSx81h/ADrPy03JGhZtasr/UuFtv7iHzGlQiRBLf
soGk38qla8wT3NKvIeFXrSzfvKIvl3j/RnMZy3gKgac9EPuS2X4dqeJRx2j5A60p
rtgOzTE+ncbG4AYNTkHx+lhdhJQJPIJHk005UiN36rwjcJInm0ZM/monU4BIuR5A
XUGc7+cZNisOSvGY88kGSzjF0jf4E+ZTnT9xOG+eHo832u2FH6Jlizsylo1cDfWV
vYx5rQPHDevyWhKp62O5A7stu5sRI7Z7t2pjxqx2H9JQw0EG4R4NuZdrEoiE+es4
ih7HMM8biJ8fOVlaqas2
=EORO
-----END PGP SIGNATURE-----

--=-UdZx3vX4oInH1CMBbny2--

