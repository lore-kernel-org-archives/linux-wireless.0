Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:44880 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756310Ab2FGUjy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 16:39:54 -0400
Received: by lbgc1 with SMTP id c1so787459lbg.15
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 13:39:51 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 9/9] wl18xx: read configuration structure from a binary file
Date: Thu,  7 Jun 2012 23:39:28 +0300
Message-Id: <1339101568-25346-10-git-send-email-coelho@ti.com> (sfid-20120607_224004_802488_60026DD6)
In-Reply-To: <1339101568-25346-1-git-send-email-coelho@ti.com>
References: <1339101568-25346-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of using the hardcoded configuration structure, try to read it
from a "firmware" file called wl18xx-conf.bin.  If the file doesn't
exist, fall back to the hardcoded version.  If the file exists but is
illegal, bail out.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   68 ++++++++++++++++++++++++++++++---
 1 file changed, 63 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index b6a80cd..9cdf24f 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/ip.h>
+#include <linux/firmware.h>
 
 #include "../wlcore/wlcore.h"
 #include "../wlcore/debug.h"
@@ -1046,15 +1047,65 @@ static s8 wl18xx_get_pg_ver(struct wl1271 *wl)
 	return (s8)fuse;
 }
 
-static void wl18xx_conf_init(struct wl1271 *wl)
+#define WL18XX_CONF_FILE_NAME "ti-connectivity/wl18xx-conf.bin"
+static int wl18xx_conf_init(struct wl1271 *wl, struct device *dev)
 {
 	struct wl18xx_priv *priv = wl->priv;
+	struct wlcore_conf_file *conf_file;
+	const struct firmware *fw;
+	int ret;
+
+	ret = request_firmware(&fw, WL18XX_CONF_FILE_NAME, dev);
+	if (ret < 0) {
+		wl1271_error("could not get configuration binary %s: %d",
+			     WL18XX_CONF_FILE_NAME, ret);
+		goto out_fallback;
+	}
+
+	if (fw->size != WL18XX_CONF_SIZE) {
+		wl1271_error("configuration binary file size is wrong, "
+			     "expected %d got %d", WL18XX_CONF_SIZE, fw->size);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	conf_file = (struct wlcore_conf_file *) fw->data;
+
+	if (conf_file->header.magic != cpu_to_le32(WL18XX_CONF_MAGIC)) {
+		wl1271_error("configuration binary file magic number mismatch, "
+			     "expected 0x%0x got 0x%0x", WL18XX_CONF_MAGIC,
+			     conf_file->header.magic);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (conf_file->header.version != cpu_to_le32(WL18XX_CONF_VERSION)) {
+		wl1271_error("configuration binary file version not supported, "
+			     "expected 0x%08x got 0x%08x",
+			     WL18XX_CONF_VERSION, conf_file->header.version);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	memcpy(&wl->conf, &conf_file->core, sizeof(wl18xx_conf));
+	memcpy(&priv->conf, &conf_file->priv, sizeof(priv->conf));
+
+	goto out;
+
+out_fallback:
+	wl1271_warning("falling back to default config");
 
 	/* apply driver default configuration */
 	memcpy(&wl->conf, &wl18xx_conf, sizeof(wl18xx_conf));
-
 	/* apply default private configuration */
 	memcpy(&priv->conf, &wl18xx_default_priv_conf, sizeof(priv->conf));
+
+	/* For now we just fallback */
+	return 0;
+
+out:
+	release_firmware(fw);
+	return ret;
 }
 
 static int wl18xx_plt_init(struct wl1271 *wl)
@@ -1261,11 +1312,13 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 	struct wl1271 *wl;
 	struct ieee80211_hw *hw;
 	struct wl18xx_priv *priv;
+	int ret;
 
 	hw = wlcore_alloc_hw(sizeof(*priv));
 	if (IS_ERR(hw)) {
 		wl1271_error("can't allocate hw");
-		return PTR_ERR(hw);
+		ret = PTR_ERR(hw);
+		goto out;
 	}
 
 	wl = hw->priv;
@@ -1305,10 +1358,13 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 		       sizeof(wl18xx_siso20_ht_cap));
 	} else {
 		wl1271_error("invalid ht_mode '%s'", ht_mode_param);
+		ret = -EINVAL;
 		goto out_free;
 	}
 
-	wl18xx_conf_init(wl);
+	ret = wl18xx_conf_init(wl, &pdev->dev);
+	if (ret < 0)
+		goto out_free;
 
 	if (!strcmp(board_type_param, "fpga")) {
 		priv->board_type = BOARD_TYPE_FPGA_18XX;
@@ -1326,6 +1382,7 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 		priv->conf.phy.low_band_component_type = 0x06;
 	} else {
 		wl1271_error("invalid board type '%s'", board_type_param);
+		ret = -EINVAL;
 		goto out_free;
 	}
 
@@ -1373,7 +1430,8 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 
 out_free:
 	wlcore_free_hw(wl);
-	return -EINVAL;
+out:
+	return ret;
 }
 
 static const struct platform_device_id wl18xx_id_table[] __devinitconst = {
-- 
1.7.10

