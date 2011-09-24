Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3436 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200Ab1IXCJU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 22:09:20 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 00/20] staging: brcm80211: 8th reaction for mainline
 patch #2
Date: Fri, 23 Sep 2011 19:08:48 -0700
Message-ID: <1316830148-28661-1-git-send-email-frankyl@broadcom.com> (sfid-20110924_040958_866150_94F9761F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code clean up for softmac.

This series applies to staging-next and depends on the following patch set:

Message-ID: <1316736476-23725-1-git-send-email-frankyl@broadcom.com>

Arend van Spriel (9):
  staging: brcm80211: remove uncoditional code blocks from brcmsmac
  staging: brcm80211: cleanup structure fields used for scanning
  staging: brcm80211: use endian annotated structures in brcmsmac
  staging: brcm80211: remove ht_cap field from brcms_c_info structure
  staging: brcm80211: use fragment number provided in transmit frame
  staging: brcm80211: remove unused function si_pmu_ilp_clock()
  staging: brcm80211: make device initializer table for wme constant
  staging: brcm80211: remove dongle firmware related debug code
  staging: brcm80211: remove unnecessary mac80211 callbacks

Roland Vossen (11):
  staging: brcm80211: removed unused argument from softmac functions
  staging: brcm80211: deleted unused array of bss configurations in
    softmac
  staging: brcm80211: removed redundant wlc->cfg struct member
  staging: brcm80211: removed global var from aiutils.c
  staging: brcm80211: removed global vars in softmac ucode handling
  staging: brcm80211: removed unused softmac workaround
  staging: brcm80211: declared global vars in softmac phy as const
  staging: brcm80211: removed band related global vars from softmac
  staging: brcm80211: removed global var global_scb from softmac
  staging: brcm80211: various global var related changes in softmac
  staging: brcm80211: removed global variable in softmac otp

 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |  259 +-------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |   32 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |    5 +-
 drivers/staging/brcm80211/brcmsmac/Makefile        |    3 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.c       |   15 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.h       |    2 -
 drivers/staging/brcm80211/brcmsmac/ampdu.c         |    6 +-
 drivers/staging/brcm80211/brcmsmac/d11.h           |   83 ++-
 drivers/staging/brcm80211/brcmsmac/dma.c           |   41 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c   |  125 +---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h   |    3 +-
 drivers/staging/brcm80211/brcmsmac/main.c          |  729 +++++++++-----------
 drivers/staging/brcm80211/brcmsmac/main.h          |   19 +-
 drivers/staging/brcm80211/brcmsmac/otp.c           |  147 +----
 drivers/staging/brcm80211/brcmsmac/otp.h           |    8 -
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c   |   49 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h   |   23 -
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c   |  112 ++--
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c     |   62 +-
 .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.c    |    2 +-
 drivers/staging/brcm80211/brcmsmac/pmu.c           |   22 -
 drivers/staging/brcm80211/brcmsmac/pmu.h           |    1 -
 drivers/staging/brcm80211/brcmsmac/pub.h           |    1 -
 drivers/staging/brcm80211/brcmsmac/rate.h          |    1 -
 drivers/staging/brcm80211/brcmsmac/srom.c          |   19 +-
 drivers/staging/brcm80211/brcmsmac/stf.c           |    9 -
 drivers/staging/brcm80211/brcmsmac/types.h         |    5 -
 drivers/staging/brcm80211/brcmsmac/ucode_loader.c  |  121 ++--
 drivers/staging/brcm80211/brcmsmac/ucode_loader.h  |   46 +-
 29 files changed, 656 insertions(+), 1294 deletions(-)


