Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:33892 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635Ab2K0Nws (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 08:52:48 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id qARDqlWU005360
	for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 07:52:47 -0600
Received: from DLEE74.ent.ti.com (dlee74.ent.ti.com [157.170.170.8])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id qARDqlYk014317
	for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 07:52:47 -0600
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>
Subject: [PATCH 5/6] wlcore/wl12xx/wl18xx: verify multi-role and single-role fw versions
Date: Tue, 27 Nov 2012 15:52:00 +0200
Message-ID: <1354024321-20635-6-git-send-email-coelho@ti.com> (sfid-20121127_145254_760058_D7E68504)
In-Reply-To: <1354024321-20635-1-git-send-email-coelho@ti.com>
References: <1354024321-20635-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously we were only checking the single-role firmware version.
Now add code to check for the firmware versions separately for each
firmware type.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   24 ++++++++++++++---------
 drivers/net/wireless/ti/wl12xx/wl12xx.h |   32 +++++++++++++++++++++----------
 drivers/net/wireless/ti/wl18xx/main.c   |    8 +++++---
 drivers/net/wireless/ti/wlcore/boot.c   |    3 ++-
 drivers/net/wireless/ti/wlcore/wlcore.h |   29 +++++++++++++++++++---------
 5 files changed, 64 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index cadd7f3..31f8367 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -646,9 +646,11 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		/* read data preparation is only needed by wl127x */
 		wl->ops->prepare_read = wl127x_prepare_read;
 
-		wlcore_set_min_fw_ver(wl, WL127X_CHIP_VER, WL127X_IFTYPE_VER,
-				      WL127X_MAJOR_VER, WL127X_SUBTYPE_VER,
-				      WL127X_MINOR_VER);
+		wlcore_set_min_fw_ver(wl, WL127X_CHIP_VER,
+			      WL127X_IFTYPE_SR_VER,  WL127X_MAJOR_SR_VER,
+			      WL127X_SUBTYPE_SR_VER, WL127X_MINOR_SR_VER,
+			      WL127X_IFTYPE_MR_VER,  WL127X_MAJOR_MR_VER,
+			      WL127X_SUBTYPE_MR_VER, WL127X_MINOR_MR_VER);
 		break;
 
 	case CHIP_ID_127X_PG20:
@@ -667,9 +669,11 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		/* read data preparation is only needed by wl127x */
 		wl->ops->prepare_read = wl127x_prepare_read;
 
-		wlcore_set_min_fw_ver(wl, WL127X_CHIP_VER, WL127X_IFTYPE_VER,
-				      WL127X_MAJOR_VER, WL127X_SUBTYPE_VER,
-				      WL127X_MINOR_VER);
+		wlcore_set_min_fw_ver(wl, WL127X_CHIP_VER,
+			      WL127X_IFTYPE_SR_VER,  WL127X_MAJOR_SR_VER,
+			      WL127X_SUBTYPE_SR_VER, WL127X_MINOR_SR_VER,
+			      WL127X_IFTYPE_MR_VER,  WL127X_MAJOR_MR_VER,
+			      WL127X_SUBTYPE_MR_VER, WL127X_MINOR_MR_VER);
 		break;
 
 	case CHIP_ID_128X_PG20:
@@ -684,9 +688,11 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 			      WLCORE_QUIRK_DUAL_PROBE_TMPL |
 			      WLCORE_QUIRK_TKIP_HEADER_SPACE;
 
-		wlcore_set_min_fw_ver(wl, WL128X_CHIP_VER, WL128X_IFTYPE_VER,
-				      WL128X_MAJOR_VER, WL128X_SUBTYPE_VER,
-				      WL128X_MINOR_VER);
+		wlcore_set_min_fw_ver(wl, WL128X_CHIP_VER,
+			      WL128X_IFTYPE_SR_VER,  WL128X_MAJOR_SR_VER,
+			      WL128X_SUBTYPE_SR_VER, WL128X_MINOR_SR_VER,
+			      WL128X_IFTYPE_MR_VER,  WL128X_MAJOR_MR_VER,
+			      WL128X_SUBTYPE_MR_VER, WL128X_MINOR_MR_VER);
 		break;
 	case CHIP_ID_128X_PG10:
 	default:
diff --git a/drivers/net/wireless/ti/wl12xx/wl12xx.h b/drivers/net/wireless/ti/wl12xx/wl12xx.h
index 310df52..a07be5e 100644
--- a/drivers/net/wireless/ti/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/ti/wl12xx/wl12xx.h
@@ -30,19 +30,31 @@
 #define CHIP_ID_128X_PG10              (0x05030101)
 #define CHIP_ID_128X_PG20              (0x05030111)
 
-/* minimum FW required for driver for wl127x */
+/* FW chip version for wl127x */
 #define WL127X_CHIP_VER		6
-#define WL127X_IFTYPE_VER	WLCORE_FW_VER_IGNORE
-#define WL127X_MAJOR_VER	10
-#define WL127X_SUBTYPE_VER	WLCORE_FW_VER_IGNORE
-#define WL127X_MINOR_VER	115
+/* minimum single-role FW version for wl127x */
+#define WL127X_IFTYPE_SR_VER	3
+#define WL127X_MAJOR_SR_VER	10
+#define WL127X_SUBTYPE_SR_VER	WLCORE_FW_VER_IGNORE
+#define WL127X_MINOR_SR_VER	115
+/* minimum multi-role FW version for wl127x */
+#define WL127X_IFTYPE_MR_VER	5
+#define WL127X_MAJOR_MR_VER	7
+#define WL127X_SUBTYPE_MR_VER	WLCORE_FW_VER_IGNORE
+#define WL127X_MINOR_MR_VER	115
 
-/* minimum FW required for driver for wl128x */
+/* FW chip version for wl128x */
 #define WL128X_CHIP_VER		7
-#define WL128X_IFTYPE_VER	WLCORE_FW_VER_IGNORE
-#define WL128X_MAJOR_VER	10
-#define WL128X_SUBTYPE_VER	WLCORE_FW_VER_IGNORE
-#define WL128X_MINOR_VER	115
+/* minimum single-role FW version for wl128x */
+#define WL128X_IFTYPE_SR_VER	3
+#define WL128X_MAJOR_SR_VER	10
+#define WL128X_SUBTYPE_SR_VER	WLCORE_FW_VER_IGNORE
+#define WL128X_MINOR_SR_VER	115
+/* minimum multi-role FW version for wl128x */
+#define WL128X_IFTYPE_MR_VER	5
+#define WL128X_MAJOR_MR_VER	7
+#define WL128X_SUBTYPE_MR_VER	WLCORE_FW_VER_IGNORE
+#define WL128X_MINOR_MR_VER	42
 
 #define WL12XX_AGGR_BUFFER_SIZE	(4 * PAGE_SIZE)
 
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index a39682a..5864ef0 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -614,9 +614,11 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
 			      WLCORE_QUIRK_NO_SCHED_SCAN_WHILE_CONN |
 			      WLCORE_QUIRK_TX_PAD_LAST_FRAME;
 
-		wlcore_set_min_fw_ver(wl, WL18XX_CHIP_VER, WL18XX_IFTYPE_VER,
-				      WL18XX_MAJOR_VER, WL18XX_SUBTYPE_VER,
-				      WL18XX_MINOR_VER);
+		wlcore_set_min_fw_ver(wl, WL18XX_CHIP_VER,
+				      WL18XX_IFTYPE_VER,  WL18XX_MAJOR_VER,
+				      WL18XX_SUBTYPE_VER, WL18XX_MINOR_VER,
+				      /* there's no separate multi-role FW */
+				      0, 0, 0, 0);
 		break;
 	case CHIP_ID_185x_PG10:
 		wl1271_warning("chip id 0x%x (185x PG10) is deprecated",
diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index be216b8..b92e572 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -84,7 +84,8 @@ out:
 static int wlcore_validate_fw_ver(struct wl1271 *wl)
 {
 	unsigned int *fw_ver = wl->chip.fw_ver;
-	unsigned int *min_ver = wl->min_fw_ver;
+	unsigned int *min_ver = (wl->fw_type == WL12XX_FW_TYPE_NORMAL) ?
+		wl->min_sr_fw_ver : wl->min_mr_fw_ver;
 	char min_fw_str[32] = "";
 	int i;
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 6184f53..fc6ba49 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -408,8 +408,11 @@ struct wl1271 {
 	/* the number of allocated MAC addresses in this chip */
 	int num_mac_addr;
 
-	/* the minimum FW version required for the driver to work */
-	unsigned int min_fw_ver[NUM_FW_VER];
+	/* minimum FW version required for the driver to work in single-role */
+	unsigned int min_sr_fw_ver[NUM_FW_VER];
+
+	/* minimum FW version required for the driver to work in multi-role */
+	unsigned int min_mr_fw_ver[NUM_FW_VER];
 
 	struct completion nvs_loading_complete;
 };
@@ -435,14 +438,22 @@ wlcore_set_ht_cap(struct wl1271 *wl, enum ieee80211_band band,
 
 static inline void
 wlcore_set_min_fw_ver(struct wl1271 *wl, unsigned int chip,
-		      unsigned int iftype, unsigned int major,
-		      unsigned int subtype, unsigned int minor)
+		      unsigned int iftype_sr, unsigned int major_sr,
+		      unsigned int subtype_sr, unsigned int minor_sr,
+		      unsigned int iftype_mr, unsigned int major_mr,
+		      unsigned int subtype_mr, unsigned int minor_mr)
 {
-	wl->min_fw_ver[FW_VER_CHIP] = chip;
-	wl->min_fw_ver[FW_VER_IF_TYPE] = iftype;
-	wl->min_fw_ver[FW_VER_MAJOR] = major;
-	wl->min_fw_ver[FW_VER_SUBTYPE] = subtype;
-	wl->min_fw_ver[FW_VER_MINOR] = minor;
+	wl->min_sr_fw_ver[FW_VER_CHIP] = chip;
+	wl->min_sr_fw_ver[FW_VER_IF_TYPE] = iftype_sr;
+	wl->min_sr_fw_ver[FW_VER_MAJOR] = major_sr;
+	wl->min_sr_fw_ver[FW_VER_SUBTYPE] = subtype_sr;
+	wl->min_sr_fw_ver[FW_VER_MINOR] = minor_sr;
+
+	wl->min_mr_fw_ver[FW_VER_CHIP] = chip;
+	wl->min_mr_fw_ver[FW_VER_IF_TYPE] = iftype_mr;
+	wl->min_mr_fw_ver[FW_VER_MAJOR] = major_mr;
+	wl->min_mr_fw_ver[FW_VER_SUBTYPE] = subtype_mr;
+	wl->min_mr_fw_ver[FW_VER_MINOR] = minor_mr;
 }
 
 /* Firmware image load chunk size */
-- 
1.7.10.4

