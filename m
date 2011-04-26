Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3391 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756272Ab1DZCeW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 22:34:22 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	brudley@broadcom.com, henryp@broadcom.com, hharte@broadcom.com
Subject: [PATCH 0/5 v2] staging: brcm80211: remove si sb utils
 dependency from brcmfmac
Date: Mon, 25 Apr 2011 19:34:03 -0700
Message-ID: <1303785248-27420-1-git-send-email-frankyl@broadcom.com> (sfid-20110426_043438_545819_F56B7CA1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

I fix the apply error issue of the rest 5 patches. The original path series
intends to remove si and sb utility from broadcom fullmac driver.

Thanks
Franky

Franky Lin (5):
  staging: brcm80211: Remove siutils dependency of
    dhdsdio_download_state
  staging: brcm80211: Move sdiod strength init to dhd_sdio.c
  staging: brcm80211: Add dhdsdio_chip_detach in dhd_sdio.c
  staging: brcm80211: Remove siutils dependence from dhd_sdio.c
  staging: brcm80211: Remove si sb utils from brcmfmac

 drivers/staging/brcm80211/brcmfmac/Makefile   |    6 +-
 drivers/staging/brcm80211/brcmfmac/bcmchip.h  |    1 +
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c   |    1 -
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |  325 +++++++++++-------
 drivers/staging/brcm80211/brcmfmac/hndpmu.c   |    1 -
 drivers/staging/brcm80211/brcmfmac/sbutils.c  |    1 -
 drivers/staging/brcm80211/brcmfmac/siutils.c  |    1 -
 drivers/staging/brcm80211/util/bcmutils.c     |    1 -
 drivers/staging/brcm80211/util/sbutils.c      |  476 -------------------------
 9 files changed, 206 insertions(+), 607 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/hndpmu.c
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/sbutils.c
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/siutils.c
 delete mode 100644 drivers/staging/brcm80211/util/sbutils.c


