Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4630 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab1KJTau (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 14:30:50 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/19] brcm80211: cleanup and preparing for new chip
Date: Thu, 10 Nov 2011 20:30:15 +0100
Message-ID: <1320953434-16859-2-git-send-email-arend@broadcom.com> (sfid-20111110_203114_119754_C620C18D)
In-Reply-To: <1320953434-16859-1-git-send-email-arend@broadcom.com>
References: <1320953434-16859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series is more cleanup that is related to comments on the mainline
patch and preparing for adding a new chip for brcmfmac driver.

This patch series should apply on wireless-testing repository. There are
not other patches this series depends on.

Alwin Beukers (2):
  brcm80211: smac: don't modify sta parameters when adding sta
  brcm80211: smac: combine promiscuous mode functionality

Arend van Spriel (9):
  brcm80211: smac: fix endianess issue for OTP memory access
  brcm80211: smac: remove code under unused macro definitions
  brcm80211: smac: replace own access category definitions with
    mac80211 enum
  brcm80211: smac: remove duplicate definition of D11_PHY_HDR_LEN
  brcm80211: smac: remove usage of brcmu_pkttotlen
  brcm80211: util: use sk_buff_head in precedence queue functions
  brcm80211: util: move brcmu_pkttotlen() function to brcmfmac
  brcm80211: util: remove pointer traversal from brcmu_pkt_buf_free_skb
  brcm80211: fmac: add function to free the glom skb queue

Franky Lin (8):
  brcm80211: fmac: add iscoreup function for bcm4330 chip
  brcm80211: fmac: add corerev function for bcm4330 chip
  brcm80211: fmac: add coredisable function for bcm4330 chip
  brcm80211: fmac: add resetcore function for bcm4330 chip
  brcm80211: fmac: remove id retrieve code
  brcm80211: fmac: stop using hard coded firmware/nvram name
  brcm80211: fmac: remove PCMCIA core related code
  brcm80211: fmac: release bss struct returned from cfg80211_inform_bss

 drivers/net/wireless/brcm80211/Kconfig             |   14 ++
 drivers/net/wireless/brcm80211/brcmfmac/bcmchip.h  |   25 --
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    2 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   96 ++++-----
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |  234 +++++++++++++++----
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |   17 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   18 +-
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c    |    6 +-
 drivers/net/wireless/brcm80211/brcmsmac/channel.c  |  118 ----------
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    7 -
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   86 ++++----
 drivers/net/wireless/brcm80211/brcmsmac/main.h     |    8 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |    8 -
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    2 -
 drivers/net/wireless/brcm80211/brcmsmac/srom.c     |    2 +
 drivers/net/wireless/brcm80211/brcmutil/utils.c    |  167 ++++-----------
 .../net/wireless/brcm80211/include/brcmu_utils.h   |   19 +-
 17 files changed, 359 insertions(+), 470 deletions(-)
 delete mode 100644 drivers/net/wireless/brcm80211/brcmfmac/bcmchip.h

-- 
1.7.5.4


