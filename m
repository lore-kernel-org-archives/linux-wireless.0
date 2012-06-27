Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:48985 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756160Ab2F0PgU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 11:36:20 -0400
Received: by eaaq13 with SMTP id q13so558770eaa.17
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 08:36:18 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 2/8] wlcore/wl12xx/wl18xx: check min FW version
Date: Wed, 27 Jun 2012 18:35:56 +0300
Message-Id: <1340811362-30441-3-git-send-email-coelho@ti.com> (sfid-20120627_173624_182607_F2D47F79)
In-Reply-To: <1340811362-30441-1-git-send-email-coelho@ti.com>
References: <1340811362-30441-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Refuse to boot if the FW version is too old. The minimum version is set
per chip, with the option of setting it per PG in the future.

When boot fails because of an old FW, display a helpful message.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    9 ++++++
 drivers/net/wireless/ti/wl12xx/wl12xx.h |   14 +++++++++
 drivers/net/wireless/ti/wl18xx/main.c   |    4 +++
 drivers/net/wireless/ti/wl18xx/wl18xx.h |    7 +++++
 drivers/net/wireless/ti/wlcore/boot.c   |   51 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/wlcore.h |   15 +++++++++
 6 files changed, 100 insertions(+)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 47ba2e0..1c56d1d 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -646,6 +646,9 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		/* read data preparation is only needed by wl127x */
 		wl->ops->prepare_read = wl127x_prepare_read;
 
+		wlcore_set_min_fw_ver(wl, WL127X_CHIP_VER, WL127X_IFTYPE_VER,
+				      WL127X_MAJOR_VER, WL127X_SUBTYPE_VER,
+				      WL127X_MINOR_VER);
 		break;
 
 	case CHIP_ID_1271_PG20:
@@ -663,6 +666,9 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		/* read data preparation is only needed by wl127x */
 		wl->ops->prepare_read = wl127x_prepare_read;
 
+		wlcore_set_min_fw_ver(wl, WL127X_CHIP_VER, WL127X_IFTYPE_VER,
+				      WL127X_MAJOR_VER, WL127X_SUBTYPE_VER,
+				      WL127X_MINOR_VER);
 		break;
 
 	case CHIP_ID_1283_PG20:
@@ -676,6 +682,9 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		wl->quirks |= WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN |
 			      WLCORE_QUIRK_TKIP_HEADER_SPACE;
 
+		wlcore_set_min_fw_ver(wl, WL128X_CHIP_VER, WL128X_IFTYPE_VER,
+				      WL128X_MAJOR_VER, WL128X_SUBTYPE_VER,
+				      WL128X_MINOR_VER);
 		break;
 	case CHIP_ID_1283_PG10:
 	default:
diff --git a/drivers/net/wireless/ti/wl12xx/wl12xx.h b/drivers/net/wireless/ti/wl12xx/wl12xx.h
index de11324..26990fb 100644
--- a/drivers/net/wireless/ti/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/ti/wl12xx/wl12xx.h
@@ -24,6 +24,20 @@
 
 #include "conf.h"
 
+/* minimum FW required for driver for wl127x */
+#define WL127X_CHIP_VER		6
+#define WL127X_IFTYPE_VER	3
+#define WL127X_MAJOR_VER	10
+#define WL127X_SUBTYPE_VER	2
+#define WL127X_MINOR_VER	115
+
+/* minimum FW required for driver for wl128x */
+#define WL128X_CHIP_VER		7
+#define WL128X_IFTYPE_VER	3
+#define WL128X_MAJOR_VER	10
+#define WL128X_SUBTYPE_VER	2
+#define WL128X_MINOR_VER	115
+
 struct wl127x_rx_mem_pool_addr {
 	u32 addr;
 	u32 addr_extra;
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 16847ec..341e878 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -611,6 +611,10 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
 			      WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN |
 			      WLCORE_QUIRK_NO_SCHED_SCAN_WHILE_CONN |
 			      WLCORE_QUIRK_TX_PAD_LAST_FRAME;
+
+		wlcore_set_min_fw_ver(wl, WL18XX_CHIP_VER, WL18XX_IFTYPE_VER,
+				      WL18XX_MAJOR_VER, WL18XX_SUBTYPE_VER,
+				      WL18XX_MINOR_VER);
 		break;
 	case CHIP_ID_185x_PG10:
 		wl1271_warning("chip id 0x%x (185x PG10) is deprecated",
diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
index bc67a47..6452396 100644
--- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -24,6 +24,13 @@
 
 #include "conf.h"
 
+/* minimum FW required for driver */
+#define WL18XX_CHIP_VER		8
+#define WL18XX_IFTYPE_VER	2
+#define WL18XX_MAJOR_VER	0
+#define WL18XX_SUBTYPE_VER	0
+#define WL18XX_MINOR_VER	100
+
 #define WL18XX_CMD_MAX_SIZE          740
 
 struct wl18xx_priv {
diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index 8965960..6111329 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -81,6 +81,53 @@ out:
 	return ret;
 }
 
+static int wlcore_validate_fw_ver(struct wl1271 *wl)
+{
+	unsigned int *fw_ver = wl->chip.fw_ver;
+	unsigned int *min_ver = wl->min_fw_ver;
+
+	/* the chip must be exactly equal */
+	if (min_ver[FW_VER_CHIP] != fw_ver[FW_VER_CHIP])
+		goto fail;
+
+	/* always check the next digit if all previous ones are equal */
+
+	if (min_ver[FW_VER_IF_TYPE] < fw_ver[FW_VER_IF_TYPE])
+		goto out;
+	else if (min_ver[FW_VER_IF_TYPE] > fw_ver[FW_VER_IF_TYPE])
+		goto fail;
+
+	if (min_ver[FW_VER_MAJOR] < fw_ver[FW_VER_MAJOR])
+		goto out;
+	else if (min_ver[FW_VER_MAJOR] > fw_ver[FW_VER_MAJOR])
+		goto fail;
+
+	if (min_ver[FW_VER_SUBTYPE] < fw_ver[FW_VER_SUBTYPE])
+		goto out;
+	else if (min_ver[FW_VER_SUBTYPE] > fw_ver[FW_VER_SUBTYPE])
+		goto fail;
+
+	if (min_ver[FW_VER_MINOR] < fw_ver[FW_VER_MINOR])
+		goto out;
+	else if (min_ver[FW_VER_MINOR] > fw_ver[FW_VER_MINOR])
+		goto fail;
+
+out:
+	return 0;
+
+fail:
+	wl1271_error("Your WiFi FW version (%u.%u.%u.%u.%u) is outdated.\n"
+		     "Please use at least FW %u.%u.%u.%u.%u.\n"
+		     "You can get more information at:\n"
+		     "http://wireless.kernel.org/en/users/Drivers/wl12xx",
+		     fw_ver[FW_VER_CHIP], fw_ver[FW_VER_IF_TYPE],
+		     fw_ver[FW_VER_MAJOR], fw_ver[FW_VER_SUBTYPE],
+		     fw_ver[FW_VER_MINOR], min_ver[FW_VER_CHIP],
+		     min_ver[FW_VER_IF_TYPE], min_ver[FW_VER_MAJOR],
+		     min_ver[FW_VER_SUBTYPE], min_ver[FW_VER_MINOR]);
+	return -EINVAL;
+}
+
 static int wlcore_boot_static_data(struct wl1271 *wl)
 {
 	struct wl1271_static_data *static_data;
@@ -101,6 +148,10 @@ static int wlcore_boot_static_data(struct wl1271 *wl)
 	if (ret < 0)
 		goto out_free;
 
+	ret = wlcore_validate_fw_ver(wl);
+	if (ret < 0)
+		goto out_free;
+
 	ret = wlcore_handle_static_data(wl, static_data);
 	if (ret < 0)
 		goto out_free;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 216bdb0..942cef1 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -390,6 +390,9 @@ struct wl1271 {
 
 	/* sleep auth value currently configured to FW */
 	int sleep_auth;
+
+	/* the minimum FW version required for the driver to work */
+	unsigned int min_fw_ver[NUM_FW_VER];
 };
 
 int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
@@ -408,6 +411,18 @@ wlcore_set_ht_cap(struct wl1271 *wl, enum ieee80211_band band,
 	memcpy(&wl->ht_cap[band], ht_cap, sizeof(*ht_cap));
 }
 
+static inline void
+wlcore_set_min_fw_ver(struct wl1271 *wl, unsigned int chip,
+		      unsigned int iftype, unsigned int major,
+		      unsigned int subtype, unsigned int minor)
+{
+	wl->min_fw_ver[FW_VER_CHIP] = chip;
+	wl->min_fw_ver[FW_VER_IF_TYPE] = iftype;
+	wl->min_fw_ver[FW_VER_MAJOR] = major;
+	wl->min_fw_ver[FW_VER_SUBTYPE] = subtype;
+	wl->min_fw_ver[FW_VER_MINOR] = minor;
+}
+
 /* Firmware image load chunk size */
 #define CHUNK_SIZE	16384
 
-- 
1.7.10

