Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43401 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbZCaCai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 22:30:38 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/9] atheros: start merge of ath5k/ath9k/ar9170
Date: Mon, 30 Mar 2009 22:30:26 -0400
Message-Id: <1238466635-23280-1-git-send-email-lrodriguez@atheros.com> (sfid-20090331_043043_299072_6B3809B4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series starts work to start sharing code between atheros
wireless drivers. We start off with the sharing of the atheros
regulatory work.

This patch series applies on top of Sujiths' latest series
and Bob's channel fixes for ath5k, "reduce exported channel list".

I've done testing with ath9k, and ath5k. I believe Bob has tested
ath5k more, and Chris himself sent the ar9170 patch, this just
brings it all together.

The last few patches are space cleanups and a sparse fix.

We can now extend the common ath.ko module as we see fit when we
find common elements.

Much thanks to Bob and Chris for their work on this.

You can find Sujith's series + bob's patchs + this series in
one file here:

http://bombadil.infradead.org/~mcgrof/patches/ath/super-unholy-unibomb.patch.txt

Bob Copeland (5):
  ath9k: separate ath9k specific code from ath9k_regd_get_ctl()
  ath9k: pass regd structure directly to regulatory functions
  atheros: introduce ath module containing common ath5k/ath9k/ar9170
    code
  ath: move more setup code into ath_regd_init
  ath5k: use regulatory infrastructure

Christian Lamparter (1):
  Make ar9170 use common ath reg code

Luis R. Rodriguez (3):
  atheros: put atheros wireless drivers into ath/
  ath: space cleanup
  ath5k: sparse fix ath5k_led_on needs to be static

 drivers/net/wireless/Kconfig                      |    4 +-
 drivers/net/wireless/Makefile                     |    4 +-
 drivers/net/wireless/ath/Kconfig                  |    8 +
 drivers/net/wireless/ath/Makefile                 |    7 +
 drivers/net/wireless/{ => ath}/ar9170/Kconfig     |    1 +
 drivers/net/wireless/{ => ath}/ar9170/Makefile    |    0
 drivers/net/wireless/{ => ath}/ar9170/ar9170.h    |    3 +
 drivers/net/wireless/{ => ath}/ar9170/cmd.c       |    0
 drivers/net/wireless/{ => ath}/ar9170/cmd.h       |    0
 drivers/net/wireless/{ => ath}/ar9170/eeprom.h    |    0
 drivers/net/wireless/{ => ath}/ar9170/hw.h        |    0
 drivers/net/wireless/{ => ath}/ar9170/led.c       |    0
 drivers/net/wireless/{ => ath}/ar9170/mac.c       |    0
 drivers/net/wireless/{ => ath}/ar9170/main.c      |   18 ++
 drivers/net/wireless/{ => ath}/ar9170/phy.c       |    0
 drivers/net/wireless/{ => ath}/ar9170/usb.c       |    0
 drivers/net/wireless/{ => ath}/ar9170/usb.h       |    0
 drivers/net/wireless/{ => ath}/ath5k/Kconfig      |    1 +
 drivers/net/wireless/{ => ath}/ath5k/Makefile     |    0
 drivers/net/wireless/{ => ath}/ath5k/ath5k.h      |    5 +-
 drivers/net/wireless/{ => ath}/ath5k/attach.c     |    0
 drivers/net/wireless/{ => ath}/ath5k/base.c       |   20 ++
 drivers/net/wireless/{ => ath}/ath5k/base.h       |    0
 drivers/net/wireless/{ => ath}/ath5k/caps.c       |    0
 drivers/net/wireless/{ => ath}/ath5k/debug.c      |    0
 drivers/net/wireless/{ => ath}/ath5k/debug.h      |    0
 drivers/net/wireless/{ => ath}/ath5k/desc.c       |    0
 drivers/net/wireless/{ => ath}/ath5k/desc.h       |    0
 drivers/net/wireless/{ => ath}/ath5k/dma.c        |    0
 drivers/net/wireless/{ => ath}/ath5k/eeprom.c     |    0
 drivers/net/wireless/{ => ath}/ath5k/eeprom.h     |    0
 drivers/net/wireless/{ => ath}/ath5k/gpio.c       |    0
 drivers/net/wireless/{ => ath}/ath5k/initvals.c   |    0
 drivers/net/wireless/{ => ath}/ath5k/led.c        |    2 +-
 drivers/net/wireless/{ => ath}/ath5k/pcu.c        |    0
 drivers/net/wireless/{ => ath}/ath5k/phy.c        |    0
 drivers/net/wireless/{ => ath}/ath5k/qcu.c        |    0
 drivers/net/wireless/{ => ath}/ath5k/reg.h        |    0
 drivers/net/wireless/{ => ath}/ath5k/reset.c      |    0
 drivers/net/wireless/{ => ath}/ath5k/rfbuffer.h   |    0
 drivers/net/wireless/{ => ath}/ath5k/rfgain.h     |    0
 drivers/net/wireless/{ => ath}/ath9k/Kconfig      |    1 +
 drivers/net/wireless/{ => ath}/ath9k/Makefile     |    1 -
 drivers/net/wireless/{ => ath}/ath9k/ahb.c        |    0
 drivers/net/wireless/{ => ath}/ath9k/ani.c        |    0
 drivers/net/wireless/{ => ath}/ath9k/ani.h        |    0
 drivers/net/wireless/{ => ath}/ath9k/ath9k.h      |    0
 drivers/net/wireless/{ => ath}/ath9k/beacon.c     |    0
 drivers/net/wireless/{ => ath}/ath9k/calib.c      |    0
 drivers/net/wireless/{ => ath}/ath9k/calib.h      |    0
 drivers/net/wireless/{ => ath}/ath9k/debug.c      |    0
 drivers/net/wireless/{ => ath}/ath9k/debug.h      |    0
 drivers/net/wireless/{ => ath}/ath9k/eeprom.c     |    0
 drivers/net/wireless/{ => ath}/ath9k/eeprom.h     |    2 +
 drivers/net/wireless/{ => ath}/ath9k/hw.c         |   21 ++-
 drivers/net/wireless/{ => ath}/ath9k/hw.h         |    5 +-
 drivers/net/wireless/{ => ath}/ath9k/initvals.h   |    0
 drivers/net/wireless/{ => ath}/ath9k/mac.c        |    0
 drivers/net/wireless/{ => ath}/ath9k/mac.h        |    0
 drivers/net/wireless/{ => ath}/ath9k/main.c       |   42 ++--
 drivers/net/wireless/{ => ath}/ath9k/pci.c        |    0
 drivers/net/wireless/{ => ath}/ath9k/phy.c        |    0
 drivers/net/wireless/{ => ath}/ath9k/phy.h        |    0
 drivers/net/wireless/{ => ath}/ath9k/rc.c         |    0
 drivers/net/wireless/{ => ath}/ath9k/rc.h         |    0
 drivers/net/wireless/{ => ath}/ath9k/recv.c       |    0
 drivers/net/wireless/{ => ath}/ath9k/reg.h        |    0
 drivers/net/wireless/{ => ath}/ath9k/virtual.c    |    0
 drivers/net/wireless/{ => ath}/ath9k/xmit.c       |    0
 drivers/net/wireless/{ath9k => ath}/regd.c        |  242 ++++++++++++---------
 drivers/net/wireless/{ath9k => ath}/regd.h        |   41 +++-
 drivers/net/wireless/{ath9k => ath}/regd_common.h |    0
 72 files changed, 274 insertions(+), 154 deletions(-)
 create mode 100644 drivers/net/wireless/ath/Kconfig
 create mode 100644 drivers/net/wireless/ath/Makefile
 rename drivers/net/wireless/{ => ath}/ar9170/Kconfig (96%)
 rename drivers/net/wireless/{ => ath}/ar9170/Makefile (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/ar9170.h (99%)
 rename drivers/net/wireless/{ => ath}/ar9170/cmd.c (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/cmd.h (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/eeprom.h (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/hw.h (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/led.c (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/mac.c (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/main.c (98%)
 rename drivers/net/wireless/{ => ath}/ar9170/phy.c (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/usb.c (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/usb.h (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/Kconfig (98%)
 rename drivers/net/wireless/{ => ath}/ath5k/Makefile (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/ath5k.h (99%)
 rename drivers/net/wireless/{ => ath}/ath5k/attach.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/base.c (99%)
 rename drivers/net/wireless/{ => ath}/ath5k/base.h (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/caps.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/debug.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/debug.h (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/desc.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/desc.h (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/dma.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/eeprom.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/eeprom.h (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/gpio.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/initvals.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/led.c (99%)
 rename drivers/net/wireless/{ => ath}/ath5k/pcu.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/phy.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/qcu.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/reg.h (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/reset.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/rfbuffer.h (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/rfgain.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/Kconfig (97%)
 rename drivers/net/wireless/{ => ath}/ath9k/Makefile (96%)
 rename drivers/net/wireless/{ => ath}/ath9k/ahb.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/ani.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/ani.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/ath9k.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/beacon.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/calib.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/calib.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/debug.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/debug.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/eeprom.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/eeprom.h (99%)
 rename drivers/net/wireless/{ => ath}/ath9k/hw.c (99%)
 rename drivers/net/wireless/{ => ath}/ath9k/hw.h (99%)
 rename drivers/net/wireless/{ => ath}/ath9k/initvals.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/mac.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/mac.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/main.c (98%)
 rename drivers/net/wireless/{ => ath}/ath9k/pci.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/phy.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/phy.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/rc.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/rc.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/recv.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/reg.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/virtual.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/xmit.c (100%)
 rename drivers/net/wireless/{ath9k => ath}/regd.c (65%)
 rename drivers/net/wireless/{ath9k => ath}/regd.h (85%)
 rename drivers/net/wireless/{ath9k => ath}/regd_common.h (100%)

