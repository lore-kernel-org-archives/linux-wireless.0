Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56570 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbZJHLwB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 07:52:01 -0400
Subject: Re: NULL pointer deref at wext ioctl (Re: [PATCH] compat-2.6:
 adding  ethtool.h to compat-2.6.31.h)
From: Johannes Berg <johannes@sipsolutions.net>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1254995514.3713.22.camel@johannes.local>
References: <3ace41890910071216y69b8bc9la67b8f0ce5890cd8@mail.gmail.com>
	 <3ace41890910071228i786d4097w69dc7a3dfeb64afe@mail.gmail.com>
	 <1254952886.3713.4.camel@johannes.local>
	 <3ace41890910072328n1460ee34v1fe7ca9b78eb646f@mail.gmail.com>
	 <1254995514.3713.22.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tPlL29C7sp9Nrvx9nBlr"
Date: Thu, 08 Oct 2009 13:50:47 +0200
Message-Id: <1255002647.3713.25.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tPlL29C7sp9Nrvx9nBlr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-10-08 at 11:51 +0200, Johannes Berg wrote:

> Ok, that's odd. Is it possible that somehow cfg80211 is picking up an
> #ifdef'ed copy of "struct iw_handler_def", and thus the struct it is
> defining is simply too small?

That is apparently what is happening since compat-wireless ships
iw_handler.h. This is wrong, as wext functionality is built into the
kernel image so you can't use a newer header file with it.

johannes

--=-tPlL29C7sp9Nrvx9nBlr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKzdITAAoJEODzc/N7+Qma90gP/RVGBO8raSqpE/W3K+CdSBQu
tBpRZvZO+KrFn9Ke9Ymafd8gl//Wm9wZMudYq353FRfcatz1FjRTIauILSep5MGy
6l0IQ2AFLxDZ554eI7GF3TuCHQVhTQrxrhZVR9/PwV/uiPHfAoBUkzShueOtD+g0
PtNKgXorfEKrgq/OEKDHvJKX1ka54MMCBhdfOmiSLyhbSAIyc4v252kj8PFmoXyw
NGdFsyHn4cooxRKjsIpAt/HDoMeBDMcqusGseIFYi7521qkJ7Rg0ohYrS6y2Tizj
GIbS0X3q307mRPN86HOwsgOabhxWIUhfERBGwCK3QwI9LJguSQTe8DYBLRdkQWac
JQqCGvXN5Pfh5jr7o+IYCXAUEUnPPd5I1ErUAKHyNqNJudDO8nEkGpYH/60LqMOj
F+kdqKIs7pD7WqqNxuuT6P0vW+BYLd1/g/+uWTunZt/IvlDmnk9TkYdBKAWvvP/b
Ybov2fWJxKSRo5H1OLQmlNgH5CKhuINUQUla7UZytcPcXuDNu1E6xG0WDPVrRGcN
S1h4M6DpsJBUileRvCkWf69sR4O9ySNuco+khshnaas/Dgi8kZFSxEW9VWFwnB4j
C6OyAWGvxB8o4Uxlunq/V1OT/goklgYOyj7KnfvB6vXSV1E9VQB/r2U06UKl7cdj
OIRuw5VqE72ut2+ka1OI
=7OEX
-----END PGP SIGNATURE-----

--=-tPlL29C7sp9Nrvx9nBlr--

