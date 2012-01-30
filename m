Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47536 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab2A3L5i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 06:57:38 -0500
Received: by mail-wi0-f174.google.com with SMTP id s10so3321396wic.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 03:57:37 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 01/12] wl12xx: fw api change - add role_id to set_template
Date: Mon, 30 Jan 2012 14:00:46 +0200
Message-Id: <1327924857-1250-2-git-send-email-eliad@wizery.com> (sfid-20120130_125744_855498_E65D81C8)
In-Reply-To: <1327924857-1250-1-git-send-email-eliad@wizery.com>
References: <1327924857-1250-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The set_template commands now takes the role_id as
parameter.

Usually, we'll use the vif's main role_id.
However, sometimes we'll want to use
wlvif->dev_role_id instead of wlvif->role_id,
so pass the wanted role_id as param.

Update WL127X_FW_NAME/WL128X_FW_NAME.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c    |   37 ++++++++++++++++++----------
 drivers/net/wireless/wl12xx/cmd.h    |   18 +++++++++----
 drivers/net/wireless/wl12xx/init.c   |   45 ++++++++++++++++++++++-----------
 drivers/net/wireless/wl12xx/main.c   |   11 ++++----
 drivers/net/wireless/wl12xx/scan.c   |   28 +++++++++++++--------
 drivers/net/wireless/wl12xx/wl12xx.h |    4 +-
 6 files changed, 91 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 25990bd..28e0a56 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1022,8 +1022,9 @@ out:
 	return ret;
 }
 
-int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
-			    void *buf, size_t buf_len, int index, u32 rates)
+int wl1271_cmd_template_set(struct wl1271 *wl, u8 role_id,
+			    u16 template_id, void *buf, size_t buf_len,
+			    int index, u32 rates)
 {
 	struct wl1271_cmd_template_set *cmd;
 	int ret = 0;
@@ -1039,6 +1040,8 @@ int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
 		goto out;
 	}
 
+	/* during initialization wlvif is NULL */
+	cmd->role_id = role_id;
 	cmd->len = cpu_to_le16(buf_len);
 	cmd->template_type = template_id;
 	cmd->enabled_rates = cpu_to_le32(rates);
@@ -1082,7 +1085,8 @@ int wl12xx_cmd_build_null_data(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		ptr = skb->data;
 	}
 
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, ptr, size, 0,
+	ret = wl1271_cmd_template_set(wl, wlvif->role_id,
+				      CMD_TEMPL_NULL_DATA, ptr, size, 0,
 				      wlvif->basic_rate);
 
 out:
@@ -1105,7 +1109,7 @@ int wl12xx_cmd_build_klv_null_data(struct wl1271 *wl,
 	if (!skb)
 		goto out;
 
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_KLV,
+	ret = wl1271_cmd_template_set(wl, wlvif->role_id, CMD_TEMPL_KLV,
 				      skb->data, skb->len,
 				      CMD_TEMPL_KLV_IDX_NULL_DATA,
 				      wlvif->basic_rate);
@@ -1130,7 +1134,8 @@ int wl1271_cmd_build_ps_poll(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	if (!skb)
 		goto out;
 
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_PS_POLL, skb->data,
+	ret = wl1271_cmd_template_set(wl, wlvif->role_id,
+				      CMD_TEMPL_PS_POLL, skb->data,
 				      skb->len, 0, wlvif->basic_rate_set);
 
 out:
@@ -1138,9 +1143,10 @@ out:
 	return ret;
 }
 
-int wl1271_cmd_build_probe_req(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+int wl12xx_cmd_build_probe_req(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			       u8 role_id, u8 band,
 			       const u8 *ssid, size_t ssid_len,
-			       const u8 *ie, size_t ie_len, u8 band)
+			       const u8 *ie, size_t ie_len)
 {
 	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 	struct sk_buff *skb;
@@ -1158,10 +1164,12 @@ int wl1271_cmd_build_probe_req(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 	rate = wl1271_tx_min_rate_get(wl, wlvif->bitrate_masks[band]);
 	if (band == IEEE80211_BAND_2GHZ)
-		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4,
+		ret = wl1271_cmd_template_set(wl, role_id,
+					      CMD_TEMPL_CFG_PROBE_REQ_2_4,
 					      skb->data, skb->len, 0, rate);
 	else
-		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_5,
+		ret = wl1271_cmd_template_set(wl, role_id,
+					      CMD_TEMPL_CFG_PROBE_REQ_5,
 					      skb->data, skb->len, 0, rate);
 
 out:
@@ -1186,10 +1194,12 @@ struct sk_buff *wl1271_cmd_build_ap_probe_req(struct wl1271 *wl,
 
 	rate = wl1271_tx_min_rate_get(wl, wlvif->bitrate_masks[wlvif->band]);
 	if (wlvif->band == IEEE80211_BAND_2GHZ)
-		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4,
+		ret = wl1271_cmd_template_set(wl, wlvif->role_id,
+					      CMD_TEMPL_CFG_PROBE_REQ_2_4,
 					      skb->data, skb->len, 0, rate);
 	else
-		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_5,
+		ret = wl1271_cmd_template_set(wl, wlvif->role_id,
+					      CMD_TEMPL_CFG_PROBE_REQ_5,
 					      skb->data, skb->len, 0, rate);
 
 	if (ret < 0)
@@ -1235,7 +1245,7 @@ int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	memcpy(tmpl.sender_hw, vif->addr, ETH_ALEN);
 	tmpl.sender_ip = ip_addr;
 
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_ARP_RSP,
+	ret = wl1271_cmd_template_set(wl, wlvif->role_id, CMD_TEMPL_ARP_RSP,
 				      &tmpl, sizeof(tmpl), 0,
 				      wlvif->basic_rate);
 
@@ -1260,7 +1270,8 @@ int wl1271_build_qos_null_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 	/* FIXME: not sure what priority to use here */
 	template.qos_ctrl = cpu_to_le16(0);
 
-	return wl1271_cmd_template_set(wl, CMD_TEMPL_QOS_NULL_DATA, &template,
+	return wl1271_cmd_template_set(wl, wlvif->role_id,
+				       CMD_TEMPL_QOS_NULL_DATA, &template,
 				       sizeof(template), 0,
 				       wlvif->basic_rate);
 }
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index 3f7d0b9..8e8035d 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -54,14 +54,16 @@ int wl1271_cmd_ps_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		       u8 ps_mode);
 int wl1271_cmd_read_memory(struct wl1271 *wl, u32 addr, void *answer,
 			   size_t len);
-int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
-			    void *buf, size_t buf_len, int index, u32 rates);
+int wl1271_cmd_template_set(struct wl1271 *wl, u8 role_id,
+			    u16 template_id, void *buf, size_t buf_len,
+			    int index, u32 rates);
 int wl12xx_cmd_build_null_data(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl1271_cmd_build_ps_poll(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			     u16 aid);
-int wl1271_cmd_build_probe_req(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+int wl12xx_cmd_build_probe_req(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			       u8 role_id, u8 band,
 			       const u8 *ssid, size_t ssid_len,
-			       const u8 *ie, size_t ie_len, u8 band);
+			       const u8 *ie, size_t ie_len);
 struct sk_buff *wl1271_cmd_build_ap_probe_req(struct wl1271 *wl,
 					      struct wl12xx_vif *wlvif,
 					      struct sk_buff *skb);
@@ -191,7 +193,7 @@ enum cmd_templ {
 /* unit ms */
 #define WL1271_COMMAND_TIMEOUT     2000
 #define WL1271_CMD_TEMPL_DFLT_SIZE 252
-#define WL1271_CMD_TEMPL_MAX_SIZE  548
+#define WL1271_CMD_TEMPL_MAX_SIZE  512
 #define WL1271_EVENT_TIMEOUT       750
 
 struct wl1271_cmd_header {
@@ -364,14 +366,18 @@ struct cmd_enabledisable_path {
 struct wl1271_cmd_template_set {
 	struct wl1271_cmd_header header;
 
-	__le16 len;
+	u8 role_id;
 	u8 template_type;
+	__le16 len;
 	u8 index;  /* relevant only for KLV_TEMPLATE type */
+	u8 padding[3];
+
 	__le32 enabled_rates;
 	u8 short_retry_limit;
 	u8 long_retry_limit;
 	u8 aflags;
 	u8 reserved;
+
 	u8 template_data[WL1271_CMD_TEMPL_MAX_SIZE];
 } __packed;
 
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index ca7ee59..fcf2b12 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -39,50 +39,58 @@ int wl1271_init_templates_config(struct wl1271 *wl)
 	int ret, i;
 
 	/* send empty templates for fw memory reservation */
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4, NULL,
+	ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
+				      CMD_TEMPL_CFG_PROBE_REQ_2_4, NULL,
 				      WL1271_CMD_TEMPL_DFLT_SIZE,
 				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_5,
+	ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
+				      CMD_TEMPL_CFG_PROBE_REQ_5,
 				      NULL, WL1271_CMD_TEMPL_DFLT_SIZE, 0,
 				      WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, NULL,
+	ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
+				      CMD_TEMPL_NULL_DATA, NULL,
 				      sizeof(struct wl12xx_null_data_template),
 				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_PS_POLL, NULL,
+	ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
+				      CMD_TEMPL_PS_POLL, NULL,
 				      sizeof(struct wl12xx_ps_poll_template),
 				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_QOS_NULL_DATA, NULL,
+	ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
+				      CMD_TEMPL_QOS_NULL_DATA, NULL,
 				      sizeof
 				      (struct ieee80211_qos_hdr),
 				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_PROBE_RESPONSE, NULL,
+	ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
+				      CMD_TEMPL_PROBE_RESPONSE, NULL,
 				      WL1271_CMD_TEMPL_DFLT_SIZE,
 				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_BEACON, NULL,
+	ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
+				      CMD_TEMPL_BEACON, NULL,
 				      WL1271_CMD_TEMPL_DFLT_SIZE,
 				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_ARP_RSP, NULL,
+	ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
+				      CMD_TEMPL_ARP_RSP, NULL,
 				      sizeof
 				      (struct wl12xx_arp_rsp_template),
 				      0, WL1271_RATE_AUTOMATIC);
@@ -93,19 +101,22 @@ int wl1271_init_templates_config(struct wl1271 *wl)
 	 * Put very large empty placeholders for all templates. These
 	 * reserve memory for later.
 	 */
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_AP_PROBE_RESPONSE, NULL,
+	ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
+				      CMD_TEMPL_AP_PROBE_RESPONSE, NULL,
 				      WL1271_CMD_TEMPL_MAX_SIZE,
 				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_AP_BEACON, NULL,
+	ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
+				      CMD_TEMPL_AP_BEACON, NULL,
 				      WL1271_CMD_TEMPL_MAX_SIZE,
 				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_DEAUTH_AP, NULL,
+	ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
+				      CMD_TEMPL_DEAUTH_AP, NULL,
 				      sizeof
 				      (struct wl12xx_disconn_template),
 				      0, WL1271_RATE_AUTOMATIC);
@@ -113,7 +124,8 @@ int wl1271_init_templates_config(struct wl1271 *wl)
 		return ret;
 
 	for (i = 0; i < CMD_TEMPL_KLV_IDX_MAX; i++) {
-		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_KLV, NULL,
+		ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
+					      CMD_TEMPL_KLV, NULL,
 					      sizeof(struct ieee80211_qos_hdr),
 					      i, WL1271_RATE_AUTOMATIC);
 		if (ret < 0)
@@ -140,7 +152,8 @@ static int wl1271_ap_init_deauth_template(struct wl1271 *wl,
 					     IEEE80211_STYPE_DEAUTH);
 
 	rate = wl1271_tx_min_rate_get(wl, wlvif->basic_rate_set);
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_DEAUTH_AP,
+	ret = wl1271_cmd_template_set(wl, wlvif->role_id,
+				      CMD_TEMPL_DEAUTH_AP,
 				      tmpl, sizeof(*tmpl), 0, rate);
 
 out:
@@ -172,7 +185,8 @@ static int wl1271_ap_init_null_template(struct wl1271 *wl,
 	memcpy(nullfunc->addr3, vif->addr, ETH_ALEN);
 
 	rate = wl1271_tx_min_rate_get(wl, wlvif->basic_rate_set);
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, nullfunc,
+	ret = wl1271_cmd_template_set(wl, wlvif->role_id,
+				      CMD_TEMPL_NULL_DATA, nullfunc,
 				      sizeof(*nullfunc), 0, rate);
 
 out:
@@ -204,7 +218,8 @@ static int wl1271_ap_init_qos_null_template(struct wl1271 *wl,
 	memcpy(qosnull->addr3, vif->addr, ETH_ALEN);
 
 	rate = wl1271_tx_min_rate_get(wl, wlvif->basic_rate_set);
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_QOS_NULL_DATA, qosnull,
+	ret = wl1271_cmd_template_set(wl, wlvif->role_id,
+				      CMD_TEMPL_QOS_NULL_DATA, qosnull,
 				      sizeof(*qosnull), 0, rate);
 
 out:
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 91c03d8..0509816 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3271,6 +3271,7 @@ static void wl12xx_remove_vendor_ie(struct sk_buff *skb,
 static int wl1271_ap_set_probe_resp_tmpl(struct wl1271 *wl, u32 rates,
 					 struct ieee80211_vif *vif)
 {
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct sk_buff *skb;
 	int ret;
 
@@ -3278,7 +3279,7 @@ static int wl1271_ap_set_probe_resp_tmpl(struct wl1271 *wl, u32 rates,
 	if (!skb)
 		return -EOPNOTSUPP;
 
-	ret = wl1271_cmd_template_set(wl,
+	ret = wl1271_cmd_template_set(wl, wlvif->role_id,
 				      CMD_TEMPL_AP_PROBE_RESPONSE,
 				      skb->data,
 				      skb->len, 0,
@@ -3302,7 +3303,7 @@ static int wl1271_ap_set_probe_resp_tmpl_legacy(struct wl1271 *wl,
 
 	/* no need to change probe response if the SSID is set correctly */
 	if (wlvif->ssid_len > 0)
-		return wl1271_cmd_template_set(wl,
+		return wl1271_cmd_template_set(wl, wlvif->role_id,
 					       CMD_TEMPL_AP_PROBE_RESPONSE,
 					       probe_rsp_data,
 					       probe_rsp_len, 0,
@@ -3339,7 +3340,7 @@ static int wl1271_ap_set_probe_resp_tmpl_legacy(struct wl1271 *wl,
 	       ptr, probe_rsp_len - (ptr - probe_rsp_data));
 	templ_len += probe_rsp_len - (ptr - probe_rsp_data);
 
-	return wl1271_cmd_template_set(wl,
+	return wl1271_cmd_template_set(wl, wlvif->role_id,
 				       CMD_TEMPL_AP_PROBE_RESPONSE,
 				       probe_rsp_templ,
 				       templ_len, 0,
@@ -3436,7 +3437,7 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 		min_rate = wl1271_tx_min_rate_get(wl, wlvif->basic_rate_set);
 		tmpl_id = is_ap ? CMD_TEMPL_AP_BEACON :
 				  CMD_TEMPL_BEACON;
-		ret = wl1271_cmd_template_set(wl, tmpl_id,
+		ret = wl1271_cmd_template_set(wl, wlvif->role_id, tmpl_id,
 					      beacon->data,
 					      beacon->len, 0,
 					      min_rate);
@@ -3475,7 +3476,7 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 						beacon->len,
 						min_rate);
 		else
-			ret = wl1271_cmd_template_set(wl,
+			ret = wl1271_cmd_template_set(wl, wlvif->role_id,
 						CMD_TEMPL_PROBE_RESPONSE,
 						beacon->data,
 						beacon->len, 0,
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index e24111e..416ae91 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -217,9 +217,11 @@ static int wl1271_scan_send(struct wl1271 *wl, struct ieee80211_vif *vif,
 
 	memcpy(cmd->addr, vif->addr, ETH_ALEN);
 
-	ret = wl1271_cmd_build_probe_req(wl, wlvif, wl->scan.ssid,
-					 wl->scan.ssid_len, wl->scan.req->ie,
-					 wl->scan.req->ie_len, band);
+	ret = wl12xx_cmd_build_probe_req(wl, wlvif,
+					 wlvif->role_id, band,
+					 wl->scan.ssid, wl->scan.ssid_len,
+					 wl->scan.req->ie,
+					 wl->scan.req->ie_len);
 	if (ret < 0) {
 		wl1271_error("PROBE request template failed");
 		goto out;
@@ -658,11 +660,13 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 	}
 
 	if (!force_passive && cfg->active[0]) {
-		ret = wl1271_cmd_build_probe_req(wl, wlvif, req->ssids[0].ssid,
+		u8 band = IEEE80211_BAND_2GHZ;
+		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
+						 wlvif->role_id, band,
+						 req->ssids[0].ssid,
 						 req->ssids[0].ssid_len,
-						 ies->ie[IEEE80211_BAND_2GHZ],
-						 ies->len[IEEE80211_BAND_2GHZ],
-						 IEEE80211_BAND_2GHZ);
+						 ies->ie[band],
+						 ies->len[band]);
 		if (ret < 0) {
 			wl1271_error("2.4GHz PROBE request template failed");
 			goto out;
@@ -670,11 +674,13 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 	}
 
 	if (!force_passive && cfg->active[1]) {
-		ret = wl1271_cmd_build_probe_req(wl, wlvif, req->ssids[0].ssid,
+		u8 band = IEEE80211_BAND_5GHZ;
+		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
+						 wlvif->role_id, band,
+						 req->ssids[0].ssid,
 						 req->ssids[0].ssid_len,
-						 ies->ie[IEEE80211_BAND_5GHZ],
-						 ies->len[IEEE80211_BAND_5GHZ],
-						 IEEE80211_BAND_5GHZ);
+						 ies->ie[band],
+						 ies->len[band]);
 		if (ret < 0) {
 			wl1271_error("5GHz PROBE request template failed");
 			goto out;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index b2b09cd..6e025ca 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -35,8 +35,8 @@
 #include "conf.h"
 #include "ini.h"
 
-#define WL127X_FW_NAME "ti-connectivity/wl127x-fw-3.bin"
-#define WL128X_FW_NAME "ti-connectivity/wl128x-fw-3.bin"
+#define WL127X_FW_NAME "ti-connectivity/wl127x-fw-4-sr.bin"
+#define WL128X_FW_NAME "ti-connectivity/wl128x-fw-4-sr.bin"
 
 /*
  * wl127x and wl128x are using the same NVS file name. However, the
-- 
1.7.6.401.g6a319

