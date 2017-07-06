Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:32823 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751654AbdGFOmc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 10:42:32 -0400
Received: by mail-pg0-f67.google.com with SMTP id u62so503598pgb.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jul 2017 07:42:32 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: [v3 11/21] rsi: set immediate wakeup bit
Date: Thu,  6 Jul 2017 20:07:14 +0530
Message-Id: <1499351844-2046-12-git-send-email-amitkarwar@gmail.com> (sfid-20170706_164236_262236_186037D0)
In-Reply-To: <1499351844-2046-1-git-send-email-amitkarwar@gmail.com>
References: <1499351844-2046-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

immediate wakeup bit is set while sending internal management
frame to the firmware.

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index c230359..7c9224f 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -149,6 +149,7 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 	extnd_size = ((uintptr_t)skb->data & 0x3);
 
 	if (tx_params->flags & INTERNAL_MGMT_PKT) {
+		skb->data[1] |= BIT(7); /* Immediate Wakeup bit*/
 		if ((extnd_size) > skb_headroom(skb)) {
 			rsi_dbg(ERR_ZONE, "%s: Unable to send pkt\n", __func__);
 			dev_kfree_skb(skb);
-- 
2.7.4
