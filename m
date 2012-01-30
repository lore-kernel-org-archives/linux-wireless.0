Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35402 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab2A3Oze (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 09:55:34 -0500
Received: by mail-wi0-f174.google.com with SMTP id s10so3498005wic.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 06:55:34 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 6/7] wl12xx: Add functions for managing rx data filters
Date: Mon, 30 Jan 2012 16:58:44 +0200
Message-Id: <1327935525-24361-7-git-send-email-eliad@wizery.com> (sfid-20120130_155542_279259_9989FAFB)
In-Reply-To: <1327935525-24361-1-git-send-email-eliad@wizery.com>
References: <1327935525-24361-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

These functions will make sure filters are set according to what the
firmware expects. It also stores the filter state in the driver.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/rx.c     |  105 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/rx.h     |   14 ++++-
 drivers/net/wireless/wl12xx/wl12xx.h |   21 +++++++
 3 files changed, 139 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 4fbd2a7..3468db3 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -282,3 +282,108 @@ void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
 
 	wl12xx_rearm_rx_streaming(wl, active_hlids);
 }
+
+/*
+ * Global on / off for RX packet filtering in firmware
+ */
+int wl1271_rx_data_filtering_enable(struct wl1271 *wl, bool enable,
+				    enum rx_data_filter_action policy)
+{
+	int ret;
+
+	if (policy < FILTER_DROP || policy > FILTER_FW_HANDLE) {
+		wl1271_warning("filter policy value is not in valid range");
+		return -ERANGE;
+	}
+
+	if (enable < 0 || enable > 1) {
+		wl1271_warning("filter enable value is not in valid range");
+		return -ERANGE;
+	}
+
+	ret = wl1271_acx_toggle_rx_data_filter(wl, enable, policy);
+
+	if (ret)
+		return ret;
+
+	wl->rx_data_filter_enabled = enable;
+	wl->rx_data_filter_policy = policy;
+	return 0;
+}
+
+int wl1271_rx_data_filter_enable(struct wl1271 *wl,
+				 struct wl12xx_rx_data_filter *f, int nr,
+				 bool enable)
+{
+	int ret;
+
+	if (f->enabled == enable)
+		return 0;
+
+	ret = wl1271_acx_set_rx_data_filter(wl, enable, nr, f->action,
+					    f->pattern, f->len, f->offset);
+	if (ret) {
+		wl1271_error("Failed to enable/disable rx data filter");
+		return ret;
+	}
+
+	f->enabled = enable;
+	return 0;
+}
+
+int wl1271_rx_data_filter_set_action(struct wl12xx_rx_data_filter *f,
+				     enum rx_data_filter_action action)
+{
+	if (f->enabled)
+		return -EBUSY;
+
+	if (action < FILTER_DROP || action > FILTER_FW_HANDLE) {
+		wl1271_warning("filter action is not in valid range");
+		return -ERANGE;
+	}
+
+	f->action = action;
+	return 0;
+}
+
+int wl1271_rx_data_filter_set_offset(struct wl12xx_rx_data_filter *f,
+				     u16 offset)
+{
+	if (f->enabled)
+		return -EBUSY;
+
+	if (offset > USHRT_MAX-1) {
+		wl1271_warning("illegal value for filter offset");
+		return -ERANGE;
+	}
+
+	f->offset = offset;
+	return 0;
+}
+
+int wl1271_rx_data_filter_set_pattern(struct wl12xx_rx_data_filter *f, u8 *buf,
+				      u8 len)
+{
+	if (f->enabled)
+		return -EBUSY;
+	if (len > WL1271_RX_DATA_FILTER_MAX_PATTERN_SIZE)
+		return -E2BIG;
+
+	memcpy(f->pattern, buf, len);
+	f->len = len;
+	return 0;
+}
+
+/* Unset any active filters */
+void wl1271_rx_data_filters_clear_all(struct wl1271 *wl)
+{
+	int i;
+	struct wl12xx_rx_data_filter *f;
+
+	for (i = 0; i < WL1271_MAX_RX_DATA_FILTERS; i++) {
+		f  = &wl->rx_data_filters[i];
+		if (!f->enabled)
+			continue;
+		wl1271_rx_data_filter_enable(wl, f, i, 0);
+	}
+}
diff --git a/drivers/net/wireless/wl12xx/rx.h b/drivers/net/wireless/wl12xx/rx.h
index 86ba6b1..019d6ce 100644
--- a/drivers/net/wireless/wl12xx/rx.h
+++ b/drivers/net/wireless/wl12xx/rx.h
@@ -128,5 +128,17 @@ struct wl1271_rx_descriptor {
 
 void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status);
 u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
-
+void wl1271_set_default_filters(struct wl1271 *wl);
+int wl1271_rx_data_filtering_enable(struct wl1271 *wl, bool enable,
+				    enum rx_data_filter_action policy);
+int wl1271_rx_data_filter_enable(struct wl1271 *wl,
+				 struct wl12xx_rx_data_filter *f, int nr,
+				 bool enable);
+int wl1271_rx_data_filter_set_action(struct wl12xx_rx_data_filter *f,
+				     enum rx_data_filter_action action);
+int wl1271_rx_data_filter_set_offset(struct wl12xx_rx_data_filter *f,
+				     u16 offset);
+int wl1271_rx_data_filter_set_pattern(struct wl12xx_rx_data_filter *f, u8 *buf,
+				      u8 len);
+void wl1271_rx_data_filters_clear_all(struct wl1271 *wl);
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index d29de3f..66bda55 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -292,6 +292,14 @@ enum rx_data_filter_action {
 	FILTER_FW_HANDLE = 2
 };
 
+struct wl12xx_rx_data_filter {
+	bool enabled;
+	enum rx_data_filter_action action;
+	u8 len;
+	u16 offset;
+	u8 pattern[WL1271_MAX_RX_DATA_FILTER_SIZE];
+};
+
 struct wl1271 {
 	struct ieee80211_hw *hw;
 	bool mac80211_registered;
@@ -491,6 +499,19 @@ struct wl1271 {
 
 	/* last wlvif we transmitted from */
 	struct wl12xx_vif *last_wlvif;
+
+	/* AP-mode - work to add stations back on AP reconfig */
+	struct work_struct ap_start_work;
+
+	/* Global on/off switch for rx all rx filters */
+	bool rx_data_filter_enabled;
+
+	/* Default action for packets not matching any rule */
+	enum rx_data_filter_action rx_data_filter_policy;
+
+	/* RX Data filter rule descriptors */
+	struct wl12xx_rx_data_filter
+				rx_data_filters[WL1271_MAX_RX_DATA_FILTERS];
 };
 
 struct wl1271_station {
-- 
1.7.6.401.g6a319

