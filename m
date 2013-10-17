Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48757 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab3JQHmn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:42:43 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 00/21] rt2x00: separate rt2800 PCI and SoC driver
Date: Thu, 17 Oct 2013 09:42:14 +0200
Message-Id: <1381995755-16471-1-git-send-email-juhosg@openwrt.org> (sfid-20131017_094250_348242_1DDDB116)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rt2800pci driver supports both PCI and SoC device. To achieve
this, the code uses several ifdef statements which makes the code
quite ugly. The patch set introduces a shared module, and moves the
SoC driver into a separate module to get rid of the mess.


Gabor Juhos (21):
  rt2x00: create a new module for rt2800 MMIO code
  rt2x00: rt2800pci: use rt2800mmio prefix for TX descriptor functions
  rt2x00: rt2800pci: move TX descriptor functions to the rt2800mmio module
  rt2x00: rt2800pci: use rt2800mmio prefix for RX control handler functions
  rt2x00: rt2800pci: move RX control handler functions to the rt2800mmio module
  rt2x00: rt2800pci: use rt2800mmio prefix for interrupt functions
  rt2x00: rt2800pci: move interrupt functions to the rt2800mmio module
  rt2x00: rt2800pci: use rt2800mmio prefix for queue functions
  rt2x00: rt2800pci: move queue functions to the rt2800mmio module
  rt2x00: rt2800pci: use rt2800mmio prefix for initialization functions
  rt2x00: rt2800pci: move initialization functions to the rt2800mmio module
  rt2x00: rt2800pci: use separate ops for the SoC driver
  rt2x00: rt2800pci: use separate read_eeprom callback for SoC devices
  rt2x00: rt2800pci: use separate firmware callbacks for SoC devices
  rt2x00: rt2800pci: use separate set_state callback for SoC devices
  rt2x00: rt2800pci: rename rt2800pci_disable_radio function
  rt2x00: rt2800pci: split rt2800pci_enable_radio function
  rt2x00: rt2800pci: move rt2800mmio_enable_radio function to another module
  rt2x00: rt2800pci: use separate hwcrypt_disabled callback for SoC devices
  rt2x00: rt2800pci: move SoC specific code into a separate module
  rt2x00: rt2800pci: use module_pci_driver macro

 drivers/net/wireless/rt2x00/Kconfig      |   27 +-
 drivers/net/wireless/rt2x00/Makefile     |    2 +
 drivers/net/wireless/rt2x00/rt2800mmio.c |  873 +++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800mmio.h |  165 ++++++
 drivers/net/wireless/rt2x00/rt2800pci.c  |  951 +-----------------------------
 drivers/net/wireless/rt2x00/rt2800pci.h  |   97 ---
 drivers/net/wireless/rt2x00/rt2800soc.c  |  263 +++++++++
 7 files changed, 1348 insertions(+), 1030 deletions(-)
 create mode 100644 drivers/net/wireless/rt2x00/rt2800mmio.c
 create mode 100644 drivers/net/wireless/rt2x00/rt2800mmio.h
 create mode 100644 drivers/net/wireless/rt2x00/rt2800soc.c

--
1.7.10
