Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:48819 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758280AbZACNoy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jan 2009 08:44:54 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [RFC 00/12] ath9k: add preliminary support for the AR913x SoCs
Date: Sat,  3 Jan 2009 14:44:10 +0100
Message-Id: <1230990262-22923-1-git-send-email-juhosg@openwrt.org> (sfid-20090103_144500_578753_FD5CE589)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set introduces preliminary support for the Atheros' AR9130/AR9132
SoCs built-in WMAC device. Tested with compat-wireless-2008-12-29 on 2.6.2{7,8} 
kernels.

12 patches will follow as replies:

Gabor Juhos (12):
      ath9k: introduce bus specific DMA routines
      ath9k: introduce bus specific register access routines
      ath9k: introduce bus specific cache size routine
      ath9k: introduce bus specific cleanup routine
      ath9k: move PCI code into separate file
      ath9k: convert to struct device
      ath9k: introduce platform driver for AHB bus support
      ath9k: get EEPROM contents from platform data on AHB bus
      ath9k: enable support for AR9100
      ath9k: remove (u16) casts from rtc register access
      ath9k: fix ar5416Addac_9100 values
      ath9k: fix null pointer dereference in ani monitor code

 drivers/net/wireless/ath9k/Makefile   |    2 
 drivers/net/wireless/ath9k/ahb.c      |  285 +++++++++++++++++++++++++
 drivers/net/wireless/ath9k/ani.c      |    6 -
 drivers/net/wireless/ath9k/ath9k.h    |    4 
 drivers/net/wireless/ath9k/beacon.c   |   29 +--
 drivers/net/wireless/ath9k/core.h     |  137 ++++++++++++
 drivers/net/wireless/ath9k/eeprom.c   |   51 ----
 drivers/net/wireless/ath9k/hw.c       |   17 +
 drivers/net/wireless/ath9k/initvals.h |    2 
 drivers/net/wireless/ath9k/main.c     |  315 +++------------------------
 drivers/net/wireless/ath9k/pci.c      |  381 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath9k/recv.c     |   30 +--
 drivers/net/wireless/ath9k/xmit.c     |   12 -
 include/linux/ath9k_platform.h        |   28 ++
 14 files changed, 913 insertions(+), 386 deletions(-)
 create mode 100644 drivers/net/wireless/ath9k/ahb.c
 create mode 100644 drivers/net/wireless/ath9k/pci.c
 create mode 100644 include/linux/ath9k_platform.h
