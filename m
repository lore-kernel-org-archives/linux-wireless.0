Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33601 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753744AbdFMOwE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 10:52:04 -0400
Received: by mail-pf0-f196.google.com with SMTP id w12so11947232pfk.0
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jun 2017 07:52:03 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 10/20] rsi: set immediate wakeup bit
Date: Tue, 13 Jun 2017 20:18:58 +0530
Message-Id: <1497365348-2305-11-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170613_170119_647113_7183FB0E)
In-Reply-To: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
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
