Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:59926 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933741Ab2DLMvR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 08:51:17 -0400
Received: by lahl5 with SMTP id l5so1419668lah.15
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2012 05:51:13 -0700 (PDT)
Message-ID: <1334235045.10398.44.camel@cumari> (sfid-20120412_145121_470548_19AF9ECD)
Subject: pull request: wl12xx 2012-04-12
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Thu, 12 Apr 2012 15:50:45 +0300
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-KbOSVWzjAQFAqvsgpOrV"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KbOSVWzjAQFAqvsgpOrV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

This is the first pull request intended for 3.5.  It looks big, but it
contains mostly reorganization of the directories and splitting the
wl12xx code into a wlcore module and a wl12xx submodule.  This is done
in preparation for wl18xx support.  It also contain a few random fixes
here and there.=20

Please pull or let me know if there's any problem. This tree is based on
wireless-next/master and the head I want you to pull from is
916ef361ce70a56601654e44c91855153e557051.=20

Thanks!=20

The following changes since commit e66a8ddff72e85605f2212a0ebc666c7e9116641=
:

  rt2x00: do not generate seqno in h/w if QOS is disabled (2012-04-11 16:24=
:01 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linvill=
e

Arik Nemtsov (19):
      wlcore/wl12xx: create per-chip-family private storage
      wlcore/wl12xx: set the number of Tx descriptors per chip family
      wlcore/wl12xx: change GEM Tx-spare blocks per-vif
      wlcore/wl12xx: add hw op for calculating hw block count per packet
      wlcore/wl12xx: add hw op for setting blocks in hw_tx_desc
      wlcore/wl12xx: add hw op for setting frame length in tx_hw_desc
      wlcore/wl12xx: add global elements to convert hw-rates to standard ra=
tes
      wlcore: introduce Rx block-size alignment HW quirk
      wlcore/wl12xx: add hw op for getting rx buffer data alignment
      wlcore/wl12xx: add hw op for getting rx packet data length
      wlcore/wl12xx: split Tx completion to immediate/delayed
      wlcore/wl12xx: turn no-Tx-align quirk into Tx-align
      wlcore/wl12xx: add hw op for vif init
      wlcore/wl12xx: expand functionality of cmd_trigger HW op
      wlcore/wl12xx: add hw op to get rate-mask for AP-link in STA mode
      wlcore/wl12xx: set HT capabilities per chip-family
      wlcore: set max_rx_agg_subframes in mac80211 according to HT conf
      wlcore: add module param to prevent HW recovery
      wlcore/wl12xx: adapt FW status for multiple families

Eliad Peller (2):
      wl12xx: set do_join on BSS_CHANGED_ASSOC
      wl12xx: free ap keys only in ap mode

Eyal Shapira (4):
      wl12xx: fix race between suspend/resume and recovery
      wl12xx: fix a memory leak of probereq template upon recovery
      wl12xx: adaptive sched scan dwell times
      wl12xx: increase scan timeout to 30s

Luciano Coelho (22):
      wireless/wl12xx/wl1251: move TI WLAN modules to a common ti subdirect=
ory
      wl12xx/wlcore: rename wl12xx to wlcore
      wl12xx/wlcore: spin out the wl12xx probe from wlcore to a new wl12xx
      wl12xx/wlcore: initial split of probe
      wl12xx/wlcore: move wl1271 struct to wlcore and add ops
      wlcore/wl12xx: implement chip-specific partition tables
      wlcore/wl12xx: implement chip-specific register tables
      wlcore/wl12xx: add chip-specific identify chip operation
      wlcore/wl12xx: move get_pg_ver to the lower driver
      wlcore/wl12xx: move top initialization to wl12xx
      wlcore/wl12xx: move MAC address reading operation to lower driver
      wlcore/wl12xx: add command trigger and event ack operations
      wlcore/wl12xx: add quirk for legacy NVS support
      wlcore: remove some unnecessary event mailbox address reads
      wlcore: add quirk to disable ELP
      wlcore/wl12xx: add prepare_read hw op for Rx data
      wlcore/wl12xx: add hw_init operation
      wlcore/wl12xx: move runtime configuration struct to the lower driver
      wlcore/wl12xx: move extended radio configuration parameters to wl12xx
      wlcore/wl12xx: use a single memory config and reset if using wl127x
      wlcore/wl12xx: move identify firmware function to a lower driver op
      Merge branch 'wl12xx-next' into for-linville

Mircea Gherzan (1):
      wl12xx: fix DMA-API-related warnings

Victor Goldenshtein (1):
      wl12xx: fix station channel switch

 MAINTAINERS                                        |   27 +-
 drivers/net/wireless/Kconfig                       |    3 +-
 drivers/net/wireless/Makefile                      |    4 +-
 drivers/net/wireless/ti/Kconfig                    |   14 +
 drivers/net/wireless/ti/Makefile                   |    4 +
 drivers/net/wireless/{ =3D> ti}/wl1251/Kconfig       |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/Makefile      |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/acx.c         |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/acx.h         |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/boot.c        |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/boot.h        |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/cmd.c         |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/cmd.h         |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/debugfs.c     |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/debugfs.h     |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/event.c       |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/event.h       |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/init.c        |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/init.h        |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/io.c          |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/io.h          |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/main.c        |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/ps.c          |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/ps.h          |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/reg.h         |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/rx.c          |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/rx.h          |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/sdio.c        |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/spi.c         |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/spi.h         |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/tx.c          |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/tx.h          |    0
 drivers/net/wireless/{ =3D> ti}/wl1251/wl1251.h      |    0
 .../net/wireless/{ =3D> ti}/wl1251/wl12xx_80211.h    |    0
 drivers/net/wireless/ti/wl12xx/Kconfig             |    8 +
 drivers/net/wireless/ti/wl12xx/Makefile            |    3 +
 drivers/net/wireless/ti/wl12xx/acx.c               |   53 +
 drivers/net/wireless/ti/wl12xx/acx.h               |   36 +
 drivers/net/wireless/ti/wl12xx/cmd.c               |  254 ++++
 drivers/net/wireless/ti/wl12xx/cmd.h               |  112 ++
 drivers/net/wireless/ti/wl12xx/conf.h              |   50 +
 drivers/net/wireless/ti/wl12xx/main.c              | 1388 ++++++++++++++++=
++++
 drivers/net/wireless/{ =3D> ti}/wl12xx/reg.h         |  315 +++---
 drivers/net/wireless/ti/wl12xx/wl12xx.h            |   31 +
 drivers/net/wireless/ti/wlcore/Kconfig             |   41 +
 drivers/net/wireless/ti/wlcore/Makefile            |   15 +
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/acx.c   |   42 +-
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/acx.h   |   10 +-
 drivers/net/wireless/ti/wlcore/boot.c              |  443 +++++++
 drivers/net/wireless/ti/wlcore/boot.h              |   54 +
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/cmd.c   |  285 +----
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/cmd.h   |   98 +--
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/conf.h  |   85 +-
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/debug.h |    1 +
 .../net/wireless/{wl12xx =3D> ti/wlcore}/debugfs.c   |    3 +-
 .../net/wireless/{wl12xx =3D> ti/wlcore}/debugfs.h   |    2 +-
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/event.c |   31 +-
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/event.h |    3 +-
 drivers/net/wireless/ti/wlcore/hw_ops.h            |  122 ++
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/ini.h   |    0
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/init.c  |   66 +-
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/init.h  |    2 +-
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/io.c    |  191 +--
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/io.h    |   88 +-
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/main.c  |  821 ++----------
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/ps.c    |    8 +-
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/ps.h    |    2 +-
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/rx.c    |  130 +-
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/rx.h    |   12 +-
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/scan.c  |   30 +-
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/scan.h  |    4 +-
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/sdio.c  |    6 +-
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/spi.c   |    4 +-
 .../net/wireless/{wl12xx =3D> ti/wlcore}/testmode.c  |    3 +-
 .../net/wireless/{wl12xx =3D> ti/wlcore}/testmode.h  |    0
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/tx.c    |  125 +--
 drivers/net/wireless/{wl12xx =3D> ti/wlcore}/tx.h    |    7 +-
 .../net/wireless/{wl12xx =3D> ti/wlcore}/wl12xx.h    |  271 +----
 .../wireless/{wl12xx =3D> ti/wlcore}/wl12xx_80211.h  |    0
 .../{wl12xx =3D> ti/wlcore}/wl12xx_platform_data.c   |    0
 drivers/net/wireless/ti/wlcore/wlcore.h            |  448 +++++++
 drivers/net/wireless/wl12xx/Kconfig                |   48 -
 drivers/net/wireless/wl12xx/Makefile               |   15 -
 drivers/net/wireless/wl12xx/boot.c                 |  786 -----------
 drivers/net/wireless/wl12xx/boot.h                 |  120 --
 85 files changed, 3800 insertions(+), 2924 deletions(-)
 create mode 100644 drivers/net/wireless/ti/Kconfig
 create mode 100644 drivers/net/wireless/ti/Makefile
 rename drivers/net/wireless/{ =3D> ti}/wl1251/Kconfig (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/Makefile (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/acx.c (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/acx.h (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/boot.c (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/boot.h (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/cmd.c (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/cmd.h (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/debugfs.c (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/debugfs.h (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/event.c (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/event.h (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/init.c (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/init.h (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/io.c (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/io.h (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/main.c (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/ps.c (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/ps.h (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/reg.h (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/rx.c (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/rx.h (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/sdio.c (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/spi.c (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/spi.h (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/tx.c (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/tx.h (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/wl1251.h (100%)
 rename drivers/net/wireless/{ =3D> ti}/wl1251/wl12xx_80211.h (100%)
 create mode 100644 drivers/net/wireless/ti/wl12xx/Kconfig
 create mode 100644 drivers/net/wireless/ti/wl12xx/Makefile
 create mode 100644 drivers/net/wireless/ti/wl12xx/acx.c
 create mode 100644 drivers/net/wireless/ti/wl12xx/acx.h
 create mode 100644 drivers/net/wireless/ti/wl12xx/cmd.c
 create mode 100644 drivers/net/wireless/ti/wl12xx/cmd.h
 create mode 100644 drivers/net/wireless/ti/wl12xx/conf.h
 create mode 100644 drivers/net/wireless/ti/wl12xx/main.c
 rename drivers/net/wireless/{ =3D> ti}/wl12xx/reg.h (71%)
 create mode 100644 drivers/net/wireless/ti/wl12xx/wl12xx.h
 create mode 100644 drivers/net/wireless/ti/wlcore/Kconfig
 create mode 100644 drivers/net/wireless/ti/wlcore/Makefile
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/acx.c (97%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/acx.h (99%)
 create mode 100644 drivers/net/wireless/ti/wlcore/boot.c
 create mode 100644 drivers/net/wireless/ti/wlcore/boot.h
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/cmd.c (84%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/cmd.h (87%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/conf.h (94%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/debug.h (99%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/debugfs.c (99%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/debugfs.h (98%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/event.c (91%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/event.h (98%)
 create mode 100644 drivers/net/wireless/ti/wlcore/hw_ops.h
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/ini.h (100%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/init.c (93%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/init.h (98%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/io.c (55%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/io.h (71%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/main.c (85%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/ps.c (97%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/ps.h (98%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/rx.c (69%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/rx.h (92%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/scan.c (95%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/scan.h (98%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/sdio.c (98%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/spi.c (99%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/testmode.c (99%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/testmode.h (100%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/tx.c (90%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/tx.h (97%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/wl12xx.h (68%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/wl12xx_80211.h (100%)
 rename drivers/net/wireless/{wl12xx =3D> ti/wlcore}/wl12xx_platform_data.c=
 (100%)
 create mode 100644 drivers/net/wireless/ti/wlcore/wlcore.h
 delete mode 100644 drivers/net/wireless/wl12xx/Kconfig
 delete mode 100644 drivers/net/wireless/wl12xx/Makefile
 delete mode 100644 drivers/net/wireless/wl12xx/boot.c
 delete mode 100644 drivers/net/wireless/wl12xx/boot.h

--=20
Cheers,
Luca.

--=-KbOSVWzjAQFAqvsgpOrV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPhs+lAAoJEKFHnKIaPMX6+9cQAImwSCm/wvO8hsEUAV5O5eSb
iijOyH/+F/eUUwv9Q055BDGT6lInu+TNzuYUIzhzA4UI2LJi7PySlKh3bhhCmJAy
HBYZtvfdPAn+ChZjII8/DdHkiTvETs2ShXEnEHOe1y9W4uubPvpKIma4SIVKOWEJ
A/VgSr/Z0UUJ0xRkEjHzfdCV4B0CVfUaT/wvX0ymNRDn4tddYVJU6UqGSqoVoBpE
0494k8u91T3y91USIKNlYjXhRjsOaVqDX8e15o+Y6N0IKZgSYric5sYAIovzQpU/
VeXkBANW2pohsWHvM08YQLXiIPQQs4+o4CHja1eYBMeuDyHUiqevNHGfeJSmNuU9
oVnqbK1u7jDPsIA0sDZAIht0DNUvL/oeShxa2KYf2mOv90jJpmPw/hwoyYTbF8dn
NRXWbDKW2VYn3HGVokmKm5K4hkUtKX4ogBri7rJPLNQdDoazmxNSdJ5FgUXnCEJ1
v9QXQrsA1x7qyzS4pnuP+zmfulyKpkuOGBpkiDhweiB7yTNXCmVsUsYiv1sivXVd
qpPWFr/2YbED8oPv5eH796F2VVGJouz4b7U2d8/wO+JtBChAgNjtUqBqEXz8O4XK
C6OSU6PC3e3ub2ihmduBGCp+5GtbiyfYWBM0Vu+hUnjC9jUfjbVVqtKpi0V9Vshr
ieRNTWBe6E+4Frup+l7v
=rsRq
-----END PGP SIGNATURE-----

--=-KbOSVWzjAQFAqvsgpOrV--

