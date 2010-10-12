Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43534 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab0JLWJb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 18:09:31 -0400
Received: by bwz15 with SMTP id 15so2776714bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 15:09:29 -0700 (PDT)
From: mike.rapoport@gmail.com
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>, linux-wireless@vger.kernel.org,
	Mike Rapoport <mike.rapoport@gmail.com>
Subject: [PATCH 0/7] staging: brcm80211: linus_osl.c cleanups
Date: Wed, 13 Oct 2010 00:09:06 +0200
Message-Id: <cover.1286920620.git.mike.rapoport@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches replace part of proprietary utility functions with
public kernel versions.

The following changes since commit 0f0881b09078fe3a6bc70f05e8ba49a52b2478a2:
  Greg Kroah-Hartman (1):                                                   
        Staging: brcm80211: remove TRUE #define                             

Mike Rapoport (7):
  staging: brcm80211: remove OSL_DELAY
  staging: brcm80211: remove DHD_USE_STATIC_BUF
  staging: brcm80211: remove osl_malloced()/MALLOCED()
  staging: brcm80211: replace MALLOC() with k[zm]alloc
  staging: brcm80211: remove unused NATIVE_{MALLOC,MFREE}
  staging: brcm80211: replace MFREE with kfree
  staging: brcm80211: remove unrefrenced malloced field

 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |   16 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |   20 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |   27 +--
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    4 +-
 drivers/staging/brcm80211/brcmfmac/dhd.h           |    6 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |   20 +--
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |   18 +-
 .../staging/brcm80211/brcmfmac/dhd_custom_gpio.c   |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |   53 ++----
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |   98 +++------
 drivers/staging/brcm80211/include/bcmutils.h       |    2 +-
 drivers/staging/brcm80211/include/linux_osl.h      |   18 --
 drivers/staging/brcm80211/phy/wlc_phy_cmn.c        |   20 +-
 drivers/staging/brcm80211/phy/wlc_phy_lcn.c        |   87 ++++----
 drivers/staging/brcm80211/phy/wlc_phy_n.c          |   88 ++++----
 drivers/staging/brcm80211/sys/wl_mac80211.c        |   33 ++--
 drivers/staging/brcm80211/sys/wlc_alloc.c          |   57 ++---
 drivers/staging/brcm80211/sys/wlc_ampdu.c          |   12 +-
 drivers/staging/brcm80211/sys/wlc_antsel.c         |    8 +-
 drivers/staging/brcm80211/sys/wlc_bmac.c           |   32 ++--
 drivers/staging/brcm80211/sys/wlc_channel.c        |    8 +-
 drivers/staging/brcm80211/sys/wlc_event.c          |   13 +-
 drivers/staging/brcm80211/sys/wlc_mac80211.c       |   19 +-
 drivers/staging/brcm80211/sys/wlc_phy_shim.c       |    8 +-
 drivers/staging/brcm80211/util/aiutils.c           |    8 +-
 drivers/staging/brcm80211/util/bcmotp.c            |    6 +-
 drivers/staging/brcm80211/util/bcmsrom.c           |   36 ++--
 drivers/staging/brcm80211/util/hnddma.c            |   43 ++---
 drivers/staging/brcm80211/util/hndpmu.c            |   14 +-
 drivers/staging/brcm80211/util/linux_osl.c         |  228 --------------------
 drivers/staging/brcm80211/util/nicpci.c            |   15 +-
 drivers/staging/brcm80211/util/nvram/nvram_ro.c    |    9 +-
 drivers/staging/brcm80211/util/sbutils.c           |   14 +-
 drivers/staging/brcm80211/util/siutils.c           |   21 +-
 34 files changed, 335 insertions(+), 728 deletions(-)

