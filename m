Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46694 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933075Ab0DHT1j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:39 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 000/102] ath9k: add AR9003 support
Date: Thu,  8 Apr 2010 15:25:56 -0400
Message-Id: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds support for a new chipset family for the ath9k driver,
the AR9003 harware family. This family of chipsets will includes 2-stream
and 3-stream devices. We start off by supporting only 2-streams on both
devices. Both the 2-stream and 3-stream devices are fully functional at
this point. We have a few more items which we will iron out as part
of future patches but we're sending this out so that we don't stall
development on more cleanups/etc. Our delta is already quite large.

For information of the status of this driver you can refer to:

http://wireless.kernel.org/en/users/Drivers/ath9k/todo/ar93xx

You can download an all-in-one series of all these patches here:

http://bombadil.infradead.org/~mcgrof/patches/ath9k/2010/all-04-08-v2.patch

sha1sum:
412524e75fb512603a31211e72ff67c635d5d04d  all-04-08-v2.patch

Felix Fietkau (15):
  ath9k_hw: add silicon revision macros for AR9300
  ath9k_hw: add a macro for abstracting generic timer access
  ath9k_hw: fix a missing hex prefix for a register mask
  ath9k_hw: add simple register abstraction for some AR9300 registers
  ath9k_hw: add support for GPIO differences on AR9003
  ath9k_hw: Add AR9003 PHY register definitions
  ath9k_hw: Set the channel on AR9003
  ath9k_hw: Implement PLL control on AR9003
  ath9k_hw: Implement spur mitigation on AR9003
  ath9k_hw: Split off ANI control to the PHY ops
  ath9k: Add Rx EDMA support
  ath9k_hw: Split out the function for reading the noise floor
  ath9k_hw: Update ath9k_hw_set_dma for AR9300
  ath9k_hw: Handle big-endian access for AR9300 EEPROM reads
  ath9k_hw: Fix internal regulator setting on AR9003

Luis R. Rodriguez (55):
  ath9k_hw: start building an abstraction layer for hardware routines
  ath9k_hw: AR9003 does not have AR_RC_AHB skip its setting
  ath9k_hw: remove wrapper ath9k_hw_write_regs()
  ath9k_hw: Move some RF ops to the private callbacks
  ath9k_hw: skip PLL initialization on AR9003 on Power-On-Reset
  ath9k_hw: add some comments for ath9k_set_power_network_sleep()
  ath9k_hw: add a private callback for PLL control computation
  ath9k_hw: Add AR9003 PHY support
  ath9k_hw: move init config and default after chip is up
  ath9k_hw: add the AR9003 ar9003_hw_macversion_supported()
  ath9k_hw: enable all ANI functionality for AR9003
  ath9k_hw: add common channel select helpers for ar900[23]
  ath9k_hw: split initvals.h by hardware family
  ath9k_hw: run Lindent on intivals
  ath9k_hw: add initvals for the AR9003 hardware family
  ath9k_hw: add helpers for processing the AR9003 INI
  ath9k_hw: add all the AR9003 PHY callbacks
  ath9k_hw: add a helper for Power Amplifier calibration for AR9002
  ath9k_hw: add a helper for the OLC tem compensation for AR9002
  ath9k_hw: rename PA calib for AR9287
  ath9k_hw: shift code for AR9280 OLC temp comp
  ath9k_hw: move the AR9280 OLC temp comp to its own helper
  ath9k_hw: simplify OLC temp compensation for AR9002
  ath9k_hw: rename the PA calib routines to match their families
  ath9k_hw: rename getNoiseFloorThresh() to ath9k_hw_loadnf()
  ath9k_hw: move the cal AR9100 calibration settings
  ath9k_hw: split calib code by hardware families
  ath9k_hw: add the AR9003 ar9003_hw_init_cal callback
  ath9k_hw: add the config_pci_powersave AR9003 callback
  ath9k_hw: split the generic hardware code by hardware family
  ath9k_hw: move the cck channel 14 INI to the AR9002 hw code
  ath9k_hw: move TX/RX gain INI stuff to its own hardware family code
  ath9k_hw: abstract the AR_PHY_AGC_CONTROL register access
  ath9k_hw: abstract loading noisefloor
  ath9k_hw: fill in the callbacks for calibration for AR9003
  ath9k_hw: add a helper for changing the TX/RX masks
  ath9k_hw: complete AR9003 calibration
  ath9k_hw: rename eep_AR9287_ops to eep_ar9287_ops
  ath9k_hw: restore mac address reading logic
  ath9k_hw: add OFDM spur mitigation for AR9003
  ath9k_hw: move AR9280 PCI EEPROM fix to ar9002_hw.c
  ath9k_hw: simplify the AR9280 PCI EEPROM fix
  ath9k_hw: move the RF claim stuff to AR9002 hardware family
  ath9k_hw: add the AR9300 SREV hw name print
  ath9k_hw: add TX/RX gain register initialization for AR9003
  ath9k_hw: skip asynch fifo enablement to AR9003
  ath9k_hw: skip WEP aggregation enable code for AR9003
  ath9k: add RXLP and RXHP to debugfs counters
  ath9k_hw: enable CRC check of descriptors for AR9003
  ath9k_hw: set cwmin and cwmax to 0 for for AR9003 upon txq reset
  ath9k_hw: move AR9002 mac ops to its own file
  mac80211: add LDPC control flag
  ath9k_hw: add LDPC support for AR9003
  ath9k: add LDPC support
  ath9k_hw: add the PCI ID for the first AR9300 device

Senthil Balasubramanian (5):
  ath9k_hw: Add the PCI IDs for AR9300 and fill up the pci_id_tables
  ath9k_hw: update the chip tests for AR9003
  ath9k_hw: prevent reset control register zeroing on AR9003 reset
  ath9k_hw: Get rid of eep_map and reorganize the functions.
  ath9k_hw: Implement AR9003 eeprom callbacks

Vasanthakumar Thiagarajan (27):
  ath9k_hw: Add hw cap flag for EDMA for the AR9003 family
  ath9k_hw: Fill few hw cap for edma
  ath9k_hw: Add abstraction for rx enable
  ath9k_hw: Fill rx_enable() for the AR9003 hardware family
  ath9k_hw: Add few routines for rx edma support
  ath9k_hw: Define tx control struct for AR9003
  ath9k_hw: Move code which populates ds_data to ath9k_hw
  ath9k_hw: Add abstraction to set/get link pointer
  ath9k: Use abstraction to get link pointer
  ath9k: Use memcpy in ath_clone_txbuf()
  ath9k: Remove ATH9K_TX_SW_ABORTED and introduce a bool for this
    purpose
  ath9k: Make bf_desc of ath_buf opaque
  ath9k_hw: Abstract the routine which returns interrupt status
  ath9k_hw: Initialize interrupt mask for AR9003
  ath9k_hw: Fill get_isr() for AR9003
  ath9k_hw: Configure Tx interrupt mitigation timer
  ath9k: Load SW filtered NF values and start NF cal during full reset
    for AR9003
  ath9k_hw: Define abstraction for tx desc access
  ath9k_hw: Add function to configure tx status ring buffer
  ath9k_hw: Fill descriptor abstrations for AR9003
  ath9k: Setup appropriate tx desc for regular dma and edma
  ath9k: Initialize and configure tx status for EDMA
  ath9k_hw: Compute pointer checksum over the link descriptor
  ath9k: Add frame onto hw tx fifo for edma
  ath9k: Enable TXOK and TXERR interrupts for TX EDMA
  ath9k: Handle Tx interrupt for EDMA
  ath9k_hw: Abort rx if hw is not coming out of full sleep in reset

 drivers/net/wireless/ath/ath9k/Makefile          |   16 +-
 drivers/net/wireless/ath/ath9k/ani.c             |  185 +-
 drivers/net/wireless/ath/ath9k/ar5008_initvals.h |  873 +++
 drivers/net/wireless/ath/ath9k/ar5008_phy.c      | 1275 ++++
 drivers/net/wireless/ath/ath9k/ar9001_initvals.h | 1314 ++++
 drivers/net/wireless/ath/ath9k/ar9002_calib.c    |  988 +++
 drivers/net/wireless/ath/ath9k/ar9002_hw.c       |  640 ++
 drivers/net/wireless/ath/ath9k/ar9002_initvals.h | 7768 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9002_mac.c      |  474 ++
 drivers/net/wireless/ath/ath9k/ar9002_phy.c      |  601 ++
 drivers/net/wireless/ath/ath9k/ar9002_phy.h      |  572 ++
 drivers/net/wireless/ath/ath9k/ar9003_calib.c    |  798 +++
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c   | 1841 +++++
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h   |  323 +
 drivers/net/wireless/ath/ath9k/ar9003_hw.c       |  205 +
 drivers/net/wireless/ath/ath9k/ar9003_initvals.h | 1793 +++++
 drivers/net/wireless/ath/ath9k/ar9003_mac.c      |  618 ++
 drivers/net/wireless/ath/ath9k/ar9003_mac.h      |  124 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c      | 1145 ++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h      |  849 +++
 drivers/net/wireless/ath/ath9k/ath9k.h           |   23 +-
 drivers/net/wireless/ath/ath9k/beacon.c          |    5 +-
 drivers/net/wireless/ath/ath9k/calib.c           | 1089 +---
 drivers/net/wireless/ath/ath9k/calib.h           |   19 +-
 drivers/net/wireless/ath/ath9k/common.h          |    4 +-
 drivers/net/wireless/ath/ath9k/debug.c           |    8 +
 drivers/net/wireless/ath/ath9k/debug.h           |    4 +
 drivers/net/wireless/ath/ath9k/eeprom.c          |    9 +-
 drivers/net/wireless/ath/ath9k/eeprom.h          |   22 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c       |    7 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c     |    9 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c      |    7 +-
 drivers/net/wireless/ath/ath9k/hw-ops.h          |  284 +
 drivers/net/wireless/ath/ath9k/hw.c              | 1698 +----
 drivers/net/wireless/ath/ath9k/hw.h              |  232 +-
 drivers/net/wireless/ath/ath9k/init.c            |   38 +-
 drivers/net/wireless/ath/ath9k/initvals.h        | 7200 --------------------
 drivers/net/wireless/ath/ath9k/mac.c             |  435 +-
 drivers/net/wireless/ath/ath9k/mac.h             |   50 +-
 drivers/net/wireless/ath/ath9k/main.c            |   60 +-
 drivers/net/wireless/ath/ath9k/pci.c             |    1 +
 drivers/net/wireless/ath/ath9k/phy.c             |  976 ---
 drivers/net/wireless/ath/ath9k/phy.h             |  584 +--
 drivers/net/wireless/ath/ath9k/rc.c              |    9 +
 drivers/net/wireless/ath/ath9k/recv.c            |  518 ++-
 drivers/net/wireless/ath/ath9k/reg.h             |  166 +-
 drivers/net/wireless/ath/ath9k/xmit.c            |  295 +-
 include/net/mac80211.h                           |    2 +
 48 files changed, 24090 insertions(+), 12066 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar5008_initvals.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar5008_phy.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9001_initvals.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_calib.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_hw.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_initvals.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_mac.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_phy.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_phy.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_calib.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_hw.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_initvals.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_mac.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_mac.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_phy.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_phy.h
 create mode 100644 drivers/net/wireless/ath/ath9k/hw-ops.h
 delete mode 100644 drivers/net/wireless/ath/ath9k/initvals.h
 delete mode 100644 drivers/net/wireless/ath/ath9k/phy.c

