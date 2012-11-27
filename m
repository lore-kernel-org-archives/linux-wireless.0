Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:42694 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602Ab2K0Nwo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 08:52:44 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id qARDqheT031473
	for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 07:52:43 -0600
Received: from DFLE73.ent.ti.com (dfle73.ent.ti.com [128.247.5.110])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id qARDqhBe014262
	for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 07:52:43 -0600
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>
Subject: [PATCH 2/6] wlcore/wl12xx: remove deprecated FW version check
Date: Tue, 27 Nov 2012 15:51:57 +0200
Message-ID: <1354024321-20635-3-git-send-email-coelho@ti.com> (sfid-20121127_145248_614093_78D7700B)
In-Reply-To: <1354024321-20635-1-git-send-email-coelho@ti.com>
References: <1354024321-20635-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't distinguish between STA and AP firmwares anymore, so the
firmware version checking and quirks setting in wl12xx isn't needed
anymore.

Remove implementation of .identify_fw in wl12xx and deprecated
definitions.  Don't remove the op entirely from wlcore, because it may
be needed for more fine-grained checking later.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c     |   17 -----------------
 drivers/net/wireless/ti/wlcore/wlcore_i.h |   11 -----------
 2 files changed, 28 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 0b11029..cadd7f3 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1394,22 +1394,6 @@ static u32 wl12xx_sta_get_ap_rate_mask(struct wl1271 *wl,
 	return wlvif->rate_set;
 }
 
-static int wl12xx_identify_fw(struct wl1271 *wl)
-{
-	unsigned int *fw_ver = wl->chip.fw_ver;
-
-	/* Only new station firmwares support routing fw logs to the host */
-	if ((fw_ver[FW_VER_IF_TYPE] == FW_VER_IF_TYPE_STA) &&
-	    (fw_ver[FW_VER_MINOR] < FW_VER_MINOR_FWLOG_STA_MIN))
-		wl->quirks |= WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED;
-
-	/* This feature is not yet supported for AP mode */
-	if (fw_ver[FW_VER_IF_TYPE] == FW_VER_IF_TYPE_AP)
-		wl->quirks |= WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED;
-
-	return 0;
-}
-
 static void wl12xx_conf_init(struct wl1271 *wl)
 {
 	struct wl12xx_priv *priv = wl->priv;
@@ -1594,7 +1578,6 @@ static int wl12xx_setup(struct wl1271 *wl);
 static struct wlcore_ops wl12xx_ops = {
 	.setup			= wl12xx_setup,
 	.identify_chip		= wl12xx_identify_chip,
-	.identify_fw		= wl12xx_identify_fw,
 	.boot			= wl12xx_boot,
 	.plt_init		= wl12xx_plt_init,
 	.trigger_cmd		= wl12xx_trigger_cmd,
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 6678d4b..dbbfca1 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -109,17 +109,6 @@ enum {
 	NUM_FW_VER
 };
 
-#define FW_VER_CHIP_WL127X 6
-#define FW_VER_CHIP_WL128X 7
-
-#define FW_VER_IF_TYPE_STA 1
-#define FW_VER_IF_TYPE_AP  2
-
-#define FW_VER_MINOR_1_SPARE_STA_MIN 58
-#define FW_VER_MINOR_1_SPARE_AP_MIN  47
-
-#define FW_VER_MINOR_FWLOG_STA_MIN 70
-
 struct wl1271_chip {
 	u32 id;
 	char fw_ver_str[ETHTOOL_BUSINFO_LEN];
-- 
1.7.10.4

