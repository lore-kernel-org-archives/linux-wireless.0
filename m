Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:36790 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222AbbKRXWl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 18:22:41 -0500
Received: by qkda6 with SMTP id a6so20223388qkd.3
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2015 15:22:41 -0800 (PST)
From: Steve deRosier <derosier@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org,
	Steve deRosier <steve.derosier@lairdtech.com>
Subject: [PATCH v2 2/2] ath6kl_sdio: Add power gpio reset feature into sdio driver for suspend
Date: Wed, 18 Nov 2015 15:20:48 -0800
Message-Id: <1447888848-19530-3-git-send-email-steve.derosier@lairdtech.com> (sfid-20151119_002244_690385_06900655)
In-Reply-To: <1447888848-19530-1-git-send-email-steve.derosier@lairdtech.com>
References: <1447888848-19530-1-git-send-email-steve.derosier@lairdtech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change adds pm suspend callbacks in order to trigger a gpio line
to push the CHIP_PWD_L reset/power line low on suspend. This puts the chip
into the lowest power state on suspend. On resume, it releases the line,
allowing the chip to boot. Slower, but provides a clean reset of the
chip and recovery from standby.

Signed-off-by: Steve deRosier <steve.derosier@lairdtech.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c | 40 ++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index c0755eb..c411033 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -1288,8 +1288,44 @@ static int ath6kl_sdio_pm_resume(struct device *device)
 	return 0;
 }
 
-static SIMPLE_DEV_PM_OPS(ath6kl_sdio_pm_ops, ath6kl_sdio_pm_suspend,
-			 ath6kl_sdio_pm_resume);
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
+	if (gpio_is_valid(reset_pwd_gpio)) {
+		gpio_set_value(reset_pwd_gpio, 1);
+		usleep_range(1000, 5000); /* wait for power up */
+	}
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
 
 #define ATH6KL_SDIO_PM_OPS (&ath6kl_sdio_pm_ops)
 
-- 
1.9.1

