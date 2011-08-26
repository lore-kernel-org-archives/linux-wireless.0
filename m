Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4766 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755129Ab1HZNT5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 09:19:57 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 00/13] staging: brcm80211: first reaction to mainline
 patch #2
Date: Fri, 26 Aug 2011 15:19:27 +0200
Message-ID: <1314364780-9462-1-git-send-email-rvossen@broadcom.com> (sfid-20110826_152020_719135_6CCB34B8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Comments were given by various people. This patch covers part of those
comments. Apart from that, there is also a bugfix.

This series applies to staging-next and depends on the following patch set:

Message-ID: <927eab8b5c950c13991911cd4c16457a5d618bc7.1314252671.git.joe@perches.com>

Arend van Spriel (6):
  staging: brcm80211: remove unused definition flag from top Makefile
  staging: brcm80211: remove macro definitions from brcmsmac Makefile
  staging: brcm80211: remove usage of macro WL11N_20MHZONLY
  staging: brcm80211: remove macro definitions from brcmfmac Makefile
  staging: brcm80211: rename key endian conversion functions
  staging: brcm80211: remove brcmf_find_msb() function

Roland Vossen (7):
  staging: brcm80211: removed unused code in dma.c
  staging: brcm80211: assigned physical addresses in dma.c correct type
  staging: brcm80211: bugfix for 32 bit power pc platform
  staging: brcm80211: removed NORADIO_ENAB() macro from softmac phy
    code
  staging: brcm80211: removed unused phy logging
  staging: brcm80211: removed unused #ifdef sections
  staging: brcm80211: got rid of static function declarations in
    softmac phy

 drivers/staging/brcm80211/Makefile                |    1 -
 drivers/staging/brcm80211/brcmfmac/Makefile       |    5 -
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    4 -
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h      |    7 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |   16 -
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h    |    5 -
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |   37 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c  |   65 +-
 drivers/staging/brcm80211/brcmsmac/Makefile       |    7 -
 drivers/staging/brcm80211/brcmsmac/aiutils.c      |    1 +
 drivers/staging/brcm80211/brcmsmac/aiutils.h      |   17 -
 drivers/staging/brcm80211/brcmsmac/channel.c      |   12 -
 drivers/staging/brcm80211/brcmsmac/d11.h          |    4 -
 drivers/staging/brcm80211/brcmsmac/dma.c          |  173 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c  |   13 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h  |    3 -
 drivers/staging/brcm80211/brcmsmac/main.c         |   35 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c  |  444 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h  |   22 -
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c  | 5375 +++---
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c    |23214 ++++++++++-----------
 drivers/staging/brcm80211/brcmsmac/pub.h          |   16 +-
 drivers/staging/brcm80211/brcmsmac/srom.c         |   12 +-
 drivers/staging/brcm80211/brcmsmac/types.h        |    8 -
 drivers/staging/brcm80211/include/brcmu_utils.h   |    6 -
 drivers/staging/brcm80211/include/brcmu_wifi.h    |   14 -
 drivers/staging/brcm80211/include/defs.h          |    6 -
 drivers/staging/brcm80211/include/soc.h           |    4 -
 28 files changed, 14416 insertions(+), 15110 deletions(-)

-- 
1.7.4.1


