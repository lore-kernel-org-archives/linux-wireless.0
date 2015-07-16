Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:35607 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581AbbGPIeT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2015 04:34:19 -0400
Received: from dlelxv90.itg.ti.com ([172.17.2.17])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id t6G8YJU2021386
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2015 03:34:19 -0500
Received: from DFLE72.ent.ti.com (dfle72.ent.ti.com [128.247.5.109])
	by dlelxv90.itg.ti.com (8.14.3/8.13.8) with ESMTP id t6G8YJlY004609
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2015 03:34:19 -0500
From: Guy Mishol <guym@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: Guy Mishol <guym@ti.com>
Subject: [PATCH] wlcore: add antenna diversity reading
Date: Thu, 16 Jul 2015 11:22:47 +0300
Message-ID: <1437034967-30374-1-git-send-email-guym@ti.com> (sfid-20150716_103433_303462_6A75033B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

update the rssi reading on rx_status
to read both RSSI level (7 bits) and
antenna diversity (msb)

Signed-off-by: Guy Mishol <guym@ti.com>
---
 drivers/net/wireless/ti/wlcore/rx.c |    3 ++-
 drivers/net/wireless/ti/wlcore/rx.h |    3 +++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index 3844944..c2f673f 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -74,7 +74,8 @@ static void wl1271_rx_status(struct wl1271 *wl,
 	if (desc->rate <= wl->hw_min_ht_rate)
 		status->flag |= RX_FLAG_HT;
 
-	status->signal = desc->rssi;
+	status->signal = ((desc->rssi & RSSI_LEVEL_BITMASK) | BIT(7));
+	status->antenna = ((desc->rssi & ANT_DIVERSITY_BITMASK) >> 7);
 
 	/*
 	 * FIXME: In wl1251, the SNR should be divided by two.  In wl1271 we
diff --git a/drivers/net/wireless/ti/wlcore/rx.h b/drivers/net/wireless/ti/wlcore/rx.h
index a3b1618..f5a7087c 100644
--- a/drivers/net/wireless/ti/wlcore/rx.h
+++ b/drivers/net/wireless/ti/wlcore/rx.h
@@ -30,6 +30,9 @@
 #define WL1271_RX_MAX_RSSI -30
 #define WL1271_RX_MIN_RSSI -95
 
+#define RSSI_LEVEL_BITMASK	0x7F
+#define ANT_DIVERSITY_BITMASK	BIT(7)
+
 #define SHORT_PREAMBLE_BIT   BIT(0)
 #define OFDM_RATE_BIT        BIT(6)
 #define PBCC_RATE_BIT        BIT(7)
-- 
1.7.9

