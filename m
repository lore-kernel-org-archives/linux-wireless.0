Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1999 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755718Ab1I2Wes (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 18:34:48 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v3 00/25] staging: brcm80211: 8th reaction for mainline
 patch #2
Date: Thu, 29 Sep 2011 15:34:11 -0700
Message-ID: <1317335676-3424-1-git-send-email-frankyl@broadcom.com> (sfid-20110930_003541_379264_F0B80FBA)
In-Reply-To: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code clean up for softmac.

This patch series is in order to replace the following one:
Message-ID: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>

V2:
* Rework some patches based on the comments from community
V3:
* Fix patch misorder of V2

Arend van Spriel (13):
  staging: brcm80211: remove uncoditional code blocks from brcmsmac
  staging: brcm80211: remove ht_cap field from brcms_c_info structure
  staging: brcm80211: use fragment number provided in transmit frame
  staging: brcm80211: remove unused function si_pmu_ilp_clock()
  staging: brcm80211: make device initializer table for wme constant
  staging: brcm80211: remove dongle firmware related debug code
  staging: brcm80211: remove unnecessary mac80211 callbacks
  staging: brcm80211: changing interface to n-phy rssi compute function
  staging: brcm80211: change interface for common rssi compute function
  staging: brcm80211: convert endianess before handling the frame
  staging: brcm80211: use endian annotated structures in brcmsmac
  staging: brcm80211: move rssi computation to place we need it
  staging: brcm80211: use d11rxhdr structure in brcms_c_recover_tsf64()

Roland Vossen (12):
  staging: brcm80211: removed unused argument from softmac functions
  staging: brcm80211: deleted unused array of bss configurations in
    softmac
  staging: brcm80211: removed redundant wlc->cfg struct member
  staging: brcm80211: removed global var from aiutils.c
  staging: brcm80211: removed global vars in softmac ucode handling
  staging: brcm80211: removed unused softmac workaround
  staging: brcm80211: removed band related global vars from softmac
  staging: brcm80211: removed global var global_scb from softmac
  staging: brcm80211: various global var related changes in softmac
  staging: brcm80211: removed global variable in softmac otp
  staging: brcm80211: simple changes to softmac phy variables
  staging: brcm80211: declared global vars in softmac phy as const

 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |  259 +-------
 drivers/staging/brcm80211/brcmsmac/Makefile       |    3 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.c      |   15 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.h      |    2 -
 drivers/staging/brcm80211/brcmsmac/ampdu.c        |    6 +-
 drivers/staging/brcm80211/brcmsmac/d11.h          |   91 ++--
 drivers/staging/brcm80211/brcmsmac/dma.c          |   41 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c  |  125 +---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h  |    3 +-
 drivers/staging/brcm80211/brcmsmac/main.c         |  747 +++++++++------------
 drivers/staging/brcm80211/brcmsmac/main.h         |   19 +-
 drivers/staging/brcm80211/brcmsmac/otp.c          |  147 +----
 drivers/staging/brcm80211/brcmsmac/otp.h          |    8 -
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c  |   62 +--
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h  |    4 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h  |   25 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c  |  112 ++--
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c    |   75 +--
 drivers/staging/brcm80211/brcmsmac/pmu.c          |   22 -
 drivers/staging/brcm80211/brcmsmac/pmu.h          |    1 -
 drivers/staging/brcm80211/brcmsmac/pub.h          |    1 -
 drivers/staging/brcm80211/brcmsmac/rate.h         |    1 -
 drivers/staging/brcm80211/brcmsmac/srom.c         |   19 +-
 drivers/staging/brcm80211/brcmsmac/stf.c          |    9 -
 drivers/staging/brcm80211/brcmsmac/types.h        |    6 -
 drivers/staging/brcm80211/brcmsmac/ucode_loader.c |  121 ++--
 drivers/staging/brcm80211/brcmsmac/ucode_loader.h |   46 +-
 27 files changed, 648 insertions(+), 1322 deletions(-)


