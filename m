Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:21965 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbbDNSKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 14:10:55 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 00/10] brcmfmac: device support and fixes
Date: Tue, 14 Apr 2015 20:10:23 +0200
Message-ID: <1429035033-14076-1-git-send-email-arend@broadcom.com> (sfid-20150414_201124_337614_CB2AA658)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series include some fixes related to SDIO suspend and resume,
wiphy band info and changes in regulatory settings. Furthermore,
support for BCM4324 SDIO and BCM4358 PCIe is added. Finally,
some patches from Hante that should enable support of PCIe devices
on router platforms.

This series is intended for v4.2 and applies to the master branch
of the wireless-drivers-next repository.

Arend van Spriel (8):
  brcmfmac: use static superset of channels for wiphy bands
  brcmfmac: update wiphy band information upon updating regulatory
    domain
  brcmfmac: add description for feature flags
  brcmfmac: make scheduled scan support conditional
  brcmfmac: add support for BCM4324 rev B5 chipset
  brcmfmac: process interrupt regardless sdiod state
  brcmfmac: fix sdio suspend and resume
  brcmfmac: add support for BCM4358 PCIe device

Hante Meuleman (2):
  brcmfmac: add additional 43602 pcie device id.
  brcmfmac: Add support for multiple PCIE devices in nvram.

 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  18 +-
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 202 ++++++++++++---------
 drivers/net/wireless/brcm80211/brcmfmac/chip.c     |   1 +
 drivers/net/wireless/brcm80211/brcmfmac/feature.c  |   1 +
 drivers/net/wireless/brcm80211/brcmfmac/feature.h  |   4 +
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c | 189 ++++++++++++++++++-
 drivers/net/wireless/brcm80211/brcmfmac/firmware.h |   6 +
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c     |  25 ++-
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c     |  11 +-
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |   3 +
 10 files changed, 348 insertions(+), 112 deletions(-)

-- 
1.9.1

