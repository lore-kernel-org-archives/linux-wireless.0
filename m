Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41413 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab2AaOky (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 09:40:54 -0500
Received: by mail-ww0-f44.google.com with SMTP id dt10so26775wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 06:40:54 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 7/7] wl12xx: support wowlan wakeup patterns
Date: Tue, 31 Jan 2012 16:44:08 +0200
Message-Id: <1328021048-8944-8-git-send-email-eliad@wizery.com> (sfid-20120131_154059_464539_E9C2D82F)
In-Reply-To: <1328021048-8944-1-git-send-email-eliad@wizery.com>
References: <1328021048-8944-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

(based on Pontus' patch)

Use FW RX data filters to support cfg80211 wowlan wakeup patterns.
This enables to wake up the host from suspend following detection
of certain configurable patters within an incoming packet.
Up to 4 patterns are supported. Once the host is resumed
any configured RX data filter is cleared.
A single pattern can match several bytes sequences with different
offsets within a packet.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |  200 ++++++++++++++++++++++++++++++++++--
 1 files changed, 193 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index f2960df..27c064b 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1564,8 +1564,180 @@ static struct notifier_block wl1271_dev_notifier = {
 };
 
 #ifdef CONFIG_PM
+int wl1271_validate_wowlan_pattern(struct cfg80211_wowlan_trig_pkt_pattern *p)
+{
+	if (p->pattern_len > WL1271_RX_DATA_FILTER_MAX_PATTERN_SIZE) {
+		wl1271_warning("WoWLAN pattern too big");
+		return -E2BIG;
+	}
+
+	if (!p->mask) {
+		wl1271_warning("No mask in WoWLAN pattern");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int wl1271_build_rx_filter_field(struct wl12xx_rx_data_filter_field *field,
+				 u8 *pattern, u8 len, u8 offset,
+				 u8 *bitmask, u8 flags)
+{
+	u8 *mask;
+	int i;
+
+	field->flags = flags | WL1271_RX_DATA_FILTER_FLAG_MASK;
+
+	/* Not using the capability to set offset within an RX filter field.
+	 * The offset param is used to access pattern and bitmask.
+	 */
+	field->offset = 0;
+	field->len = len;
+	memcpy(field->pattern, &pattern[offset], len);
+
+	/* Translate the WowLAN bitmask (in bits) to the FW RX filter field
+	   mask which is in bytes */
+
+	mask = field->pattern + len;
+
+	for (i = offset; i < (offset+len); i++) {
+		if (test_bit(i, (unsigned long *)bitmask))
+			*mask = 0xFF;
+
+		mask++;
+	}
+
+	return sizeof(*field) + len + (bitmask ? len : 0);
+}
+
+/* Allocates an RX filter returned through f
+   which needs to be freed using kfree() */
+int wl1271_convert_wowlan_pattern_to_rx_filter(
+	struct cfg80211_wowlan_trig_pkt_pattern *p,
+	struct wl12xx_rx_data_filter **f)
+{
+	int filter_size, num_fields, fields_size;
+	int first_field_size;
+	int ret = 0;
+	struct wl12xx_rx_data_filter_field *field;
+	struct wl12xx_rx_data_filter *filter;
+
+	/* If pattern is longer then the ETHERNET header we split it into
+	 * 2 fields in the rx filter as you can't have a single
+	 * field across ETH header boundary. The first field will filter
+	 * anything in the ETH header and the 2nd one from the IP header.
+	 * Each field will contain pattern bytes and mask bytes
+	 */
+	if (p->pattern_len > WL1271_RX_DATA_FILTER_ETH_HEADER_SIZE)
+		num_fields = 2;
+	else
+		num_fields = 1;
+
+	fields_size = (sizeof(*field) * num_fields) + (2 * p->pattern_len);
+	filter_size = sizeof(*filter) + fields_size;
+
+	filter = kzalloc(filter_size, GFP_KERNEL);
+	if (!filter) {
+		wl1271_warning("Failed to alloc rx filter");
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	field = &filter->fields[0];
+	first_field_size = wl1271_build_rx_filter_field(field,
+			p->pattern,
+			min(p->pattern_len,
+			    WL1271_RX_DATA_FILTER_ETH_HEADER_SIZE),
+			0,
+			p->mask,
+			WL1271_RX_DATA_FILTER_FLAG_ETHERNET_HEADER);
+
+	field = (struct wl12xx_rx_data_filter_field *)
+		  (((u8 *)filter->fields) + first_field_size);
+
+	if (num_fields > 1) {
+		wl1271_build_rx_filter_field(field,
+		     p->pattern,
+		     p->pattern_len - WL1271_RX_DATA_FILTER_ETH_HEADER_SIZE,
+		     WL1271_RX_DATA_FILTER_ETH_HEADER_SIZE,
+		     p->mask,
+		     WL1271_RX_DATA_FILTER_FLAG_IP_HEADER);
+	}
+
+	filter->action = FILTER_SIGNAL;
+	filter->num_fields = num_fields;
+	filter->fields_size = fields_size;
+
+	*f = filter;
+	return 0;
+
+err:
+	kfree(filter);
+	*f = NULL;
+
+	return ret;
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
+		struct wl12xx_rx_data_filter *filter = NULL;
+
+		p = &wow->patterns[i];
+
+		ret = wl1271_validate_wowlan_pattern(p);
+		if (ret) {
+			wl1271_warning("validate_wowlan_pattern "
+				       "failed (%d)", ret);
+			goto out;
+		}
+
+		ret = wl1271_convert_wowlan_pattern_to_rx_filter(p, &filter);
+		if (ret) {
+			wl1271_warning("convert_wowlan_pattern_to_rx_filter "
+				       "failed (%d)", ret);
+			goto out;
+		}
+
+		ret = wl1271_rx_data_filter_enable(wl, i, 1, filter);
+
+		kfree(filter);
+		if (ret) {
+			wl1271_warning("rx_data_filter_enable "
+				       " failed (%d)", ret);
+			goto out;
+		}
+	}
+
+	ret = wl1271_rx_data_filtering_enable(wl, 1, FILTER_DROP);
+	if (ret) {
+		wl1271_warning("rx_data_filtering_enable failed (%d)", ret);
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
 static int wl1271_configure_suspend_sta(struct wl1271 *wl,
-					struct wl12xx_vif *wlvif)
+					struct wl12xx_vif *wlvif,
+					struct cfg80211_wowlan *wow)
 {
 	int ret = 0;
 
@@ -1578,6 +1750,10 @@ static int wl1271_configure_suspend_sta(struct wl1271 *wl,
 	if (ret < 0)
 		goto out_unlock;
 
+	ret = wl1271_configure_wowlan(wl, wow);
+	if (ret < 0)
+		wl1271_error("suspend: Could not configure WoWLAN: %d", ret);
+
 	ret = wl1271_acx_wake_up_conditions(wl, wlvif,
 				    wl->conf.conn.suspend_wake_up_event,
 				    wl->conf.conn.suspend_listen_interval);
@@ -1618,10 +1794,11 @@ out_unlock:
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
@@ -1643,6 +1820,9 @@ static void wl1271_configure_resume(struct wl1271 *wl,
 		goto out;
 
 	if (is_sta) {
+		/* Remove WoWLAN filtering */
+		wl1271_configure_wowlan(wl, NULL);
+
 		ret = wl1271_acx_wake_up_conditions(wl, wlvif,
 				    wl->conf.conn.wake_up_event,
 				    wl->conf.conn.listen_interval);
@@ -1668,11 +1848,11 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
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
@@ -1734,7 +1914,7 @@ static int wl1271_op_resume(struct ieee80211_hw *hw)
 
 	return 0;
 }
-#endif
+#endif /* CONFIG_PM */
 
 static int wl1271_op_start(struct ieee80211_hw *hw)
 {
@@ -5172,8 +5352,14 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
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

