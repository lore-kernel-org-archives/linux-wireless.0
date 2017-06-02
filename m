Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34368 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751145AbdFBOPp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 10:15:45 -0400
Received: by mail-pf0-f194.google.com with SMTP id w69so11906677pfk.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jun 2017 07:15:44 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 3/6] rsi: Register interrupt handler before firmware load
Date: Fri,  2 Jun 2017 19:43:02 +0530
Message-Id: <1496412785-8720-4-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170602_161547_963903_D1B070B1)
In-Reply-To: <1496412785-8720-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1496412785-8720-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Before firmware load, sometimes false interrupts are received.
System hang is observed if interrupt handler is not registered
to receive these interrupts. Hence interrupt handler registration
is moved before firmware load. We will drop these false interrupts
as these are not from the device.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c  |  1 +
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 21 +++++++++++----------
 drivers/net/wireless/rsi/rsi_main.h     |  1 +
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 3d24e8e..94e074d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -733,6 +733,7 @@ int rsi_hal_device_init(struct rsi_hw *adapter)
 	default:
 		return -EINVAL;
 	}
+	common->fsm_state = FSM_CARD_NOT_READY;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 2ef844a..e5ea99b 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -139,6 +139,8 @@ static void rsi_handle_interrupt(struct sdio_func *function)
 {
 	struct rsi_hw *adapter = sdio_get_drvdata(function);
 
+	if (adapter->priv->fsm_state == FSM_FW_NOT_LOADED)
+		return;
 	sdio_release_host(function);
 	rsi_interrupt_handler(adapter);
 	sdio_claim_host(function);
@@ -908,10 +910,19 @@ static int rsi_probe(struct sdio_func *pfunction,
 			__func__);
 		goto fail;
 	}
+	sdio_claim_host(pfunction);
+	if (sdio_claim_irq(pfunction, rsi_handle_interrupt)) {
+		rsi_dbg(ERR_ZONE, "%s: Failed to request IRQ\n", __func__);
+		sdio_release_host(pfunction);
+		goto fail;
+	}
+	sdio_release_host(pfunction);
+	rsi_dbg(INIT_ZONE, "%s: Registered Interrupt handler\n", __func__);
 
 	if (rsi_hal_device_init(adapter)) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in device init\n", __func__);
 		sdio_claim_host(pfunction);
+		sdio_release_irq(pfunction);
 		sdio_disable_func(pfunction);
 		sdio_release_host(pfunction);
 		goto fail;
@@ -923,16 +934,6 @@ static int rsi_probe(struct sdio_func *pfunction,
 		return -EIO;
 	}
 
-	sdio_claim_host(pfunction);
-	if (sdio_claim_irq(pfunction, rsi_handle_interrupt)) {
-		rsi_dbg(ERR_ZONE, "%s: Failed to request IRQ\n", __func__);
-		sdio_release_host(pfunction);
-		goto fail;
-	}
-
-	sdio_release_host(pfunction);
-	rsi_dbg(INIT_ZONE, "%s: Registered Interrupt handler\n", __func__);
-
 	return 0;
 fail:
 	rsi_91x_deinit(adapter);
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 833c66f5..74ae0ac 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -32,6 +32,7 @@
 #define ISR_ZONE                        BIT(8)  /* For Interrupt Msgs         */
 
 enum RSI_FSM_STATES {
+	FSM_FW_NOT_LOADED,
 	FSM_CARD_NOT_READY,
 	FSM_BOOT_PARAMS_SENT,
 	FSM_EEPROM_READ_MAC_ADDR,
-- 
2.7.4
