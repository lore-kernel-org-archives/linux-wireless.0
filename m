Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hotel311.server4you.de ([85.25.146.15]:52497 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbcG1IFa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2016 04:05:30 -0400
From: Daniel Wagner <wagi@monom.org>
To: Bastien Nocera <hadess@hadess.net>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-input@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: [RFC v0 4/8] Input: goodix: use firmware_stat instead of completion
Date: Thu, 28 Jul 2016 09:55:08 +0200
Message-Id: <1469692512-16863-5-git-send-email-wagi@monom.org> (sfid-20160728_100547_295536_03700D53)
In-Reply-To: <1469692512-16863-1-git-send-email-wagi@monom.org>
References: <1469692512-16863-1-git-send-email-wagi@monom.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

Loading firmware is an operation many drivers implement in various ways
around the completion API. And most of them do it almost in the same
way. Let's reuse the firmware_stat API which is used also by the
firmware_class loader. Apart of streamlining the firmware loading states
we also document it slightly better.

Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
---
 drivers/input/touchscreen/goodix.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index 240b16f..67158d3 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -47,7 +47,7 @@ struct goodix_ts_data {
 	u16 id;
 	u16 version;
 	const char *cfg_name;
-	struct completion firmware_loading_complete;
+	struct firmware_stat fwst;
 	unsigned long irq_flags;
 };
 
@@ -683,7 +683,7 @@ static void goodix_config_cb(const struct firmware *cfg, void *ctx)
 
 err_release_cfg:
 	release_firmware(cfg);
-	complete_all(&ts->firmware_loading_complete);
+	fw_loading_done(ts->fwst);
 }
 
 static int goodix_ts_probe(struct i2c_client *client,
@@ -705,7 +705,7 @@ static int goodix_ts_probe(struct i2c_client *client,
 
 	ts->client = client;
 	i2c_set_clientdata(client, ts);
-	init_completion(&ts->firmware_loading_complete);
+	firmware_stat_init(&ts->fwst);
 
 	error = goodix_get_gpio_config(ts);
 	if (error)
@@ -766,7 +766,7 @@ static int goodix_ts_remove(struct i2c_client *client)
 	struct goodix_ts_data *ts = i2c_get_clientdata(client);
 
 	if (ts->gpiod_int && ts->gpiod_rst)
-		wait_for_completion(&ts->firmware_loading_complete);
+		fw_loading_wait(ts->fwst);
 
 	return 0;
 }
@@ -781,7 +781,7 @@ static int __maybe_unused goodix_suspend(struct device *dev)
 	if (!ts->gpiod_int || !ts->gpiod_rst)
 		return 0;
 
-	wait_for_completion(&ts->firmware_loading_complete);
+	fw_loading_wait(ts->fwst);
 
 	/* Free IRQ as IRQ pin is used as output in the suspend sequence */
 	goodix_free_irq(ts);
-- 
2.7.4
