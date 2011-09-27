Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:47554 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab1I0Lb1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 07:31:27 -0400
Subject: [PATCH 4/4] ath6kl: improve wmi debug messages
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Sep 2011 14:31:21 +0300
Message-ID: <20110927113121.11592.32688.stgit@localhost6.localdomain6> (sfid-20110927_133130_570482_C7E36E65)
In-Reply-To: <20110927113045.11592.15974.stgit@localhost6.localdomain6>
References: <20110927113045.11592.15974.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new debug level ATH6KL_DBG_WMI_DUMP and other minor
improvements to the wmi debug messages.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.h |    3 +-
 drivers/net/wireless/ath/ath6kl/wmi.c   |   44 +++++++++++++++++++++++++------
 2 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index 6288e4c..48339da 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -34,11 +34,12 @@ enum ATH6K_DEBUG_MASK {
 	ATH6KL_DBG_TRC	        = BIT(11),    /* generic func tracing */
 	ATH6KL_DBG_SCATTER	= BIT(12),    /* hif scatter tracing */
 	ATH6KL_DBG_WLAN_CFG     = BIT(13),    /* cfg80211 i/f file tracing */
-	ATH6KL_DBG_RAW_BYTES    = BIT(14),    /* dump tx/rx and wmi frames */
+	ATH6KL_DBG_RAW_BYTES    = BIT(14),    /* dump tx/rx frames */
 	ATH6KL_DBG_AGGR		= BIT(15),    /* aggregation */
 	ATH6KL_DBG_SDIO		= BIT(16),
 	ATH6KL_DBG_SDIO_DUMP	= BIT(17),
 	ATH6KL_DBG_BOOT		= BIT(18),    /* driver init and fw boot */
+	ATH6KL_DBG_WMI_DUMP	= BIT(19),
 	ATH6KL_DBG_ANY	        = 0xffffffff  /* enable all logs */
 };
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 785a8c7..a7de23c 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -721,8 +721,12 @@ static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len)
 
 	/* STA/IBSS mode connection event */
 
-	ath6kl_dbg(ATH6KL_DBG_WMI, "%s: freq %d bssid %pM\n",
-		   __func__, le16_to_cpu(ev->u.sta.ch), ev->u.sta.bssid);
+	ath6kl_dbg(ATH6KL_DBG_WMI,
+		   "wmi event connect freq %d bssid %pM listen_intvl %d beacon_intvl %d type %d\n",
+		   le16_to_cpu(ev->u.sta.ch), ev->u.sta.bssid,
+		   le16_to_cpu(ev->u.sta.listen_intvl),
+		   le16_to_cpu(ev->u.sta.beacon_intvl),
+		   le32_to_cpu(ev->u.sta.nw_type));
 
 	/* Start of assoc rsp IEs */
 	pie = ev->assoc_info + ev->beacon_ie_len +
@@ -822,7 +826,7 @@ static void ath6kl_wmi_regdomain_event(struct wmi *wmi, u8 *datap, int len)
 
 		regpair = ath6kl_get_regpair((u16) reg_code);
 		country = ath6kl_regd_find_country_by_rd((u16) reg_code);
-		ath6kl_dbg(ATH6KL_DBG_WMI, "ath6kl: Regpair used: 0x%0x\n",
+		ath6kl_dbg(ATH6KL_DBG_WMI, "Regpair used: 0x%0x\n",
 				regpair->regDmnEnum);
 	}
 
@@ -832,7 +836,7 @@ static void ath6kl_wmi_regdomain_event(struct wmi *wmi, u8 *datap, int len)
 
 		regulatory_hint(wmi->parent_dev->wdev->wiphy, alpha2);
 
-		ath6kl_dbg(ATH6KL_DBG_WMI, "ath6kl: Country alpha2 being used: %c%c\n",
+		ath6kl_dbg(ATH6KL_DBG_WMI, "Country alpha2 being used: %c%c\n",
 				alpha2[0], alpha2[1]);
 	}
 }
@@ -847,6 +851,11 @@ static int ath6kl_wmi_disconnect_event_rx(struct wmi *wmi, u8 *datap, int len)
 
 	ev = (struct wmi_disconnect_event *) datap;
 
+	ath6kl_dbg(ATH6KL_DBG_WMI,
+		   "wmi event disconnect proto_reason %d bssid %pM wmi_reason %d assoc_resp_len %d\n",
+		   le16_to_cpu(ev->proto_reason_status), ev->bssid,
+		   ev->disconn_reason, ev->assoc_resp_len);
+
 	wmi->is_wmm_enabled = false;
 	wmi->pair_crypto_type = NONE_CRYPT;
 	wmi->grp_crypto_type = NONE_CRYPT;
@@ -1526,11 +1535,14 @@ int ath6kl_wmi_cmd_send(struct wmi *wmi, struct sk_buff *skb,
 	enum htc_endpoint_id ep_id = wmi->ep_id;
 	int ret;
 
-	ath6kl_dbg(ATH6KL_DBG_WMI, "%s: cmd_id=%d\n", __func__, cmd_id);
-
 	if (WARN_ON(skb == NULL))
 		return -EINVAL;
 
+	ath6kl_dbg(ATH6KL_DBG_WMI, "wmi tx id %d len %d flag %d\n",
+		   cmd_id, skb->len, sync_flag);
+	ath6kl_dbg_dump(ATH6KL_DBG_WMI_DUMP, NULL, "wmi tx ",
+			skb->data, skb->len);
+
 	if (sync_flag >= END_WMIFLAG) {
 		dev_kfree_skb(skb);
 		return -EINVAL;
@@ -1589,6 +1601,13 @@ int ath6kl_wmi_connect_cmd(struct wmi *wmi, enum network_type nw_type,
 	struct wmi_connect_cmd *cc;
 	int ret;
 
+	ath6kl_dbg(ATH6KL_DBG_WMI,
+		   "wmi connect bssid %pM freq %d flags 0x%x ssid_len %d "
+		   "type %d dot11_auth %d auth %d pairwise %d group %d\n",
+		   bssid, channel, ctrl_flags, ssid_len, nw_type,
+		   dot11_auth_mode, auth_mode, pairwise_crypto, group_crypto);
+	ath6kl_dbg_dump(ATH6KL_DBG_WMI, NULL, "ssid ", ssid, ssid_len);
+
 	wmi->traffic_class = 100;
 
 	if ((pairwise_crypto == NONE_CRYPT) && (group_crypto != NONE_CRYPT))
@@ -1634,6 +1653,9 @@ int ath6kl_wmi_reconnect_cmd(struct wmi *wmi, u8 *bssid, u16 channel)
 	struct wmi_reconnect_cmd *cc;
 	int ret;
 
+	ath6kl_dbg(ATH6KL_DBG_WMI, "wmi reconnect bssid %pM freq %d\n",
+		   bssid, channel);
+
 	wmi->traffic_class = 100;
 
 	skb = ath6kl_wmi_get_new_buf(sizeof(struct wmi_reconnect_cmd));
@@ -1656,6 +1678,8 @@ int ath6kl_wmi_disconnect_cmd(struct wmi *wmi)
 {
 	int ret;
 
+	ath6kl_dbg(ATH6KL_DBG_WMI, "wmi disconnect\n");
+
 	wmi->traffic_class = 100;
 
 	/* Disconnect command does not need to do a SYNC before. */
@@ -2808,12 +2832,14 @@ static int ath6kl_wmi_control_rx_xtnd(struct wmi *wmi, struct sk_buff *skb)
 
 	switch (id) {
 	case WMIX_HB_CHALLENGE_RESP_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "wmi event hb challenge resp\n");
 		break;
 	case WMIX_DBGLOG_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "wmi event dbglog len %d\n", len);
 		ath6kl_debug_fwlog_event(wmi->parent_dev, datap, len);
 		break;
 	default:
-		ath6kl_err("unknown cmd id 0x%x\n", id);
+		ath6kl_warn("unknown cmd id 0x%x\n", id);
 		wmi->stat.cmd_id_err++;
 		ret = -EINVAL;
 		break;
@@ -2849,8 +2875,8 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 	datap = skb->data;
 	len = skb->len;
 
-	ath6kl_dbg(ATH6KL_DBG_WMI, "%s: wmi id: %d\n", __func__, id);
-	ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "msg payload ", "wmi rx ",
+	ath6kl_dbg(ATH6KL_DBG_WMI, "wmi rx id %d len %d\n", id, len);
+	ath6kl_dbg_dump(ATH6KL_DBG_WMI_DUMP, NULL, "wmi rx ",
 			datap, len);
 
 	switch (id) {

