Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:45608 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753686AbeDZKUG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 06:20:06 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 0/6] brcmfmac: new pcie fw-api support and cleanup
Date: Thu, 26 Apr 2018 12:19:59 +0200
Message-Id: <1524737999-2277-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180426_122010_590761_B68A8D9C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains following:
  * support for PCIe rev7 firmware api.
  * include boottime stamp for bss.
  * check user-space provided P2P DEVICE mac address.

The series applies to the master branch of wireless-drivers-next repository.

Arend van Spriel (2):
  brcmfmac: check p2pdev mac address uniqueness
  brcmfmac: constify firmware mapping tables

Franky Lin (4):
  brcmfmac: reports boottime_ns while informing bss
  brcmfmac: use nl80211_band directly to get ieee80211 channel
  brcmfmac: add hostready indication
  brcmfmac: coarse support for PCIe shared structure rev7

 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 34 +++++++++----------
 .../broadcom/brcm80211/brcmfmac/firmware.c         |  2 +-
 .../broadcom/brcm80211/brcmfmac/firmware.h         |  2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.h  |  6 ++--
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  7 ++++
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 39 ++++++++++++++++++----
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  2 +-
 8 files changed, 64 insertions(+), 30 deletions(-)

--
1.9.1
