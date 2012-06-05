Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:41807 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275Ab2FEHOr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 03:14:47 -0400
Received: by lagy4 with SMTP id y4so7456157lag.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jun 2012 00:14:44 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH] wlcore/wl12xx/wl18xx: don't use TX align quirk for wl127x
Date: Tue,  5 Jun 2012 10:14:31 +0300
Message-Id: <1338880471-854-1-git-send-email-coelho@ti.com> (sfid-20120605_091451_830655_918DA37F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we moved the identify_chip operation to an earlier stage (ie. to
the probe function), we broke wl127x support because during HW init we
would set the WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN.

To avoid this, set this quirk in the identify_chip operations and only
force it to be unset if the bus module doesn't support it.  We were
doing the opposite and setting the flag if the bus module supports it.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c |   10 ++++------
 drivers/net/wireless/ti/wl18xx/main.c |    5 +++--
 drivers/net/wireless/ti/wlcore/main.c |    7 +++++--
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index ba5afa4..67974f6 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -625,9 +625,6 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		wl1271_warning("chip id 0x%x (1271 PG10) support is obsolete",
 			       wl->chip.id);
 
-		/* clear the alignment quirk, since we don't support it */
-		wl->quirks &= ~WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN;
-
 		wl->quirks |= WLCORE_QUIRK_LEGACY_NVS;
 		wl->sr_fw_name = WL127X_FW_NAME_SINGLE;
 		wl->mr_fw_name = WL127X_FW_NAME_MULTI;
@@ -643,9 +640,6 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (1271 PG20)",
 			     wl->chip.id);
 
-		/* clear the alignment quirk, since we don't support it */
-		wl->quirks &= ~WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN;
-
 		wl->quirks |= WLCORE_QUIRK_LEGACY_NVS;
 		wl->plt_fw_name = WL127X_PLT_FW_NAME;
 		wl->sr_fw_name = WL127X_FW_NAME_SINGLE;
@@ -664,6 +658,10 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		wl->plt_fw_name = WL128X_PLT_FW_NAME;
 		wl->sr_fw_name = WL128X_FW_NAME_SINGLE;
 		wl->mr_fw_name = WL128X_FW_NAME_MULTI;
+
+		/* wl128x requires TX blocksize alignment */
+		wl->quirks |= WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN;
+
 		break;
 	case CHIP_ID_1283_PG10:
 	default:
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index dda9c18..2e9b3cb 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -591,8 +591,9 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
 		/* wl18xx uses the same firmware for PLT */
 		wl->plt_fw_name = WL18XX_FW_NAME;
 		wl->quirks |= WLCORE_QUIRK_NO_ELP |
-			      WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED |
-			      WLCORE_QUIRK_RX_BLOCKSIZE_ALIGN;
+			WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED |
+			WLCORE_QUIRK_RX_BLOCKSIZE_ALIGN |
+			WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN;
 
 		/* PG 1.0 has some problems with MCS_13, so disable it */
 		wl->ht_cap.mcs.rx_mask[1] &= ~BIT(5);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 00a4821..af00dab 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -960,9 +960,12 @@ static int wl12xx_chip_wakeup(struct wl1271 *wl, bool plt)
 	 * simplify the code and since the performance impact is
 	 * negligible, we use the same block size for all different
 	 * chip types.
+	 *
+	 * Check if the bus supports blocksize alignment and, if it
+	 * doesn't, make sure we don't have the quirk.
 	 */
-	if (wl1271_set_block_size(wl))
-		wl->quirks |= WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN;
+	if (!wl1271_set_block_size(wl))
+		wl->quirks &= ~WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN;
 
 	/* TODO: make sure the lower driver has set things up correctly */
 
-- 
1.7.10

