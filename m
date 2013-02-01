Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:41666 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab3BABys (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 20:54:48 -0500
Date: Thu, 31 Jan 2013 20:54:42 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Pontus Fuchs <pontus.fuchs@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: RFCv3: ST-E CW1200 WLAN driver
Message-ID: <20130201015442.GA2174@shaftnet.org> (sfid-20130201_025452_194025_EA559C03)
References: <1357999575-12838-1-git-send-email-pizza@shaftnet.org>
 <50F3F743.1000802@gmail.com>
 <20130130190215.GA2167@tuxdriver.com>
 <20130130223232.GA7307@shaftnet.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
In-Reply-To: <20130130223232.GA7307@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 30, 2013 at 05:32:32PM -0500, Solomon Peachy wrote:
> This is my current to-do list:

Was unexpectedly able to spend some time on this today!

>  * One final Kconfig option to eliminate

Done.

>  * A possible crash (reported not three hours ago) that needs confirming

Turns out to not be a crash, but it is a real problem.  The driver can=20
get into an inconsistent internal state if a connection loss event=20
occurs.  Proper fix triggers deadlock due to interdependencies. =20

Hackish workaround in place now, and I'm working on a proper fix.  Or=20
will be once my head stops throbbing.  The code is needlessly complex=20
and interdependent, and unravelling a bit at a time is difficult.

This state problem actually explains a bunch of other odd quirks I've=20
seen, so fixing it properly is pretty important.

>  * Hot unplug is still iffy (but better!)

More progress here, but more work to be done. (Only a problem now if=20
device isn't idle when yanked -- if the supplicant is attached, it=20
deadlocks still)

>  * Reworked SPI interrupt delivery completely untested
>  * IBSS is still busted (haven't had time to tackle it properly)
>  * Rebase against 3.8
>  * Investigate adding OF bindings that can be used instead of platform_da=
ta

No progress here yet.

I'll post another patch set this weekend.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRCyBiPuLgii2759ARAnjHAKCB+qRUxhJHHp1m7ZZLuTYGpNqhGgCfYP+T
VS5wtB99UxU+puDZI5lTYfY=
=TGNx
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
