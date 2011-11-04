Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3687 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab1KDVYC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 17:24:02 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/16] brcm80211: fmac: refactoring for coming new chip
 support
Date: Fri, 4 Nov 2011 22:23:26 +0100
Message-ID: <1320441822-4615-1-git-send-email-arend@broadcom.com> (sfid-20111104_222420_270984_6494E4D8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Working on adding support for bcm4330 in brcmfmac. This series is paving the
way for that.

This series applies to master branch in wireless-testing and depends on
patch sent on Oct 29, 2011 with following ID:

Message-ID: <1319880615-3000-1-git-send-email-arend@broadcom.com>

Franky Lin (16):
  brcm80211: fmac: remove unnecessary 4329 chip specific code
  brcm80211: fmac: move chip recognition function to sdio_chip.c
  brcm80211: fmac: move bus core prep code to sdio_chip.c
  brcm80211: fmac: abstract chip buscore setup function
  brcm80211: fmac: move core disable function to sdio_chip.c
  brcm80211: fmac: disable dongle arm core in bus core setup function
  brcm80211: fmac: move dongle gpio reset code to chip attach function
  brcm80211: fmac: remove duplicate regiter set in chip attach path
  brcm80211: fmac: chip attach code flow clean up
  brcm80211: fmac: abstract chip iscoreup function
  brcm80211: fmac: abstract chip core revision function
  brcm80211: fmac: move chip reset core function to sdio_chip.c
  brcm80211: fmac: move chip detach function to sdio_chip.c
  brcm80211: fmac: move chip drive strength related code to sdio_chip.c
  brcm80211: fmac: replace private SB macros with ssb_regs version
  brcm80211: fmac: optimize chip core info management

 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    3 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmchip.h  |    7 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  602 ++------------------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |  488 ++++++++++++++++
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |  131 +++++
 5 files changed, 656 insertions(+), 575 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h

-- 
1.7.4.1


