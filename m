Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37532 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752430AbcKRVoa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 16:44:30 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 0/7] rtl8xxxu: Pending patches
Date: Fri, 18 Nov 2016 16:44:21 -0500
Message-Id: <1479505468-29383-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20161118_224434_644438_5D862A4E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Kalle,

Please find attached a number of patches for the rtl8xxxu
driver.

The issues reported with wpa_supplicant on 8723bu still needs further
investigation.

Note the memory leak issue has only been seen with 8188eu devices so
far, but it's serious and needs to be plugged.

These are what I currently have in my pending queue. Apologies if I
already posted some of these, trying to get back in sync after
Plumbers.

Cheers,
Jes


Jes Sorensen (6):
  rtl8xxxu: Fix memory leak in handling rxdesc16 packets
  rtl8xxxu: Fix big-endian problem reporting mactime
  rtl8xxxu: Fix rtl8723bu driver reload issue
  rtl8xxxu: Fix rtl8192eu driver reload issue
  rtl8xxxu: Obtain RTS rates from mac80211
  rtl8xxxu: Pass tx_info to fill_txdesc in order to have access to retry
    count

Wei Yongjun (1):
  rtl8xxxu: Fix non static symbol warning

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  31 +++---
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |  10 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c |   4 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 114 ++++++++++++++-------
 4 files changed, 104 insertions(+), 55 deletions(-)

-- 
2.7.4
