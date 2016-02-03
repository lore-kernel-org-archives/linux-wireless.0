Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:11421 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754995AbcBCGR7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 01:17:59 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, <wnhuang@chromium.org>,
	<devicetree@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/3] mwifiex: parse host wakeup configuration from device tree
Date: Tue, 2 Feb 2016 22:14:20 -0800
Message-ID: <1454480060-27314-3-git-send-email-akarwar@marvell.com> (sfid-20160203_071806_387014_1242C249)
In-Reply-To: <1454480060-27314-1-git-send-email-akarwar@marvell.com>
References: <1454480060-27314-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch implement a framework for board specific wakeup.
driver parse irq/gpio number from device tree, corresponding
resources will be allocated, and used for host suspend/resume.
driver private binding file is also updated in the patch.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 Documentation/devicetree/bindings/mwifiex.txt      | 10 +++
 .../net/wireless/marvell/mwifiex/platform_drv.c    | 93 ++++++++++++++++++++++
 2 files changed, 103 insertions(+)

diff --git a/Documentation/devicetree/bindings/mwifiex.txt b/Documentation/devicetree/bindings/mwifiex.txt
index 367c97e..68919c7 100644
--- a/Documentation/devicetree/bindings/mwifiex.txt
+++ b/Documentation/devicetree/bindings/mwifiex.txt
@@ -14,6 +14,11 @@ Optional properties:
   - mwifiex,chip-gpio : Chip's wakeup gpio pin number. This needs to be downloaded
 			to to firmware. Chip notifies wifi wakeup signal to SOC
 			through this pin.
+  - interrupt-parent: phandle of the parent interrupt controller
+  - interrupts : interrupt number to the cpu
+  - gpios: specify SOC's wakeup GPIO
+  - pinctrl-names : a pinctrl state named "default" must be defined
+  - pinctrl-0 : pin control group to be used for this controller
 
 Example:
 
@@ -27,5 +32,10 @@ mwifiex {
 	mwifiex,caldata_00_txpwrlimit_2g_cfg_set = /bits/ 8 <
 0x01 0x00 0x06 0x00 0x08 0x02 0x89 0x01 ...>;
 	mwifiex,chip-gpio = <3>;
+	interrupt-parent = <&pio>;
+	interrupts = <38 IRQ_TYPE_LEVEL_LOW>;
+	gpios = <&pio 38 GPIO_ACTIVE_HIGH>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&wake_pins>;
 };
 
diff --git a/drivers/net/wireless/marvell/mwifiex/platform_drv.c b/drivers/net/wireless/marvell/mwifiex/platform_drv.c
index f64a12a..ed5dfc8 100644
--- a/drivers/net/wireless/marvell/mwifiex/platform_drv.c
+++ b/drivers/net/wireless/marvell/mwifiex/platform_drv.c
@@ -18,9 +18,63 @@
 
 struct platform_device *mwifiex_plt_dev;
 
+struct mwifiex_wake_dev {
+	struct device	*dev;
+	int		irq_wifi;
+	bool		wake_by_wifi;
+};
+
+static irqreturn_t mwifiex_wake_irq_wifi(int irq, void *priv)
+{
+	struct mwifiex_wake_dev *ctx = priv;
+
+	if (ctx->irq_wifi >= 0) {
+		ctx->wake_by_wifi = true;
+		disable_irq_nosync(ctx->irq_wifi);
+	}
+
+	return IRQ_HANDLED;
+}
+
 static int mwifiex_plt_probe(struct platform_device *pdev)
 {
+	int ret;
+	struct mwifiex_wake_dev *ctx;
+	int gpio;
+
 	mwifiex_plt_dev = pdev;
+
+	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->dev = &pdev->dev;
+	ctx->irq_wifi = platform_get_irq(pdev, 0);
+	if (ctx->irq_wifi < 0)
+		dev_err(&pdev->dev, "Failed to get irq_wifi\n");
+
+	gpio = of_get_gpio(pdev->dev.of_node, 0);
+	if (gpio_is_valid(gpio))
+		gpio_direction_input(gpio);
+	else
+		dev_err(&pdev->dev, "gpio wifi is invalid\n");
+
+	if (ctx->irq_wifi >= 0) {
+		ret = devm_request_irq(&pdev->dev, ctx->irq_wifi,
+				       mwifiex_wake_irq_wifi,
+				       IRQF_TRIGGER_LOW,
+				       "wifi_wake", ctx);
+		if (ret) {
+			dev_err(&pdev->dev,
+				"Failed to request irq_wifi %d (%d)\n",
+				ctx->irq_wifi, ret);
+			return -EINVAL;
+		}
+		disable_irq(ctx->irq_wifi);
+	}
+
+	platform_set_drvdata(pdev, ctx);
+
 	return 0;
 }
 
@@ -30,6 +84,44 @@ static int mwifiex_plt_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int mwifiex_plt_suspend(struct device *dev)
+{
+	struct mwifiex_wake_dev *ctx = dev_get_drvdata(dev);
+	int ret;
+
+	if (ctx->irq_wifi >= 0) {
+		ctx->wake_by_wifi = false;
+		enable_irq(ctx->irq_wifi);
+		ret = enable_irq_wake(ctx->irq_wifi);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int mwifiex_plt_resume(struct device *dev)
+{
+	struct mwifiex_wake_dev *ctx = dev_get_drvdata(dev);
+	int ret;
+
+	if (ctx->irq_wifi >= 0) {
+		ret = disable_irq_wake(ctx->irq_wifi);
+		if (!ctx->wake_by_wifi)
+			disable_irq(ctx->irq_wifi);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static const struct dev_pm_ops mwifiex_plt_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(mwifiex_plt_suspend, mwifiex_plt_resume)
+};
+#endif /* CONFIG_PM_SLEEP */
+
 static const struct of_device_id mwifiex_dt_match[] = {
 	{
 		.compatible = "marvell,mwifiex",
@@ -45,6 +137,7 @@ static struct platform_driver mwifiex_platform_driver = {
 	.driver = {
 		.name	= "mwifiex_plt",
 		.of_match_table = mwifiex_dt_match,
+		.pm             = &mwifiex_plt_pm_ops,
 	}
 };
 
-- 
1.8.1.4

