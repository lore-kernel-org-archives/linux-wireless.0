Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:42797 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754433Ab2F0PgR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 11:36:17 -0400
Received: by eaak12 with SMTP id k12so605538eaa.4
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 08:36:15 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com,
	Victor Goldenshtein <victorg@ti.com>
Subject: [PATCH 1/8] wlcore: enable sched scan while connected
Date: Wed, 27 Jun 2012 18:35:55 +0300
Message-Id: <1340811362-30441-2-git-send-email-coelho@ti.com> (sfid-20120627_173621_384247_EE5D4643)
In-Reply-To: <1340811362-30441-1-git-send-email-coelho@ti.com>
References: <1340811362-30441-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Victor Goldenshtein <victorg@ti.com>

New wl12xx firmware supports scheduled scans also while connected.
Stop blocking sched scan requests when connected and add a quirk to
block in hardware that don't support it (currently wl18xx doesn't).

This requires FW version 6/7.3.10.2.112 for single-role and
6/7.5.6.0.25 for multi-role.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/main.c   |    1 +
 drivers/net/wireless/ti/wlcore/scan.c   |    3 ++-
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 +++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 5e583be..16847ec 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -609,6 +609,7 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
 		wl->quirks |= WLCORE_QUIRK_NO_ELP |
 			      WLCORE_QUIRK_RX_BLOCKSIZE_ALIGN |
 			      WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN |
+			      WLCORE_QUIRK_NO_SCHED_SCAN_WHILE_CONN |
 			      WLCORE_QUIRK_TX_PAD_LAST_FRAME;
 		break;
 	case CHIP_ID_185x_PG10:
diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index d9daed5..5702d99 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -766,7 +766,8 @@ int wl1271_scan_sched_scan_start(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	if (wlvif->bss_type != BSS_TYPE_STA_BSS)
 		return -EOPNOTSUPP;
 
-	if (test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags))
+	if ((wl->quirks & WLCORE_QUIRK_NO_SCHED_SCAN_WHILE_CONN) &&
+	    test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags))
 		return -EBUSY;
 
 	start = kzalloc(sizeof(*start), GFP_KERNEL);
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index e796974..216bdb0 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -437,6 +437,9 @@ wlcore_set_ht_cap(struct wl1271 *wl, enum ieee80211_band band,
 /* extra header space is required for TKIP */
 #define WLCORE_QUIRK_TKIP_HEADER_SPACE		BIT(8)
 
+/* Some firmwares not support sched scans while connected */
+#define WLCORE_QUIRK_NO_SCHED_SCAN_WHILE_CONN	BIT(9)
+
 /* TODO: move to the lower drivers when all usages are abstracted */
 #define CHIP_ID_1271_PG10              (0x4030101)
 #define CHIP_ID_1271_PG20              (0x4030111)
-- 
1.7.10

