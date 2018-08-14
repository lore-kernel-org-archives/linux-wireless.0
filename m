Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx01-sz.bfs.de ([194.94.69.67]:63784 "EHLO mx01-sz.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbeHNNEa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 09:04:30 -0400
Date: Tue, 14 Aug 2018 12:17:56 +0200 (CEST)
From: Walter Harms <wharms@bfs.de>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-ID: <1853234188.165364.1534241877338@ox-groupware.bfs.de> (sfid-20180814_121803_132859_762F4802)
Subject: re:[PATCH] libertas_tf: prevent underflow in process_cmdrequest()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If recvlength is less than MESSAGE_HEADER_LEN (4) we would end up
corrupting memory.

Fixes: c305a19a0d0a ("libertas_tf: usb specific functions")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This is from static analysis.  I'm not positive that this is a real
bug, but it's harmless to check.

diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
index e92fc5001171..789337ea676a 100644
--- a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
@@ -605,9 +605,10 @@ static inline void process_cmdrequest(int recvlength,
uint8_t *recvbuff,
 {
 	unsigned long flags;
 -	if (recvlength > LBS_CMD_BUFFER_SIZE) {
+	if (recvlength < MESSAGE_HEADER_LEN ||
+	    recvlength > LBS_CMD_BUFFER_SIZE) {
 		lbtf_deb_usbd(&cardp->udev->dev,
-			     "The receive buffer is too large\n");
+			     "The receive buffer is invalid: %d\n", recvlength);

The wording here is a bit unfortunate, and give the user a false impression (at
least me).
The problem is the paketsize not the buffer.
therefor i suggest to change that into:
 "received invalid paketsize %d\n"

just my 2 cents,

re,
 wh
 		kfree_skb(skb);
 		return;
 	}
