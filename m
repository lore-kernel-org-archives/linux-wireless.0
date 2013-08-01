Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:47621
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753558Ab3HARrz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 13:47:55 -0400
Date: Thu, 1 Aug 2013 13:47:50 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: Jonathan Bagg <jbagg@lenbrook.com>
Cc: linux-wireless@vger.kernel.org, backports@vger.kernel.org
Subject: Re: cross compile backports?
Message-ID: <20130801174749.GC10904@shaftnet.org> (sfid-20130801_194758_736402_4A291089)
References: <1375338204-2021-8-git-send-email-sujith@msujith.org>
 <1375370826-1387-1-git-send-email-sujith@msujith.org>
 <51FA8ECD.7070401@lenbrook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5QAgd0e35j3NYeGe"
In-Reply-To: <51FA8ECD.7070401@lenbrook.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--5QAgd0e35j3NYeGe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 01, 2013 at 12:37:33PM -0400, Jonathan Bagg wrote:
> I've been cross compiling compat-wireless and now I'm trying
> backports.  It looks like conf.c and zconf.tab.c are being compiled
> as arm and then the build process is trying to run conf on my x86
> host.  Results using the below make parameters I was using for
> compat-wireless......

Howdy.  :)

(btw, I'm CC'ing the backports mailing list, which is a better place to=20
 ask these sorts of questions)

I found that the backports cross-compile process worked much the same=20
way as building compat-wireless.  This is what I'm doing currently in my=20
build script:  (This is using a backports package generated last night=20
using the backports git HEAD code with the cw1200 driver integrated)

 set -a
 CROSS_COMPILE=3D${CROSS_COMPILE}=20
 ARCH=3D${TARGET_CPU}
 KLIB_BUILD=3D${DEV_PATH}/${LINUX_DIR}
 KLIB=3D${TARGET_ROOT_ON_HOST}
 set +a
 make oldconfig  # menuconfig worked here too
 make
 make install

That said, the 'make install' target isn't currently sane for=20
cross-builds due to the bacport_firmware_install script not respecting=20
prefixes.  I just commented that script (and a few others like initrd=20
updates) out of the Makefiles, and I had a successful build/install.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org
Delray Beach, FL                          ^^ (email/xmpp) ^^
Quidquid latine dictum sit, altum viditur.

--5QAgd0e35j3NYeGe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFR+p9FPuLgii2759ARAmwfAJ9xOHDt1S47vszd2UKeVEsFq6SOzACdEbVk
ec4GTk3g0g9kjmUW9wlYCg8=
=D2Ey
-----END PGP SIGNATURE-----

--5QAgd0e35j3NYeGe--
