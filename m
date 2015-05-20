Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:44109 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbbETMJz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 08:09:55 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/6] brcmfmac: PCIe changes and NVRAM support
Date: Wed, 20 May 2015 14:09:46 +0200
Message-ID: <1432123792-4155-1-git-send-email-arend@broadcom.com> (sfid-20150520_140959_829641_3A0F1101)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series for the brcmfmac driver provides:

* cleanup and new feature support in PCIe code.
* alternative nvram loading for router support.

The series is intended for v4.2 kernel and apply to the master
branch of the wireless-drivers-next repository.

Arend van Spriel (1):
  brcmfmac: allow device tree node without 'interrupts' property

Franky Lin (3):
  brcmfmac: remove pci shared structure rev4 support
  brcmfmac: remove dummy cache flush/invalidate function
  brcmfmac: add support for dma indices feature

Hante Meuleman (2):
  brcmfmac: Improve throughput by scheduling msbug flow worker.
  brcmfmac: Add support for host platform NVRAM loading.

 .../net/wireless/brcm80211/brcmfmac/commonring.c   |  18 ---
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c | 107 +++++++++-----
 drivers/net/wireless/brcm80211/brcmfmac/flowring.c |   5 +-
 drivers/net/wireless/brcm80211/brcmfmac/flowring.h |   4 +-
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   |  20 +--
 drivers/net/wireless/brcm80211/brcmfmac/of.c       |  11 +-
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c     | 157 ++++++++++++++++-----
 7 files changed, 209 insertions(+), 113 deletions(-)

-- 
1.9.1

