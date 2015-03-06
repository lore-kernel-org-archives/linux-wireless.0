Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:52815 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbbCFRkt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 12:40:49 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/5] brcmfmac: new device and some fixes
Date: Fri, 6 Mar 2015 18:40:37 +0100
Message-ID: <1425663642-19725-1-git-send-email-arend@broadcom.com> (sfid-20150306_184053_442732_0BE5DEA0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds new BCM4345 SDIO device support to brcmfmac and
address a number of potential issues either found by testing or code
inspection.

The series is intended for the v4.1 kernel and applies to the master
branch of the wireless-drivers-next repository.

Hante Meuleman (4):
  brcmfmac: Fix oops when SDIO device is removed.
  brcmfmac: Simplify watchdog sleep.
  brcmfmac: Fix possible race-condition.
  brcmfmac: Fix race condition in msgbuf ioctl processing.

Syed Asifful Dayyan (1):
  brcmfmac: Add support for BCM4345 SDIO chipset.

 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   3 +-
 drivers/net/wireless/brcm80211/brcmfmac/chip.c     |   4 +
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   |   5 +-
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c     | 101 +++++++++++----------
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |   1 +
 include/linux/mmc/sdio_ids.h                       |   1 +
 6 files changed, 62 insertions(+), 53 deletions(-)

--
1.9.1

