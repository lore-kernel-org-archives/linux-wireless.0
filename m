Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3988 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063Ab1IMHuM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 03:50:12 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 00/17] staging: brcm80211: 5th reaction to mainline
 patch #2
Date: Tue, 13 Sep 2011 09:49:40 +0200
Message-ID: <1315900197-7260-1-git-send-email-rvossen@broadcom.com> (sfid-20110913_095019_267733_478B7628)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup, and one fix for a build problem.

This series applies to staging-next and depends on the following patch set:

Message-ID: <1315822504-24210-21-git-send-email-rvossen@broadcom.com>

Arend van Spriel (4):
  staging: brcm80211: remove ioctl layer from brcmsmac
  staging: brcm80211: remove function ieee_set_channel()
  staging: brcm80211: remove devpath related nvram variable lookup
  staging: brcm80211: remove brcms_c_get_par and set_par functions

Franky Lin (1):
  staging: brcm80211: remove static function declaration in dhd_sdio

Roland Vossen (12):
  staging: brcm80211: fix for fullmac build problem
  staging: brcm80211: macro cleanup in softmac dma
  staging: brcm80211: cleanup of softmac macro EDCF_ENAB()
  staging: brcm80211: removed function brcms_c_wme_initparams_sta()
  staging: brcm80211: macro cleanup in softmac main.c
  staging: brcm80211: added clarification on softmac dma alignment
  staging: brcm80211: macro cleanup in softmac rate.h
  staging: brcm80211: separated public from private ioctl functions
  staging: brcm80211: simplification of brcmf_netdev_ioctl_priv()
  staging: brcm80211: cleaned up function brcmf_cfg80211_get_key()
  staging: brcm80211: fullmac sparse endianness encryption keys check
  staging: brcm80211: introduced fullmac function get/set u32 to/from
    dongle

 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 -
 drivers/staging/brcm80211/brcmfmac/dhd.h          |   50 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |   79 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     | 6392 ++++++++++-----------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c  |  162 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.c      |   62 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.h      |    5 -
 drivers/staging/brcm80211/brcmsmac/ampdu.c        |   25 +-
 drivers/staging/brcm80211/brcmsmac/dma.c          |  147 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c  |  118 +-
 drivers/staging/brcm80211/brcmsmac/main.c         |  955 ++--
 drivers/staging/brcm80211/brcmsmac/main.h         |   21 -
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c  |    2 +-
 drivers/staging/brcm80211/brcmsmac/pub.h          |   25 +-
 drivers/staging/brcm80211/brcmsmac/rate.c         |   16 +-
 drivers/staging/brcm80211/brcmsmac/rate.h         |  188 +-
 drivers/staging/brcm80211/brcmsmac/scb.h          |    2 +-
 drivers/staging/brcm80211/brcmsmac/stf.c          |    2 +-
 drivers/staging/brcm80211/include/defs.h          |   13 +-
 19 files changed, 3931 insertions(+), 4335 deletions(-)

-- 
1.7.4.1


