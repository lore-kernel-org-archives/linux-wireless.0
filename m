Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:33300 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab0KZJ4W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 04:56:22 -0500
Date: Fri, 26 Nov 2010 10:56:17 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	ath5k-devel@lists.ath5k.org
Message-ID: <18540978.381290765372753.JavaMail.wlan@CHBU500181>
In-Reply-To: <5945195.181290764846445.JavaMail.wlan@CHBU500181>
Subject: [PATCH v6 0/9] ath5k: Add AHB support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches implements AHB bus support for ath5k driver.

General comments for AHB bus support in ath5k:
        * original patches came from Felix Fetikau. I have just made them
		  working on latest wireless testing.
        * tried with access point functionality with WPA2 and without
		  encryption
        * tested on AR5312 and AR2313 for AHB and AR5414 and AR5212 for PCI
        * tested with 2.4GHz and 5GHz band. It seems that some older chipsets
		  including AR5312 need tx descriptor byteswap on big endian systems in
		  software. I can observe that beacons all auto generated frames are
		  sent but software generated frames not. AR2313 deosn't need
		  it and both 11a and 11g seem functional. In madwifi-project, these
		  were platfroms which specify AH_NEED_DESC_SWAP. Second radio on
		  AR5312 seems to work even if byteswapping is set in hardware and not
		  in software. HW bug? At the moment in ath5k byteswapping for TX desc
		  is done in hardware only.
        * compat wireless 2010-11-20 from openwrt was used for testing
        * last two patches have to be applied together because otherwise
          hardware will crash on reset if only number 9 is committed.
          I have kept them separated for better visibility.
          There are three false positive checkpatch warnings from them.

Changes since v5 of the patch:
        * patch 8/9: add missing register accessor functions for AHB from original
         patches. It was causing a crash on module unload.
        * rebased on master-2010-11-23

Felix Fietkau (9):
  ath5k: Use Generic DMA for later support of AHB bus.
  ath5k: Introduce ath5k_init_softc function as in ath9k
  ath5k: Move PCI bus functions to separate file.
  ath5k: Use generic eeprom read from common ath_bus_opts struct.
  ath5k: Check if pci pdev struct is initialized in common functions.
  ath5k: Add a function to read chipset's MAC revision
  ath5k: Add initial registers values for radio RF2317 chip.
  ath5k: Add AHB bus support.
  ath5k: Fix reset and interrupts for AHB type of devices.

 drivers/net/wireless/ath/ath5k/Kconfig    |   17 +-
 drivers/net/wireless/ath/ath5k/Makefile   |    2 +
 drivers/net/wireless/ath/ath5k/ahb.c      |  219 ++++++++++
 drivers/net/wireless/ath/ath5k/ath5k.h    |   65 +++-
 drivers/net/wireless/ath/ath5k/attach.c   |   26 +-
 drivers/net/wireless/ath/ath5k/base.c     |  626 ++++++++++-------------------
 drivers/net/wireless/ath/ath5k/base.h     |    5 +-
 drivers/net/wireless/ath/ath5k/eeprom.c   |   40 +--
 drivers/net/wireless/ath/ath5k/eeprom.h   |    2 +-
 drivers/net/wireless/ath/ath5k/initvals.c |   23 +
 drivers/net/wireless/ath/ath5k/led.c      |   11 +-
 drivers/net/wireless/ath/ath5k/pci.c      |  326 +++++++++++++++
 drivers/net/wireless/ath/ath5k/reg.h      |   25 ++
 drivers/net/wireless/ath/ath5k/reset.c    |  116 ++++--
 drivers/net/wireless/ath/ath5k/sysfs.c    |    4 +-
 15 files changed, 1016 insertions(+), 491 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath5k/ahb.c
 create mode 100644 drivers/net/wireless/ath/ath5k/pci.c

