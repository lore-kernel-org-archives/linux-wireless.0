Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:56614 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754795Ab2DKJib (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:38:31 -0400
Received: by lbbge1 with SMTP id ge1so618456lbb.23
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 02:38:28 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, linville@tuxdriver.com, coelho@ti.com
Subject: [PATCH 15/16] wlcore: add quirk to disable ELP
Date: Wed, 11 Apr 2012 12:38:02 +0300
Message-Id: <1334137083-13490-16-git-send-email-coelho@ti.com> (sfid-20120411_113847_503626_3A2C7F66)
In-Reply-To: <1334137083-13490-1-git-send-email-coelho@ti.com>
References: <1334137083-13490-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ELP is a very complicated process in the firmware.  Due to its
complexity, in some early firmware revisions, the ELP feature is
disabled.  To support this cases, this patch adds a quirk that
disables ELP mode.

When ELP is not supported, do not attempt to enter ELP when requested by
the driver.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/boot.c   |    5 -----
 drivers/net/wireless/ti/wlcore/init.c   |   15 +++++++++++----
 drivers/net/wireless/ti/wlcore/ps.c     |    3 +++
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 +++
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index 3cb75db..2aae201 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -408,11 +408,6 @@ int wlcore_boot_run_firmware(struct wl1271 *wl)
 	wl1271_debug(DEBUG_MAILBOX, "MBOX ptrs: 0x%x 0x%x",
 		     wl->mbox_ptr[0], wl->mbox_ptr[1]);
 
-	/*
-	 * TODO: wl12xx used to set the partition here, but it seems
-	 * that it can be done later.  Make sure this is okay.
-	 */
-
 	wl1271_boot_fw_version(wl);
 
 	/*
diff --git a/drivers/net/wireless/ti/wlcore/init.c b/drivers/net/wireless/ti/wlcore/init.c
index c146d8e..d8c2235 100644
--- a/drivers/net/wireless/ti/wlcore/init.c
+++ b/drivers/net/wireless/ti/wlcore/init.c
@@ -581,10 +581,17 @@ int wl1271_init_vif_specific(struct wl1271 *wl, struct ieee80211_vif *vif)
 			if (ret < 0)
 				return ret;
 		} else if (!wl->sta_count) {
-			/* Configure for ELP power saving */
-			ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_ELP);
-			if (ret < 0)
-				return ret;
+			if (wl->quirks & WLCORE_QUIRK_NO_ELP) {
+				/* Configure for power always on */
+				ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
+				if (ret < 0)
+					return ret;
+			} else {
+				/* Configure for ELP power saving */
+				ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_ELP);
+				if (ret < 0)
+					return ret;
+			}
 		}
 	}
 
diff --git a/drivers/net/wireless/ti/wlcore/ps.c b/drivers/net/wireless/ti/wlcore/ps.c
index cfeb114..756eee2 100644
--- a/drivers/net/wireless/ti/wlcore/ps.c
+++ b/drivers/net/wireless/ti/wlcore/ps.c
@@ -73,6 +73,9 @@ void wl1271_ps_elp_sleep(struct wl1271 *wl)
 {
 	struct wl12xx_vif *wlvif;
 
+	if (wl->quirks & WLCORE_QUIRK_NO_ELP)
+		return;
+
 	/* we shouldn't get consecutive sleep requests */
 	if (WARN_ON(test_and_set_bit(WL1271_FLAG_ELP_REQUESTED, &wl->flags)))
 		return;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 984dda7..66c33b8 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -324,6 +324,9 @@ int wlcore_free_hw(struct wl1271 *wl);
 /* Older firmwares use an old NVS format */
 #define WLCORE_QUIRK_LEGACY_NVS			BIT(5)
 
+/* Some firmwares may not support ELP */
+#define WLCORE_QUIRK_NO_ELP			BIT(6)
+
 /* TODO: move to the lower drivers when all usages are abstracted */
 #define CHIP_ID_1271_PG10              (0x4030101)
 #define CHIP_ID_1271_PG20              (0x4030111)
-- 
1.7.5.4

