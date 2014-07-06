Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:48516 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaGFWUS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 18:20:18 -0400
Received: by mail-we0-f179.google.com with SMTP id w62so3557735wes.38
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 15:20:17 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/3] staging: vt6656: s_nsBulkInUsbIoCompleteRead check that used sk_buff is clean and ready to reuse.
Date: Sun,  6 Jul 2014 23:19:46 +0100
Message-Id: <1404685188-3182-1-git-send-email-tvboxspy@gmail.com> (sfid-20140707_002026_415140_BBCC51D5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

skb_push the headroom and trimmed back to 0

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
applies after patch staging: vt6656: Include re_alloc_skb within lock

 drivers/staging/vt6656/usbpipe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index c8b0ed5..dd031bb 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -303,6 +303,9 @@ static void s_nsBulkInUsbIoCompleteRead(struct urb *urb)
 				spin_unlock_irqrestore(&priv->lock, flags);
 				return;
 			}
+		} else {
+			skb_push(rcb->skb, skb_headroom(rcb->skb));
+			skb_trim(rcb->skb, 0);
 		}
 
 		urb->transfer_buffer = skb_put(rcb->skb,
-- 
1.9.1

