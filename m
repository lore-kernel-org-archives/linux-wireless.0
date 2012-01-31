Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49103 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab2AaOkx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 09:40:53 -0500
Received: by wics10 with SMTP id s10so17076wic.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 06:40:52 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 6/7] wl12xx: add RX data filters management functions
Date: Tue, 31 Jan 2012 16:44:07 +0200
Message-Id: <1328021048-8944-7-git-send-email-eliad@wizery.com> (sfid-20120131_154058_467075_B4EC1786)
In-Reply-To: <1328021048-8944-1-git-send-email-eliad@wizery.com>
References: <1328021048-8944-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

(based on Pontus' patch)

More prep work for supporting RX data filters
in FW. These functions use a driver saved state
of the enabled filters to prevent actions (enable/disable)
which don't match the FW status.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/rx.c     |   61 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/rx.h     |    8 ++++-
 drivers/net/wireless/wl12xx/wl12xx.h |    3 ++
 3 files changed, 71 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 4fbd2a7..d025db6 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -282,3 +282,64 @@ void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
 
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
+	return ret;
+}
+
+int wl1271_rx_data_filter_enable(struct wl1271 *wl,
+				 int index,
+				 bool enable,
+				 struct wl12xx_rx_data_filter *filter)
+{
+	int ret;
+
+	if (wl->rx_data_filters_status[index] == enable) {
+		wl1271_debug(DEBUG_ACX, "Request to enable an already "
+			     "enabled rx filter %d", index);
+		return 0;
+	}
+
+	ret = wl1271_acx_set_rx_data_filter(wl, index, enable, filter);
+
+	if (ret) {
+		wl1271_error("Failed to %s rx data filter %d (err=%d)",
+			     enable ? "enable" : "disable", index, ret);
+		return ret;
+	}
+
+	wl->rx_data_filters_status[index] = enable;
+
+	return 0;
+}
+
+/* Unset any active filters */
+void wl1271_rx_data_filters_clear_all(struct wl1271 *wl)
+{
+	int i;
+
+	for (i = 0; i < WL1271_MAX_RX_DATA_FILTERS; i++) {
+		if (!wl->rx_data_filters_status[i])
+			continue;
+		wl1271_rx_data_filter_enable(wl, i, 0, NULL);
+	}
+}
diff --git a/drivers/net/wireless/wl12xx/rx.h b/drivers/net/wireless/wl12xx/rx.h
index 86ba6b1..b4db4014 100644
--- a/drivers/net/wireless/wl12xx/rx.h
+++ b/drivers/net/wireless/wl12xx/rx.h
@@ -128,5 +128,11 @@ struct wl1271_rx_descriptor {
 
 void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status);
 u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
-
+int wl1271_rx_data_filtering_enable(struct wl1271 *wl, bool enable,
+				    enum rx_data_filter_action policy);
+int wl1271_rx_data_filter_enable(struct wl1271 *wl,
+				 int index,
+				 bool enable,
+				 struct wl12xx_rx_data_filter *filter);
+void wl1271_rx_data_filters_clear_all(struct wl1271 *wl);
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index c18ad0a..720ea82 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -509,6 +509,9 @@ struct wl1271 {
 
 	/* last wlvif we transmitted from */
 	struct wl12xx_vif *last_wlvif;
+
+	/* RX Data filter rule status - enabled/disabled */
+	bool rx_data_filters_status[WL1271_MAX_RX_DATA_FILTERS];
 };
 
 struct wl1271_station {
-- 
1.7.6.401.g6a319

