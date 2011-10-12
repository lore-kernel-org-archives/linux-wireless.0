Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3015 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab1JLSvv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:51:51 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/22] brcm80211: mainline patch related cleanup
Date: Wed, 12 Oct 2011 20:51:10 +0200
Message-ID: <1318445492-24207-1-git-send-email-arend@broadcom.com> (sfid-20111012_205233_475802_AFAB3469)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mainline patch (version 3) did receive some comments from
Johannes Berg and Hauke Mehrtens that we started working on. This
series contains several of those cleanup patches.

This series applies to the wireless-testing repository and depends
upon the linux-next merge patches as posted by Stephen Rothwell:

Message-ID: <20111012133600.256fea364b17e6bf96ee1081@canb.auug.org.au>
Message-ID: <20111012172954.4d5a638ef2a399b72bce5bf1@canb.auug.org.au>

There was a third patch from Stephen Rothwell to include linux/export.h
but that file is not yet in the wireless-testing repository so I did not
use that preparing this series:

Message-ID: <20111012173019.37dbde1f6797be48f8ad7c62@canb.auug.org.au>

Alwin Beukers (9):
  brcm80211: cleanup function prototypes
  brcm80211: removed unused functions
  brcm80211: moved power conversion functions
  brcm80211: moved function brcmu_chipname
  brcm80211: moved function brcmu_parse_tlvs
  brcm80211: moved function brcmu_chspec_malformed
  brcm80211: moved function brcmu_mkiovar
  brcm80211: moved function brcmu_format_flags
  brcm80211: removed file wifi.c

Arend van Spriel (10):
  brcm80211: remove sparse warning in fullmac debug function
  brcm80211: fix sparse endianess error in mac80211_if.c
  brcm80211: add endian annotation to packet filter structures
  brcm80211: rename variable in _brcmf_set_multicast_list()
  brcm80211: fix annotations in TOE configuration functions
  brcm80211: use endian annotations in scan related function
  brcm80211: use endian annotation for pmk related structure
  brcm80211: use endian annotations for assoc ie length request
  brcm80211: use endian annotation for roaming related parameters
  brcm80211: use endian annotation for scan time configuration

Roland Vossen (3):
  brcm80211: smac: removed redundant timer function parameters
  brcm80211: smac: decreased timer callback irq level
  brcm80211: fmac: fixed weird indentation

 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   27 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   71 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   55 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   11 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  332 ++-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    6 +-
 drivers/net/wireless/brcm80211/brcmsmac/channel.c  |   28 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   53 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.h  |   19 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     | 3430 ++++++++++----------
 drivers/net/wireless/brcm80211/brcmsmac/main.h     |   84 -
 .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |   12 +-
 drivers/net/wireless/brcm80211/brcmsmac/phy_shim.c |   13 +-
 drivers/net/wireless/brcm80211/brcmsmac/phy_shim.h |    9 +-
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |   49 +-
 drivers/net/wireless/brcm80211/brcmsmac/stf.c      |    2 -
 drivers/net/wireless/brcm80211/brcmutil/Makefile   |    3 +-
 drivers/net/wireless/brcm80211/brcmutil/utils.c    |  215 --
 drivers/net/wireless/brcm80211/brcmutil/wifi.c     |  136 -
 .../net/wireless/brcm80211/include/brcmu_utils.h   |   28 -
 .../net/wireless/brcm80211/include/brcmu_wifi.h    |   38 +-
 21 files changed, 2112 insertions(+), 2509 deletions(-)
 delete mode 100644 drivers/net/wireless/brcm80211/brcmutil/wifi.c

-- 
1.7.4.1


