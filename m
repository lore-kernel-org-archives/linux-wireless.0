Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:39076
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752648Ab3KGS5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Nov 2013 13:57:42 -0500
Date: Thu, 7 Nov 2013 13:57:14 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org
Subject: Re: future of prism2_usb (aka wlan-ng) in staging tree
Message-ID: <20131107185714.GD12612@shaftnet.org> (sfid-20131107_195748_127355_E3852869)
References: <20131107160522.GA12612@shaftnet.org>
 <527BC04F.2080000@lwfinger.net>
 <20131107163719.GC12612@shaftnet.org>
 <20131107175201.GA2002@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y5rl02BVI9TCfPar"
In-Reply-To: <20131107175201.GA2002@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 07, 2013 at 12:52:02PM -0500, John W. Linville wrote:
> I haven't looked at the driver in question in a long time.  Are there
> actually any users?

I honestly don't know who all uses it these days, since it's=20
802.11b-only and being USB, eminantly replacable with something more=20
modern.

Still, the driver and hardware works, and it's no more obsolete than the=20
likes of hostap, orinoco, aironet, zd1201, and others -- All of which=20
live on under net/wireless even though they still lack cfg80211 support.

BTW, this is my current WIP diffstat:

 drivers/staging/wlan-ng/Makefile           |    2
 drivers/staging/wlan-ng/hfa384x.h          |    2=20
 drivers/staging/wlan-ng/hfa384x_usb.c      |   67 ++----
 drivers/staging/wlan-ng/p80211conv.c       |   70 ------
 drivers/staging/wlan-ng/p80211metadef.h    |    3=20
 drivers/staging/wlan-ng/p80211metastruct.h |    9=20
 drivers/staging/wlan-ng/p80211netdev.c     |   79 +++----
 drivers/staging/wlan-ng/p80211netdev.h     |   35 ---
 drivers/staging/wlan-ng/prism2fw.c         |   86 +++----
 drivers/staging/wlan-ng/prism2mgmt.c       |  126 ++++-------
 drivers/staging/wlan-ng/prism2mib.c        |   64 ++---
 drivers/staging/wlan-ng/prism2sta.c        |  118 ++++------
 drivers/staging/wlan-ng/p80211ioctl.h      |   89 -------
 drivers/staging/wlan-ng/p80211req.c        |  251 ----------------------
 drivers/staging/wlan-ng/p80211req.h        |   53 ----
 drivers/staging/wlan-ng/p80211wep.c        |  301 ------------------------=
---
 16 files changed, 248 insertions(+), 1107 deletions(-)

Aside from fixing up a boatload of checkpatch warnings, I've been=20
stripping out more legacy cruft (eg custom ioctl, host-side WEP, more=20
plumbing) that's not relevant any longer.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org
Delray Beach, FL                          ^^ (email/xmpp) ^^
Quidquid latine dictum sit, altum viditur.

--Y5rl02BVI9TCfPar
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iD8DBQFSe+KKPuLgii2759ARAq18AKDEKKn4H+M3Sjzzhf0HvaD6tIsDvwCdGHGj
cgEuoBKdsymr61tcmXGZ1PM=
=x8Qg
-----END PGP SIGNATURE-----

--Y5rl02BVI9TCfPar--
