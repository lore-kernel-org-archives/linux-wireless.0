Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58375 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab2A3Ozc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 09:55:32 -0500
Received: by mail-ww0-f44.google.com with SMTP id ed3so4720629wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 06:55:32 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/7] wl12xx: Add rx data filter commands
Date: Mon, 30 Jan 2012 16:58:43 +0200
Message-Id: <1327935525-24361-6-git-send-email-eliad@wizery.com> (sfid-20120130_155539_964106_D06719BE)
In-Reply-To: <1327935525-24361-1-git-send-email-eliad@wizery.com>
References: <1327935525-24361-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

Add acx command, structs and definitions needed for the rx data
filter commands.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c    |   90 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/acx.h    |   42 ++++++++++++++++
 drivers/net/wireless/wl12xx/wl12xx.h |   15 ++++++
 3 files changed, 147 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index bc96db0..05bd79c 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1740,3 +1740,93 @@ out:
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
+int wl1271_acx_set_rx_data_filter(struct wl1271 *wl, bool add, u8 index,
+				  u8 action, u8 *pattern, u8 length, u16 offset)
+{
+	struct acx_rx_data_filter_cfg *acx;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx set rx data filter add: %d idx: %d "
+		     "act: %d pat_len: %d offset: %d", add, index, action,
+		     length, offset);
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (index >= WL1271_MAX_RX_DATA_FILTERS ||
+	    length > WL1271_RX_DATA_FILTER_MAX_PATTERN_SIZE ||
+	    (add && !pattern)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	acx->add_filter = add ? 1 : 0;
+	acx->index = index;
+	acx->num_fields = 1;
+	acx->action = action;
+
+	if (add) {
+		/* pattern description */
+		acx->length = length;
+		memcpy(acx->pattern, pattern, length);
+
+		if (offset + length <= WL1271_RX_DATA_FILTER_ETH_HEADER_SIZE) {
+			acx->flag = WL1271_RX_DATA_FILTER_FLAG_ETHERNET_HEADER;
+			acx->offset = cpu_to_le16(offset);
+		} else if (offset >= WL1271_RX_DATA_FILTER_ETH_HEADER_SIZE) {
+			acx->flag = WL1271_RX_DATA_FILTER_FLAG_IP_HEADER;
+			acx->offset = cpu_to_le16(offset -
+				      WL1271_RX_DATA_FILTER_ETH_HEADER_SIZE);
+		} else {
+			wl1271_error("header boundry crossing filters not "
+				     "supported currently");
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	ret = wl1271_cmd_configure(wl, ACX_SET_RX_DATA_FILTER, acx,
+				   sizeof(*acx));
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
index a28fc04..d68cfd2 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1152,6 +1152,43 @@ struct wl12xx_acx_config_hangover {
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
+	u8 add_filter;
+
+	/* range 0 - MAX_DATA_FILTERS */
+	u8 index;
+
+	/* action of type FILTER_XXX */
+	u8 action;
+
+	/* number of fields in this filter */
+	u8 num_fields;
+
+	/*
+	 * currently we only support a single filtering field in the driver, so
+	 * spell it out directly here
+	 */
+
+	/* The offset is taken from the start of the first MAC addr */
+	__le16 offset;
+	u8 length;
+	u8 flag;
+	u8 pattern[WL1271_RX_DATA_FILTER_MAX_PATTERN_SIZE];
+} __packed;
+
 enum {
 	ACX_WAKE_UP_CONDITIONS           = 0x0000,
 	ACX_MEM_CFG                      = 0x0001,
@@ -1310,5 +1347,10 @@ int wl1271_acx_set_inconnection_sta(struct wl1271 *wl, u8 *addr);
 int wl1271_acx_fm_coex(struct wl1271 *wl);
 int wl12xx_acx_set_rate_mgmt_params(struct wl1271 *wl);
 int wl12xx_acx_config_hangover(struct wl1271 *wl);
+int wl1271_acx_toggle_rx_data_filter(struct wl1271 *wl, bool enable,
+				     u8 default_action);
+int wl1271_acx_set_rx_data_filter(struct wl1271 *wl, bool add, u8 index,
+				  u8 action, u8 *pattern, u8 length,
+				  u16 offset);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 1463341..d29de3f 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -277,6 +277,21 @@ struct wl1271_link {
 	u8 ba_bitmap;
 };
 
+#define WL1271_MAX_RX_DATA_FILTERS 4
+#define WL1271_MAX_RX_DATA_FILTER_SIZE 98
+#define WL1271_RX_DATA_FILTER_MAX_FIELD_PATTERNS 8
+#define WL1271_RX_DATA_FILTER_MAX_PATTERN_SIZE 64
+#define WL1271_RX_DATA_FILTER_ETH_HEADER_SIZE 14
+
+#define WL1271_RX_DATA_FILTER_FLAG_IP_HEADER           0
+#define WL1271_RX_DATA_FILTER_FLAG_ETHERNET_HEADER     2
+
+enum rx_data_filter_action {
+	FILTER_DROP = 0,
+	FILTER_SIGNAL = 1,
+	FILTER_FW_HANDLE = 2
+};
+
 struct wl1271 {
 	struct ieee80211_hw *hw;
 	bool mac80211_registered;
-- 
1.7.6.401.g6a319

