Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:35356 "EHLO
        mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757504AbcILJn6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 05:43:58 -0400
Received: by mail-pa0-f65.google.com with SMTP id pp5so7549083pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2016 02:43:58 -0700 (PDT)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        johannes.berg@intel.com, hofrat@osadl.org
Cc: prameela.j04cs@gmail.com, prameela.garnepudi@redpinesignals.com
Subject: [PATCH 9/9] rsi: code cleanup in file rsi_91x_usb_ops.c
Date: Mon, 12 Sep 2016 15:08:24 +0530
Message-Id: <f6204fbacd7300f323ea35cd2c7a2a6fd5d9b5c0.1473669618.git.prameela.j04cs@gmail.com> (sfid-20160912_114401_856815_3BCB581E)
In-Reply-To: <cover.1473669618.git.prameela.j04cs@gmail.com>
References: <cover.1473669618.git.prameela.j04cs@gmail.com>
In-Reply-To: <cover.1473669618.git.prameela.j04cs@gmail.com>
References: <cover.1473669618.git.prameela.j04cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
index de49008..5ab2ce3 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
@@ -96,26 +96,25 @@ void rsi_usb_rx_thread(struct rsi_common *common)
 		rsi_wait_event(&dev->rx_thread.event, EVENT_WAIT_FOREVER);
 
 		if (atomic_read(&dev->rx_thread.thread_done))
-			goto out;
+			break;
 
 		mutex_lock(&common->tx_rxlock);
 		status = rsi_read_pkt(common, 0);
 		if (status) {
 			rsi_dbg(ERR_ZONE, "%s: Failed To read data", __func__);
 			mutex_unlock(&common->tx_rxlock);
-			return;
+			break;
 		}
 		mutex_unlock(&common->tx_rxlock);
 		rsi_reset_event(&dev->rx_thread.event);
 		if (adapter->rx_urb_submit(adapter)) {
 			rsi_dbg(ERR_ZONE,
 				"%s: Failed in urb submission", __func__);
-			return;
+			break;
 		}
 	} while (1);
 
-out:
-	rsi_dbg(INFO_ZONE, "%s: Terminated thread\n", __func__);
+	rsi_dbg(INFO_ZONE, "%s: Terminated USB RX thread\n", __func__);
 	complete_and_exit(&dev->rx_thread.completion, 0);
 }
 
-- 
2.4.11
