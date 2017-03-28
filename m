Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:41334 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754572AbdC1Knr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 06:43:47 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 0/5] brcmfmac: network namespace support
Date: Tue, 28 Mar 2017 11:43:23 +0100
Message-Id: <1490697808-5538-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170328_124743_086951_1B1D6207)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series intended for 4.12 includes:
- support for network namespace
- rework fwsignal module
- small fix for suspend error code path

Arend van Spriel (3):
  brcmfmac: add support to move wiphy instance into network namespace
  brcmfmac: restore bus state when enter_D3 fails
  brcmfmac: no need for d11inf instance in brcmf_pno_start_sched_scan()

Franky Lin (2):
  brcmfmac: wrap brcmf_fws_init into bcdc layer
  brcmfmac: move brcmf_fws_deinit to bcdc layer

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c     |  8 ++++++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c |  3 ++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c     | 12 +++---------
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c     |  1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c      |  2 --
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h    |  9 +++++++++
 6 files changed, 23 insertions(+), 12 deletions(-)

-- 
1.9.1
