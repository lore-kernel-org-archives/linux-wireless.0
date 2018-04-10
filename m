Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:34548 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751600AbeDJRmy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 13:42:54 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org, kvalo@codeaurora.org,
        rfried@codeaurora.org, bjorn.andersson@linaro.org,
        Daniel Mack <daniel@zonque.org>
Subject: [PATCH 0/1] RFC: memory coherency and data races on TX path
Date: Tue, 10 Apr 2018 19:42:44 +0200
Message-Id: <20180410174245.1116-1-daniel@zonque.org> (sfid-20180410_194259_251362_16320741)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I found something that I believe might be an issue, and I have an
idea on how to correct this, but unfortunately, this doesn't solve
the issues I occasionally see with this driver. I'd still like to 
share it, because I might be totally mistaken in my understanding.

With no firmware code or documentation at hand, it's not exactly clear
which assumption the firmware makes, but obviously, the driver and the
firmware share memory to exchange descriptors that either contain
control information or payload. The driver puts control descriptors
and payload descriptors in a ring buffer in an interleaved fashion.

When the driver wants to send an skb, it looks for a currently unused
control descriptor, and then fills it, together with its directly
chained payload descriptor. The descriptors are both marked valid and
then the firmware is instructed to start processing the ringbuffer.
In case the firmware is idle when wcn36xx_dxe_tx_frame() is entered,
this is all fine. However, when sending many packets in a short time
frame, there are cases when the firmware is still processing the ring
buffer (iow, ch->reg_ctrl & WCN36xx_DXE_CH_CTRL_EN != 0), and in this
case, writes to the shared memory area depict a data race. The local
spinlock of course doesn't help to prevent that. OTOH, it should be
completely fine to modify the descriptors while firmware is still
reading them, as the firmware should only pay attention to such that
are marked valid.

There's a problem with the latter presumption however which looks like
this in the driver code:

	desc->fr_len = ctl->skb->len;
	/* set dxe descriptor to VALID */
	desc->ctrl = ch->ctrl_skb;

The CPU may very well reorder the two writes, even though the memory is
allocated as coherent DMA. When that happens, the firmware may see a
wrong length for a valid descriptor. A simple memory write barrier would
suffice to solve this, but then again, there are two descriptors
involved.

My attempt to fix that restructures the code a bit and makes the
payload descriptor valid first and then the control descriptor, both
strongly ordered through memory fences. This however assumes that the
firmware will ignore valid payload descriptors unless they have a
valid control descriptor preceding them, but that's really just
guessing.

Does that make sense? As I said, I can't really say this improves
anything, sadly, so I might be mistaken entirely. But I'll leave this
here for further discussion. Ideally, somebody with access to the
firmware sources could give an assessment whether this is an issue at
all or not.


Thanks,
Daniel


Daniel Mack (1):
  wcn36xx: fix buffer commit logic on TX path

 drivers/net/wireless/ath/wcn36xx/dxe.c | 75 +++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 37 deletions(-)

-- 
2.14.3
