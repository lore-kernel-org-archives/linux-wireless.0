Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4662 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157Ab1DYWpa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 18:45:30 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	brudley@broadcom.com, henryp@broadcom.com, hharte@broadcom.com
Subject: [PATCH 0/7] staging: brcm80211: remove si sb utils dependency
 from brcmfmac
Date: Mon, 25 Apr 2011 15:45:06 -0700
Message-ID: <1303771513-18851-1-git-send-email-frankyl@broadcom.com> (sfid-20110426_004537_374990_CABD06D7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series is intend to remove si and sb utility from broadcom fullmac driver.

Franky Lin (7):
  staging: brcm80211: Add bcmchip.h
  staging: brcm80211: Add dhdsdio_chip_attach in dhd_sdio.c
  staging: brcm80211: Remove siutils dependency of
    dhdsdio_download_state
  staging: brcm80211: Move sdiod strength init to dhd_sdio.c
  staging: brcm80211: Add dhdsdio_chip_detach in dhd_sdio.c
  staging: brcm80211: Remove siutils dependence from dhd_sdio.c
  staging: brcm80211: Remove si sb utils from brcmfmac

 drivers/staging/brcm80211/brcmfmac/Makefile   |    3 -
 drivers/staging/brcm80211/brcmfmac/bcmchip.h  |   35 +
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c   |    1 -
 drivers/staging/brcm80211/brcmfmac/dhd_pmu.c  |  780 -------------
 drivers/staging/brcm80211/brcmfmac/dhd_pmu.h  |   52 -
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |  574 ++++++++--
 drivers/staging/brcm80211/brcmfmac/sbutils.c  |    1 -
 drivers/staging/brcm80211/brcmfmac/siutils.c  |    1 -
 drivers/staging/brcm80211/util/bcmutils.c     |    1 -
 drivers/staging/brcm80211/util/sbutils.c      |  462 --------
 drivers/staging/brcm80211/util/siutils.c      | 1490 -------------------------
 drivers/staging/brcm80211/util/siutils_priv.h |   30 -
 12 files changed, 490 insertions(+), 2940 deletions(-)
 create mode 100644 drivers/staging/brcm80211/brcmfmac/bcmchip.h
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/dhd_pmu.c
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/dhd_pmu.h
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/sbutils.c
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/siutils.c
 delete mode 100644 drivers/staging/brcm80211/util/sbutils.c
 delete mode 100644 drivers/staging/brcm80211/util/siutils.c
 delete mode 100644 drivers/staging/brcm80211/util/siutils_priv.h


