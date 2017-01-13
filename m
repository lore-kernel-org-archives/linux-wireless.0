Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:39158 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751107AbdAMVSc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:18:32 -0500
Date: Fri, 13 Jan 2017 22:18:10 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 00/40] rt2x00 patches form OpenWrt.org
Message-ID: <20170113211804.GA3321@makrotopia.org> (sfid-20170113_221841_054854_CBD4842F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some of these are fixes, most importantly Serge Vasilugin fixed setting
the HT20/HT40 filter which got us much closer to the expected
performance when using HT40 modes.

There is also a lot of new hardware support added:
Gabor Juhos wrote code for the Rt3883 WiSoC.
Daniel Golle implemented support for Rt3352 boards with external PA as
well as for boards using a 20MHz crystal instead of the usual 40MHz.
Serge Vasilugin contributed support for the Rt5350 WiSoC.
Michel Stempin, Felix Fietkau and John Crispin have been helping with
cleaning up things and putting away legal doubts.


Claudio Mignanti (1):
  rt2x00: rt2x00pci: set PCI MWI only if supported

Daniel Golle (2):
  rt2x00: support for for RT3352 with external PA
  rt2x00: add support for RT3352 with 20MHz crystal

Felix Fietkau (1):
  rt2x00: fix rf id for RT3352

Gabor Juhos (34):
  rt2x00: rt2800lib: move rt2800_drv_data declaration into rt2800lib.h
  rt2x00: rt2800lib: introduce RT2800_HAS_HIGH_SHARED_MEM flag
  rt2x00: rt2800: serialize shared memory access
  rt2x00: rt2800lib: fix beacon generation on RT3593
  rt2x00: rt2800lib: add hw_beacon_count field to struct rt2800_drv_data
  rt2x00: rt2800lib: init additional beacon offset registers
  rt2x00: rt2800lib: fix max supported beacon count for RT3593
  rt2x00: allow to build rt2800soc module for RT3883
  rt2x00: rt2800lib: enable support for RT3883
  rt2x00: rt2800lib: add rf_vals for RF3853
  rt2x00: rt2800lib: enable VCO calibration for RF3853
  rt2x00: rt2800lib: add channel configuration function for RF3853
  rt2x00: rt2800lib: enable RF3853 support
  rt2x00: rt2800lib: add MAC register initialization for RT3883
  rt2x00: rt2800soc: fix rt2800soc_disable_radio for RT3883
  rt2x00: rt2800lib: add BBP register initialization for RT3883
  rt2x00: rt2800lib: add RFCSR initialization for RT3883
  rt2x00: rt2800lib: use the extended EEPROM map for RT3883
  rt2x00: rt2800lib: force rf type to RF3853 on RT3883
  rt2x00: rt2800lib: add channel configuration code for RT3883
  rt2x00: rt2800lib: fix txpower_to_dev function for RT3883
  rt2x00: rt2800lib: use correct txpower calculation function for RT3883
  rt2x00: rt2800lib: hardcode txmixer gain values to zero for RT3883
  rt2x00: rt2800lib: use correct [RT]XWI size for RT3883
  rt2x00: rt2800lib: use correct beacon base for RT3883
  rt2x00: rt2800lib: use correct beacon count for RT3883
  rt2x00: rt2800lib: fix antenna configuration for RT3883
  rt2x00: rt2800lib: fix LNA gain configuration for RT3883
  rt2x00: rt2800lib: fix VGC setup for RT3883
  rt2x00: rt2800lib: fix EEPROM LNA validation for RT3883
  rt2x00: rt2800lib: fix txpower compensation for RT3883
  rt2x00: rt2800lib: enable RT2800_HAS_HIGH_SHARED_MEM for RT3883
  rt2x00: rt2800lib: use high memory for beacons on RT3883
  rt2x00: rt2800mmio: add a workaround for spurious TX_FIFO_STATUS
    interrupts

Michel Stempin (1):
  rt2x00: add support for RT5350 WiSoC

Serge Vasilugin (1):
  rt2x00: correctly set HT20/HT40 filter

 drivers/net/wireless/ralink/rt2x00/Kconfig      |    2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800.h     |   77 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c  | 1013 ++++++++++++++++++++++-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h  |   65 ++
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c |   98 ++-
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.h |    4 +
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c  |   14 +
 drivers/net/wireless/ralink/rt2x00/rt2800soc.c  |   12 +-
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c  |   31 +
 drivers/net/wireless/ralink/rt2x00/rt2x00.h     |   10 +
 drivers/net/wireless/ralink/rt2x00/rt2x00pci.c  |    2 +
 11 files changed, 1254 insertions(+), 74 deletions(-)

-- 
2.11.0
