Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34323 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753598AbdFMOwn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 10:52:43 -0400
Received: by mail-pg0-f66.google.com with SMTP id v14so19235104pgn.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jun 2017 07:52:43 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 17/20] rsi: Optimise sdio claim and release host
Date: Tue, 13 Jun 2017 20:19:05 +0530
Message-Id: <1497365348-2305-18-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170613_165247_808878_1F8ECEDA)
In-Reply-To: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

SDIO host is already claimed in our interrupt handler. Some lower
level APIs claims host while performing SDIO read or write operations.
Let's use sdio_irq_task variable to check if we are in interrupt
context and claim/release the host accordingly.

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index f1ba8ac..42d558b 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -138,12 +138,15 @@ static int rsi_issue_sdiocommand(struct sdio_func *func,
 static void rsi_handle_interrupt(struct sdio_func *function)
 {
 	struct rsi_hw *adapter = sdio_get_drvdata(function);
+	struct rsi_91x_sdiodev *dev =
+		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
 
 	if (adapter->priv->fsm_state == FSM_FW_NOT_LOADED)
 		return;
-	sdio_release_host(function);
+
+	dev->sdio_irq_task = current;
 	rsi_interrupt_handler(adapter);
-	sdio_claim_host(function);
+	dev->sdio_irq_task = NULL;
 }
 
 /**
@@ -407,14 +410,16 @@ int rsi_sdio_read_register(struct rsi_hw *adapter,
 	u8 fun_num = 0;
 	int status;
 
-	sdio_claim_host(dev->pfunction);
+	if (likely(dev->sdio_irq_task != current))
+		sdio_claim_host(dev->pfunction);
 
 	if (fun_num == 0)
 		*data = sdio_f0_readb(dev->pfunction, addr, &status);
 	else
 		*data = sdio_readb(dev->pfunction, addr, &status);
 
-	sdio_release_host(dev->pfunction);
+	if (likely(dev->sdio_irq_task != current))
+		sdio_release_host(dev->pfunction);
 
 	return status;
 }
@@ -438,14 +443,16 @@ int rsi_sdio_write_register(struct rsi_hw *adapter,
 		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
 	int status = 0;
 
-	sdio_claim_host(dev->pfunction);
+	if (likely(dev->sdio_irq_task != current))
+		sdio_claim_host(dev->pfunction);
 
 	if (function == 0)
 		sdio_f0_writeb(dev->pfunction, *data, addr, &status);
 	else
 		sdio_writeb(dev->pfunction, *data, addr, &status);
 
-	sdio_release_host(dev->pfunction);
+	if (likely(dev->sdio_irq_task != current))
+		sdio_release_host(dev->pfunction);
 
 	return status;
 }
@@ -490,11 +497,13 @@ static int rsi_sdio_read_register_multiple(struct rsi_hw *adapter,
 		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
 	u32 status;
 
-	sdio_claim_host(dev->pfunction);
+	if (likely(dev->sdio_irq_task != current))
+		sdio_claim_host(dev->pfunction);
 
 	status =  sdio_readsb(dev->pfunction, data, addr, count);
 
-	sdio_release_host(dev->pfunction);
+	if (likely(dev->sdio_irq_task != current))
+		sdio_release_host(dev->pfunction);
 
 	if (status != 0)
 		rsi_dbg(ERR_ZONE, "%s: Synch Cmd53 read failed\n", __func__);
@@ -532,11 +541,13 @@ int rsi_sdio_write_register_multiple(struct rsi_hw *adapter,
 		dev->write_fail++;
 	}
 
-	sdio_claim_host(dev->pfunction);
+	if (likely(dev->sdio_irq_task != current))
+		sdio_claim_host(dev->pfunction);
 
 	status = sdio_writesb(dev->pfunction, addr, data, count);
 
-	sdio_release_host(dev->pfunction);
+	if (likely(dev->sdio_irq_task != current))
+		sdio_release_host(dev->pfunction);
 
 	if (status) {
 		rsi_dbg(ERR_ZONE, "%s: Synch Cmd53 write failed %d\n",
-- 
2.7.4
