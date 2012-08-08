Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:43093 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757968Ab2HHMCe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 08:02:34 -0400
Received: by obbwc20 with SMTP id wc20so1529317obb.17
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 05:02:33 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <hostap@lists.shmoo.com>
Cc: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <johannes@sipsolutions.net>,
	<coelho@ti.com>, <assaf@ti.com>, <yoni.divinsky@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v3 6/7] nl80211: add channel switch command/event
Date: Wed,  8 Aug 2012 14:55:37 +0300
Message-Id: <1344426938-1883-7-git-send-email-victorg@ti.com> (sfid-20120808_140237_245036_DB2C117A)
In-Reply-To: <1344426938-1883-1-git-send-email-victorg@ti.com>
References: <1344426938-1883-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement AP channel switch command and handle
channel switch complete event.

Signed-hostap: Boris Presman <boris.presman@ti.com>
Signed-hostap: Victor Goldenshtein <victorg@ti.com>
---
 src/drivers/driver_nl80211.c |   65 +++++++++++++++++++++++++++++++++++++++--
 1 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index fadd4cb..c2780a4 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -1197,7 +1197,8 @@ static void mlme_event_disconnect(struct wpa_driver_nl80211_data *drv,
 
 
 static void mlme_event_ch_switch(struct wpa_driver_nl80211_data *drv,
-				 struct nlattr *freq, struct nlattr *type)
+				 struct nlattr *freq, struct nlattr *type,
+				 enum wpa_event_type event)
 {
 	union wpa_event_data data;
 	int ht_enabled = 1;
@@ -1226,7 +1227,7 @@ static void mlme_event_ch_switch(struct wpa_driver_nl80211_data *drv,
 	data.ch_switch.ht_enabled = ht_enabled;
 	data.ch_switch.ch_offset = chan_offset;
 
-	wpa_supplicant_event(drv->ctx, EVENT_CH_SWITCH, &data);
+	wpa_supplicant_event(drv->ctx, event, &data);
 }
 
 
@@ -2151,8 +2152,18 @@ static void do_process_drv_event(struct wpa_driver_nl80211_data *drv,
 				   tb[NL80211_ATTR_RESP_IE]);
 		break;
 	case NL80211_CMD_CH_SWITCH_NOTIFY:
-		mlme_event_ch_switch(drv, tb[NL80211_ATTR_WIPHY_FREQ],
-				     tb[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
+	    /*
+	     * TODO: as soon as GO will support DFS, AP
+	     * and GO channel switches should be united.
+	     */
+	    if (drv->nlmode == NL80211_IFTYPE_AP)
+		    mlme_event_ch_switch(drv, tb[NL80211_ATTR_WIPHY_FREQ],
+					 tb[NL80211_ATTR_WIPHY_CHANNEL_TYPE],
+					 EVENT_AP_CH_SWITCH_COMPLETE);
+	    else
+		    mlme_event_ch_switch(drv, tb[NL80211_ATTR_WIPHY_FREQ],
+					 tb[NL80211_ATTR_WIPHY_CHANNEL_TYPE],
+					 EVENT_CH_SWITCH);
 		break;
 	case NL80211_CMD_DISCONNECT:
 		mlme_event_disconnect(drv, tb[NL80211_ATTR_REASON_CODE],
@@ -8876,6 +8887,51 @@ nla_put_failure:
 }
 
 
+static int nl80211_ap_channel_switch(void *priv,
+				     struct hostapd_channel_switch *params)
+{
+	struct i802_bss *bss = priv;
+	struct wpa_driver_nl80211_data *drv = bss->drv;
+	struct nl_msg *msg;
+	int ret;
+
+	wpa_printf(MSG_DEBUG, "nl80211: Channel switch, "
+		   "ch_switch_count = %d, tx_block = %d, "
+		   "freq = %d, post_switch_block_tx = %d.",
+		   params->ch_switch_count, params->tx_block,
+		   params->freq, params->post_switch_block_tx);
+
+	msg = nlmsg_alloc();
+	if (!msg)
+		return -1;
+
+	nl80211_cmd(bss->drv, msg, 0, NL80211_CMD_AP_CH_SWITCH);
+
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, drv->ifindex);
+	NLA_PUT_U32(msg, NL80211_ATTR_CH_SWITCH_COUNT, params->ch_switch_count);
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, params->freq);
+
+	/* only HT20 is supported at this point */
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE, NL80211_CHAN_HT20);
+
+	if (params->tx_block)
+		NLA_PUT_FLAG(msg, NL80211_ATTR_CH_SWITCH_BLOCK_TX);
+
+	if (params->post_switch_block_tx)
+		NLA_PUT_FLAG(msg, NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX);
+
+	ret = send_and_recv_msgs(drv, msg, NULL, NULL);
+	if (ret == 0) {
+		bss->freq = params->freq;
+		return 0;
+	}
+	wpa_printf(MSG_DEBUG, "nl80211: Failed to channel switch: "
+		   "%d (%s)", ret, strerror(-ret));
+nla_put_failure:
+	return -1;
+}
+
+
 #ifdef CONFIG_TDLS
 
 static int nl80211_send_tdls_mgmt(void *priv, const u8 *dst, u8 action_code,
@@ -9171,6 +9227,7 @@ const struct wpa_driver_ops wpa_driver_nl80211_ops = {
 	.poll_client = nl80211_poll_client,
 	.set_p2p_powersave = nl80211_set_p2p_powersave,
 	.enable_tx = nl80211_enable_dfs_tx,
+	.hapd_channel_switch = nl80211_ap_channel_switch,
 #ifdef CONFIG_TDLS
 	.send_tdls_mgmt = nl80211_send_tdls_mgmt,
 	.tdls_oper = nl80211_tdls_oper,
-- 
1.7.5.4

