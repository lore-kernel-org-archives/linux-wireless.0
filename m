Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48608 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755310AbcI2Tk4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Sep 2016 15:40:56 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        stable@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 0/2] rtl8xxxu: Fix memory leak and big endian bug
Date: Thu, 29 Sep 2016 15:40:53 -0400
Message-Id: <1475178055-16924-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160929_214101_922428_32BE1553)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

These two patches for 4.9 fix a potential memory leak for gen1 parts
and a big endian problem reporting mactime.

While I have only seen it trigger for 8188eu devices, in code which
has not yet been submitted, it could potentially hit other parts such
as 8723au, 8188cu, 8192cu. I prefer to get it fixed asap.

The second bug is a double byte-swap of the mactime read from the RX
packet descriptor.

Both fixes should be applicable to stable-4.8.

Cheers,
Jes


Jes Sorensen (2):
  rtl8xxxu: Fix memory leak in handling rxdesc16 packets
  rtl8xxxu: Fix big-endian problem reporting mactime

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h      |  4 ++--
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 11 ++++++++---
 2 files changed, 10 insertions(+), 5 deletions(-)

-- 
2.7.4
