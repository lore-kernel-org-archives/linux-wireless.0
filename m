Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:36337 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbbKQFel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2015 00:34:41 -0500
Received: by qgad10 with SMTP id d10so65982455qga.3
        for <linux-wireless@vger.kernel.org>; Mon, 16 Nov 2015 21:34:41 -0800 (PST)
From: Steve deRosier <derosier@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org,
	Steve deRosier <steve.derosier@lairdtech.com>
Subject: [PATCH 2/2] ath6kl_sdio: Add power gpio reset feature into sdio driver for suspend
Date: Mon, 16 Nov 2015 21:32:53 -0800
Message-Id: <1447738373-15804-3-git-send-email-steve.derosier@lairdtech.com> (sfid-20151117_063445_938602_42081B7C)
In-Reply-To: <1447738373-15804-1-git-send-email-steve.derosier@lairdtech.com>
References: <1447738373-15804-1-git-send-email-steve.derosier@lairdtech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change adds pm suspend callbacks in order to trigger a gpio line
to push the CHIP_PWD_L reset/power line low on suspend. This puts the chip
into the lowest power state on suspend. On resume, it releases the line,
allowing the chip to boot. Slower, but provides a clean reset of the
chip and recovery from standby.

Signed-off-by: Steve deRosier <steve.derosier@lairdtech.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c | 45 ++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 7a732f3..b296809 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -1290,9 +1290,54 @@ static int ath6kl_sdio_pm_resume(struct device *device)
 	return 0;
 }
 
+#ifdef CONFIG_GPIOLIB
+/* Below handlers leverage the PM system to make sure we turn on and off
+ * the power gpio at the right time. If we do it in the earlier power on
+ * and off handlers for the sdio, we get errors from the mmc subsystem.
+ */
+static int ath6kl_sdio_pm_suspend_late(struct device *device)
+{
+	ath6kl_dbg(ATH6KL_DBG_SUSPEND, "sdio pm ath6kl_sdio_pm_suspend_late\n");
+
+	if (gpio_is_valid(reset_pwd_gpio))
+		gpio_set_value(reset_pwd_gpio, 0);
+
+	return 0;
+}
+
+static int ath6kl_sdio_pm_resume_early(struct device *device)
+{
+	ath6kl_dbg(ATH6KL_DBG_SUSPEND, "sdio pm ath6kl_sdio_pm_resume_early\n");
+
+	if (gpio_is_valid(reset_pwd_gpio))
+		gpio_set_value(reset_pwd_gpio, 1);
+
+	usleep_range(1000, 5000); /* wait for power up */
+
+	return 0;
+}
+
+/* The GPIO version requires the more complex dev_pm_ops setup */
+const struct dev_pm_ops ath6kl_sdio_pm_ops = {
+	.suspend = ath6kl_sdio_pm_suspend,
+	.suspend_late = ath6kl_sdio_pm_suspend_late,
+	.resume_early = ath6kl_sdio_pm_resume_early,
+	.resume = ath6kl_sdio_pm_resume,
+	.freeze = ath6kl_sdio_pm_suspend,
+	.thaw = ath6kl_sdio_pm_resume,
+	.poweroff = ath6kl_sdio_pm_suspend,
+	.poweroff_late = ath6kl_sdio_pm_suspend_late,
+	.restore_early = ath6kl_sdio_pm_resume_early,
+	.restore = ath6kl_sdio_pm_resume,
+};
+
+#else
+
 static SIMPLE_DEV_PM_OPS(ath6kl_sdio_pm_ops, ath6kl_sdio_pm_suspend,
 			 ath6kl_sdio_pm_resume);
 
+#endif /* CONFIG_GPIOLIB */
+
 #define ATH6KL_SDIO_PM_OPS (&ath6kl_sdio_pm_ops)
 
 #else
-- 
1.9.1

