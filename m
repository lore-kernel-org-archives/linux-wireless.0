Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:38749 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752211Ab2AZMmz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 07:42:55 -0500
Received: by mail-gx0-f177.google.com with SMTP id h4so242386ggn.22
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 04:42:54 -0800 (PST)
From: Victor Goldenshtein <victorg@ti.com>
To: <hostap@lists.shmoo.com>
Cc: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <johannes@sipsolutions.net>,
	<coelho@ti.com>, <assaf@ti.com>, <yoni.divinsky@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>
Subject: [RFC 7/7] nl80211: add start radar detection command/event
Date: Thu, 26 Jan 2012 14:41:29 +0200
Message-Id: <1327581689-22090-8-git-send-email-victorg@ti.com> (sfid-20120126_134305_752566_FB6F22CB)
In-Reply-To: <1327581689-22090-1-git-send-email-victorg@ti.com>
References: <1327581689-22090-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add command to trigger radar detection in the driver/HW.
Once radar detection has started, the driver/device shall
continuously monitor the Operating Channel (In-Service
Monitoring) to ensure that there is no radar interferences
on that channel. Process radar detection event in
do_process_drv_event().

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 src/drivers/driver_nl80211.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index 744e736..2d52c72 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -2145,6 +2145,16 @@ static void do_process_drv_event(struct wpa_driver_nl80211_data *drv,
 		wpa_supplicant_event(drv->ctx, EVENT_CHANNEL_SWITCH_COMPLETE,
 				     &data);
 		break;
+	case NL80211_CMD_DFS_RADAR_DETECTION:
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
@@ -8706,6 +8716,32 @@ nla_put_failure:
 }
 
 
+static int wpa_driver_nl80211_start_radar_detection(void *priv)
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
+	nl80211_cmd(bss->drv, msg, 0, NL80211_CMD_DFS_RADAR_DETECTION);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, drv->ifindex);
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
@@ -9001,6 +9037,7 @@ const struct wpa_driver_ops wpa_driver_nl80211_ops = {
 	.set_p2p_powersave = nl80211_set_p2p_powersave,
 	.enable_tx = wpa_driver_nl80211_enable_dfs_tx,
 	.channel_switch = wpa_driver_nl80211_channel_switch,
+	.start_radar_detection = wpa_driver_nl80211_start_radar_detection,
 #ifdef CONFIG_TDLS
 	.send_tdls_mgmt = nl80211_send_tdls_mgmt,
 	.tdls_oper = nl80211_tdls_oper,
-- 
1.7.5.4

