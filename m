Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:1712 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092AbbBFRgx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 12:36:53 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/6] brcmfmac: sdio suspend rework and debugfs change
Date: Fri, 6 Feb 2015 18:36:41 +0100
Message-ID: <1423244207-9707-1-git-send-email-arend@broadcom.com> (sfid-20150206_183703_964637_8B589B4B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here some late patches for 3.20 kernel. Most related to SDIO as that
received a bit more attention last couple of weeks. Also added a debugfs
file so users can provide us all the revinfo we could ask for.

This series is intended for v3.20 and applies to the master branch of
the wireless-drivers-next repository.

Arend van Spriel (3):
  brcmfmac: use helper function for changing SDIO state
  brcmfmac: add debugfs file containing revision info
  brcmfmac: make sdio suspend wait for threads to freeze

Hante Meuleman (3):
  brcmfmac: Remove error print for invalid key index.
  brcmfmac: Dont sleep when ctrl frames to transmit.
  brcmfmac: Fix escan timer causing oops.

 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   | 166 +++++++++++++++++----
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c |  11 +-
 drivers/net/wireless/brcm80211/brcmfmac/core.c     |  30 ++++
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c     | 109 ++++++++------
 drivers/net/wireless/brcm80211/brcmfmac/sdio.h     |  47 ++++--
 5 files changed, 270 insertions(+), 93 deletions(-)

-- 
1.9.1

