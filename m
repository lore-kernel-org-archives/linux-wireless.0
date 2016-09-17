Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:42603 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752512AbcIQQGp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 12:06:45 -0400
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH 5/5] wlcore: wl18xx: Use chip specific configuration firmware
Date: Sat, 17 Sep 2016 09:06:33 -0700
Message-Id: <20160917160633.8767-6-tony@atomide.com> (sfid-20160917_180657_088554_9C71BAB1)
In-Reply-To: <20160917160633.8767-1-tony@atomide.com>
References: <20160917160633.8767-1-tony@atomide.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the wl18xx specific config firmware we now have available.

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/net/wireless/ti/wl18xx/main.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1397,25 +1397,24 @@ static int wl18xx_get_pg_ver(struct wl1271 *wl, s8 *ver)
 	return ret;
 }
 
-#define WL18XX_CONF_FILE_NAME "ti-connectivity/wl18xx-conf.bin"
-
 static int wl18xx_load_conf_file(struct device *dev, struct wlcore_conf *conf,
-				 struct wl18xx_priv_conf *priv_conf)
+				 struct wl18xx_priv_conf *priv_conf,
+				 const char *file)
 {
 	struct wlcore_conf_file *conf_file;
 	const struct firmware *fw;
 	int ret;
 
-	ret = request_firmware(&fw, WL18XX_CONF_FILE_NAME, dev);
+	ret = request_firmware(&fw, file, dev);
 	if (ret < 0) {
 		wl1271_error("could not get configuration binary %s: %d",
-			     WL18XX_CONF_FILE_NAME, ret);
+			     file, ret);
 		return ret;
 	}
 
 	if (fw->size != WL18XX_CONF_SIZE) {
-		wl1271_error("configuration binary file size is wrong, expected %zu got %zu",
-			     WL18XX_CONF_SIZE, fw->size);
+		wl1271_error("%s configuration binary size is wrong, expected %zu got %zu",
+			     file, WL18XX_CONF_SIZE, fw->size);
 		ret = -EINVAL;
 		goto out_release;
 	}
@@ -1448,9 +1447,12 @@ static int wl18xx_load_conf_file(struct device *dev, struct wlcore_conf *conf,
 
 static int wl18xx_conf_init(struct wl1271 *wl, struct device *dev)
 {
+	struct platform_device *pdev = wl->pdev;
+	struct wlcore_platdev_data *pdata = dev_get_platdata(&pdev->dev);
 	struct wl18xx_priv *priv = wl->priv;
 
-	if (wl18xx_load_conf_file(dev, &wl->conf, &priv->conf) < 0) {
+	if (wl18xx_load_conf_file(dev, &wl->conf, &priv->conf,
+				  pdata->family->cfg_name) < 0) {
 		wl1271_warning("falling back to default config");
 
 		/* apply driver default configuration */
@@ -2141,4 +2143,3 @@ MODULE_PARM_DESC(num_rx_desc_param,
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_FIRMWARE(WL18XX_FW_NAME);
-MODULE_FIRMWARE(WL18XX_CONF_FILE_NAME);
-- 
2.9.3
