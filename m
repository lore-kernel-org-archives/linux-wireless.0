Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:47509 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752623AbdFLLrp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Jun 2017 07:47:45 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH for-4.12 0/3] brcmfmac: fix sdio suspend crash due to firmware load failure
Date: Mon, 12 Jun 2017 12:47:31 +0100
Message-Id: <1497268054-4507-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170612_134748_501407_BD1C0728)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These three patches fix a reported issue that results in a crash
for sdio devices, because when the probe fails due to firmware load
failure or other reasons, the driver does not unbind all devices but
frees all resources. This causes a null-deref upon resuming from
system suspend. The solution has been split up.

This patch series is intended for 4.12 and applies to the master
branch of the wireless-drivers repository.

Arend van Spriel (3):
  brcmfmac: add parameter to pass error code in firmware callback
  brcmfmac: use firmware callback upon failure to load
  brcmfmac: unbind all devices upon failure in firmware callback

 .../broadcom/brcm80211/brcmfmac/firmware.c         | 35 +++++++++++-----------
 .../broadcom/brcm80211/brcmfmac/firmware.h         |  4 +--
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 17 +++++++----
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 18 +++++++----
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  6 ++--
 5 files changed, 47 insertions(+), 33 deletions(-)

-- 
1.9.1
