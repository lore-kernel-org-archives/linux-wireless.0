Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:49955 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464Ab2FROxZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 10:53:25 -0400
Received: by obbwc20 with SMTP id wc20so8495670obb.31
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 07:53:23 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <hostap@lists.shmoo.com>
Cc: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <johannes@sipsolutions.net>,
	<coelho@ti.com>, <assaf@ti.com>, <yoni.divinsky@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH 6/7] nl80211: add channel switch command/event
Date: Mon, 18 Jun 2012 17:49:45 +0300
Message-Id: <1340030986-29118-7-git-send-email-victorg@ti.com> (sfid-20120618_165332_826606_5FF02659)
In-Reply-To: <1340030986-29118-1-git-send-email-victorg@ti.com>
References: <1340030986-29118-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement AP channel switch command and handle
channel switch complete event.

Signed-hostap: Boris Presman <boris.presman@ti.com>
Signed-hostap: Victor Goldenshtein <victorg@ti.com>
---
 src/drivers/driver_nl80211.c |   54 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index fe6e4d2..7e8b800 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -2054,6 +2054,8 @@ static void nl80211_spurious_frame(struct i802_bss *bss, struct nlattr **tb,
 static void do_process_drv_event(struct wpa_driver_nl80211_data *drv,
 				 int cmd, struct nlattr **tb)
 {
+	union wpa_event_data data;
+
 	if (drv->ap_scan_as_station != NL80211_IFTYPE_UNSPECIFIED &&
 	    (cmd == NL80211_CMD_NEW_SCAN_RESULTS ||
 	     cmd == NL80211_CMD_SCAN_ABORTED)) {
@@ -2161,6 +2163,17 @@ static void do_process_drv_event(struct wpa_driver_nl80211_data *drv,
 	case NL80211_CMD_PROBE_CLIENT:
 		nl80211_client_probe_event(drv, tb);
 		break;
+	case NL80211_CMD_AP_CHANNEL_SWITCH:
+		os_memset(&data, 0, sizeof(data));
+		if (tb[NL80211_ATTR_WIPHY_FREQ]) {
+			data.channel_switch_complete.freq =
+				    nla_get_u16(tb[NL80211_ATTR_WIPHY_FREQ]);
+		}
+		data.channel_switch_complete.status = TRUE;
+		wpa_printf(MSG_DEBUG, "nl80211: Channel switch complete event");
+		wpa_supplicant_event(drv->ctx, EVENT_CHANNEL_SWITCH_COMPLETE,
+				     &data);
+		break;
 	default:
 		wpa_printf(MSG_DEBUG, "nl80211: Ignored unknown event "
 			   "(cmd=%d)", cmd);
@@ -8805,6 +8818,46 @@ nla_put_failure:
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
+	nl80211_cmd(bss->drv, msg, 0, NL80211_CMD_AP_CHANNEL_SWITCH);
+
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, drv->ifindex);
+	NLA_PUT_U32(msg, NL80211_ATTR_CH_SWITCH_COUNT, params->ch_switch_count);
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, params->freq);
+
+	if (params->tx_block)
+		NLA_PUT_FLAG(msg, NL80211_ATTR_CH_SWITCH_BLOCK_TX);
+
+	if (params->post_switch_block_tx)
+		NLA_PUT_FLAG(msg, NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX);
+
+	ret = send_and_recv_msgs(drv, msg, NULL, NULL);
+	if (ret == 0)
+		return 0;
+	wpa_printf(MSG_DEBUG, "nl80211: Failed to channel switch: "
+		   "%d (%s)", ret, strerror(-ret));
+nla_put_failure:
+	return -1;
+}
+
+
 #ifdef CONFIG_TDLS
 
 static int nl80211_send_tdls_mgmt(void *priv, const u8 *dst, u8 action_code,
@@ -9100,6 +9153,7 @@ const struct wpa_driver_ops wpa_driver_nl80211_ops = {
 	.poll_client = nl80211_poll_client,
 	.set_p2p_powersave = nl80211_set_p2p_powersave,
 	.enable_tx = nl80211_enable_dfs_tx,
+	.hapd_channel_switch = nl80211_ap_channel_switch,
 #ifdef CONFIG_TDLS
 	.send_tdls_mgmt = nl80211_send_tdls_mgmt,
 	.tdls_oper = nl80211_tdls_oper,
-- 
1.7.5.4

