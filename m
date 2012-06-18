Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:34276 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464Ab2FROxe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 10:53:34 -0400
Received: by obcni5 with SMTP id ni5so9074101obc.41
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 07:53:30 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <hostap@lists.shmoo.com>
Cc: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <johannes@sipsolutions.net>,
	<coelho@ti.com>, <assaf@ti.com>, <yoni.divinsky@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH 7/7] nl80211: add start radar detection command/event
Date: Mon, 18 Jun 2012 17:49:46 +0300
Message-Id: <1340030986-29118-8-git-send-email-victorg@ti.com> (sfid-20120618_165337_467896_DF5EB0C0)
In-Reply-To: <1340030986-29118-1-git-send-email-victorg@ti.com>
References: <1340030986-29118-1-git-send-email-victorg@ti.com>
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
 src/drivers/driver_nl80211.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index 7e8b800..74d4310 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -2174,6 +2174,16 @@ static void do_process_drv_event(struct wpa_driver_nl80211_data *drv,
 		wpa_supplicant_event(drv->ctx, EVENT_CHANNEL_SWITCH_COMPLETE,
 				     &data);
 		break;
+	case NL80211_CMD_RADAR_DETECT:
+		os_memset(&data, 0, sizeof(data));
+		if (tb[NL80211_ATTR_WIPHY_FREQ]) {
+			data.radar_detected.freq =
+				    nla_get_u16(tb[NL80211_ATTR_WIPHY_FREQ]);
+		}
+		data.radar_detected.status = TRUE;
+		wpa_printf(MSG_DEBUG, "nl80211: Radar detected event");
+		wpa_supplicant_event(drv->ctx, EVENT_RADAR_DETECTED, &data);
+		break;
 	default:
 		wpa_printf(MSG_DEBUG, "nl80211: Ignored unknown event "
 			   "(cmd=%d)", cmd);
@@ -8858,6 +8868,33 @@ nla_put_failure:
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
@@ -9154,6 +9191,7 @@ const struct wpa_driver_ops wpa_driver_nl80211_ops = {
 	.set_p2p_powersave = nl80211_set_p2p_powersave,
 	.enable_tx = nl80211_enable_dfs_tx,
 	.hapd_channel_switch = nl80211_ap_channel_switch,
+	.start_radar_detection = nl80211_start_radar_detection,
 #ifdef CONFIG_TDLS
 	.send_tdls_mgmt = nl80211_send_tdls_mgmt,
 	.tdls_oper = nl80211_tdls_oper,
-- 
1.7.5.4

