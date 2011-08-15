Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2704 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421Ab1HONei (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 09:34:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/15] staging: brcm80211: big-endian support and
 cleanup
Date: Mon, 15 Aug 2011 15:34:12 +0200
Message-ID: <1313415267-5264-1-git-send-email-arend@broadcom.com> (sfid-20110815_153445_111708_87D7E07A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series fixes several issues found on big-endian platform (Sparc,
PowerPC, and MIPS) and some changes to code specific to broadcom MIPS
platforms. Other patches are cleanup items to get rid of void pointer
usage in the drivers.

This series applies to staging-next and depends on the following patch set:

Message-ID: <1313156101-16817-1-git-send-email-arend@broadcom.com>

Arend van Spriel (6):
  staging: brcm80211: remove W_SM and R_SM macros from dma.c
  staging: brcm80211: remove PHYSADDR macro from dma.c
  staging: brcm80211: replace BUS_SWAP32 macro with cpu_to_le32()
  staging: brcm80211: remove mips specific include from dma.c
  staging: brcm80211: restrict register access method for bcm47xx
  staging: brcm80211: restrict MIPS dma bug workaround to BCM47XX

Franky Lin (1):
  staging: brcm80211: void * cleanup in fullmac

Henry Ptasinski (3):
  staging: brcm80211: fix off-by-one error in swap functions
  staging: brcm80211: Remove swaps in R_REG and W_REG macros
  staging: brcm80211: Fix handling of firmware and inits on big-endian
    platforms

Roland Vossen (5):
  staging: brcm80211: got rid of several void pointers for softmac PCI
  staging: brcm80211: replaced void pointers in dma functions
  staging: brcm80211: replaced void pointers in otp functions
  staging: brcm80211: got rid of several void pointers in softmac
  staging: brcm80211: removed unused MIPS specific SDRAM swap window

 drivers/staging/brcm80211/brcmfmac/dhd.h         |    5 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c   |   14 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c    |    6 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.c     |   10 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.h     |    4 +-
 drivers/staging/brcm80211/brcmsmac/ampdu.c       |   14 --
 drivers/staging/brcm80211/brcmsmac/dma.c         |  169 ++++++++--------------
 drivers/staging/brcm80211/brcmsmac/dma.h         |   12 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |   28 ++--
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h |    4 +-
 drivers/staging/brcm80211/brcmsmac/main.c        |   70 +++++----
 drivers/staging/brcm80211/brcmsmac/main.h        |   23 +---
 drivers/staging/brcm80211/brcmsmac/nicpci.c      |   61 ++++-----
 drivers/staging/brcm80211/brcmsmac/nicpci.h      |   30 +++--
 drivers/staging/brcm80211/brcmsmac/otp.c         |   90 +++++-------
 drivers/staging/brcm80211/brcmsmac/otp.h         |   12 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.c    |    7 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.h    |    3 +-
 drivers/staging/brcm80211/brcmsmac/pub.h         |   16 +--
 drivers/staging/brcm80211/brcmsmac/scb.h         |    1 -
 drivers/staging/brcm80211/brcmsmac/srom.c        |    6 +-
 drivers/staging/brcm80211/brcmsmac/types.h       |   23 +---
 23 files changed, 258 insertions(+), 352 deletions(-)

-- 
1.7.4.1


