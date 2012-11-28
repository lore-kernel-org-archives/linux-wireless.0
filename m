Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36268 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab2K1JnT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:43:19 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so4384742wer.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 01:43:19 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 12/20] wl18xx: limit Tx for the AP single-STA-in-PSM case
Date: Wed, 28 Nov 2012 11:42:41 +0200
Message-Id: <1354095769-8724-13-git-send-email-arik@wizery.com> (sfid-20121128_104327_857965_2B7DBCB3)
In-Reply-To: <1354095769-8724-1-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Treat a single connected STA in PSM as a slow link and regulate Tx speed
according to slow link priority/stop thresholds.
This allows us to avoid flooding the FW, while delivering decent
throughput to a peer in forced-PSM.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 3836dbd..ada4616 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1446,10 +1446,11 @@ static bool wl18xx_lnk_high_prio(struct wl1271 *wl, u8 hlid,
 		return false;
 
 	/* the priority thresholds are taken from FW */
-	if (test_bit(hlid, (unsigned long *)&wl->fw_fast_lnk_map))
-		thold = status_priv->tx_fast_link_prio_threshold;
-	else
+	if (!test_bit(hlid, (unsigned long *)&wl->fw_fast_lnk_map) ||
+	    test_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map))
 		thold = status_priv->tx_slow_link_prio_threshold;
+	else
+		thold = status_priv->tx_fast_link_prio_threshold;
 
 	return lnk->allocated_pkts < thold;
 }
@@ -1464,10 +1465,11 @@ static bool wl18xx_lnk_low_prio(struct wl1271 *wl, u8 hlid,
 
 	if (test_bit(hlid, (unsigned long *)&suspend_bitmap))
 		thold = status_priv->tx_suspend_threshold;
-	else if (test_bit(hlid, (unsigned long *)&wl->fw_fast_lnk_map))
-		thold = status_priv->tx_fast_stop_threshold;
-	else
+	else if (!test_bit(hlid, (unsigned long *)&wl->fw_fast_lnk_map) ||
+		 test_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map))
 		thold = status_priv->tx_slow_stop_threshold;
+	else
+		thold = status_priv->tx_fast_stop_threshold;
 
 	return lnk->allocated_pkts < thold;
 }
-- 
1.7.9.5

