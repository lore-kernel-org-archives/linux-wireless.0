Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:53477 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464Ab2I1Lfy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 07:35:54 -0400
Message-ID: <1348832119.15949.11.camel@cumari.coelho.fi> (sfid-20120928_133558_517582_DDD70BA3)
Subject: pull request: TI wireless drivers 2012-09-28 (for 3.7)
From: Luciano Coelho <luca@coelho.fi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, arik@wizery.com, assaf@ti.com,
	coelho@ti.com
Date: Fri, 28 Sep 2012 14:35:19 +0300
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-cvXF8P4UNyIRy+TA+lZs"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cvXF8P4UNyIRy+TA+lZs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Mostly bugfixes and small improvements in our TI wireless drivers,
intended for 3.7.

The following changes since commit 944f8a1a6f5ff8b503f3544811d0aa4ac27dd2aa=
:

  ath5k: add missing breaks in ath5k_hw_set_spur_mitigation_filter (2012-09=
-25 15:57:44 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linvill=
e

for you to fetch changes up to af390f4dd35373b3ca32bafc12d7f2ad12840529:

  wlcore: protect wlcore_op_set_key with mutex (2012-09-27 12:13:54 +0300)

----------------------------------------------------------------
Arik Nemtsov (9):
      wlcore: AP mode - send non-data packets with basic rates
      wlcore: allow only the lowest OFDM rate for p2p setup frames
      wlcore: make Tx flush timings more verbose
      wlcore: tx_flush - optimize flow and force Tx during the flush
      wlcore/wl18xx/wl12xx: allow up to 3 mac addresses
      wlcore: make debug prints work without dynamic debug
      wlcore: allow up to 3 running STA interfaces in combinations
      wlcore: spi: use private max-buf-size limit
      wl18xx: default to siso40 in 2.4ghz with a single antenna

Devendra Naga (1):
      wl18xx: use module_platform_driver

Eliad Peller (9):
      wlcore: consider single fw case
      wlcore: cancel recovery_work on stop() instead of remove_interface()
      wlcore: resume() only if sta is associated
      wlcore: always use wlvif->role_id for scans
      wlcore: lazy-enable device roles
      wlcore: invalidate keep-alive template on disconnection
      wlcore: use dynamic keep-alive template ids
      wlcore: decrease elp timeout
      wlcore: protect wlcore_op_set_key with mutex

Eyal Shapira (1):
      wlcore: configure wowlan regardless of wakeup conditions

Ido Reis (2):
      wl18xx: update default phy configuration for pg2
      wl18xx: increase rx_ba_win_size to 32

Ido Yariv (6):
      wlcore: Prevent interaction with HW after recovery is queued
      wlcore: Don't recover during boot
      wlcore: Fix unbalanced interrupts enablement
      wlcore: Allow memory access when the FW crashes
      wlcore: Refactor probe
      wlcore: Load the NVS file asynchronously

Igal Chernobelsky (2):
      wl18xx/wl12xx: defines for Tx/Rx descriptors num
      wlcore/wl18xx/wl12xx: aggregation buffer size set

Luciano Coelho (1):
      wl12xx: use module_platform_driver

Tim Gardner (1):
      wlcore: Declare MODULE_FIRMWARE usage

Wei Yongjun (1):
      wl12xx: remove duplicated include from main.c

Yair Shapira (2):
      wl18xx: number_of_assembled_ant5 indicates if A band is enabled
      wlcore/wl18xx: add phy_fw_version_str to debugfs driver_state

 drivers/net/wireless/ti/wl12xx/main.c     |   79 +++++++-----
 drivers/net/wireless/ti/wl12xx/wl12xx.h   |    7 +
 drivers/net/wireless/ti/wl18xx/debugfs.c  |    2 +-
 drivers/net/wireless/ti/wl18xx/main.c     |  128 +++++++++----------
 drivers/net/wireless/ti/wl18xx/wl18xx.h   |    7 +
 drivers/net/wireless/ti/wlcore/cmd.c      |   21 ++-
 drivers/net/wireless/ti/wlcore/cmd.h      |    5 -
 drivers/net/wireless/ti/wlcore/conf.h     |    3 +-
 drivers/net/wireless/ti/wlcore/debug.h    |   16 ++-
 drivers/net/wireless/ti/wlcore/debugfs.c  |   32 +++--
 drivers/net/wireless/ti/wlcore/init.c     |   12 +-
 drivers/net/wireless/ti/wlcore/io.h       |    4 +-
 drivers/net/wireless/ti/wlcore/main.c     |  366 +++++++++++++++++++++++++=
+++++-----------------------
 drivers/net/wireless/ti/wlcore/ps.c       |   10 +-
 drivers/net/wireless/ti/wlcore/rx.c       |    2 +-
 drivers/net/wireless/ti/wlcore/scan.c     |   20 ++-
 drivers/net/wireless/ti/wlcore/spi.c      |   10 +-
 drivers/net/wireless/ti/wlcore/testmode.c |    4 +-
 drivers/net/wireless/ti/wlcore/tx.c       |   51 +++++---
 drivers/net/wireless/ti/wlcore/wlcore.h   |   23 +++-
 drivers/net/wireless/ti/wlcore/wlcore_i.h |   13 +-
 21 files changed, 476 insertions(+), 339 deletions(-)

--=20
Cheers,
Luca.


--=-cvXF8P4UNyIRy+TA+lZs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQZYt3AAoJEKFHnKIaPMX6YfEP/01fa3iUYA68GuvByhEfuG4V
/e03xk8LMs/YJkD9gDBvk7KOg+Oe+HyLugjsLG+Pa+rOMnscdPatmA9qDkIV4EPj
GTCp3sBEaRFR1V3go9qjbbJKOIm9jK6dS9CP+d0dxCCmu8OBhesYvmgYHqosD4OM
tWY6VwqowY07qPn/2Ez5kpwDyz5thCeIRnksJicRsGaCVIIDvIyWlDK5RvcL0juH
FAyKW0pZB1npeYsIJHs/1MJpXINufON7kVvvo1S2QrGs/HZpZ0yEuY2lq4C9kHM/
PDQ54B/upx3VmDjA/mnQDU5KpIMWxQlBfGFUvbhc4EzjET6dg0o98rYiRdOxFnSg
Izxa83TQHUVh3R+TZutEDsu7x2s39FmuhJtl6ZdQa5uzeFxyeVXQrzqoW4DnS4tu
rOXLJVf1F9lBPxRUUtRukpIN0Fuv4lZNtMeIYahFVt1yA5eqP4NaQvreCCydGfbg
DeZwqW5dyjOnyvyFUPxzRv3gfxDFSRyi70uqPWO92lqn3hRES+O1t4NsxD8o676q
Zy7sr2l/fnU3SZbjCHx8rFAUDU5krR/l/o3/aMCSYPw0zDJQoIW2aBwkqMHQnOS2
JLGfgK+e3AzpPpGTeAHfmGTk/yeWO2qswVV3/Pr8+RakK1Xr78DdI7cFBjTrOU5n
AZOdwPHNoVOxTYzVBg/7
=U+Qx
-----END PGP SIGNATURE-----

--=-cvXF8P4UNyIRy+TA+lZs--

