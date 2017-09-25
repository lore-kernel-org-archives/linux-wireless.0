Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32878 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934940AbdIYN11 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 09:27:27 -0400
Received: by mail-pf0-f194.google.com with SMTP id h4so3610955pfk.0
        for <linux-wireless@vger.kernel.org>; Mon, 25 Sep 2017 06:27:27 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: [PATCH 2/3] rsi: sdio: Add WOWLAN support for S4 hibernate state
Date: Mon, 25 Sep 2017 18:51:49 +0530
Message-Id: <1506345709-4699-1-git-send-email-amitkarwar@gmail.com> (sfid-20170925_152949_233300_48A19DC3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

We are disabling of interrupts from firmware in freeze handler.
Also setting power management capability KEEP_MMC_POWER to make
device wakeup for WoWLAN trigger.
At restore, we observed a device reset on some platforms. Hence
reloading of firmware and device initialization is performed.

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 109 ++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 28efa17..b8b5795 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1202,9 +1202,118 @@ static int rsi_resume(struct device *dev)
 	return 0;
 }
 
+static int rsi_freeze(struct device *dev)
+{
+	int ret;
+	struct sdio_func *pfunction = dev_to_sdio_func(dev);
+	struct rsi_hw *adapter = sdio_get_drvdata(pfunction);
+	struct rsi_common *common;
+	struct rsi_91x_sdiodev *sdev;
+
+	rsi_dbg(INFO_ZONE, "SDIO Bus freeze ===>\n");
+
+	if (!adapter) {
+		rsi_dbg(ERR_ZONE, "Device is not ready\n");
+		return -ENODEV;
+	}
+	common = adapter->priv;
+	sdev = (struct rsi_91x_sdiodev *)adapter->rsi_dev;
+
+#ifdef CONFIG_RSI_WOW
+	if ((common->wow_flags & RSI_WOW_ENABLED) &&
+	    (common->wow_flags & RSI_WOW_NO_CONNECTION))
+		rsi_dbg(ERR_ZONE,
+			"##### Device can not wake up through WLAN\n");
+#endif
+	ret = rsi_sdio_disable_interrupts(pfunction);
+
+	if (sdev->write_fail)
+		rsi_dbg(INFO_ZONE, "###### Device is not ready #######\n");
+
+	ret = rsi_set_sdio_pm_caps(adapter);
+	if (ret)
+		rsi_dbg(INFO_ZONE, "Setting power management caps failed\n");
+
+	rsi_dbg(INFO_ZONE, "***** RSI module freezed *****\n");
+
+	return 0;
+}
+
+static int rsi_thaw(struct device *dev)
+{
+	struct sdio_func *pfunction = dev_to_sdio_func(dev);
+	struct rsi_hw *adapter = sdio_get_drvdata(pfunction);
+	struct rsi_common *common = adapter->priv;
+
+	rsi_dbg(ERR_ZONE, "SDIO Bus thaw =====>\n");
+
+	common->fsm_state = FSM_CARD_NOT_READY;
+	common->iface_down = true;
+
+	rsi_sdio_enable_interrupts(pfunction);
+
+	rsi_dbg(INFO_ZONE, "***** RSI module thaw done *****\n");
+
+	return 0;
+}
+
+static int rsi_sdio_reinit_device(struct rsi_hw *adapter)
+{
+	struct rsi_91x_sdiodev *sdev = adapter->rsi_dev;
+	struct sdio_func *pfunction = sdev->pfunction;
+	int ii;
+
+	for (ii = 0; ii < NUM_SOFT_QUEUES; ii++)
+		skb_queue_purge(&adapter->priv->tx_queue[ii]);
+
+	rsi_mac80211_detach(adapter);
+
+	/* Initialize device again */
+	sdio_claim_host(pfunction);
+
+	sdio_release_irq(pfunction);
+	rsi_reset_card(pfunction);
+
+	sdio_enable_func(pfunction);
+	rsi_setupcard(adapter);
+	rsi_init_sdio_slave_regs(adapter);
+	sdio_claim_irq(pfunction, rsi_handle_interrupt);
+	rsi_hal_device_init(adapter);
+
+	sdio_release_host(pfunction);
+
+	return 0;
+}
+
+static int rsi_restore(struct device *dev)
+{
+	struct sdio_func *pfunction = dev_to_sdio_func(dev);
+	struct rsi_hw *adapter = sdio_get_drvdata(pfunction);
+	struct rsi_common *common = adapter->priv;
+
+	rsi_dbg(INFO_ZONE, "SDIO Bus restore ======>\n");
+
+	common->fsm_state = FSM_FW_NOT_LOADED;
+	common->iface_down = true;
+
+	/* Initialize device again */
+	rsi_sdio_reinit_device(adapter);
+
+#ifdef CONFIG_RSI_WOW
+	common->wow_flags = 0;
+#endif
+	common->iface_down = false;
+
+	rsi_dbg(INFO_ZONE, "RSI module restored\n");
+
+	return 0;
+}
 static const struct dev_pm_ops rsi_pm_ops = {
 	.suspend = rsi_suspend,
 	.resume = rsi_resume,
+	.freeze = rsi_freeze,
+	.thaw = rsi_thaw,
+	.restore = rsi_restore,
 };
 #endif
 
-- 
2.7.4
