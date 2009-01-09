Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:39996 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972AbZAIMZv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 07:25:51 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Christoph Hellwig <hch@infradead.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 00/11] ath9k: add preliminary support for the AR913x SoCs
Date: Fri,  9 Jan 2009 13:24:17 +0100
Message-Id: <1231503868-29226-1-git-send-email-juhosg@openwrt.org> (sfid-20090109_132606_446954_B35265EE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set introduces preliminary support for the Atheros' AR9130/AR9132
SoCs built-in WMAC device. Tested with compat-wireless-2009-01-07 and 2.6.27.10 
kernel on the following devices:
  * Atheros AP83-050 reference board (AR9132 SoC, AR9103 RF)
  * TRENDnet TEW-632BRP router (AR9130 SoC, AR9102 RF)
  * Mikrotik RB433 board (AR7161 SoC) + AR5416 based miniPCI card

Changes since v1:
  * enabling support of the AR9100 has been moved to the end of the series
  * bus specific cleanup routine has been rewritten
  * PCI code converted to use 'softc.irq' as well
  * setup of 'hw->flags' and 'hw->wiphy->interface_modes' has been removed 
    from ath_ahb_probe()
  * unregistering of the ath_ahb_diver has been fixed

Changes since RFC:
  * bus specific DMA routines removed
  * bus specific register access routines removed
  * irq value is stored in softc
  * rebased against master-2009-01-06 of wireless-testing
  
11 patches will follow as replies:

Gabor Juhos (11):
      ath9k: convert to struct device
      ath9k: convert to use bus-agnostic DMA routines
      ath9k: introduce bus specific cache size routine
      ath9k: introduce bus specific cleanup routine
      ath9k: move PCI code into separate file
      ath9k: introduce platform driver for AHB bus support
      ath9k: get EEPROM contents from platform data on AHB bus
      ath9k: remove (u16) casts from rtc register access
      ath9k: fix ar5416Addac_9100 values
      ath9k: fix null pointer dereference in ani monitor code
      ath9k: enable support for AR9100

 drivers/net/wireless/ath9k/Makefile   |    2 
 drivers/net/wireless/ath9k/ahb.c      |  187 +++++++++++++++++++
 drivers/net/wireless/ath9k/ani.c      |    6 -
 drivers/net/wireless/ath9k/beacon.c   |   28 +--
 drivers/net/wireless/ath9k/core.h     |   47 +++++
 drivers/net/wireless/ath9k/eeprom.c   |   51 -----
 drivers/net/wireless/ath9k/hw.c       |   17 +-
 drivers/net/wireless/ath9k/initvals.h |    2 
 drivers/net/wireless/ath9k/main.c     |  326 +++++----------------------------
 drivers/net/wireless/ath9k/pci.c      |  305 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath9k/recv.c     |   24 +-
 drivers/net/wireless/ath9k/xmit.c     |   14 +
 include/linux/ath9k_platform.h        |   28 +++
 13 files changed, 663 insertions(+), 374 deletions(-)
 create mode 100644 drivers/net/wireless/ath9k/ahb.c
 create mode 100644 drivers/net/wireless/ath9k/pci.c
 create mode 100644 include/linux/ath9k_platform.h
