Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41798 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab1FRQFZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:25 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/25] update for 3.1
Date: Sat, 18 Jun 2011 08:34:06 -0700
Message-Id: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180531_214732_60007197)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We introduce the PCI bus encapsulation layer, which is the fundation to
support different bus interface.
We also add few more module parameters to control power management

Emmanuel Grumbach (15):
  iwlagn: don't disable interrupts after the NIC has been reset
  iwlagn: add a iwl_pci.[ch] files that will contain all PCI specific
    code
  iwlagn: remove uneeded include to pci.h and dma_mapping.h from a few
    files
  iwlagn: introduce iwl_bus and iwl_bus_ops
  iwlagn: add get_dev to iwl_bus_ops
  iwlagn: move PCI related operations from probe and remove to PCI
    layer
  iwlagn: don't use the PCI wrappers for DMA operation
  iwlagn: add a method to get the HW ID description as a string to
    iwl_bus_ops
  iwlagn: don't read the PCI_REVISION_ID from iwl-agn.c
  iwlagn: add a get_irq method to iwl_bus_ops and use it
  iwlagn: finally kill the pointer to pci_dev from iwl-dev.h
  iwlagn: waterfall the bus level if prepare card failed
  iwlagn: fix misplaced bracket
  iwlagn: warn about nested SYNC commands
  iwlagn: store the irq number to iwl_bus just like dev

Wey-Yi Guy (10):
  iwlagn: Remove un-necessary indirect call
  iwlagn: add PAN to tx flush
  iwlagn: Support flush queues for specified interface
  iwlagn: move PCI power related functions to the PCI layer
  iwlagn: add power_save module parameter
  iwlagn: Add power_level module parameter
  iwlagn: add offset define for subsystem id
  iwlagn: code alignment
  iwlagn: merge duplicate code into single function
  iwlagn: remove incorrect define

these patches are also available from wireless-next-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/Makefile       |    1 +
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    4 -
 drivers/net/wireless/iwlwifi/iwl-2000.c     |   20 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   23 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   22 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h   |    7 -
 drivers/net/wireless/iwlwifi/iwl-agn-ict.c  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   35 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |   30 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  441 ++++-----------------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    6 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |   23 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |   54 +---
 drivers/net/wireless/iwlwifi/iwl-core.h     |   37 +--
 drivers/net/wireless/iwlwifi/iwl-debug.h    |    8 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    5 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   48 ++-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |   25 ++
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |    3 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |   11 +-
 drivers/net/wireless/iwlwifi/iwl-io.h       |    6 +-
 drivers/net/wireless/iwlwifi/iwl-led.c      |    5 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c      |  571 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-pci.h      |   69 ++++
 drivers/net/wireless/iwlwifi/iwl-power.c    |   22 +-
 drivers/net/wireless/iwlwifi/iwl-power.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-sv-open.c  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   33 +-
 29 files changed, 927 insertions(+), 596 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-pci.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-pci.h

