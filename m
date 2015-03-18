Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:32931 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352AbbCRMZg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 08:25:36 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/8] brcmfmac: device support and some fixes
Date: Wed, 18 Mar 2015 13:25:20 +0100
Message-ID: <1426681528-15831-1-git-send-email-arend@broadcom.com> (sfid-20150318_132555_853354_6D484DF5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds support for the BCM43430 SDIO chipset. Recent
BCM4345 support is changed to support BCM43455 and BCM43457 as
it has been verified on those. In SDIO driver part memory barriers
have been added to assure data validity between driver threads.

This series is intended for v4.1 kernel and applies to the master
branch of the wireless-drivers-next repository.

Arend van Spriel (5):
  brcmfmac: avoid runtime-pm for sdio host controller
  brcmfmac: add MODULE_FIRMWARE() macros for bcm4356 PCIe device
  brcmfmac: add support for BCM43430 SDIO chipset
  brcmfmac: only support the BCM43455/7 device
  brcmfmac: remove support for unreleased BCM4354 PCIe

Hante Meuleman (3):
  brcmfmac: Add necessary memory barriers for SDIO.
  brcmfmac: Update msgbuf commonring size for improved throughput.
  brcmfmac: Remove unnecessary new-line in pcie console logging.

 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  5 +-
 drivers/net/wireless/brcm80211/brcmfmac/chip.c     | 18 ++++++
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.h   |  8 +--
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c     | 14 +----
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c     | 72 +++++++++++++---------
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |  1 +
 .../net/wireless/brcm80211/include/chipcommon.h    |  9 ++-
 include/linux/mmc/sdio_ids.h                       |  1 +
 8 files changed, 82 insertions(+), 46 deletions(-)

-- 
1.9.1

