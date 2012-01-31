Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41413 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab2AaOkv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 09:40:51 -0500
Received: by mail-ww0-f44.google.com with SMTP id dt10so26775wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 06:40:50 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 5/7] wl12xx: add RX data filter ACX commands
Date: Tue, 31 Jan 2012 16:44:06 +0200
Message-Id: <1328021048-8944-6-git-send-email-eliad@wizery.com> (sfid-20120131_154056_159148_2ADB994E)
In-Reply-To: <1328021048-8944-1-git-send-email-eliad@wizery.com>
References: <1328021048-8944-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

(based on Pontus' patch)

Added commands for setting a specific filter
and controlling the behaviour RX data filters
implemented by the FW.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c    |  105 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/acx.h    |   31 ++++++++++-
 drivers/net/wireless/wl12xx/wl12xx.h |   33 +++++++++++
 3 files changed, 168 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index bc96db0..668d337 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1740,3 +1740,108 @@ out:
 	return ret;
 
 }
+
+int wl1271_acx_toggle_rx_data_filter(struct wl1271 *wl, bool enable,
+				     u8 default_action)
+{
+	struct acx_rx_data_filter_state *acx;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx toggle rx data filter en: %d act: %d",
+		     enable, default_action);
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->enable = enable ? 1 : 0;
+	acx->default_action = default_action;
+
+	ret = wl1271_cmd_configure(wl, ACX_ENABLE_RX_DATA_FILTER, acx,
+				   sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("toggling rx data filter failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
+int wl1271_acx_set_rx_data_filter(struct wl1271 *wl, u8 index, bool enable,
+				  struct wl12xx_rx_data_filter *filter)
+{
+	struct acx_rx_data_filter_cfg *acx;
+	int fields_size = 0;
+	int acx_size;
+	int ret;
+
+	if (enable && !filter) {
+		wl1271_warning("acx_set_rx_data_filter: enable but no filter");
+		return -EINVAL;
+	}
+
+	if (index >= WL1271_MAX_RX_DATA_FILTERS) {
+		wl1271_warning("acx_set_rx_data_filter: invalid filter idx(%d)",
+			       index);
+		return -EINVAL;
+	}
+
+	if (filter) {
+		if (filter->action < FILTER_DROP ||
+		    filter->action > FILTER_FW_HANDLE) {
+			wl1271_warning("invalid filter action (%d)",
+				       filter->action);
+			return -EINVAL;
+		}
+
+		if (filter->num_fields != 1 &&
+		    filter->num_fields != 2) {
+			wl1271_warning("invalid filter num_fields (%d)",
+				       filter->num_fields);
+			return -EINVAL;
+		}
+	}
+
+	wl1271_debug(DEBUG_ACX, "acx set rx data filter idx: %d, enable: %d",
+		     index, enable);
+
+	if (enable) {
+		fields_size = filter->fields_size;
+
+		wl1271_debug(DEBUG_ACX, "act: %d num_fields: %d field_size: %d",
+		      filter->action, filter->num_fields, fields_size);
+	}
+
+	acx_size = roundup(sizeof(*acx) + fields_size, 4);
+	acx = kzalloc(acx_size, GFP_KERNEL);
+
+	if (!acx)
+		return -ENOMEM;
+
+	acx->enable = enable ? 1 : 0;
+	acx->index = index;
+
+	if (enable) {
+		acx->num_fields = filter->num_fields;
+		acx->action = filter->action;
+
+		memcpy(acx->fields, filter->fields, filter->fields_size);
+	}
+
+	wl1271_dump(DEBUG_ACX, "RX_FILTER: ", acx, acx_size);
+
+	ret = wl1271_cmd_configure(wl, ACX_SET_RX_DATA_FILTER, acx,
+				   acx_size);
+	if (ret < 0) {
+		wl1271_warning("setting rx data filter failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index a28fc04..9d0d30b 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1152,6 +1152,32 @@ struct wl12xx_acx_config_hangover {
 	u8 padding[2];
 } __packed;
 
+
+struct acx_rx_data_filter_state {
+	struct acx_header header;
+	u8 enable;
+
+	/* action of type FILTER_XXX */
+	u8 default_action;
+	u8 pad[2];
+} __packed;
+
+
+struct acx_rx_data_filter_cfg {
+	struct acx_header header;
+
+	u8 enable;
+
+	/* range 0 - MAX_DATA_FILTERS */
+	u8 index;
+
+	u8 action;
+
+	u8 num_fields;
+
+	struct wl12xx_rx_data_filter_field fields[0];
+} __packed;
+
 enum {
 	ACX_WAKE_UP_CONDITIONS           = 0x0000,
 	ACX_MEM_CFG                      = 0x0001,
@@ -1310,5 +1336,8 @@ int wl1271_acx_set_inconnection_sta(struct wl1271 *wl, u8 *addr);
 int wl1271_acx_fm_coex(struct wl1271 *wl);
 int wl12xx_acx_set_rate_mgmt_params(struct wl1271 *wl);
 int wl12xx_acx_config_hangover(struct wl1271 *wl);
-
+int wl1271_acx_toggle_rx_data_filter(struct wl1271 *wl, bool enable,
+				     u8 default_action);
+int wl1271_acx_set_rx_data_filter(struct wl1271 *wl, u8 index, bool enable,
+				  struct wl12xx_rx_data_filter *filter);
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 1463341..c18ad0a 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -277,6 +277,39 @@ struct wl1271_link {
 	u8 ba_bitmap;
 };
 
+#define WL1271_MAX_RX_DATA_FILTERS 4
+#define WL1271_RX_DATA_FILTER_MAX_FIELD_PATTERNS 8
+
+/* FW MAX FILTER SIZE is 98 bytes. The MAX_PATTERN_SIZE is imposed
+ * after taking into account the mask bytes and other structs members
+ */
+#define WL1271_RX_DATA_FILTER_MAX_PATTERN_SIZE 43
+#define WL1271_RX_DATA_FILTER_ETH_HEADER_SIZE 14
+
+#define WL1271_RX_DATA_FILTER_FLAG_MASK                BIT(0)
+#define WL1271_RX_DATA_FILTER_FLAG_IP_HEADER           0
+#define WL1271_RX_DATA_FILTER_FLAG_ETHERNET_HEADER     BIT(1)
+
+enum rx_data_filter_action {
+	FILTER_DROP = 0,
+	FILTER_SIGNAL = 1,
+	FILTER_FW_HANDLE = 2
+};
+
+struct wl12xx_rx_data_filter_field {
+	__le16 offset;
+	u8 len;
+	u8 flags;
+	u8 pattern[0];
+} __packed;
+
+struct wl12xx_rx_data_filter {
+	u8 action;
+	int num_fields;
+	int fields_size;
+	struct wl12xx_rx_data_filter_field fields[0];
+} __packed;
+
 struct wl1271 {
 	struct ieee80211_hw *hw;
 	bool mac80211_registered;
-- 
1.7.6.401.g6a319

