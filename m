Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:30742 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab0CZKyd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 06:54:33 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 22/24] wl1271: Add keep-alive frame template support
Date: Fri, 26 Mar 2010 12:53:31 +0200
Message-Id: <1269600813-32145-23-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
References: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Add support for keep-alive templates, which are indexed.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |   35 ++++++++++++++++++++++++-----
 drivers/net/wireless/wl12xx/wl1271_cmd.h  |    8 +++++-
 drivers/net/wireless/wl12xx/wl1271_init.c |   31 ++++++++++++++++++-------
 drivers/net/wireless/wl12xx/wl1271_main.c |    4 +-
 4 files changed, 60 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 0dcb3c2..0cb4cbb 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -698,7 +698,7 @@ out:
 }
 
 int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
-			    void *buf, size_t buf_len)
+			    void *buf, size_t buf_len, int index)
 {
 	struct wl1271_cmd_template_set *cmd;
 	int ret = 0;
@@ -719,6 +719,7 @@ int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
 	cmd->enabled_rates = cpu_to_le32(wl->conf.tx.rc_conf.enabled_rates);
 	cmd->short_retry_limit = wl->conf.tx.rc_conf.short_retry_limit;
 	cmd->long_retry_limit = wl->conf.tx.rc_conf.long_retry_limit;
+	cmd->index = index;
 
 	if (buf)
 		memcpy(cmd->template_data, buf, buf_len);
@@ -755,7 +756,7 @@ int wl1271_cmd_build_null_data(struct wl1271 *wl)
 		ptr = skb->data;
 	}
 
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, ptr, size);
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, ptr, size, 0);
 
 out:
 	dev_kfree_skb(skb);
@@ -766,6 +767,28 @@ out:
 
 }
 
+int wl1271_cmd_build_klv_null_data(struct wl1271 *wl)
+{
+	struct sk_buff *skb = NULL;
+	int ret = -ENOMEM;
+
+	skb = ieee80211_nullfunc_get(wl->hw, wl->vif);
+	if (!skb)
+		goto out;
+
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_KLV,
+				      skb->data, skb->len,
+				      CMD_TEMPL_KLV_IDX_NULL_DATA);
+
+out:
+	dev_kfree_skb(skb);
+	if (ret)
+		wl1271_warning("cmd build klv null data failed %d", ret);
+
+	return ret;
+
+}
+
 int wl1271_cmd_build_ps_poll(struct wl1271 *wl, u16 aid)
 {
 	struct sk_buff *skb;
@@ -776,7 +799,7 @@ int wl1271_cmd_build_ps_poll(struct wl1271 *wl, u16 aid)
 		goto out;
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_PS_POLL, skb->data,
-				      skb->len);
+				      skb->len, 0);
 
 out:
 	dev_kfree_skb(skb);
@@ -801,10 +824,10 @@ int wl1271_cmd_build_probe_req(struct wl1271 *wl,
 
 	if (band == IEEE80211_BAND_2GHZ)
 		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4,
-					      skb->data, skb->len);
+					      skb->data, skb->len, 0);
 	else
 		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_5,
-					      skb->data, skb->len);
+					      skb->data, skb->len, 0);
 
 out:
 	dev_kfree_skb(skb);
@@ -829,7 +852,7 @@ int wl1271_build_qos_null_data(struct wl1271 *wl)
 	template.qos_ctrl = cpu_to_le16(0);
 
 	return wl1271_cmd_template_set(wl, CMD_TEMPL_QOS_NULL_DATA, &template,
-				       sizeof(template));
+				       sizeof(template), 0);
 }
 
 int wl1271_cmd_set_default_wep_key(struct wl1271 *wl, u8 id)
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index bdd7a3d..e1131bc 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -45,13 +45,14 @@ int wl1271_cmd_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
 		    const u8 *ie, size_t ie_len, u8 active_scan,
 		    u8 high_prio, u8 band, u8 probe_requests);
 int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
-			    void *buf, size_t buf_len);
+			    void *buf, size_t buf_len, int index);
 int wl1271_cmd_build_null_data(struct wl1271 *wl);
 int wl1271_cmd_build_ps_poll(struct wl1271 *wl, u16 aid);
 int wl1271_cmd_build_probe_req(struct wl1271 *wl,
 			       const u8 *ssid, size_t ssid_len,
 			       const u8 *ie, size_t ie_len, u8 band);
 int wl1271_build_qos_null_data(struct wl1271 *wl);
+int wl1271_cmd_build_klv_null_data(struct wl1271 *wl);
 int wl1271_cmd_set_default_wep_key(struct wl1271 *wl, u8 id);
 int wl1271_cmd_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 		       u8 key_size, const u8 *key, const u8 *addr,
@@ -101,6 +102,11 @@ enum wl1271_commands {
 
 #define MAX_CMD_PARAMS 572
 
+enum {
+	CMD_TEMPL_KLV_IDX_NULL_DATA = 0,
+	CMD_TEMPL_KLV_IDX_MAX = 4
+};
+
 enum cmd_templ {
 	CMD_TEMPL_NULL_DATA = 0,
 	CMD_TEMPL_BEACON,
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 987978c..0106663 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -51,50 +51,63 @@ static int wl1271_init_hwenc_config(struct wl1271 *wl)
 
 int wl1271_init_templates_config(struct wl1271 *wl)
 {
-	int ret;
+	int ret, i;
 
 	/* send empty templates for fw memory reservation */
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4, NULL,
-				      sizeof(struct wl12xx_probe_req_template));
+				      sizeof(struct wl12xx_probe_req_template),
+				      0);
 	if (ret < 0)
 		return ret;
 
 	if (wl1271_11a_enabled()) {
+		size_t size = sizeof(struct wl12xx_probe_req_template);
 		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_5,
-				NULL,
-				sizeof(struct wl12xx_probe_req_template));
+					      NULL, size, 0);
 		if (ret < 0)
 			return ret;
 	}
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, NULL,
-				      sizeof(struct wl12xx_null_data_template));
+				      sizeof(struct wl12xx_null_data_template),
+				      0);
 	if (ret < 0)
 		return ret;
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_PS_POLL, NULL,
-				      sizeof(struct wl12xx_ps_poll_template));
+				      sizeof(struct wl12xx_ps_poll_template),
+				      0);
 	if (ret < 0)
 		return ret;
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_QOS_NULL_DATA, NULL,
 				      sizeof
-				      (struct wl12xx_qos_null_data_template));
+				      (struct wl12xx_qos_null_data_template),
+				      0);
 	if (ret < 0)
 		return ret;
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_PROBE_RESPONSE, NULL,
 				      sizeof
-				      (struct wl12xx_probe_resp_template));
+				      (struct wl12xx_probe_resp_template),
+				      0);
 	if (ret < 0)
 		return ret;
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_BEACON, NULL,
 				      sizeof
-				      (struct wl12xx_beacon_template));
+				      (struct wl12xx_beacon_template),
+				      0);
 	if (ret < 0)
 		return ret;
 
+	for (i = 0; i < CMD_TEMPL_KLV_IDX_MAX; i++) {
+		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_KLV, NULL,
+					      WL1271_CMD_TEMPL_MAX_SIZE, i);
+		if (ret < 0)
+			return ret;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 2df00ad..afab52b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1596,7 +1596,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			wl1271_ssid_set(wl, beacon);
 			ret = wl1271_cmd_template_set(wl, CMD_TEMPL_BEACON,
 						      beacon->data,
-						      beacon->len);
+						      beacon->len, 0);
 
 			if (ret < 0) {
 				dev_kfree_skb(beacon);
@@ -1611,7 +1611,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			ret = wl1271_cmd_template_set(wl,
 						      CMD_TEMPL_PROBE_RESPONSE,
 						      beacon->data,
-						      beacon->len);
+						      beacon->len, 0);
 			dev_kfree_skb(beacon);
 			if (ret < 0)
 				goto out_sleep;
-- 
1.6.3.3

