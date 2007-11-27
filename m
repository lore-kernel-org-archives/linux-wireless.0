Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:51154 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753598AbXK0CQu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 21:16:50 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Tony Breeds <tony@bakeyournoodle.com>
Subject: Re: mm snapshot broken-out-2007-11-20-01-45 Build Fail - net/wireless driver
Date: Mon, 26 Nov 2007 21:20:08 -0500
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
	akpm@linux-foundation.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org> <4742DFC3.80305@linux.vnet.ibm.com> <20071127005950.GZ24243@bakeyournoodle.com>
In-Reply-To: <20071127005950.GZ24243@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5837485.7axB9uEovt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200711262120.13218.flamingice@sourmilk.net> (sfid-20071127_021655_770784_68DBCDF6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart5837485.7axB9uEovt
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

(Trimmed CC list a bit, hopefully didn't cut anyone interested out)

On Monday 26 November 2007 19:59:50 Tony Breeds wrote:
> On Tue, Nov 20, 2007 at 06:53:15PM +0530, Kamalesh Babulal wrote:
> > Hi Andrew,
> >
> > The kernel build fails, with following message
> >
> >   LD      drivers/net/wireless/built-in.o
> > drivers/net/wireless/rtl8187.o: In function `rtl8225z2_rf_init':
> > (.opd+0x180): multiple definition of `rtl8225z2_rf_init'
> > drivers/net/wireless/rtl8180.o:(.opd+0x1b0): first defined here
> > drivers/net/wireless/rtl8187.o: In function `rtl8225z2_rf_init':
> > /root/linux-2.6.24-rc3/drivers/net/wireless/rtl8187_rtl8225.c:571:
> > multiple definition of `.rtl8225z2_rf_init'
> > drivers/net/wireless/rtl8180.o:/root/linux-2.6.24-rc3/drivers/net/wirel=
es
> >s/rtl8180_rtl8225.c:561: first defined here ld: Warning: size of symbol
> > `.rtl8225z2_rf_init' changed from 3836 in drivers/net/wireless/rtl8180.o
> > to 3544 in drivers/net/wireless/rtl8187.o
>
> <snip>
>
> The patch below is a little ugly but will allow allyesconfig to work.  I
> don't know enough about the Realtek devices to make intellegent
> suggestions on how to fix this particular problem.  Clearly the 2
> drivers share a lot of common code so perhaps they can be merged?
>
I would rather have a patch to temporarily not allow them to be built into =
the=20
kernel. (or only allow one at a time to be built as a module) There's no=20
issues when these drivers are compiled as modules.

It's mostly the rtl8225 radio tuning code that's similar. They're not exact=
ly=20
the same though, so it'll be a bit messy to merge the usb rtl8225 radio=20
tuning and pci rtl8225 radio tuning code. However, I do think it'll be bett=
er=20
overall so the merger of that code is planned.

=2DMichael Wu

--nextPart5837485.7axB9uEovt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHS37dT3Oqt9AH4aERArqJAJ0SvSrgdX16cVwr9CaDUeQpEdqCzgCfalsA
AOuXFAxt7r9Zxz4hSgftZn4=
=hrvI
-----END PGP SIGNATURE-----

--nextPart5837485.7axB9uEovt--
