Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:35502 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751671AbeEPOIc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 10:08:32 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org, kvalo@codeaurora.org,
        rfried@codeaurora.org, bjorn.andersson@linaro.org,
        nicolas.dechesne@linaro.org, loic.poulain@linaro.org,
        Daniel Mack <daniel@zonque.org>
Subject: [PATCH 00/10] Some more patches for wcn36xx
Date: Wed, 16 May 2018 16:08:10 +0200
Message-Id: <20180516140820.1636-1-daniel@zonque.org> (sfid-20180516_160836_202689_84247628)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are some more patches for the wcn36xx driver that emerged from
reviews and my attempts to fix the connection timeout issues. Some of
them merely bring the driver in sync with what the "prima" downstream
driver is doing, and they seemingly make the driver more stable.
Others just apply some best practice patterns or do some cleanup.

The first patch in the series is one that I've sent earlier as RFC, and
Loic expressed his support in a follow-up. I still believe it does the
right thing.

However, the connection timeout problems are still there unfortunately,
but they seemingly appear to happen less often now.

To recap, when the driver gets stuck, not a single packet is being sent
out anymore. I have a 2nd machine tuned to the same channel to capture
all packets from the MAC of the device under test, and it shows a flat
line once the connection timeouts happen. Some more context is given in
this bug report:

  https://bugs.96boards.org/show_bug.cgi?id=538

One interesting find is that setting the debug_mask module parameter to
0x4 or 0x400 (or both), the issue is much less likely to happen. All
this does is adding printk()s before each message is sent out, and that
affects the timings of course. I tried adding mdelay() there instead,
and they too make the effect less likely, but they don't make it go
away.

Hence I believe that some sort of firmware internal buffer is overrun if
too many SMD requests fly in in a short amount of time. The firmware
does, however, still ack all packets just fine on the SMD channels, and
also the DXE communication flows are all healthy. No errors are reported
anywhere, but nothing is being put on the ether anymore.

I'm running out of ideas at this point. I guess without access to the
firmware sources, it's virtually impossible to grok what's going on and
how to work around whatever is causing it.

If anyone has an idea on how to debug this frustrating issue any further,
please let me know. A reproducer is described in the bug reported linked
to above.


Thanks,
Daniel


Daniel Mack (10):
  wcn36xx: fix buffer commit logic on TX path
  wcn36xx: set DMA mask explicitly
  wcn36xx: don't disable RX IRQ from handler
  wcn36xx: clear all masks in RX interrupt
  wcn36xx: only handle packets when ED or DONE bit is set
  wcn36xx: consider CTRL_EOP bit when looking for valid descriptors
  wcn36xx: set PREASSOC and IDLE stated when BSS info changes
  wcn36xx: drain pending indicator messages on shutdown
  wcn36xx: simplify wcn36xx_smd_open()
  wcn36xx: improve debug and error messages for SMD

 drivers/net/wireless/ath/wcn36xx/dxe.c  | 176 ++++++++++++++++++++------------
 drivers/net/wireless/ath/wcn36xx/main.c |  10 ++
 drivers/net/wireless/ath/wcn36xx/smd.c  |  32 +++---
 3 files changed, 137 insertions(+), 81 deletions(-)

-- 
2.14.3
