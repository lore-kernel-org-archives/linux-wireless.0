Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:42677 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754368Ab2FXIj4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jun 2012 04:39:56 -0400
Received: by lbbgk8 with SMTP id gk8so5508115lbb.40
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jun 2012 01:39:53 -0700 (PDT)
Message-ID: <1340527191.1631.423.camel@cumari.coelho.fi> (sfid-20120624_104000_437844_E4C0BB82)
Subject: pull request: TI wireless drivers 2012-06-24 (for 3.6)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, arik@wizery.com, assaf@ti.com
Date: Sun, 24 Jun 2012 11:39:51 +0300
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-DuUOmeG0w+V9BAtFZwin"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DuUOmeG0w+V9BAtFZwin
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

One more pull request intended for 3.6.  Mostly about SDIO error
handling (by Ido) and correct handling and recovery during
suspend/resume.  Plus one new debugfs entry that allows easier FW
debugging, by Arkady.

Please pull or let me know if there's any problem.


The following changes since commit 5ea276963eacbef742fe4854883c0f69c903fcfd=
:

  rtlwifi: Change debug level for deletion of an entry in CAM (2012-06-22 1=
4:44:06 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linvill=
e

for you to fetch changes up to 03e713de9df5afd00dd13f23f83b2eb20c4c92b3:

  Merge branch 'wl12xx-next' into for-linville (2012-06-24 10:40:25 +0300)

----------------------------------------------------------------

Arik Nemtsov (6):
      wlcore: cancel suspend when recovery is pending
      wlcore: don't allow SDIO read/writes after failure
      wlcore: force recovery on resume if suspended without recovering
      wlcore: check Rx-filter functions in the suspend path
      wlcore: refactor threaded IRQ routine
      wlcore: prevent recovery in the middle of resume

Arkady Miasnikov (1):
      wlcore: access the firmware memory via debugfs

Ido Yariv (11):
      wlcore: Fix sdio out-of-sync power state
      wlcore: Disable interrupts while recovering
      wlcore: Change read/write ops to return errors
      wlcore: Change raw io functions to return errors
      wlcore: Propagate errors from wlcore_raw_*_data functions
      wlcore: Propagate errors from wl1271_read
      wlcore: Propagate errors from wl1271_write
      wlcore: Propagate errors from wl1271_raw_read32
      wlcore: Propagate errors from wl1271_raw_write32
      wlcore: Propagate errors from wl1271_read_hwaddr
      wlcore: Force checking of io functions' return values

Luciano Coelho (1):
      Merge branch 'wl12xx-next' into for-linville

 drivers/net/wireless/ti/wl12xx/main.c     |  343 +++++++++++++++++++++++++=
+++++++++++++++++++----------------
 drivers/net/wireless/ti/wl18xx/io.c       |   39 ++++---
 drivers/net/wireless/ti/wl18xx/io.h       |    4 +-
 drivers/net/wireless/ti/wl18xx/main.c     |  219 +++++++++++++++++++++++++=
++-----------
 drivers/net/wireless/ti/wlcore/boot.c     |   84 ++++++++++-----
 drivers/net/wireless/ti/wlcore/cmd.c      |   47 +++++++--
 drivers/net/wireless/ti/wlcore/debugfs.c  |  192 +++++++++++++++++++++++++=
+++++++++
 drivers/net/wireless/ti/wlcore/event.c    |   15 ++-
 drivers/net/wireless/ti/wlcore/hw_ops.h   |   12 ++-
 drivers/net/wireless/ti/wlcore/io.c       |   55 +++++++---
 drivers/net/wireless/ti/wlcore/io.h       |  144 ++++++++++++++++---------
 drivers/net/wireless/ti/wlcore/main.c     |  240 +++++++++++++++++++++++++=
++++++-----------
 drivers/net/wireless/ti/wlcore/ps.c       |   14 ++-
 drivers/net/wireless/ti/wlcore/rx.c       |   37 +++++--
 drivers/net/wireless/ti/wlcore/rx.h       |    4 +-
 drivers/net/wireless/ti/wlcore/sdio.c     |   50 +++++----
 drivers/net/wireless/ti/wlcore/spi.c      |   14 ++-
 drivers/net/wireless/ti/wlcore/tx.c       |   61 +++++++----
 drivers/net/wireless/ti/wlcore/tx.h       |    4 +-
 drivers/net/wireless/ti/wlcore/wlcore.h   |   14 +--
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    9 +-
 21 files changed, 1196 insertions(+), 405 deletions(-)

--=20
Cheers,
Luca.


--=-DuUOmeG0w+V9BAtFZwin
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP5tJXAAoJEKFHnKIaPMX64OIP+QGTiDstT71YtFwPA5mPBRew
DiNQA0ixP+lrEFr9l1hH5YeJb+69TOVn7IPCJv7D9yDFQWwqKX+ymMt9Sud5LEuO
QfdSaB6FPtEP5ApOf+dEPO0JaVdFG7RRvk8b3fWR5W1l74lJ8mQ5ekWf3+gTdEX8
SOLbp1KHCSpiJHOp2aBxqi8VG1fMZN7jzVOQClAPSQ9Y068ZxVU2QozfBgbdpN1K
9RXFwtsgBYB4ObU/yMtq6hcmuazGgONLpIfwyruS+BNsyP4gygWDmkxkaCXZec6i
WRyXph+SIWTip7JB9umE1L8zYw1q4Gbr/A2pPE3xssbug6j/sRM6VzL2lMfse+KG
ZW2cApSc1PGT+Ff+hrlyQ/ZVpxFgEVg3MdEGta7xEaqvyHgEqcKexBSYrkeQZMcN
dgBS8dz7FpOe9QZRm+GCnQHZKoS03BV3B7bCGDXPzZxO9JeVAXaFokL3i3qUI2up
Mcv3KHy31NWZ9HhgmDIcxHVIOt1fLlwqTIGSB9B7H+hBDHsSVDlS91C61Zo3wRFX
qKFcFKgssIKEZaJw2bi2lBjXM4pVUmjVY+XnmBBvUfdwssNmIOiD3qq5Z7COLoyX
tgAenqiVxD33VCCuWnml33gMfRdCbV8FToY3Z3KSAcHh9ytp96NAcF8k9UDg9iAs
3eghMIkC4AoZEGT75193
=wXXx
-----END PGP SIGNATURE-----

--=-DuUOmeG0w+V9BAtFZwin--

