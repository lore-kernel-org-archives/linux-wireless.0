Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:34443 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbaLULoB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 06:44:01 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 00/10] brcmfmac: new device support and more
Date: Sun, 21 Dec 2014 12:43:43 +0100
Message-ID: <1419162233-19492-1-git-send-email-arend@broadcom.com> (sfid-20141221_124408_952484_C784B8FD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here a first batch for v3.20. This series adds support for the
BCM43340 and BCM43341 SDIO chipsets. A number of changes are
related to AP mode and some fixes of potential issues that do
not seem to qualify for the wireless tree.

This series is intended for v3.20 and applies to the master
branch of the *new* wireless-next repository.

Arend van Spriel (5):
  brcmfmac: Add support for bcm43340/1 wireless chipsets
  brcmfmac: get rid of duplicate SDIO device identifiers
  brcmfmac: remove unused/duplicate defines in chip.c
  brcmfmac: follow user-space regulatory domain selection
  brcmfmac: enable 802.11d support in firmware

Hante Meuleman (5):
  brcmfmac: Fix incorrect casting of 64 bit physical address.
  brcmfmac: Fix possible dereference of NULL pointer.
  brcmfmac: Fix WEP configuration for AP mode.
  brcmfmac: Change error log in standard log for rxbufpost.
  brcmfmac: signal completion of 802.1x.

 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  22 +--
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 176 ++++++++++++++++++---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h |   5 +
 drivers/net/wireless/brcm80211/brcmfmac/chip.c     |  15 +-
 drivers/net/wireless/brcm80211/brcmfmac/common.c   |   3 +
 drivers/net/wireless/brcm80211/brcmfmac/common.h   |  20 +++
 drivers/net/wireless/brcm80211/brcmfmac/core.c     |   3 +-
 drivers/net/wireless/brcm80211/brcmfmac/core.h     |   4 +-
 drivers/net/wireless/brcm80211/brcmfmac/flowring.c |   6 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.h     |   4 +
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |  14 ++
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   |  24 +--
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c     |  10 +-
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c     |   7 +-
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |  12 +-
 include/linux/mmc/sdio_ids.h                       |   2 +
 16 files changed, 239 insertions(+), 88 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/common.h

-- 
1.9.1

