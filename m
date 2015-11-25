Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:1707 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbbKYKcv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 05:32:51 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 00/11] brcmfmac: beamforming support and cleanup
Date: Wed, 25 Nov 2015 11:32:36 +0100
Message-ID: <1448447567-12189-1-git-send-email-arend@broadcom.com> (sfid-20151125_113258_251387_FB7A4E8E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series has the following highlights:

* beamforming support.
* unified handling of firmware files.
* 5G join preference.

The series is intended for 4.5 kernel and applies to wireless-drivers-next
on top of previous series with Message-ID:

<1446147199-21671-1-git-send-email-arend@broadcom.com>

Arend van Spriel (1):
  brcmfmac: assure net_ratelimit() is declared before use

Franky Lin (1):
  brcmfmac: no retries on rxglom superframe errors

Hante Meuleman (9):
  brcmfmac: Cleanup ssid storage.
  brcmfmac: Return actual error by fwil.
  brcmfmac: Change error print on wlan0 existence.
  brcmfmac: Remove redundant parameter action from scan.
  brcmfmac: Cleanup roaming configuration.
  brcmfmac: Add beamforming support.
  brcmfmac: Make 5G join preference configurable.
  brcmfmac: Unify methods to define and map firmware files.
  brcmfmac: Fix double free on exception at module load.

 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 124 +++++++------
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |  10 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  53 +++---
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   9 +-
 .../wireless/broadcom/brcm80211/brcmfmac/debug.h   |   2 +
 .../broadcom/brcm80211/brcmfmac/firmware.c         |  44 ++++-
 .../broadcom/brcm80211/brcmfmac/firmware.h         |  46 ++++-
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.c    |   3 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  12 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  33 ++--
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.h |   2 -
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 149 +++-------------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 196 +++++----------------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |   4 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  86 +++------
 15 files changed, 317 insertions(+), 456 deletions(-)

-- 
1.9.1

