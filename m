Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1245 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757506Ab1JRMD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 08:03:28 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/15] brcm80211: cleanup work on community feedback
Date: Tue, 18 Oct 2011 14:02:56 +0200
Message-ID: <1318939391-19495-1-git-send-email-arend@broadcom.com> (sfid-20111018_140337_676904_C87C3DB5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some more cleanup work is done based on comments from the mainline patch #3
and after reflector discussion about crc8 library usage for sprom data.

This series applies to the wireless-testing repository and does not depend
on pending patches as there are none for these drivers.

Alwin Beukers (2):
  brcm80211: cleanup defines in main.c
  brcm80211: removed duplicate defines

Arend van Spriel (8):
  brcm80211: smac: drop "40MHz intolerant" flag from HT capability info
  brcm80211: smac: remove obsolete srom variables from n-phy
  brcm80211: smac: avoid sprom endianess conversions for crc8 check
  brcm80211: smac: some local function made static in main.c
  brcm80211: smac: remove phy api bypass in rate.h
  brcm80211: util: move brcmu_pktfrombuf() function to brcmfmac
  brcm80211: util: remove function brcmu_format_hex() from brcmutil
  brcm80211: fmac: use sk_buff list for handling frames in receive path

Roland Vossen (5):
  brcm80211: smac: removed support for SROM rev < 8
  brcm80211: fmac: annotated little endian struct with _le
  brmc80211: fmac: reworked next_bss()
  brcm80211: fmac: changed two scan related structures
  brcm80211: smac: indicate severe problems to Mac80211

 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   13 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   82 +++--
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   23 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    9 -
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h  |   76 ----
 drivers/net/wireless/brcm80211/brcmsmac/dma.c      |    1 +
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   14 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.h  |    1 +
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |  398 ++++++++-----------
 .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |    2 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_int.h  |    5 -
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |   38 +--
 drivers/net/wireless/brcm80211/brcmsmac/pmu.c      |    1 +
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |   32 --
 drivers/net/wireless/brcm80211/brcmsmac/rate.h     |    5 +-
 drivers/net/wireless/brcm80211/brcmsmac/srom.c     |  436 +++-----------------
 drivers/net/wireless/brcm80211/brcmsmac/srom.h     |    5 -
 drivers/net/wireless/brcm80211/brcmutil/utils.c    |   51 +---
 .../net/wireless/brcm80211/include/brcmu_utils.h   |   11 +-
 drivers/net/wireless/brcm80211/include/soc.h       |   12 +-
 20 files changed, 334 insertions(+), 881 deletions(-)

-- 
1.7.4.1


