Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58375 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab2A3Ozg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 09:55:36 -0500
Received: by mail-ww0-f44.google.com with SMTP id ed3so4720629wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 06:55:36 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 7/7] wl12xx: Add support for WoWLAN packet pattern trigger
Date: Mon, 30 Jan 2012 16:58:45 +0200
Message-Id: <1327935525-24361-8-git-send-email-eliad@wizery.com> (sfid-20120130_155542_850663_4297600E)
In-Reply-To: <1327935525-24361-1-git-send-email-eliad@wizery.com>
References: <1327935525-24361-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

Add support for waking up if a pattern in a incoming packet is found.
Up to 4 patterns are supported.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |  106 ++++++++++++++++++++++++++++++++++--
 1 files changed, 100 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index f2960df..34bb277 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1564,8 +1564,88 @@ static struct notifier_block wl1271_dev_notifier = {
 };
 
 #ifdef CONFIG_PM
+/* Count number of 1->0 or 0->1 transitions in a bit mask */
+static int wl1271_count_bit_flips(void *bitmap, int len)
+{
+	int i, flips = 0;
+	int b, bt;
+
+	if (!len)
+		return 0;
+
+	b = test_bit(0, bitmap);
+
+	for (i = 0; i < len; i++) {
+		bt = test_bit(i, bitmap);
+		if (bt != b)
+			flips++;
+		b = bt;
+	}
+
+	return flips;
+}
+
+static int wl1271_configure_wowlan(struct wl1271 *wl,
+				   struct cfg80211_wowlan *wow)
+{
+	int i, ret;
+
+	if (!wow) {
+		wl1271_rx_data_filtering_enable(wl, 0, FILTER_SIGNAL);
+		return 0;
+	}
+
+	WARN_ON(wow->n_patterns > WL1271_MAX_RX_DATA_FILTERS);
+	if (wow->any || !wow->n_patterns)
+		return 0;
+
+	wl1271_rx_data_filters_clear_all(wl);
+
+	/* Translate WoWLAN patterns into filters */
+	for (i = 0; i < wow->n_patterns; i++) {
+		struct cfg80211_wowlan_trig_pkt_pattern *p;
+		struct wl12xx_rx_data_filter *f;
+		int offset, len;
+
+		p = &wow->patterns[i];
+		f = &wl->rx_data_filters[i];
+
+		/* WoWLAN triggers as defined by nl80211 does not match wl12xx's
+		   capabilities 1:1 so it's possible to get a pattern that
+		   FW cannot handle */
+		if (wl1271_count_bit_flips(p->mask, p->pattern_len) > 1) {
+			wl1271_warning("WoWLAN pattern too advanced\n");
+			goto err;
+		}
+		offset = find_first_bit((const unsigned long *) p->mask,
+					p->pattern_len);
+		len = p->pattern_len - offset;
+
+		ret = wl1271_rx_data_filter_set_action(f, FILTER_SIGNAL);
+		if (ret)
+			goto err;
+		ret = wl1271_rx_data_filter_set_offset(f, offset);
+		if (ret)
+			goto err;
+		ret = wl1271_rx_data_filter_set_pattern(f, &p->pattern[offset],
+							len);
+		if (ret)
+			goto err;
+		ret = wl1271_rx_data_filter_enable(wl, f, i, 1);
+		if (ret)
+			goto err;
+	}
+	ret = wl1271_rx_data_filtering_enable(wl, 1, FILTER_DROP);
+	if (ret)
+		goto err;
+	return 0;
+err:
+	return ret;
+}
+
 static int wl1271_configure_suspend_sta(struct wl1271 *wl,
-					struct wl12xx_vif *wlvif)
+					struct wl12xx_vif *wlvif,
+					struct cfg80211_wowlan *wow)
 {
 	int ret = 0;
 
@@ -1578,6 +1658,10 @@ static int wl1271_configure_suspend_sta(struct wl1271 *wl,
 	if (ret < 0)
 		goto out_unlock;
 
+	ret = wl1271_configure_wowlan(wl, wow);
+	if (ret < 0)
+		wl1271_error("suspend: Could not configure WoWLAN: %d", ret);
+
 	ret = wl1271_acx_wake_up_conditions(wl, wlvif,
 				    wl->conf.conn.suspend_wake_up_event,
 				    wl->conf.conn.suspend_listen_interval);
@@ -1618,10 +1702,11 @@ out_unlock:
 }
 
 static int wl1271_configure_suspend(struct wl1271 *wl,
-				    struct wl12xx_vif *wlvif)
+				    struct wl12xx_vif *wlvif,
+					struct cfg80211_wowlan *wow)
 {
 	if (wlvif->bss_type == BSS_TYPE_STA_BSS)
-		return wl1271_configure_suspend_sta(wl, wlvif);
+		return wl1271_configure_suspend_sta(wl, wlvif, wow);
 	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
 		return wl1271_configure_suspend_ap(wl, wlvif);
 	return 0;
@@ -1643,6 +1728,9 @@ static void wl1271_configure_resume(struct wl1271 *wl,
 		goto out;
 
 	if (is_sta) {
+		/* Remove WoWLAN filtering */
+		wl1271_configure_wowlan(wl, NULL);
+
 		ret = wl1271_acx_wake_up_conditions(wl, wlvif,
 				    wl->conf.conn.wake_up_event,
 				    wl->conf.conn.listen_interval);
@@ -1668,11 +1756,11 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 	int ret;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 suspend wow=%d", !!wow);
-	WARN_ON(!wow || !wow->any);
+	WARN_ON(!wow);
 
 	wl->wow_enabled = true;
 	wl12xx_for_each_wlvif(wl, wlvif) {
-		ret = wl1271_configure_suspend(wl, wlvif);
+		ret = wl1271_configure_suspend(wl, wlvif, wow);
 		if (ret < 0) {
 			wl1271_warning("couldn't prepare device to suspend");
 			return ret;
@@ -5172,8 +5260,14 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
 	if (!ret) {
 		wl->irq_wake_enabled = true;
 		device_init_wakeup(wl->dev, 1);
-		if (pdata->pwr_in_suspend)
+		if (pdata->pwr_in_suspend) {
 			hw->wiphy->wowlan.flags = WIPHY_WOWLAN_ANY;
+			hw->wiphy->wowlan.n_patterns =
+				WL1271_MAX_RX_DATA_FILTERS;
+			hw->wiphy->wowlan.pattern_min_len = 1;
+			hw->wiphy->wowlan.pattern_max_len =
+				WL1271_RX_DATA_FILTER_MAX_PATTERN_SIZE;
+		}
 
 	}
 	disable_irq(wl->irq);
-- 
1.7.6.401.g6a319

