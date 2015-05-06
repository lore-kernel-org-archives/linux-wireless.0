Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37390 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbbEFI37 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2015 04:29:59 -0400
Received: by widdi4 with SMTP id di4so13227669wid.0
        for <linux-wireless@vger.kernel.org>; Wed, 06 May 2015 01:29:58 -0700 (PDT)
Received: from localhost.localdomain ([93.172.48.98])
        by mx.google.com with ESMTPSA id l3sm1022092wik.16.2015.05.06.01.29.57
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 06 May 2015 01:29:57 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl18xx: fallback to default conf in case of invalid conf file
Date: Wed,  6 May 2015 11:29:54 +0300
Message-Id: <1430900994-20509-1-git-send-email-eliad@wizery.com> (sfid-20150506_103008_217299_C5FE411E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the wl18xx-conf.bin file is missing or invalid (e.g. due
to recent driver change), fallback to default configuration
instead of failing driver load.

Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c | 45 +++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 717c4f5..3d38f54 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1351,9 +1351,10 @@ out:
 }
 
 #define WL18XX_CONF_FILE_NAME "ti-connectivity/wl18xx-conf.bin"
-static int wl18xx_conf_init(struct wl1271 *wl, struct device *dev)
+
+static int wl18xx_load_conf_file(struct device *dev, struct wlcore_conf *conf,
+				 struct wl18xx_priv_conf *priv_conf)
 {
-	struct wl18xx_priv *priv = wl->priv;
 	struct wlcore_conf_file *conf_file;
 	const struct firmware *fw;
 	int ret;
@@ -1362,14 +1363,14 @@ static int wl18xx_conf_init(struct wl1271 *wl, struct device *dev)
 	if (ret < 0) {
 		wl1271_error("could not get configuration binary %s: %d",
 			     WL18XX_CONF_FILE_NAME, ret);
-		goto out_fallback;
+		return ret;
 	}
 
 	if (fw->size != WL18XX_CONF_SIZE) {
 		wl1271_error("configuration binary file size is wrong, expected %zu got %zu",
 			     WL18XX_CONF_SIZE, fw->size);
 		ret = -EINVAL;
-		goto out;
+		goto out_release;
 	}
 
 	conf_file = (struct wlcore_conf_file *) fw->data;
@@ -1379,7 +1380,7 @@ static int wl18xx_conf_init(struct wl1271 *wl, struct device *dev)
 			     "expected 0x%0x got 0x%0x", WL18XX_CONF_MAGIC,
 			     conf_file->header.magic);
 		ret = -EINVAL;
-		goto out;
+		goto out_release;
 	}
 
 	if (conf_file->header.version != cpu_to_le32(WL18XX_CONF_VERSION)) {
@@ -1387,28 +1388,32 @@ static int wl18xx_conf_init(struct wl1271 *wl, struct device *dev)
 			     "expected 0x%08x got 0x%08x",
 			     WL18XX_CONF_VERSION, conf_file->header.version);
 		ret = -EINVAL;
-		goto out;
+		goto out_release;
 	}
 
-	memcpy(&wl->conf, &conf_file->core, sizeof(wl18xx_conf));
-	memcpy(&priv->conf, &conf_file->priv, sizeof(priv->conf));
+	memcpy(conf, &conf_file->core, sizeof(*conf));
+	memcpy(priv_conf, &conf_file->priv, sizeof(*priv_conf));
 
-	goto out;
+out_release:
+	release_firmware(fw);
+	return ret;
+}
 
-out_fallback:
-	wl1271_warning("falling back to default config");
+static int wl18xx_conf_init(struct wl1271 *wl, struct device *dev)
+{
+	struct wl18xx_priv *priv = wl->priv;
 
-	/* apply driver default configuration */
-	memcpy(&wl->conf, &wl18xx_conf, sizeof(wl18xx_conf));
-	/* apply default private configuration */
-	memcpy(&priv->conf, &wl18xx_default_priv_conf, sizeof(priv->conf));
+	if (wl18xx_load_conf_file(dev, &wl->conf, &priv->conf) < 0) {
+		wl1271_warning("falling back to default config");
 
-	/* For now we just fallback */
-	return 0;
+		/* apply driver default configuration */
+		memcpy(&wl->conf, &wl18xx_conf, sizeof(wl->conf));
+		/* apply default private configuration */
+		memcpy(&priv->conf, &wl18xx_default_priv_conf,
+		       sizeof(priv->conf));
+	}
 
-out:
-	release_firmware(fw);
-	return ret;
+	return 0;
 }
 
 static int wl18xx_plt_init(struct wl1271 *wl)
-- 
1.8.5.2.229.g4448466.dirty

