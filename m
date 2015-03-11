Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:12285 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbbCKPLj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 11:11:39 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/7] brcmfmac: memory size queury and cleanup
Date: Wed, 11 Mar 2015 16:11:26 +0100
Message-ID: <1426086693-13876-1-git-send-email-arend@broadcom.com> (sfid-20150311_161154_042991_EAF09889)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds code to brcmfmac for querying the device about
the RAM size. The driver needs that info to determine whether the firmware
is up and running. All but one patch are related to this change. The last
patch in this series fixes the fact that devices did not go to low-power
mode anymore.

The series is intended for v4.1 kernel and applies to the wireless-drivers-next
repository after the patches from the series posted on March 6th with
Message-ID: 1425663642-19725-1-git-send-email-arend@broadcom.com

Arend van Spriel (7):
  brcmfmac: remove duplication of ramsize info
  brcmfmac: always perform cores checks
  brcmfmac: rename chip download functions
  brcmfmac: assure device is ready for download after
    brcmf_chip_attach()
  brcmfmac: extract ram size info from internal memory registers
  brcmfmac: take save&restore memory into account for SDIO shared info
  brcmfmac: fix watchdog timer regression

 drivers/net/wireless/brcm80211/brcmfmac/chip.c | 296 +++++++++++++++++++------
 drivers/net/wireless/brcm80211/brcmfmac/chip.h |  12 +-
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c |  10 +-
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c |  72 +++---
 4 files changed, 276 insertions(+), 114 deletions(-)

--
1.9.1

