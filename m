Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:62369 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaAMVUk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 16:20:40 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/8] brcmfmac: cleanup work for 3.14
Date: Mon, 13 Jan 2014 22:20:21 +0100
Message-ID: <1389648029-23560-1-git-send-email-arend@broadcom.com> (sfid-20140113_222045_618831_3B1B67CA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here a small series of patches that hopefully can make it for
the 3.14 merge window. Most changes are on correcting chip core
access on SDIO devices.

The series applies to the master branch of the wireless-next
repository.

Arend van Spriel (6):
  bcma: add agent IOCTL bit values for Broadcom 802.11 and CR4 cores
  brcmfmac: rework firmware download code
  brcmfmac: restructure brcmf_sdio_chip_recognition()
  brcmfmac: rename chip and core related structures
  brcmfmac: initialize escan function pointer during scheduled scan
  brcmfmac: handle SDIO card removal

Hante Meuleman (2):
  brcmfmac: Create common nvram parsing routines.
  brcmfmac: update core reset and disable routines.

 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   40 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |   21 +
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    4 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  339 +++++------
 drivers/net/wireless/brcm80211/brcmfmac/nvram.c    |   94 ++++
 drivers/net/wireless/brcm80211/brcmfmac/nvram.h    |   24 +
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |  593 +++++++++-----------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |   31 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    4 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    1 +
 include/linux/bcma/bcma_regs.h                     |    5 +-
 12 files changed, 608 insertions(+), 549 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/nvram.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/nvram.h

-- 
1.7.10.4

