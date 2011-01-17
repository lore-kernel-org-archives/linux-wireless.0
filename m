Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.techwires.net ([79.140.39.242]:38740 "EHLO mx.techwires.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab1AQQVe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 11:21:34 -0500
In-Reply-To: <201101171621.29863.bernhard.schmidt@saxnet.de>
References: <201101171621.29863.bernhard.schmidt@saxnet.de>
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 17 Jan 2011 14:23:54 +0100
Subject: [PATCH 6/8] hostap: request CAC before using a radar channel
Cc: <lrodriguez@atheros.com>, <nbd@openwrt.org>, <dubowoj@neratec.com>,
	<zefir.kurtisi@neratec.com>, <simon.wunderlich@saxnet.de>
Message-Id: <20110117161327.9A2A62097@mx.techwires.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 src/ap/ap_drv_ops.c          |    7 ++++
 src/ap/ap_drv_ops.h          |    1 +
 src/ap/drv_callbacks.c       |    4 ++
 src/ap/hostapd.c             |   83 ++++++++++++++++++++++++++++++++++++++++++
 src/ap/hostapd.h             |    5 +++
 src/ap/hw_features.c         |    2 +-
 src/drivers/driver.h         |    9 +++++
 src/drivers/driver_nl80211.c |   35 ++++++++++++++++++
 8 files changed, 145 insertions(+), 1 deletions(-)

diff --git a/src/ap/ap_drv_ops.c b/src/ap/ap_drv_ops.c
index 7f9522a..4d260ac 100644
--- a/src/ap/ap_drv_ops.c
+++ b/src/ap/ap_drv_ops.c
@@ -429,6 +429,13 @@ int hostapd_set_freq(struct hostapd_data *hapd, int mode, int freq,
 	return hapd->driver->set_freq(hapd->drv_priv, &data);
 }
 
+int hostapd_radar_cac(struct hostapd_data *hapd, int enable)
+{
+	if (hapd->driver == NULL || hapd->driver->radar_cac == NULL)
+		return -1;
+	return hapd->driver->radar_cac(hapd->drv_priv, enable);
+}
+
 int hostapd_set_rts(struct hostapd_data *hapd, int rts)
 {
 	if (hapd->driver == NULL || hapd->driver->set_rts == NULL)
diff --git a/src/ap/ap_drv_ops.h b/src/ap/ap_drv_ops.h
index 5bc9d01..3c51422 100644
--- a/src/ap/ap_drv_ops.h
+++ b/src/ap/ap_drv_ops.h
@@ -53,6 +53,7 @@ int hostapd_get_seqnum(const char *ifname, struct hostapd_data *hapd,
 int hostapd_flush(struct hostapd_data *hapd);
 int hostapd_set_freq(struct hostapd_data *hapd, int mode, int freq,
 		     int channel, int ht_enabled, int sec_channel_offset);
+int hostapd_radar_cac(struct hostapd_data *hapd, int enable);
 int hostapd_set_rts(struct hostapd_data *hapd, int rts);
 int hostapd_set_frag(struct hostapd_data *hapd, int frag);
 int hostapd_sta_set_flags(struct hostapd_data *hapd, u8 *addr,
diff --git a/src/ap/drv_callbacks.c b/src/ap/drv_callbacks.c
index c55c42a..1006bc0 100644
--- a/src/ap/drv_callbacks.c
+++ b/src/ap/drv_callbacks.c
@@ -521,6 +521,10 @@ void wpa_supplicant_event(void *ctx, enum wpa_event_type event,
 			break;
 		hostapd_event_sta_low_ack(hapd, data->low_ack.addr);
 		break;
+	case EVENT_RADAR_CAC_DONE:
+		if (hapd->iface->radar_cac_cb)
+			hapd->iface->radar_cac_cb(hapd);
+		break;
 	case EVENT_RADAR_FLAGS_CHANGED:
 		hostapd_radar_flags_changed(hapd, data->radar.freq,
 					    data->radar.flags);
diff --git a/src/ap/hostapd.c b/src/ap/hostapd.c
index 592a01f..a065fc9 100644
--- a/src/ap/hostapd.c
+++ b/src/ap/hostapd.c
@@ -695,6 +695,82 @@ static int setup_interface(struct hostapd_iface *iface)
 			return 0;
 		}
 	}
+	return hostapd_setup_radar_complete(iface);
+}
+
+static int hostapd_channel_availability_check(struct hostapd_data *hapd)
+{
+	struct hostapd_iface *iface = hapd->iface;
+
+	iface->freq = hostapd_hw_get_freq(hapd, hapd->iconf->channel);
+	if (hostapd_set_freq(hapd, hapd->iconf->hw_mode, iface->freq,
+			     hapd->iconf->channel,
+			     hapd->iconf->ieee80211n,
+			     hapd->iconf->secondary_channel)) {
+		wpa_printf(MSG_ERROR, "Could not set channel for "
+			   "kernel driver");
+			return -1;
+	}
+
+	if (hostapd_radar_cac(hapd, 1))
+		return -1;
+
+	return 0;
+}
+
+static void hostapd_cac_done(struct hostapd_data *hapd)
+{
+	struct hostapd_iface *iface = hapd->iface;
+	u32 flags;
+
+	iface->radar_cac_cb = NULL;
+	iface->radar_flags_cb = NULL;
+	flags = hostapd_hw_get_radar_flags(hapd, iface->conf->channel);
+	if ((flags & HOSTAPD_CHAN_RADAR_CLEAR)) {
+		hostapd_setup_interface_complete(iface, 0);
+		return;
+	}
+	if ((flags & HOSTAPD_CHAN_RADAR_INTERFERENCE)) {
+		int chan = iface->conf->channel;
+		u32 newflags;
+		iface->conf->channel = 0;
+		if (hostapd_select_random_channel(iface))
+			iface->conf->channel = chan;
+		newflags = hostapd_hw_get_radar_flags(hapd,
+						      iface->conf->channel);
+		if ((newflags & HOSTAPD_CHAN_RADAR_INTERFERENCE))
+			iface->radar_flags_cb = hostapd_cac_done;
+		else
+			hostapd_cac_done(hapd);
+	} else {
+		if (hostapd_channel_availability_check(hapd))
+			hostapd_setup_interface_complete(iface, 1);
+		iface->radar_cac_cb = hostapd_cac_done;
+	}
+}
+
+int hostapd_setup_radar_complete(struct hostapd_iface *iface)
+{
+	struct hostapd_data *hapd = iface->bss[0];
+	u32 flags;
+
+	flags = hostapd_hw_get_radar_flags(hapd, iface->conf->channel);
+	if ((flags & HOSTAPD_CHAN_RADAR) == 0)
+		return hostapd_setup_interface_complete(iface, 0);
+	if ((flags & HOSTAPD_CHAN_RADAR_INTERFERENCE)) {
+		hapd->iface->radar_flags_cb = hostapd_cac_done;
+		wpa_printf(MSG_DEBUG, "Interface initialization will "
+			   "be completed in a callback");
+		return 0;
+	}
+	if ((flags & HOSTAPD_CHAN_RADAR_CLEAR) == 0)  {
+		if (hostapd_channel_availability_check(hapd))
+			return hostapd_setup_interface_complete(iface, 1);
+		iface->radar_cac_cb = hostapd_cac_done;
+		wpa_printf(MSG_DEBUG, "Interface initialization will "
+			   "be completed in a callback");
+		return 0;
+	}
 	return hostapd_setup_interface_complete(iface, 0);
 }
 
@@ -919,5 +995,12 @@ void hostapd_new_assoc_sta(struct hostapd_data *hapd, struct sta_info *sta,
 
 void hostapd_radar_flags_changed(struct hostapd_data *hapd, int freq, u32 flags)
 {
+	struct hostapd_iface *iface = hapd->iface;
+
 	hostapd_hw_set_radar_flags(hapd, freq, flags);
+
+	if (iface->radar_flags_cb) {
+		iface->radar_flags_cb(hapd);
+		return;
+	}
 }
diff --git a/src/ap/hostapd.h b/src/ap/hostapd.h
index e2e4234..b38a91d 100644
--- a/src/ap/hostapd.h
+++ b/src/ap/hostapd.h
@@ -215,6 +215,10 @@ struct hostapd_iface {
 	u16 ht_op_mode;
 	void (*scan_cb)(struct hostapd_iface *iface);
 
+	/* Radar handling callbacks */
+	void (*radar_cac_cb)(struct hostapd_data *hapd);
+	void (*radar_flags_cb)(struct hostapd_data *hapd);
+
 	int (*ctrl_iface_init)(struct hostapd_data *hapd);
 	void (*ctrl_iface_deinit)(struct hostapd_data *hapd);
 
@@ -230,6 +234,7 @@ hostapd_alloc_bss_data(struct hostapd_iface *hapd_iface,
 		       struct hostapd_config *conf,
 		       struct hostapd_bss_config *bss);
 int hostapd_setup_interface(struct hostapd_iface *iface);
+int hostapd_setup_radar_complete(struct hostapd_iface *iface);
 int hostapd_setup_interface_complete(struct hostapd_iface *iface, int err);
 void hostapd_interface_deinit(struct hostapd_iface *iface);
 void hostapd_interface_free(struct hostapd_iface *iface);
diff --git a/src/ap/hw_features.c b/src/ap/hw_features.c
index 04bf210..a7f4eda 100644
--- a/src/ap/hw_features.c
+++ b/src/ap/hw_features.c
@@ -505,7 +505,7 @@ static void ieee80211n_check_scan(struct hostapd_iface *iface)
 		iface->conf->ht_capab &= ~HT_CAP_INFO_SUPP_CHANNEL_WIDTH_SET;
 	}
 
-	hostapd_setup_interface_complete(iface, 0);
+	hostapd_setup_radar_complete(iface);
 }
 
 
diff --git a/src/drivers/driver.h b/src/drivers/driver.h
index 777f854..0bbf4bd 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -1498,6 +1498,14 @@ struct wpa_driver_ops {
 	int (*set_freq)(void *priv, struct hostapd_freq_params *freq);
 
 	/**
+	 * radar_cac - Start/stop CAC (AP only)
+	 * @priv: Private driver interface data
+	 * @enable: Enable/disable CAC (0 = disable, 1 = enable)
+	 * Returns 0 on success, -1 on failure
+	 */
+	int (*radar_cac)(void *priv, int enable);
+
+	/**
 	 * set_rts - Set RTS threshold
 	 * @priv: Private driver interface data
 	 * @rts: RTS threshold in octets
@@ -2581,6 +2589,7 @@ enum wpa_event_type {
 	EVENT_P2P_SD_REQUEST,
 	EVENT_P2P_SD_RESPONSE,
 
+	EVENT_RADAR_CAC_DONE,
 	EVENT_RADAR_FLAGS_CHANGED,
 };
 
diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index d919a73..b7b7bdb 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -1294,6 +1294,9 @@ static void nl80211_radar_event(struct wpa_driver_nl80211_data *drv, u32 cmd,
 	union wpa_event_data data;
 
 	switch (cmd) {
+	case NL80211_CMD_RADAR_CAC_DONE:
+		wpa_supplicant_event(drv->ctx, EVENT_RADAR_CAC_DONE, NULL);
+		break;
 	case NL80211_CMD_RADAR_FLAGS_CHANGED:
 		if (!tb[NL80211_FREQUENCY_ATTR_FREQ])
 			return;
@@ -1424,6 +1427,7 @@ static int process_event(struct nl_msg *msg, void *arg)
 	case NL80211_CMD_NEW_STATION:
 		nl80211_new_station_event(drv, tb);
 		break;
+	case NL80211_CMD_RADAR_CAC_DONE:
 	case NL80211_CMD_RADAR_FLAGS_CHANGED:
 		nl80211_radar_event(drv, gnlh->cmd, tb);
 		break;
@@ -5102,6 +5106,36 @@ static int i802_set_freq(void *priv, struct hostapd_freq_params *freq)
 
 #ifdef HOSTAPD
 
+static int i802_radar_cac(void *priv, int enable)
+{
+	struct i802_bss *bss = priv;
+	struct wpa_driver_nl80211_data *drv = bss->drv;
+	struct nl_msg *msg;
+	int cmd, ret;
+
+	msg = nlmsg_alloc();
+	if (!msg)
+		return -1;
+
+	if (enable)
+		cmd = NL80211_CMD_RADAR_CAC_START;
+	else
+		cmd = NL80211_CMD_RADAR_CAC_STOP;
+
+	genlmsg_put(msg, 0, 0, genl_family_get_id(drv->nl80211), 0, 0, cmd, 0);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, if_nametoindex(bss->ifname));
+
+	ret = send_and_recv_msgs(drv, msg, NULL, NULL);
+	if (ret != 0) {
+		wpa_printf(MSG_DEBUG, "nl80211: Failed to start CAC: %d (%s)",
+			   ret, strerror(-ret));
+	}
+	return ret;
+
+ nla_put_failure:
+	return -1;
+}
+
 static int i802_set_rts(void *priv, int rts)
 {
 	struct i802_bss *bss = priv;
@@ -6424,6 +6458,7 @@ const struct wpa_driver_ops wpa_driver_nl80211_ops = {
 	.hapd_deinit = i802_deinit,
 	.get_seqnum = i802_get_seqnum,
 	.flush = i802_flush,
+	.radar_cac = i802_radar_cac,
 	.read_sta_data = i802_read_sta_data,
 	.sta_deauth = i802_sta_deauth,
 	.sta_disassoc = i802_sta_disassoc,
-- 
1.5.6.5

