Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:46771 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754772AbdDFMPA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 08:15:00 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 0/6] brcmfmac: fwsignal and scheduled scan rework
Date: Thu,  6 Apr 2017 13:14:36 +0100
Message-Id: <1491480882-13877-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170406_141508_758203_B9F20E5A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series is intended for 4.12 including:
 * rework for fwsignal module.
 * tighten length checks for scheduled scan result event.
 * fix duplicate entries in scan request for scheduled scan.

The patches apply to the master branch of the wireless-drivers-next
repository.

Arend van Spriel (6):
  brcmfmac: rename brcmf_fws_{de,}init to brcmf_fws{at,de}tach
  brcmfmac: ignore interfaces when fwsignal is disabled
  brcmfmac: remove reference to fwsignal data from struct brcmf_pub
  brcmfmac: add length checks in scheduled scan result handler
  brcmfmac: remove bogus check in scheduled scan result handler
  brcmfmac: only add channels and ssids once in scan request

 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    | 35 ++++++++++----
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.h    |  1 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 39 +++++++++++-----
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  2 -
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         | 53 ++++++++++------------
 .../broadcom/brcm80211/brcmfmac/fwsignal.h         |  4 +-
 6 files changed, 82 insertions(+), 52 deletions(-)

-- 
1.9.1
