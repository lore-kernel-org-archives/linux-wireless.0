Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:33114
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933622AbXCEVeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2007 16:34:22 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Linville, John" <linville@tuxdriver.com>
Subject: Please pull http://bu3sch.de/git/wireless-dev.git for-linville
Date: Mon, 5 Mar 2007 22:33:29 +0100
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Message-Id: <200703052233.30189.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This batch of patches includes a few critical bugfixes
and bugfixes for issues just reported in the -mm kernel.




The following changes since commit 96f93b6fbd8b2cd454ede3a9b75bbd98415164d8:
  Ivo van Doorn:
        rt2x00: fix NULL pointer exception

are found in the git repository at:

  http://bu3sch.de/git/wireless-dev.git for-linville

Michael Buesch:
      bcm43xx-mac80211: fix a sparse warning
      ssb: Save lots of memory by shrinking struct ssb_device.
      bcm43xx-mac80211: Ignore any IRQ that's not for us.
      bcm43xx-mac80211: Flip radio_ver conditional in b5 init.
      bcm43xx-mac80211: Don't free beacon_control, as it's not allocated dynamically.
      bcm43xx-mac80211: bcm43xx-pcmcia must depend on PCMCIA
      Subject: bcm43xx-mac80211: Put the PCI stub into main.c
      ssb: Fix compile of OHCI core driver.
      ssb: Don't poke with dev->drvdata in SSB to avoid a conflict with USB OHCI.
      ssb-ohci: Proper start/reset and suspend/resume routines.

 drivers/net/b44.c                                  |   50 ++++---
 drivers/net/wireless/mac80211/bcm43xx/Kconfig      |    2 
 drivers/net/wireless/mac80211/bcm43xx/Makefile     |    1 
 drivers/net/wireless/mac80211/bcm43xx/bcm43xx.h    |    3 
 .../net/wireless/mac80211/bcm43xx/bcm43xx_dma.c    |   16 +--
 .../net/wireless/mac80211/bcm43xx/bcm43xx_main.c   |   56 +++++++--
 .../net/wireless/mac80211/bcm43xx/bcm43xx_pci.c    |   61 ----------
 .../net/wireless/mac80211/bcm43xx/bcm43xx_pci.h    |   22 ----
 .../net/wireless/mac80211/bcm43xx/bcm43xx_phy.c    |    2 
 .../net/wireless/mac80211/bcm43xx/bcm43xx_sysfs.c  |    4 -
 drivers/ssb/core.c                                 |  136 ++++++++++++++++----
 drivers/ssb/scan.c                                 |   20 ---
 drivers/ssb/ssb_private.h                          |    1 
 drivers/usb/host/Kconfig                           |   20 +--
 drivers/usb/host/ohci-hcd.c                        |   19 +++
 drivers/usb/host/ohci-ssb.c                        |  100 +++++++++++----
 include/linux/ssb/ssb.h                            |   25 +++-
 17 files changed, 311 insertions(+), 227 deletions(-)
 delete mode 100644 drivers/net/wireless/mac80211/bcm43xx/bcm43xx_pci.c
 delete mode 100644 drivers/net/wireless/mac80211/bcm43xx/bcm43xx_pci.h

-- 
Greetings Michael.
