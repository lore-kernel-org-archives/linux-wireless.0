Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38548 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab1EXLdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 07:33:00 -0400
Received: by wya21 with SMTP id 21so4890711wya.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 May 2011 04:32:59 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: fix erroneous commit (cb5ae0)
Date: Tue, 24 May 2011 14:33:08 +0300
Message-Id: <1306236788-2921-1-git-send-email-eliad@wizery.com> (sfid-20110524_133314_488684_84366616)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to rebase error, the patch for commit cb5ae0 ("wl12xx: configure
rates when working in ibss mode") was wrong - a blob was added
into the wrong function. fix it.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index fb0f764..f7b62a0 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2895,28 +2895,10 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 				wl1271_debug(DEBUG_AP, "stopped AP");
 			}
 		}
 	}
 
-	if (changed & BSS_CHANGED_IBSS) {
-		wl1271_debug(DEBUG_ADHOC, "ibss_joined: %d",
-			     bss_conf->ibss_joined);
-
-		if (bss_conf->ibss_joined) {
-			u32 rates = bss_conf->basic_rates;
-			wl->basic_rate_set = wl1271_tx_enabled_rates_get(wl,
-									 rates);
-			wl->basic_rate = wl1271_tx_min_rate_get(wl);
-
-			/* by default, use 11b rates */
-			wl->rate_set = CONF_TX_IBSS_DEFAULT_RATES;
-			ret = wl1271_acx_sta_rate_policies(wl);
-			if (ret < 0)
-				goto out;
-		}
-	}
-
 	ret = wl1271_bss_erp_info_changed(wl, bss_conf, changed);
 	if (ret < 0)
 		goto out;
 out:
 	return;
@@ -3138,10 +3120,28 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 				wl1271_dummy_join(wl);
 			}
 		}
 	}
 
+	if (changed & BSS_CHANGED_IBSS) {
+		wl1271_debug(DEBUG_ADHOC, "ibss_joined: %d",
+			     bss_conf->ibss_joined);
+
+		if (bss_conf->ibss_joined) {
+			u32 rates = bss_conf->basic_rates;
+			wl->basic_rate_set = wl1271_tx_enabled_rates_get(wl,
+									 rates);
+			wl->basic_rate = wl1271_tx_min_rate_get(wl);
+
+			/* by default, use 11b rates */
+			wl->rate_set = CONF_TX_IBSS_DEFAULT_RATES;
+			ret = wl1271_acx_sta_rate_policies(wl);
+			if (ret < 0)
+				goto out;
+		}
+	}
+
 	ret = wl1271_bss_erp_info_changed(wl, bss_conf, changed);
 	if (ret < 0)
 		goto out;
 
 	if (changed & BSS_CHANGED_ARP_FILTER) {
-- 
1.7.0.4

