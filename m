Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:47024 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbeHZT5k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 26 Aug 2018 15:57:40 -0400
Received: by mail-oi0-f66.google.com with SMTP id y207-v6so23226599oie.13
        for <linux-wireless@vger.kernel.org>; Sun, 26 Aug 2018 09:14:41 -0700 (PDT)
Subject: Re: [Regression]BCM4312 is broken in kernel 4.18[Root cause found]
To: prabhu <d.praabhu@gmail.com>, Taketo Kabe <kabe@sra-tohoku.co.jp>
Cc: kvalo@codeaurora.org, m@bues.ch, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org
References: <CAHnrWRruLuuPN+bYc4NqO515W8+wHoCPH16ULsnJV_JrD+9oEw@mail.gmail.com>
 <20180823201147.393b1d53@wiggum> <87lg8wjhqe.fsf@kamboji.qca.qualcomm.com>
 <f9553dfe-d89b-0760-29c6-cdad29b54f6f@lwfinger.net>
 <CAHnrWRp2n7W_Xb5kjT1ykcC0gL3ONc+dmqePAbKEEBHLd1euFA@mail.gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <25814b23-dcc9-3a20-7276-40818bbba6cb@lwfinger.net> (sfid-20180826_181529_761184_9652D9E1)
Date: Sun, 26 Aug 2018 11:14:38 -0500
MIME-Version: 1.0
In-Reply-To: <CAHnrWRp2n7W_Xb5kjT1ykcC0gL3ONc+dmqePAbKEEBHLd1euFA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------2089F2158891A7E781A0BA33"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------2089F2158891A7E781A0BA33
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/26/2018 02:23 AM, prabhu wrote:
> Larry,
> 
> Upgrading the firmware didn't fix the issue.
> 
> The patch fixes it. My system has been running without any issues
> since yesterday.

I did not think the new firmware would help, but it had to be tried. Thanks for 
the testing.

@Pradhu & @Taketo: Attached is a new (improved?) patch for you to try. You need 
to start from an unmodified 4.18 source. This patch should allow both of your 
systems to work and avoid needing to revert Taketo's fix for his setup.

Thanks,

Larry



--------------2089F2158891A7E781A0BA33
Content-Type: text/x-patch;
 name="0001-b43-Fix-regression-in-kernel-4.18.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-b43-Fix-regression-in-kernel-4.18.patch"

>From 4805a08715de42d49587975979425031307218b6 Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Sun, 26 Aug 2018 10:47:52 -0500
Subject: [PATCH] b43: Fix regression in kernel 4.18
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org

In commit 66cffd6daab7 ("b43: fix transmit failure when VT is switched"),
a condition is noted where the network controller needs to be reset. Note
that this situation happens when running the open-source firmware
(http://netweb.ing.unibs.it/~openfwwf/), plus a number of other special
conditions.

for a different card model, it is reported that this change breaks
operation running the proprietary firmware
(https://marc.info/?l=linux-wireless&m=153504546924558&w=2). Rather
than reverting the previous patch, the code is tweaked to avoid the
reset unless the open-source firmware is being used.

Fixes: 66cffd6daab7 ("b43: fix transmit failure when VT is switched")
Cc: Stable <stable@vger.kernel.org> # 4.18+
Cc: Taketo Kabe <kabe@sra-tohoku.co.jp>
Cc: D. Prabhu <d.praabhu@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/broadcom/b43/dma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/dma.c b/drivers/net/wireless/broadcom/b43/dma.c
index 6b0e1ec346cb..d46d57b989ae 100644
--- a/drivers/net/wireless/broadcom/b43/dma.c
+++ b/drivers/net/wireless/broadcom/b43/dma.c
@@ -1518,13 +1518,15 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
 			}
 		} else {
 			/* More than a single header/data pair were missed.
-			 * Report this error, and reset the controller to
+			 * Report this error. If running with open-source
+			 * firmware, then reset the controller to
 			 * revive operation.
 			 */
 			b43dbg(dev->wl,
 			       "Out of order TX status report on DMA ring %d. Expected %d, but got %d\n",
 			       ring->index, firstused, slot);
-			b43_controller_restart(dev, "Out of order TX");
+			if (dev->fw.opensource)
+				b43_controller_restart(dev, "Out of order TX");
 			return;
 		}
 	}
-- 
2.18.0


--------------2089F2158891A7E781A0BA33--
