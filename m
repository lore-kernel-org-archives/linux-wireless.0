Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:35373 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755771Ab2FWGmT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 02:42:19 -0400
Received: by lbok6 with SMTP id k6so5180457lbo.4
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 23:42:16 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com, ido@wizery.com
Subject: [PATCH 16/18] wlcore: check Rx-filter functions in the suspend path
Date: Sat, 23 Jun 2012 09:41:27 +0300
Message-Id: <1340433689-24320-17-git-send-email-coelho@ti.com> (sfid-20120623_085130_633031_AF0F4545)
In-Reply-To: <1340433689-24320-1-git-send-email-coelho@ti.com>
References: <1340433689-24320-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Propagate some missing return values for Rx-filter related functions.
This and makes sure we always fail the suspend in case of SDIO errors.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   27 +++++++++++++++++++++------
 drivers/net/wireless/ti/wlcore/rx.c   |   11 ++++++++---
 drivers/net/wireless/ti/wlcore/rx.h   |    2 +-
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 0b51522..e6e6654 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1513,8 +1513,15 @@ static int wl1271_configure_wowlan(struct wl1271 *wl,
 	int i, ret;
 
 	if (!wow || wow->any || !wow->n_patterns) {
-		wl1271_acx_default_rx_filter_enable(wl, 0, FILTER_SIGNAL);
-		wl1271_rx_filter_clear_all(wl);
+		ret = wl1271_acx_default_rx_filter_enable(wl, 0,
+							  FILTER_SIGNAL);
+		if (ret)
+			goto out;
+
+		ret = wl1271_rx_filter_clear_all(wl);
+		if (ret)
+			goto out;
+
 		return 0;
 	}
 
@@ -1530,8 +1537,13 @@ static int wl1271_configure_wowlan(struct wl1271 *wl,
 		}
 	}
 
-	wl1271_acx_default_rx_filter_enable(wl, 0, FILTER_SIGNAL);
-	wl1271_rx_filter_clear_all(wl);
+	ret = wl1271_acx_default_rx_filter_enable(wl, 0, FILTER_SIGNAL);
+	if (ret)
+		goto out;
+
+	ret = wl1271_rx_filter_clear_all(wl);
+	if (ret)
+		goto out;
 
 	/* Translate WoWLAN patterns into filters */
 	for (i = 0; i < wow->n_patterns; i++) {
@@ -1573,7 +1585,10 @@ static int wl1271_configure_suspend_sta(struct wl1271 *wl,
 	if (ret < 0)
 		goto out;
 
-	wl1271_configure_wowlan(wl, wow);
+	ret = wl1271_configure_wowlan(wl, wow);
+	if (ret < 0)
+		goto out_sleep;
+
 	ret = wl1271_acx_wake_up_conditions(wl, wlvif,
 				    wl->conf.conn.suspend_wake_up_event,
 				    wl->conf.conn.suspend_listen_interval);
@@ -1581,8 +1596,8 @@ static int wl1271_configure_suspend_sta(struct wl1271 *wl,
 	if (ret < 0)
 		wl1271_error("suspend: set wake up conditions failed: %d", ret);
 
+out_sleep:
 	wl1271_ps_elp_sleep(wl);
-
 out:
 	return ret;
 
diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index f42b969..f55e2f9 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -318,14 +318,19 @@ int wl1271_rx_filter_enable(struct wl1271 *wl,
 	return 0;
 }
 
-void wl1271_rx_filter_clear_all(struct wl1271 *wl)
+int wl1271_rx_filter_clear_all(struct wl1271 *wl)
 {
-	int i;
+	int i, ret = 0;
 
 	for (i = 0; i < WL1271_MAX_RX_FILTERS; i++) {
 		if (!wl->rx_filter_enabled[i])
 			continue;
-		wl1271_rx_filter_enable(wl, i, 0, NULL);
+		ret = wl1271_rx_filter_enable(wl, i, 0, NULL);
+		if (ret)
+			goto out;
 	}
+
+out:
+	return ret;
 }
 #endif /* CONFIG_PM */
diff --git a/drivers/net/wireless/ti/wlcore/rx.h b/drivers/net/wireless/ti/wlcore/rx.h
index 79f7839..71eba18 100644
--- a/drivers/net/wireless/ti/wlcore/rx.h
+++ b/drivers/net/wireless/ti/wlcore/rx.h
@@ -148,6 +148,6 @@ u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
 int wl1271_rx_filter_enable(struct wl1271 *wl,
 			    int index, bool enable,
 			    struct wl12xx_rx_filter *filter);
-void wl1271_rx_filter_clear_all(struct wl1271 *wl);
+int wl1271_rx_filter_clear_all(struct wl1271 *wl);
 
 #endif
-- 
1.7.10

