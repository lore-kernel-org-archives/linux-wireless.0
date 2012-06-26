Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:32919 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751036Ab2FZUDN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 16:03:13 -0400
Received: by lbbgj10 with SMTP id gj10so655760lbb.23
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jun 2012 13:03:10 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 1/5] wl18xx: deprecate PG1 support
Date: Tue, 26 Jun 2012 23:02:56 +0300
Message-Id: <1340740980-22284-2-git-send-email-coelho@ti.com> (sfid-20120626_220316_975152_1F0B95D8)
In-Reply-To: <1340740980-22284-1-git-send-email-coelho@ti.com>
References: <1340740980-22284-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new PG2 version of the chip has a few differences in terms of FW
API if compared to PG1.  PG1 is just a sample that shouldn't be used
in real life, so to avoid having to handle both separately, mark the
PG1 version as deprecated and bail out during probe.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/acx.h  |   34 +++++++++++--------------
 drivers/net/wireless/ti/wl18xx/main.c |   45 +++++----------------------------
 2 files changed, 22 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/acx.h b/drivers/net/wireless/ti/wl18xx/acx.h
index ebbaf61..e2609a6 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.h
+++ b/drivers/net/wireless/ti/wl18xx/acx.h
@@ -32,25 +32,21 @@ enum {
 /* numbers of bits the length field takes (add 1 for the actual number) */
 #define WL18XX_HOST_IF_LEN_SIZE_FIELD 15
 
-#define WL18XX_ACX_EVENTS_VECTOR_PG1	(WL1271_ACX_INTR_WATCHDOG      | \
-					WL1271_ACX_INTR_INIT_COMPLETE | \
-					WL1271_ACX_INTR_EVENT_A       | \
-					WL1271_ACX_INTR_EVENT_B       | \
-					WL1271_ACX_INTR_CMD_COMPLETE  | \
-					WL1271_ACX_INTR_HW_AVAILABLE  | \
-					WL1271_ACX_INTR_DATA)
-
-#define WL18XX_ACX_EVENTS_VECTOR_PG2	(WL18XX_ACX_EVENTS_VECTOR_PG1 | \
-					WL1271_ACX_SW_INTR_WATCHDOG)
-
-#define WL18XX_INTR_MASK_PG1		(WL1271_ACX_INTR_WATCHDOG      | \
-					WL1271_ACX_INTR_EVENT_A       | \
-					WL1271_ACX_INTR_EVENT_B       | \
-					WL1271_ACX_INTR_HW_AVAILABLE  | \
-					WL1271_ACX_INTR_DATA)
-
-#define WL18XX_INTR_MASK_PG2		(WL18XX_INTR_MASK_PG1         | \
-					WL1271_ACX_SW_INTR_WATCHDOG)
+#define WL18XX_ACX_EVENTS_VECTOR	(WL1271_ACX_INTR_WATCHDOG	| \
+					 WL1271_ACX_INTR_INIT_COMPLETE	| \
+					 WL1271_ACX_INTR_EVENT_A	| \
+					 WL1271_ACX_INTR_EVENT_B	| \
+					 WL1271_ACX_INTR_CMD_COMPLETE	| \
+					 WL1271_ACX_INTR_HW_AVAILABLE	| \
+					 WL1271_ACX_INTR_DATA		| \
+					 WL1271_ACX_SW_INTR_WATCHDOG)
+
+#define WL18XX_INTR_MASK		(WL1271_ACX_INTR_WATCHDOG	| \
+					 WL1271_ACX_INTR_EVENT_A	| \
+					 WL1271_ACX_INTR_EVENT_B	| \
+					 WL1271_ACX_INTR_HW_AVAILABLE	| \
+					 WL1271_ACX_INTR_DATA		| \
+					 WL1271_ACX_SW_INTR_WATCHDOG)
 
 struct wl18xx_acx_host_config_bitmap {
 	struct acx_header header;
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index c25b960..5e583be 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -612,20 +612,11 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
 			      WLCORE_QUIRK_TX_PAD_LAST_FRAME;
 		break;
 	case CHIP_ID_185x_PG10:
-		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (185x PG10)",
-			     wl->chip.id);
-		wl->sr_fw_name = WL18XX_FW_NAME;
-		/* wl18xx uses the same firmware for PLT */
-		wl->plt_fw_name = WL18XX_FW_NAME;
-		wl->quirks |= WLCORE_QUIRK_NO_ELP |
-			WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED |
-			WLCORE_QUIRK_RX_BLOCKSIZE_ALIGN |
-			WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN;
-
-		/* PG 1.0 has some problems with MCS_13, so disable it */
-		wl->ht_cap[IEEE80211_BAND_2GHZ].mcs.rx_mask[1] &= ~BIT(5);
+		wl1271_warning("chip id 0x%x (185x PG10) is deprecated",
+			       wl->chip.id);
+		ret = -ENODEV;
+		goto out;
 
-		break;
 	default:
 		wl1271_warning("unsupported chip id: 0x%x", wl->chip.id);
 		ret = -ENODEV;
@@ -776,21 +767,14 @@ out:
 static int wl18xx_set_mac_and_phy(struct wl1271 *wl)
 {
 	struct wl18xx_priv *priv = wl->priv;
-	size_t len;
 	int ret;
 
-	/* the parameters struct is smaller for PG1 */
-	if (wl->chip.id == CHIP_ID_185x_PG10)
-		len = offsetof(struct wl18xx_mac_and_phy_params, psat) + 1;
-	else
-		len = sizeof(struct wl18xx_mac_and_phy_params);
-
 	ret = wlcore_set_partition(wl, &wl->ptable[PART_PHY_INIT]);
 	if (ret < 0)
 		goto out;
 
 	ret = wlcore_write(wl, WL18XX_PHY_INIT_MEM_ADDR, (u8 *)&priv->conf.phy,
-			   len, false);
+			   sizeof(struct wl18xx_mac_and_phy_params), false);
 
 out:
 	return ret;
@@ -801,13 +785,8 @@ static int wl18xx_enable_interrupts(struct wl1271 *wl)
 	u32 event_mask, intr_mask;
 	int ret;
 
-	if (wl->chip.id == CHIP_ID_185x_PG10) {
-		event_mask = WL18XX_ACX_EVENTS_VECTOR_PG1;
-		intr_mask = WL18XX_INTR_MASK_PG1;
-	} else {
-		event_mask = WL18XX_ACX_EVENTS_VECTOR_PG2;
-		intr_mask = WL18XX_INTR_MASK_PG2;
-	}
+	event_mask = WL18XX_ACX_EVENTS_VECTOR;
+	intr_mask = WL18XX_INTR_MASK;
 
 	ret = wlcore_write_reg(wl, REG_INTERRUPT_MASK, event_mask);
 	if (ret < 0)
@@ -1049,16 +1028,6 @@ static u32 wl18xx_ap_get_mimo_wide_rate_mask(struct wl1271 *wl,
 	} else if (!strcmp(ht_mode_param, "mimo")) {
 		wl1271_debug(DEBUG_ACX, "using MIMO rate mask");
 
-		/*
-		 * PG 1.0 has some problems with MCS_13, so disable it
-		 *
-		 * TODO: instead of hacking this in here, we should
-		 * make it more general and change a bit in the
-		 * wlvif->rate_set instead.
-		 */
-		if (wl->chip.id == CHIP_ID_185x_PG10)
-			return CONF_TX_MIMO_RATES & ~CONF_HW_BIT_RATE_MCS_13;
-
 		return CONF_TX_MIMO_RATES;
 	} else {
 		return 0;
-- 
1.7.10

