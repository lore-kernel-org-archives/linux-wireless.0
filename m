Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:25277 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab0DAIjA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 04:39:00 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/8] wl1271: Configure rates for templates
Date: Thu,  1 Apr 2010 11:38:21 +0300
Message-Id: <1270111104-29549-6-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1270111104-29549-1-git-send-email-luciano.coelho@nokia.com>
References: <1270111104-29549-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Configure meaningful rates to be used with the templates. For control frames,
use the determined basic rates (currently the lowest rate for the band) and
for data-frames (null-funcs) let the firmware use the current rate policy to
determine the rate.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |   21 +++++++++++++--------
 drivers/net/wireless/wl12xx/wl1271_cmd.h  |    4 +++-
 drivers/net/wireless/wl12xx/wl1271_init.c |   18 ++++++++++--------
 drivers/net/wireless/wl12xx/wl1271_main.c |    6 ++++--
 4 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 5cee59f..b190903 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -700,7 +700,7 @@ out:
 }
 
 int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
-			    void *buf, size_t buf_len, int index)
+			    void *buf, size_t buf_len, int index, u32 rates)
 {
 	struct wl1271_cmd_template_set *cmd;
 	int ret = 0;
@@ -718,7 +718,7 @@ int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
 
 	cmd->len = cpu_to_le16(buf_len);
 	cmd->template_type = template_id;
-	cmd->enabled_rates = cpu_to_le32(wl->conf.tx.rc_conf.enabled_rates);
+	cmd->enabled_rates = cpu_to_le32(rates);
 	cmd->short_retry_limit = wl->conf.tx.rc_conf.short_retry_limit;
 	cmd->long_retry_limit = wl->conf.tx.rc_conf.long_retry_limit;
 	cmd->index = index;
@@ -758,7 +758,8 @@ int wl1271_cmd_build_null_data(struct wl1271 *wl)
 		ptr = skb->data;
 	}
 
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, ptr, size, 0);
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, ptr, size, 0,
+				      WL1271_RATE_AUTOMATIC);
 
 out:
 	dev_kfree_skb(skb);
@@ -780,7 +781,8 @@ int wl1271_cmd_build_klv_null_data(struct wl1271 *wl)
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_KLV,
 				      skb->data, skb->len,
-				      CMD_TEMPL_KLV_IDX_NULL_DATA);
+				      CMD_TEMPL_KLV_IDX_NULL_DATA,
+				      WL1271_RATE_AUTOMATIC);
 
 out:
 	dev_kfree_skb(skb);
@@ -801,7 +803,7 @@ int wl1271_cmd_build_ps_poll(struct wl1271 *wl, u16 aid)
 		goto out;
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_PS_POLL, skb->data,
-				      skb->len, 0);
+				      skb->len, 0, wl->basic_rate);
 
 out:
 	dev_kfree_skb(skb);
@@ -826,10 +828,12 @@ int wl1271_cmd_build_probe_req(struct wl1271 *wl,
 
 	if (band == IEEE80211_BAND_2GHZ)
 		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4,
-					      skb->data, skb->len, 0);
+					      skb->data, skb->len, 0,
+					      wl->conf.tx.basic_rate);
 	else
 		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_5,
-					      skb->data, skb->len, 0);
+					      skb->data, skb->len, 0,
+					      wl->conf.tx.basic_rate_5);
 
 out:
 	dev_kfree_skb(skb);
@@ -854,7 +858,8 @@ int wl1271_build_qos_null_data(struct wl1271 *wl)
 	template.qos_ctrl = cpu_to_le16(0);
 
 	return wl1271_cmd_template_set(wl, CMD_TEMPL_QOS_NULL_DATA, &template,
-				       sizeof(template), 0);
+				       sizeof(template), 0,
+				       WL1271_RATE_AUTOMATIC);
 }
 
 int wl1271_cmd_set_default_wep_key(struct wl1271 *wl, u8 id)
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index d61f339..00f78b7 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -45,7 +45,7 @@ int wl1271_cmd_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
 		    const u8 *ie, size_t ie_len, u8 active_scan,
 		    u8 high_prio, u8 band, u8 probe_requests);
 int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
-			    void *buf, size_t buf_len, int index);
+			    void *buf, size_t buf_len, int index, u32 rates);
 int wl1271_cmd_build_null_data(struct wl1271 *wl);
 int wl1271_cmd_build_ps_poll(struct wl1271 *wl, u16 aid);
 int wl1271_cmd_build_probe_req(struct wl1271 *wl,
@@ -252,6 +252,8 @@ struct cmd_enabledisable_path {
 	u8 padding[3];
 } __attribute__ ((packed));
 
+#define WL1271_RATE_AUTOMATIC  0
+
 struct wl1271_cmd_template_set {
 	struct wl1271_cmd_header header;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 8ec94ac..9ab3368 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -56,54 +56,56 @@ int wl1271_init_templates_config(struct wl1271 *wl)
 	/* send empty templates for fw memory reservation */
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4, NULL,
 				      sizeof(struct wl12xx_probe_req_template),
-				      0);
+				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
 	if (wl1271_11a_enabled()) {
 		size_t size = sizeof(struct wl12xx_probe_req_template);
 		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_5,
-					      NULL, size, 0);
+					      NULL, size, 0,
+					      WL1271_RATE_AUTOMATIC);
 		if (ret < 0)
 			return ret;
 	}
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, NULL,
 				      sizeof(struct wl12xx_null_data_template),
-				      0);
+				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_PS_POLL, NULL,
 				      sizeof(struct wl12xx_ps_poll_template),
-				      0);
+				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_QOS_NULL_DATA, NULL,
 				      sizeof
 				      (struct wl12xx_qos_null_data_template),
-				      0);
+				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_PROBE_RESPONSE, NULL,
 				      sizeof
 				      (struct wl12xx_probe_resp_template),
-				      0);
+				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_BEACON, NULL,
 				      sizeof
 				      (struct wl12xx_beacon_template),
-				      0);
+				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
 	for (i = 0; i < CMD_TEMPL_KLV_IDX_MAX; i++) {
 		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_KLV, NULL,
-					      WL1271_CMD_TEMPL_MAX_SIZE, i);
+					      WL1271_CMD_TEMPL_MAX_SIZE, i,
+					      WL1271_RATE_AUTOMATIC);
 		if (ret < 0)
 			return ret;
 	}
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index ca5cd32..247f407 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1642,7 +1642,8 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			wl1271_ssid_set(wl, beacon);
 			ret = wl1271_cmd_template_set(wl, CMD_TEMPL_BEACON,
 						      beacon->data,
-						      beacon->len, 0);
+						      beacon->len, 0,
+						      wl1271_min_rate_get(wl));
 
 			if (ret < 0) {
 				dev_kfree_skb(beacon);
@@ -1657,7 +1658,8 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			ret = wl1271_cmd_template_set(wl,
 						      CMD_TEMPL_PROBE_RESPONSE,
 						      beacon->data,
-						      beacon->len, 0);
+						      beacon->len, 0,
+						      wl1271_min_rate_get(wl));
 			dev_kfree_skb(beacon);
 			if (ret < 0)
 				goto out_sleep;
-- 
1.6.3.3

