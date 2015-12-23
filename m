Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from softlayer.compulab.co.il ([50.23.254.55]:46105 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755584AbbLWIfx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2015 03:35:53 -0500
From: Uri Mashiach <uri.mashiach@compulab.co.il>
To: Kalle Valo <kvalo@codeaurora.org>,
	Rob Herring <robh+dt@kernel.org>,
	Tony Lindgren <tony@atomide.com>
Cc: Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, bcousson@baylibre.com,
	Igor Grinberg <grinberg@compulab.co.il>,
	Eliad Peller <eliad@wizery.com>, devicetree@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	Uri Mashiach <uri.mashiach@compulab.co.il>
Subject: [PATCH 1/3] wlcore/wl12xx: spi: fix NULL pointer dereference (Oops)
Date: Wed, 23 Dec 2015 10:35:42 +0200
Message-Id: <1450859744-9948-2-git-send-email-uri.mashiach@compulab.co.il> (sfid-20151223_093620_660353_B339E74C)
In-Reply-To: <1450859744-9948-1-git-send-email-uri.mashiach@compulab.co.il>
References: <1450859744-9948-1-git-send-email-uri.mashiach@compulab.co.il>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The power function uses a consumer regulator access to update the WiFi
enable GPIO value.

Fix the below Oops when trying to modprobe wlcore_spi.
The oops occurs because the wl1271_power_{off,on}()
function doesn't check the power() function pointer.

[   23.401447] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[   23.409954] pgd = c0004000
[   23.412922] [00000000] *pgd=00000000
[   23.416693] Internal error: Oops: 80000007 [#1] SMP ARM
[   23.422168] Modules linked in: wl12xx wlcore mac80211 cfg80211
musb_dsps musb_hdrc usbcore usb_common snd_soc_simple_card evdev joydev
omap_rng wlcore_spi snd_soc_tlv320aic23_i2c rng_core snd_soc_tlv320aic23
c_can_platform c_can can_dev snd_soc_davinci_mcasp snd_soc_edma
snd_soc_omap omap_wdt musb_am335x cpufreq_dt thermal_sys hwmon
[   23.453253] CPU: 0 PID: 36 Comm: kworker/0:2 Not tainted
4.2.0-00002-g951efee-dirty #233
[   23.461720] Hardware name: Generic AM33XX (Flattened Device Tree)
[   23.468123] Workqueue: events request_firmware_work_func
[   23.473690] task: de32efc0 ti: de4ee000 task.ti: de4ee000
[   23.479341] PC is at 0x0
[   23.482112] LR is at wl12xx_set_power_on+0x28/0x124 [wlcore]
[   23.488074] pc : [<00000000>]    lr : [<bf2581f0>]    psr: 60000013
[   23.488074] sp : de4efe50  ip : 00000002  fp : 00000000
[   23.500162] r10: de7cdd00  r9 : dc848800  r8 : bf27af00
[   23.505663] r7 : bf27a1a8  r6 : dcbd8a80  r5 : dce0e2e0  r4 :
dce0d2e0
[   23.512536] r3 : 00000000  r2 : 00000000  r1 : 00000001  r0 :
dc848810
[   23.519412] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
Segment kernel
[   23.527109] Control: 10c5387d  Table: 9cb78019  DAC: 00000015
[   23.533160] Process kworker/0:2 (pid: 36, stack limit = 0xde4ee218)
[   23.539760] Stack: (0xde4efe50 to 0xde4f0000)

[...]

[   23.665030] [<bf2581f0>] (wl12xx_set_power_on [wlcore]) from
[<bf25f7ac>] (wlcore_nvs_cb+0x118/0xa4c [wlcore])
[   23.675604] [<bf25f7ac>] (wlcore_nvs_cb [wlcore]) from [<c04387ec>]
(request_firmware_work_func+0x30/0x58)
[   23.685784] [<c04387ec>] (request_firmware_work_func) from
[<c0058e2c>] (process_one_work+0x1b4/0x4b4)
[   23.695591] [<c0058e2c>] (process_one_work) from [<c0059168>]
(worker_thread+0x3c/0x4a4)
[   23.704124] [<c0059168>] (worker_thread) from [<c005ee68>]
(kthread+0xd4/0xf0)
[   23.711747] [<c005ee68>] (kthread) from [<c000f598>]
(ret_from_fork+0x14/0x3c)
[   23.719357] Code: bad PC value
[   23.722760] ---[ end trace 981be8510db9b3a9 ]---

Fix this by adding a power() function implementation.

Signed-off-by: Uri Mashiach <uri.mashiach@compulab.co.il>
Acked-by: Igor Grinberg <grinberg@compulab.co.il>
---
 drivers/net/wireless/ti/wlcore/spi.c | 37 ++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index 44f059f..d3a4bcb 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -30,6 +30,7 @@
 #include <linux/spi/spi.h>
 #include <linux/wl12xx.h>
 #include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
 
 #include "wlcore.h"
 #include "wl12xx_80211.h"
@@ -81,6 +82,7 @@
 struct wl12xx_spi_glue {
 	struct device *dev;
 	struct platform_device *core;
+	struct regulator *reg; /* Power regulator */
 };
 
 static void wl12xx_spi_reset(struct device *child)
@@ -318,11 +320,40 @@ static int __must_check wl12xx_spi_raw_write(struct device *child, int addr,
 	return 0;
 }
 
+/**
+ * wl12xx_spi_set_power - power on/off the wl12xx unit
+ * @child: wl12xx device handle.
+ * @enable: true/false to power on/off the unit.
+ *
+ * use the WiFi enable regulator to enable/disable the WiFi unit.
+ */
+static int wl12xx_spi_set_power(struct device *child, bool enable)
+{
+	int ret = 0;
+	struct wl12xx_spi_glue *glue = dev_get_drvdata(child->parent);
+
+	WARN_ON(!glue->reg);
+
+	/* Update regulator state */
+	if (enable) {
+		ret = regulator_enable(glue->reg);
+		if (ret)
+			dev_err(child, "Power enable failure\n");
+	} else {
+		ret =  regulator_disable(glue->reg);
+		if (ret)
+			dev_err(child, "Power disable failure\n");
+	}
+
+	return ret;
+}
+
 static struct wl1271_if_operations spi_ops = {
 	.read		= wl12xx_spi_raw_read,
 	.write		= wl12xx_spi_raw_write,
 	.reset		= wl12xx_spi_reset,
 	.init		= wl12xx_spi_init,
+	.power		= wl12xx_spi_set_power,
 	.set_block_size = NULL,
 };
 
@@ -353,6 +384,12 @@ static int wl1271_probe(struct spi_device *spi)
 	 * comes from the board-peripherals file */
 	spi->bits_per_word = 32;
 
+	glue->reg = devm_regulator_get(&spi->dev, "vwlan");
+	if (IS_ERR(glue->reg)) {
+		dev_err(glue->dev, "can't get regulator\n");
+		return PTR_ERR(glue->reg);
+	}
+
 	ret = spi_setup(spi);
 	if (ret < 0) {
 		dev_err(glue->dev, "spi_setup failed\n");
-- 
2.5.0

