Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35040 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751829AbdHAJKZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 05:10:25 -0400
Received: by mail-pg0-f68.google.com with SMTP id l64so1724512pge.2
        for <linux-wireless@vger.kernel.org>; Tue, 01 Aug 2017 02:10:25 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: [PATCH 7/8] rsi: buffer available interrupt handling
Date: Tue,  1 Aug 2017 14:35:51 +0530
Message-Id: <1501578352-10795-8-git-send-email-amitkarwar@gmail.com> (sfid-20170801_111028_511858_0D3A83AC)
In-Reply-To: <1501578352-10795-1-git-send-email-amitkarwar@gmail.com>
References: <1501578352-10795-1-git-send-email-amitkarwar@gmail.com>
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
