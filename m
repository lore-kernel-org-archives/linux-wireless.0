Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:56566 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757968Ab2HHMCj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 08:02:39 -0400
Received: by yhjj63 with SMTP id j63so836473yhj.23
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 05:02:37 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <hostap@lists.shmoo.com>
Cc: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <johannes@sipsolutions.net>,
	<coelho@ti.com>, <assaf@ti.com>, <yoni.divinsky@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v3 7/7] nl80211: add start radar detection command/event
Date: Wed,  8 Aug 2012 14:55:38 +0300
Message-Id: <1344426938-1883-8-git-send-email-victorg@ti.com> (sfid-20120808_140242_002239_7ACD8A55)
In-Reply-To: <1344426938-1883-1-git-send-email-victorg@ti.com>
References: <1344426938-1883-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add command to trigger radar detection in the driver/HW.
Once radar detection has started, the driver/device shall
continuously monitor the Operating Channel (In-Service
Monitoring) to ensure that there is no radar interferences
on that channel. Process radar detection event in
do_process_drv_event().

Signed-hostap: Victor Goldenshtein <victorg@ti.com>
---
 src/drivers/driver_nl80211.c |   50 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index c2780a4..31edc98 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -2067,6 +2067,22 @@ static void nl80211_client_probe_event(struct wpa_driver_nl80211_data *drv,
 	wpa_supplicant_event(drv->ctx, EVENT_DRIVER_CLIENT_POLL_OK, &data);
 }
 
+static void nl80211_radar_event(struct wpa_driver_nl80211_data *drv,
+				struct nlattr **tb)
+{
+	union wpa_event_data data;
+
+	if (!tb[NL80211_ATTR_WIPHY_FREQ])
+		return;
+
+	os_memset(&data, 0, sizeof(data));
+	data.radar_detected.freq = nla_get_u16(tb[NL80211_ATTR_WIPHY_FREQ]);
+
+	wpa_printf(MSG_DEBUG, "nl80211: Radar detected event on freq = %d",
+		   data.radar_detected.freq);
+
+	wpa_supplicant_event(drv->ctx, EVENT_RADAR_DETECTED, &data);
+}
 
 static void nl80211_spurious_frame(struct i802_bss *bss, struct nlattr **tb,
 				   int wds)
@@ -2210,6 +2226,9 @@ static void do_process_drv_event(struct wpa_driver_nl80211_data *drv,
 	case NL80211_CMD_PROBE_CLIENT:
 		nl80211_client_probe_event(drv, tb);
 		break;
+	case NL80211_CMD_RADAR_DETECT:
+		nl80211_radar_event(drv, tb);
+		break;
 	default:
 		wpa_printf(MSG_DEBUG, "nl80211: Ignored unknown event "
 			   "(cmd=%d)", cmd);
@@ -8932,6 +8951,36 @@ nla_put_failure:
 }
 
 
+static int nl80211_start_radar_detection(void *priv, int freq)
+{
+	struct i802_bss *bss = priv;
+	struct wpa_driver_nl80211_data *drv = bss->drv;
+	struct nl_msg *msg;
+	int ret;
+
+	wpa_printf(MSG_DEBUG, "nl80211: Start radar detection");
+
+	msg = nlmsg_alloc();
+	if (!msg)
+		return -1;
+
+	nl80211_cmd(bss->drv, msg, 0, NL80211_CMD_RADAR_DETECT);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, drv->ifindex);
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, freq);
+
+	/* only HT20 is supported at this point */
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE, NL80211_CHAN_HT20);
+
+	ret = send_and_recv_msgs(drv, msg, NULL, NULL);
+	if (ret == 0)
+		return 0;
+	wpa_printf(MSG_DEBUG, "nl80211: Failed to start radar detection: "
+		   "%d (%s)", ret, strerror(-ret));
+nla_put_failure:
+	return -1;
+}
+
+
 #ifdef CONFIG_TDLS
 
 static int nl80211_send_tdls_mgmt(void *priv, const u8 *dst, u8 action_code,
@@ -9228,6 +9277,7 @@ const struct wpa_driver_ops wpa_driver_nl80211_ops = {
 	.set_p2p_powersave = nl80211_set_p2p_powersave,
 	.enable_tx = nl80211_enable_dfs_tx,
 	.hapd_channel_switch = nl80211_ap_channel_switch,
+	.start_radar_detection = nl80211_start_radar_detection,
 #ifdef CONFIG_TDLS
 	.send_tdls_mgmt = nl80211_send_tdls_mgmt,
 	.tdls_oper = nl80211_tdls_oper,
-- 
1.7.5.4

