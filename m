Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:58556 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdAMEOw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 23:14:52 -0500
Date: Fri, 13 Jan 2017 04:50:32 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org, lede-dev@lists.infradead.org,
        openwrt-devel@lists.openwrt.org, john@phrozen.org, nbd@nbd.name,
        roman@advem.lv, evaxige@qq.com, c.mignanti@gmail.com,
        michel.stempin@wanadoo.fr, vasilugin@yandex.ru,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [RFC] [PULL REQUEST] rt2x00 patches from OpenWrt.org
Message-ID: <20170113035020.GA9063@makrotopia.org> (sfid-20170113_051456_093267_032968AC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

In preparation to be submitted upstream I started to clean up a huge
pile of patches for rt2x00 we have been carrying along for quite a
while (some for more than half a decade!).
Some of them are fixes, most importantly Serge Vasilugin fixed setting
the HT20/HT40 filter which got us much closer to the expected
performance when using HT40 modes.

And also a lot of new added hardware support:
Gabor Juhos wrote code for Rt3883 WiSoC.
Daniel Golle implemented support for Rt3352 by designs with external PA
as well as for boards using a 20MHz crystal instead of the usual 40MHz.
Serge Vasilugin contributed support for the Rt5350 WiSoC.
Michel Stempin, Felix Fietkau and John Crispin have been helping with
cleaning up things and putting away legal doubts.

Please review and comment, so we can get those patches merged!


Cheers


Daniel


The following changes since commit cc75c577806a53893122829d91cb122b51643a2d:

  mwifiex: get rid of global save_adapter and sdio_work (2017-01-12 16:49:18 +0200)

are available in the git repository at:

  https://github.com/dangowrt/linux.git rt2x00-from-openwrt

for you to fetch changes up to fb8832d1896475059c964c75ab4baaf94199143c:

  rt2x00: fix WARN_ON_ONCE() caused by inbalanced set/clear of beacon enable bit (2017-01-13 04:17:57 +0100)

----------------------------------------------------------------
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
      rt2x00: rt2800mmio: add a workaround for spurious TX_FIFO_STATUS interrupts

Michel Stempin (1):
      rt2x00: add support for RT5350 WiSoC

Serge Vasilugin (1):
      rt2x00 correctly set ht20/ht40 filter

evaxige (1):
      rt2x00: fix WARN_ON_ONCE() caused by inbalanced set/clear of beacon enable bit

 drivers/net/wireless/ralink/rt2x00/Kconfig      |    2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800.h     |   79 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c  | 1006 ++++++++++++++++++++++-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h  |   63 ++
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c |   98 ++-
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.h |    4 +
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c  |   14 +
 drivers/net/wireless/ralink/rt2x00/rt2800soc.c  |   12 +-
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c  |   31 +
 drivers/net/wireless/ralink/rt2x00/rt2x00.h     |   10 +
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c  |    7 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c  |    8 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00pci.c  |    2 +
 13 files changed, 1254 insertions(+), 82 deletions(-)
