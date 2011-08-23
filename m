Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4700 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab1HWMOR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 08:14:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 0/8] brcmsmac fixes and driver cleanup
Date: Tue, 23 Aug 2011 14:13:52 +0200
Message-ID: <1314101640-4229-1-git-send-email-arend@broadcom.com> (sfid-20110823_141428_484340_FFD54844)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With 3.1 kernel the crc8 and cordic library modules are available in the
staging tree. The brcmsmac driver now uses them. Some small fixes have
been made and the driver is made to work on the Sparc platform.

This series applies to staging-next and depends on the following patch set:

Message-ID: <1313415267-5264-1-git-send-email-arend@broadcom.com>

Arend van Spriel (4):
  staging: brcm80211: make use of crc8 library function
  staging: brcm80211: make use of cordic library function
  staging: brcm80211: fix rtnl_lock issue when bringing down brcmfmac
  staging: brcm80211: fill in proper rx rate in mac80211 rx status

Franky Lin (1):
  staging: brcm80211: fix checkpatch warning in fullmac

Henry Ptasinski (1):
  staging: brcm80211: only enable brcmsmac if bcma is not set

Roland Vossen (2):
  staging: brcm80211: bugfix for exception on Sparc platforms
  staging: brcm80211: bugfix for fifo problem on 64 bits platforms.

 drivers/staging/brcm80211/Kconfig                |    3 +
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    7 ++
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |    2 +-
 drivers/staging/brcm80211/brcmsmac/dma.c         |    7 ++-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    9 ++-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h |    6 ++
 drivers/staging/brcm80211/brcmsmac/main.c        |   15 ++++-
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |   62 -------------------
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h |    1 -
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c |    7 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c   |   14 +++--
 drivers/staging/brcm80211/brcmsmac/srom.c        |   20 +++++-
 drivers/staging/brcm80211/brcmutil/utils.c       |   69 ----------------------
 drivers/staging/brcm80211/include/brcmu_utils.h  |    5 --
 14 files changed, 71 insertions(+), 156 deletions(-)

-- 
1.7.4.1


