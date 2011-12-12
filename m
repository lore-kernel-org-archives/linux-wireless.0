Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3057 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783Ab1LLXPq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 18:15:46 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/15] brcm80211: the rest of smac bcma switch series
Date: Mon, 12 Dec 2011 15:14:58 -0800
Message-ID: <1323731713-14942-1-git-send-email-frankyl@broadcom.com> (sfid-20111213_001611_300126_C8DBD6EB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This train contains the rest of patch series switching brcmsmac to use
bcma bus interface.
It depends on the following patch set:
[PATCH 00/23] brcm80211: fullmac 4430 support and softmac switch to bcma
Message-ID: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>

Arend van Spriel (15):
  brcm80211: smac: change ai_findcoreidx() to ai_findcore()
  brcm80211: smac: use bcma core access functions in otp.c
  brcm80211: smac: use bcma core access function in srom.c
  brcm80211: smac: use bcma core access functions in pmu.c
  brcm80211: smac: use bcma core access functions in aiutils.c
  brcm80211: smac: remove register access macro definitions
  brcm80211: smac: remove empty or unused functions from pmu.c
  brcm80211: smac: INTROFF/INTRESTORE macros removed
  brcm80211: smac: remove interrupt disable callback functionality
  brcm80211: smac: remove ai_switch_core() function
  brcm80211: smac: remove mapped core related function from aiutils.c
  brcm80211: smac: cleanup si_info structure definition
  brcm80211: smac: cleanup buscore handling in aiutils.c
  brcm80211: smac: register with bcma for specific 802.11 core
    revisions
  brcm80211: smac: fix compilation issue with CONFIG_BCM47XX set

 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c  |  512 +++++---------------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h  |   66 +--
 drivers/net/wireless/brcm80211/brcmsmac/dma.c      |  101 ++--
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    4 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   40 +--
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.c   |    3 +-
 drivers/net/wireless/brcm80211/brcmsmac/otp.c      |   68 +--
 .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |    2 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |    7 +-
 drivers/net/wireless/brcm80211/brcmsmac/pmu.c      |  224 +++------
 drivers/net/wireless/brcm80211/brcmsmac/pmu.h      |    5 +-
 drivers/net/wireless/brcm80211/brcmsmac/srom.c     |   50 +--
 drivers/net/wireless/brcm80211/brcmsmac/srom.h     |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/types.h    |   51 --
 .../net/wireless/brcm80211/include/chipcommon.h    |    2 +
 15 files changed, 302 insertions(+), 835 deletions(-)

-- 
1.7.5.4


