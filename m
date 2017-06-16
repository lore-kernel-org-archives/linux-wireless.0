Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34164 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752999AbdFPO63 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 10:58:29 -0400
Received: by mail-pg0-f67.google.com with SMTP id j186so6648234pge.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jun 2017 07:58:29 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 17/20] rsi: Optimise sdio claim and release host
Date: Fri, 16 Jun 2017 20:24:38 +0530
Message-Id: <1497624881-2315-18-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170616_165832_147426_0D5D37CE)
In-Reply-To: <1497624881-2315-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1497624881-2315-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

SDIO host is already claimed in our interrupt handler. Some lower
level APIs claims host while performing SDIO read or write operations.
Let's use sdio_irq_task variable to check if we are in interrupt
context and claim/release the host accordingly.

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
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
