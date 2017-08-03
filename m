Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35108 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751878AbdHCOdr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 10:33:47 -0400
Received: by mail-pf0-f196.google.com with SMTP id j68so1672051pfc.2
        for <linux-wireless@vger.kernel.org>; Thu, 03 Aug 2017 07:33:47 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: [v2 7/8] rsi: buffer available interrupt handling
Date: Thu,  3 Aug 2017 19:59:03 +0530
Message-Id: <1501770544-6746-8-git-send-email-amitkarwar@gmail.com> (sfid-20170803_163349_908084_EF56DD04)
In-Reply-To: <1501770544-6746-1-git-send-email-amitkarwar@gmail.com>
References: <1501770544-6746-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

BUFFER_AVAILABLE interrupt is sent by firmware to indicate
change in buffer status. We should check buffer status while
handling this interrupt. Currently buffer status is checked
only while dequeueing packets. This patch fixes a data
traffic stuck problem observed occasionally.

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index 94a9fcd..8e2a95c 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -259,10 +259,12 @@ void rsi_interrupt_handler(struct rsi_hw *adapter)
 
 			switch (isr_type) {
 			case BUFFER_AVAILABLE:
-				dev->rx_info.watch_bufferfull_count = 0;
-				dev->rx_info.buffer_full = false;
-				dev->rx_info.semi_buffer_full = false;
-				dev->rx_info.mgmt_buffer_full = false;
+				status = rsi_sdio_check_buffer_status(adapter,
+								      0);
+				if (status < 0)
+					rsi_dbg(ERR_ZONE,
+						"%s: Failed to check buffer status\n",
+						__func__);
 				rsi_sdio_ack_intr(common->priv,
 						  (1 << PKT_BUFF_AVAILABLE));
 				rsi_set_event(&common->tx_thread.event);
@@ -270,7 +272,6 @@ void rsi_interrupt_handler(struct rsi_hw *adapter)
 				rsi_dbg(ISR_ZONE,
 					"%s: ==> BUFFER_AVAILABLE <==\n",
 					__func__);
-				dev->rx_info.buf_available_counter++;
 				dev->buff_status_updated = true;
 				break;
 
-- 
2.7.4
