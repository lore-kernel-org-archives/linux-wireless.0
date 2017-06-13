Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35729 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753677AbdFMOwv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 10:52:51 -0400
Received: by mail-pf0-f194.google.com with SMTP id s66so7361644pfs.2
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jun 2017 07:52:51 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 19/20] rsi: use separate mutex lock for receive thread
Date: Tue, 13 Jun 2017 20:19:07 +0530
Message-Id: <1497365348-2305-20-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170613_165254_290927_3A5397DD)
In-Reply-To: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

Deadlock issue is observed during our stress tests. The root
cause for the issue is same lock is used between tx and rx threads.

This patch adds a separate mutex lock for rx thread to resolve
the problem.

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 10 +++++-----
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c  |  6 +++---
 drivers/net/wireless/rsi/rsi_main.h         |  2 ++
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index b6d0e2a..b3f7adc 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -230,7 +230,7 @@ void rsi_interrupt_handler(struct rsi_hw *adapter)
 	dev->rx_info.sdio_int_counter++;
 
 	do {
-		mutex_lock(&common->tx_rxlock);
+		mutex_lock(&common->rx_lock);
 		status = rsi_sdio_read_register(common->priv,
 						RSI_FN1_INT_REGISTER,
 						&isr_status);
@@ -238,7 +238,7 @@ void rsi_interrupt_handler(struct rsi_hw *adapter)
 			rsi_dbg(ERR_ZONE,
 				"%s: Failed to Read Intr Status Register\n",
 				__func__);
-			mutex_unlock(&common->tx_rxlock);
+			mutex_unlock(&common->rx_lock);
 			return;
 		}
 		adapter->interrupt_status = isr_status;
@@ -246,7 +246,7 @@ void rsi_interrupt_handler(struct rsi_hw *adapter)
 		if (isr_status == 0) {
 			rsi_set_event(&common->tx_thread.event);
 			dev->rx_info.sdio_intr_status_zero++;
-			mutex_unlock(&common->tx_rxlock);
+			mutex_unlock(&common->rx_lock);
 			return;
 		}
 
@@ -304,7 +304,7 @@ void rsi_interrupt_handler(struct rsi_hw *adapter)
 					rsi_dbg(ERR_ZONE,
 						"%s: Failed to read pkt\n",
 						__func__);
-					mutex_unlock(&common->tx_rxlock);
+					mutex_unlock(&common->rx_lock);
 					return;
 				}
 				break;
@@ -319,7 +319,7 @@ void rsi_interrupt_handler(struct rsi_hw *adapter)
 			}
 			isr_status ^= BIT(isr_type - 1);
 		} while (isr_status);
-		mutex_unlock(&common->tx_rxlock);
+		mutex_unlock(&common->rx_lock);
 	} while (1);
 }
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
index d3e0a07..465692b 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
@@ -37,14 +37,14 @@ void rsi_usb_rx_thread(struct rsi_common *common)
 		if (atomic_read(&dev->rx_thread.thread_done))
 			goto out;
 
-		mutex_lock(&common->tx_rxlock);
+		mutex_lock(&common->rx_lock);
 		status = rsi_read_pkt(common, 0);
 		if (status) {
 			rsi_dbg(ERR_ZONE, "%s: Failed To read data", __func__);
-			mutex_unlock(&common->tx_rxlock);
+			mutex_unlock(&common->rx_lock);
 			return;
 		}
-		mutex_unlock(&common->tx_rxlock);
+		mutex_unlock(&common->rx_lock);
 		rsi_reset_event(&dev->rx_thread.event);
 		if (adapter->rx_urb_submit(adapter)) {
 			rsi_dbg(ERR_ZONE,
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index febecbd..6d41c9b 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -179,6 +179,8 @@ struct rsi_common {
 	struct mutex mutex;
 	/* Mutex used between tx/rx threads */
 	struct mutex tx_rxlock;
+	/* Mutex used for rx thread */
+	struct mutex rx_lock;
 	u8 endpoint;
 
 	/* Channel/band related */
-- 
2.7.4
