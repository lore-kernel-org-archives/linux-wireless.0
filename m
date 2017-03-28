Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:55764 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754795AbdC1I63 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 04:58:29 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Daniel J Blueman <daniel@quora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH for-4.11 0/2] brcmfmac: fixing use-after-free reports
Date: Tue, 28 Mar 2017 09:11:29 +0100
Message-Id: <1490688691-20100-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170328_112613_363874_C0BF96E8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two use-after-free issues were found using KASAN and reported by
Daniel J Blueman. One of them was submitted as patch. However, no
response came upon my comments. So decided to push the fixes myself.

These patches are intended for v4.11 and apply to the master branch of
the wireless-drivers repository.

Arend van Spriel (2):
  brcmfmac: use local iftype avoiding use-after-free of virtual
    interface
  cfg80211: check rdev resume callback only for registered wiphy

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  8 +++++---
 net/wireless/sysfs.c                                   | 10 ++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

-- 
1.9.1
