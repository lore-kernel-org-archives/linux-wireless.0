Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:38222 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751323AbdH3OOS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 10:14:18 -0400
Received: by mail-pf0-f196.google.com with SMTP id r187so4383004pfr.5
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 07:14:18 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: [PATCH] rsi: sdio suspend and resume support
Date: Wed, 30 Aug 2017 19:39:32 +0530
Message-Id: <1504102172-5262-1-git-send-email-amitkarwar@gmail.com> (sfid-20170830_161422_467713_C101D301)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

SDIO suspend and resume handlers are implemented and verified
that device works after suspend/resume cycle.

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 126 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/rsi/rsi_sdio.h     |   2 +
 2 files changed, 124 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 8d3a483..855b605 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1059,16 +1059,134 @@ static void rsi_disconnect(struct sdio_func *pfunction)
 }
 
 #ifdef CONFIG_PM
+static int rsi_set_sdio_pm_caps(struct rsi_hw *adapter)
+{
+	struct rsi_91x_sdiodev *dev =
+		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
+	struct sdio_func *func = dev->pfunction;
+	int ret;
+
+	ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
+	if (ret)
+		rsi_dbg(ERR_ZONE, "Set sdio keep pwr flag failed: %d\n", ret);
+
+	return ret;
+}
+
+static int rsi_sdio_disable_interrupts(struct sdio_func *pfunc)
+{
+	struct rsi_hw *adapter = sdio_get_drvdata(pfunc);
+	u8 isr_status = 0, data = 0;
+	int ret;
+
+	rsi_dbg(INFO_ZONE, "Waiting for interrupts to be cleared..");
+	do {
+		rsi_sdio_read_register(adapter, RSI_FN1_INT_REGISTER,
+				       &isr_status);
+		rsi_dbg(INFO_ZONE, ".");
+	} while (isr_status);
+	rsi_dbg(INFO_ZONE, "Interrupts cleared\n");
+
+	sdio_claim_host(pfunc);
+	ret = rsi_cmd52readbyte(pfunc->card, RSI_INT_ENABLE_REGISTER, &data);
+	if (ret < 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Failed to read int enable register\n",
+			__func__);
+		goto done;
+	}
+
+	data &= RSI_INT_ENABLE_MASK;
+	ret = rsi_cmd52writebyte(pfunc->card, RSI_INT_ENABLE_REGISTER, data);
+	if (ret < 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Failed to write to int enable register\n",
+			__func__);
+		goto done;
+	}
+	ret = rsi_cmd52readbyte(pfunc->card, RSI_INT_ENABLE_REGISTER, &data);
+	if (ret < 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Failed to read int enable register\n",
+			__func__);
+		goto done;
+	}
+	rsi_dbg(INFO_ZONE, "int enable reg content = %x\n", data);
+
+done:
+	sdio_release_host(pfunc);
+	return ret;
+}
+
+static int rsi_sdio_enable_interrupts(struct sdio_func *pfunc)
+{
+	u8 data;
+	int ret;
+
+	sdio_claim_host(pfunc);
+	ret = rsi_cmd52readbyte(pfunc->card, RSI_INT_ENABLE_REGISTER, &data);
+	if (ret < 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Failed to read int enable register\n", __func__);
+		goto done;
+	}
+
+	data |= ~RSI_INT_ENABLE_MASK & 0xff;
+
+	ret = rsi_cmd52writebyte(pfunc->card, RSI_INT_ENABLE_REGISTER, data);
+	if (ret < 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Failed to write to int enable register\n",
+			__func__);
+		goto done;
+	}
+
+	ret = rsi_cmd52readbyte(pfunc->card, RSI_INT_ENABLE_REGISTER, &data);
+	if (ret < 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Failed to read int enable register\n", __func__);
+		goto done;
+	}
+	rsi_dbg(INFO_ZONE, "int enable reg content = %x\n", data);
+
+done:
+	sdio_release_host(pfunc);
+	return ret;
+}
+
 static int rsi_suspend(struct device *dev)
 {
-	/* Not yet implemented */
-	return -ENOSYS;
+	int ret;
+	struct sdio_func *pfunction = dev_to_sdio_func(dev);
+	struct rsi_hw *adapter = sdio_get_drvdata(pfunction);
+	struct rsi_common *common;
+
+	if (!adapter) {
+		rsi_dbg(ERR_ZONE, "Device is not ready\n");
+		return -ENODEV;
+	}
+	common = adapter->priv;
+	rsi_sdio_disable_interrupts(pfunction);
+
+	ret = rsi_set_sdio_pm_caps(adapter);
+	if (ret)
+		rsi_dbg(INFO_ZONE,
+			"Setting power management caps failed\n");
+	common->fsm_state = FSM_CARD_NOT_READY;
+
+	return 0;
 }
 
 static int rsi_resume(struct device *dev)
 {
-	/* Not yet implemented */
-	return -ENOSYS;
+	struct sdio_func *pfunction = dev_to_sdio_func(dev);
+	struct rsi_hw *adapter = sdio_get_drvdata(pfunction);
+	struct rsi_common *common = adapter->priv;
+
+	common->fsm_state = FSM_MAC_INIT_DONE;
+	rsi_sdio_enable_interrupts(pfunction);
+
+	return 0;
 }
 
 static const struct dev_pm_ops rsi_pm_ops = {
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index 95e4bed..49c549b 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -48,6 +48,8 @@ enum sdio_interrupt_type {
 
 #define RSI_DEVICE_BUFFER_STATUS_REGISTER       0xf3
 #define RSI_FN1_INT_REGISTER                    0xf9
+#define RSI_INT_ENABLE_REGISTER			0x04
+#define RSI_INT_ENABLE_MASK			0xfc
 #define RSI_SD_REQUEST_MASTER                   0x10000
 
 /* FOR SD CARD ONLY */
-- 
2.7.4
