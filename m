Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:43086 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbaIXAeb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 20:34:31 -0400
Date: Wed, 24 Sep 2014 02:34:23 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux NFC <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [GIT] [3.18] NFC update
Message-ID: <20140924003423.GF4235@zurbaran> (sfid-20140924_023438_104814_AA34EFCE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the NFC pull request for 3.18.

We've had major updates for TI and ST Microelectronics drivers, and a
few NCI related changes.

For TI's trf7970a driver:

- Target mode support for trf7970a
- Suspend/resume support for trf7970a
- DT properties additions to handle different quirks
- A bunch of fixes for smartphone IOP related issues

For ST Microelectronics' ST21NFCA and ST21NFCB drivers:

- ISO15693 support for st21nfcb
- checkpatch and sparse related warning fixes
- Code cleanups and a few minor fixes

Finally, Marvell added ISO15693 support to the NCI stack, together with a
couple of NCI fixes.

Thanks in advance for pulling those in.

The following changes since commit 6a5d088a923854569e20eac4f3f569926d5911ec:

  carl9170: tx: Replace rcu_assign_pointer() with RCU_INIT_POINTER() (2014-08-28 14:50:13 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.18-1

for you to fetch changes up to 094e93592433312548dd5e43d7b24b152f658063:

  NFC: st21nfca: Fix potential double kfree_skb error (2014-09-24 02:02:24 +0200)

----------------------------------------------------------------
Axel Lin (1):
      NFC: st21nfca: Convert to use devm_gpio_request_one

Christophe Ricard (29):
      NFC: st21nfca: Fix sparse: cast to restricted __be32
      NFC: st21nfca: Fix scripts/checkpatch.pl warnings "Missing a blank line after declarations"
      NFC: st21nfcb: Fix scripts/checkpatch.pl error "code indent should use tabs where possible"
      NFC: st21nfcb: Convert to use devm_gpio_request_one
      NFC: st21nfcb: Remove double assignment of .owner in struct device_driver
      NFC: st21nfcb: Remove useless new line in nfc_err call
      NFC: st21nfcb: Remove inappropriate kfree on a previously devm_kzalloc pointer
      NFC: st21nfca: Fix logic when setting session_id
      NFC: st21nfca: Remove useless new line in nfc_err call
      NFC: st21nfca: Change nfcid3 generation
      NFC: st21nfca: Remove useless err == 0 condition
      NFC: st21nfca: Remove useless IS_ERR(skb) conditions
      NFC: st21nfca: Add condition to make sure atr_req->length is valid.
      NFC: st21nfcb: Fix logic when running into i2c read retry
      NFC: st21nfca: Clean up st21nfca.h macros
      NFC: st21nfca: Clean up macros alignment
      NFC: st21nfca: fix "WARNING: else is not generally useful after a break or return"
      NFC: st21nfcb: Remove useless headers
      NFC: st21nfca: Fix few coding style issue
      NFC: st21nfca: Fix potential skb leaks in NFC-DEP code
      NFC: st21nfca: Fix recursive fault when doing p2p in target mode.
      NFC: dts: st21nfcb_i2c: Fix invalid interrupts polarity.
      NFC: st21nfcb: Fix improper management of -EREMOTEIO error code.
      NFC: st21nfcb: Fix improper ndlc T2 management
      NFC: nci: Add support for proprietary RF Protocols
      NFC: st21nfcb: Add ISO15693 Reader/Writer support
      NFC: st21nfcb: remove error output
      NFC: st21nfca: ERR_PTR vs NULL fix
      NFC: st21nfca: Fix potential double kfree_skb error

Emil Goode (1):
      NFC: st21nfca: Remove double assignment of .owner in struct device_driver

Mark A. Greer (44):
      NFC: digital: Add Inititor-side PSL support
      NFC: trf7970a: Add VIN voltage override support
      NFC: trf7970a: Document the 'vin-voltage-override' DTS property
      NFC: trf7970a: Move IRQ Status Read quirk to device tree
      NFC: trf7970a: Document the 'irq-status-read-quirk' DT property
      NFC: trf7970a: Add quirk to keep EN2 low
      NFC: trf7970a: Document the 'en2-rf-quirk' DT property
      NFC: trf7970a: Make gpio labels more readable
      NFC: trf7970a: Remove incorrect of_node_put() call
      NFC: trf7970a: Remove trf7970a_tg_listen_mdaa()
      NFC: trf7970a: Call spi_setup() to configure SPI communication
      NFC: trf7970a: Use spi_sync() instead of spi_write_then_read()
      NFC: trf7970a: Ignore Overflow bit in FIFO Status Register
      NFC: trf7970a: FIFO Size is really 127 bytes
      NFC: trf7970a: Remove unnecessary sleep
      NFC: trf7970a: Disable SYS_CLK Output
      NFC: trf7970a: Initialize when enabling RF
      NFC: trf7970a: Add RF technology specific guard times
      NFC: trf7970a: Recalculate driver timeout values
      NFC: trf7970a: Clear possible spurious interrupt before transmitting
      NFC: trf7970a: Remove unnecessary FIFO reset & RSSI read
      NFC: trf7970a: Prefix TX data when refilling FIFO
      NFC: trf7970a: Only fill FIFO if there is space
      NFC: trf7970a: Handle low-watermark IRQ when transmitting
      NFC: trf7970a: Reread FIFO Status Register when draining FIFO
      NFC: trf7970a: Ensure no more RX data before completing receive
      NFC: trf7970a: Return error code when turning on RF fails
      NFC: trf7970a: Rename TRF7970A_ST_OFF to TRF7970A_ST_RF_OFF
      NFC: trf7970a: Don't assume CONFIG_PM_RUNTIME is enabled
      NFC: trf7970a: Create startup and shutdown routines
      NFC: trf7970a: Add System Suspend/Resume support
      NFC: trf7970a: Delay after initialization
      NFC: trf7970a: Add '_in_' to initiator routines
      NFC: trf7970a: Don't turn off RF if its already off
      NFC: trf7970a: trf7970a_init() turns off the RF transmitter
      NFC: trf7970a: Don't turn on RF if there is already an RF field
      NFC: trf7970a: Cancel timer when error encountered
      NFC: trf7970a: Handle timeout values of zero
      NFC: trf7970a: Add Target Mode Support
      NFC: trf7970a: Add Target Mode Detection Support
      NFC: trf7970a: Remove useless local variable
      NFC: trf7970a: Remove unnecessary local variable initialization
      NFC: trf7970a: Unlock mutex before exiting trf7970a_irq()
      NFC: trf7970a: Unlock mutex before exiting _trf7970a_tg_listen()

Vincent Cuissard (3):
      NFC: NCI: Add support of ISO15693
      NFC: NCI: Fix nci_register_device init sequence
      NFC: NCI: Fix NCI RF FRAME interface usage

 .../devicetree/bindings/net/nfc/st21nfcb.txt       |    2 +-
 .../devicetree/bindings/net/nfc/trf7970a.txt       |    8 +
 drivers/nfc/st21nfca/i2c.c                         |   34 +-
 drivers/nfc/st21nfca/st21nfca.c                    |   59 +-
 drivers/nfc/st21nfca/st21nfca.h                    |   21 -
 drivers/nfc/st21nfca/st21nfca_dep.c                |   59 +-
 drivers/nfc/st21nfcb/i2c.c                         |   67 +-
 drivers/nfc/st21nfcb/ndlc.c                        |    6 +-
 drivers/nfc/st21nfcb/ndlc.h                        |    4 +
 drivers/nfc/st21nfcb/st21nfcb.c                    |   27 +-
 drivers/nfc/st21nfcb/st21nfcb.h                    |    2 -
 drivers/nfc/trf7970a.c                             | 1059 +++++++++++++++++---
 include/net/nfc/nci.h                              |   16 +-
 include/net/nfc/nci_core.h                         |    9 +-
 net/nfc/digital_dep.c                              |  101 ++
 net/nfc/nci/core.c                                 |   21 +-
 net/nfc/nci/data.c                                 |    7 +-
 net/nfc/nci/ntf.c                                  |   40 +-
 18 files changed, 1188 insertions(+), 354 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
