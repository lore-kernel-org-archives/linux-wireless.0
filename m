Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:43609 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbeH0TVY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Aug 2018 15:21:24 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>,
        Taketo Kabe <kabe@sra-tohoku.co.jp>
Subject: [PATCH] b43: Fix regression in kernel 4.18
Date: Mon, 27 Aug 2018 10:34:07 -0500
Message-Id: <20180827153407.5612-1-Larry.Finger@lwfinger.net> (sfid-20180827_173427_211643_5850C325)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
Reported-and-tested-by: D. Prabhu <d.praabhu@gmail.com>
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
