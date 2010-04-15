Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54735 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715Ab0DODax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 00/97] ath9k: add AR9003 support
Date: Wed, 14 Apr 2010 23:29:14 -0400
Message-Id: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a respin of our last series for AR9003 support. We've taken
the feedback given and made a few respective changes. The initval
Lindent patch was completely removed, instead we figure we'll address
a new style for the new initvals after this series. We've fixed a few
bugs while addressing some of the feedback, and at the same time have
taken the time to merge a few patches together where it made sense,
namely in the EEPROM area.

All these patches have been tested with sparse v0.4.2 and checkpatch.pl,
the only remaining complaints you'll see are for volatile use for gcc
bug #37014 [1], one false positive which we need to fix upstream on
checkpatch [2], and the usual WARNINGs for > 80 lines on header files
for macros, and just a few places in code where it was just not
a good idea yet to split the code to avoid the 80 column length.

The new style for the initvals will be addressed by using a userspace
program [3] which reads the existing initvals and regenerates it at our will.
This same program was also used by us to verify the integrity of the
initvals during our code shuffle, the checksums for existing wireless-testing
and after this patch series matches.

Worth noting also is we have disabled ANI, although it has been
working for us, our systems team has not completed its testing
yet so no point in filing bugs for it if its not working yet :)
TX interrupt mitigation is also disabled due to pervious issues we
(ath9k) have seen with AR9280, we'll enable it later after some more
testing.

I'll note I've used -M on this patch series on forma-patch, please let
me know if there are any issues with it.

[1] http://gcc.gnu.org/bugzilla/show_bug.cgi?id=37014
[2] ERROR: trailing statements should be on next line
#576: FILE: drivers/net/wireless/ath/ath9k/recv.c:734:
+       while (ath_edma_get_buffers(sc, qtype));
[3] git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/initvals.git

Felix Fietkau (14):
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
  ath9k_hw: move AR9280 PCI EEPROM fix to eeprom_def.c
  ath9k_hw: Update ath9k_hw_set_dma for AR9300

Luis R. Rodriguez (52):
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
  ath9k_hw: disable ANI for AR9003
  ath9k: disable the MIB interrupt if ANI is disabled
  ath9k_hw: add common channel select helpers for ar900[23]
  ath9k_hw: split initvals.h by hardware family
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
  ath9k_hw: complete AR9003 calibration
  ath9k_hw: rename eep_AR9287_ops to eep_ar9287_ops
  ath9k_hw: restore mac address reading logic
  ath9k_hw: add OFDM spur mitigation for AR9003
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
  ath9k_hw: the eep_map is used only for AR9280 PCI card ini fixup
  ath9k_hw: Implement AR9003 eeprom callbacks

Vasanthakumar Thiagarajan (26):
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
  ath9k: Add Tx EDMA support
  ath9k: Enable TXOK and TXERR interrupts for TX EDMA
  ath9k_hw: Abort rx if hw is not coming out of full sleep in reset

 drivers/net/wireless/ath/ath9k/Makefile            |   16 +-
 drivers/net/wireless/ath/ath9k/ani.c               |  185 +--
 drivers/net/wireless/ath/ath9k/ar5008_initvals.h   |  742 ++++++++
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        | 1347 +++++++++++++
 drivers/net/wireless/ath/ath9k/ar9001_initvals.h   | 1254 +++++++++++++
 drivers/net/wireless/ath/ath9k/ar9002_calib.c      |  995 ++++++++++
 drivers/net/wireless/ath/ath9k/ar9002_hw.c         |  588 ++++++
 .../ath/ath9k/{initvals.h => ar9002_initvals.h}    | 1984 +-------------------
 drivers/net/wireless/ath/ath9k/ar9002_mac.c        |  462 +++++
 drivers/net/wireless/ath/ath9k/ar9002_phy.c        |  534 ++++++
 drivers/net/wireless/ath/ath9k/ar9002_phy.h        |  572 ++++++
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |  802 ++++++++
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     | 1856 ++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |  323 ++++
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |  204 ++
 drivers/net/wireless/ath/ath9k/ar9003_initvals.h   | 1793 ++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |  610 ++++++
 drivers/net/wireless/ath/ath9k/ar9003_mac.h        |  124 ++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        | 1142 +++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |  847 +++++++++
 drivers/net/wireless/ath/ath9k/ath9k.h             |   24 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |    5 +-
 drivers/net/wireless/ath/ath9k/calib.c             | 1089 +-----------
 drivers/net/wireless/ath/ath9k/calib.h             |   19 +-
 drivers/net/wireless/ath/ath9k/common.h            |    4 +-
 drivers/net/wireless/ath/ath9k/debug.c             |   22 +-
 drivers/net/wireless/ath/ath9k/debug.h             |    4 +
 drivers/net/wireless/ath/ath9k/eeprom.c            |    9 +-
 drivers/net/wireless/ath/ath9k/eeprom.h            |   22 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c         |    7 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c       |    9 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c        |   13 +-
 drivers/net/wireless/ath/ath9k/hw-ops.h            |  280 +++
 drivers/net/wireless/ath/ath9k/hw.c                | 1646 +++--------------
 drivers/net/wireless/ath/ath9k/hw.h                |  229 +++-
 drivers/net/wireless/ath/ath9k/init.c              |   38 +-
 drivers/net/wireless/ath/ath9k/mac.c               |  447 ++---
 drivers/net/wireless/ath/ath9k/mac.h               |   51 +-
 drivers/net/wireless/ath/ath9k/main.c              |   51 +-
 drivers/net/wireless/ath/ath9k/pci.c               |    1 +
 drivers/net/wireless/ath/ath9k/phy.c               |  978 ----------
 drivers/net/wireless/ath/ath9k/phy.h               |  584 +------
 drivers/net/wireless/ath/ath9k/rc.c                |    9 +
 drivers/net/wireless/ath/ath9k/recv.c              |  517 ++++--
 drivers/net/wireless/ath/ath9k/reg.h               |  167 ++-
 drivers/net/wireless/ath/ath9k/xmit.c              |  364 +++-
 include/net/mac80211.h                             |    2 +
 47 files changed, 16144 insertions(+), 6827 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar5008_initvals.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar5008_phy.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9001_initvals.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_calib.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_hw.c
 rename drivers/net/wireless/ath/ath9k/{initvals.h => ar9002_initvals.h} (79%)
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
 delete mode 100644 drivers/net/wireless/ath/ath9k/phy.c

