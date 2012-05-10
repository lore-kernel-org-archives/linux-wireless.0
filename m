Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46680 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758536Ab2EJJQi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:38 -0400
Received: by mail-wi0-f170.google.com with SMTP id hm4so231590wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:38 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 58/78] wl18xx: disable MCS_13 for wl18xx PG 1.0
Date: Thu, 10 May 2012 12:14:03 +0300
Message-Id: <1336641263-5761-59-git-send-email-arik@wizery.com> (sfid-20120510_111854_464242_C68A7E5A)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

There are some problems with MCS_13 in PG 1.0 hardware.  So we disable
it when PG 1.0 is detected.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 6047a6d..afa2334 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -588,6 +588,9 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
 			      WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED |
 			      WLCORE_QUIRK_RX_BLOCKSIZE_ALIGN;
 
+		/* PG 1.0 has some problems with MCS_13, so disable it */
+		wl->ht_cap.mcs.rx_mask[1] &= ~BIT(5);
+
 		/* TODO: need to blocksize alignment for RX/TX separately? */
 		break;
 	default:
@@ -914,6 +917,10 @@ static void wl18xx_set_rx_csum(struct wl1271 *wl,
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 }
 
+/*
+ * TODO: instead of having these two functions to get the rate mask,
+ * we should modify the wlvif->rate_set instead
+ */
 static u32 wl18xx_sta_get_ap_rate_mask(struct wl1271 *wl,
 				       struct wl12xx_vif *wlvif)
 {
@@ -940,6 +947,17 @@ static u32 wl18xx_ap_get_mimo_wide_rate_mask(struct wl1271 *wl,
 		return CONF_TX_RATE_USE_WIDE_CHAN;
 	} else {
 		wl1271_debug(DEBUG_ACX, "using MIMO rate mask");
+
+		/*
+		 * PG 1.0 has some problems with MCS_13, so disable it
+		 *
+		 * TODO: instead of hacking this in here, we should
+		 * make it more general and change a bit in the
+		 * wlvif->rate_set instead.
+		 */
+		if (wl->chip.id == CHIP_ID_185x_PG10)
+			return CONF_TX_MIMO_RATES & ~CONF_HW_BIT_RATE_MCS_13;
+
 		return CONF_TX_MIMO_RATES;
 	}
 }
-- 
1.7.9.5

