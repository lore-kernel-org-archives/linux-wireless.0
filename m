Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35056 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754070AbdFPOiu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 10:38:50 -0400
Received: by mail-pg0-f67.google.com with SMTP id f127so6552689pgc.2
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jun 2017 07:38:50 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v2 3/6] rsi: Register interrupt handler before firmware load
Date: Fri, 16 Jun 2017 20:05:38 +0530
Message-Id: <1497623741-2082-4-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170616_163853_811477_B9B01D31)
In-Reply-To: <1497623741-2082-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1497623741-2082-1-git-send-email-amit.karwar@redpinesignals.com>
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
