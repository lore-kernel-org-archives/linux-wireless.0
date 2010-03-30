Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:32913 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755546Ab0C3G2l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 02:28:41 -0400
Date: Mon, 29 Mar 2010 23:28:30 -0700
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Track Beacon signal strength and implement cqm
 events
Message-ID: <20100330062830.GA4953@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Calculate a running average of the signal strength reported for Beacon
frames and indicate cqm events if the average value moves below or
above the configured threshold value (and filter out repetitive events
with by using the configured hysteresis).

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 net/mac80211/cfg.c            |    9 +++++---
 net/mac80211/debugfs_netdev.c |   12 +++++++++++
 net/mac80211/ieee80211_i.h    |   19 +++++++++++++++++
 net/mac80211/mlme.c           |   45 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 82 insertions(+), 3 deletions(-)

This addresses the comments on the RFC version (typo and GFP_ATOMIC ->
GFP_KERNEL).

--- wireless-testing.orig/net/mac80211/debugfs_netdev.c	2010-03-28 11:28:46.000000000 -0700
+++ wireless-testing/net/mac80211/debugfs_netdev.c	2010-03-28 11:42:21.000000000 -0700
@@ -99,6 +99,14 @@ static ssize_t ieee80211_if_fmt_##name(	
 	return scnprintf(buf, buflen, "%pM\n", sdata->field);		\
 }
 
+#define IEEE80211_IF_FMT_DEC_DIV_16(name, field)			\
+static ssize_t ieee80211_if_fmt_##name(					\
+	const struct ieee80211_sub_if_data *sdata,			\
+	char *buf, int buflen)						\
+{									\
+	return scnprintf(buf, buflen, "%d\n", sdata->field / 16);	\
+}
+
 #define __IEEE80211_IF_FILE(name, _write)				\
 static ssize_t ieee80211_if_read_##name(struct file *file,		\
 					char __user *userbuf,		\
@@ -139,6 +147,8 @@ IEEE80211_IF_FILE(rc_rateidx_mask_5ghz, 
 /* STA attributes */
 IEEE80211_IF_FILE(bssid, u.mgd.bssid, MAC);
 IEEE80211_IF_FILE(aid, u.mgd.aid, DEC);
+IEEE80211_IF_FILE(last_beacon, u.mgd.last_beacon_signal, DEC);
+IEEE80211_IF_FILE(ave_beacon, u.mgd.ave_beacon_signal, DEC_DIV_16);
 
 static int ieee80211_set_smps(struct ieee80211_sub_if_data *sdata,
 			      enum ieee80211_smps_mode smps_mode)
@@ -275,6 +285,8 @@ static void add_sta_files(struct ieee802
 
 	DEBUGFS_ADD(bssid);
 	DEBUGFS_ADD(aid);
+	DEBUGFS_ADD(last_beacon);
+	DEBUGFS_ADD(ave_beacon);
 	DEBUGFS_ADD_MODE(smps, 0600);
 }
 
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-03-28 11:17:34.000000000 -0700
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-03-28 12:10:22.000000000 -0700
@@ -317,6 +317,7 @@ enum ieee80211_sta_flags {
 	IEEE80211_STA_MFP_ENABLED	= BIT(6),
 	IEEE80211_STA_UAPSD_ENABLED	= BIT(7),
 	IEEE80211_STA_NULLFUNC_ACKED	= BIT(8),
+	IEEE80211_STA_RESET_SIGNAL_AVE	= BIT(9),
 };
 
 struct ieee80211_if_managed {
@@ -359,6 +360,24 @@ struct ieee80211_if_managed {
 	int wmm_last_param_set;
 
 	u8 use_4addr;
+
+	/* Signal strength from the last Beacon frame in the current BSS. */
+	int last_beacon_signal;
+
+	/*
+	 * Weighted average of the signal strength from Beacon frames in the
+	 * current BSS. This is in units of 1/16 of the signal unit to maintain
+	 * accuracy and to speed up calculations, i.e., the value need to be
+	 * divided by 16 to get the actual value.
+	 */
+	int ave_beacon_signal;
+
+	/*
+	 * Last Beacon frame signal strength average (ave_beacon_signal / 16)
+	 * that triggered a cqm event. 0 indicates that no event has been
+	 * generated for the current association.
+	 */
+	int last_cqm_event_signal;
 };
 
 enum ieee80211_ibss_request {
--- wireless-testing.orig/net/mac80211/mlme.c	2010-03-28 11:14:11.000000000 -0700
+++ wireless-testing/net/mac80211/mlme.c	2010-03-28 12:36:18.000000000 -0700
@@ -46,6 +46,13 @@
  */
 #define IEEE80211_PROBE_WAIT		(HZ / 2)
 
+/*
+ * Weight given to the latest Beacon frame when calculating average signal
+ * strength for Beacon frames received in the current BSS. This must be
+ * between 1 and 15.
+ */
+#define IEEE80211_SIGNAL_AVE_WEIGHT	3
+
 #define TMR_RUNNING_TIMER	0
 #define TMR_RUNNING_CHANSW	1
 
@@ -728,6 +735,8 @@ static void ieee80211_set_associated(str
 	sdata->u.mgd.associated = cbss;
 	memcpy(sdata->u.mgd.bssid, cbss->bssid, ETH_ALEN);
 
+	sdata->u.mgd.flags |= IEEE80211_STA_RESET_SIGNAL_AVE;
+
 	/* just to be sure */
 	sdata->u.mgd.flags &= ~(IEEE80211_STA_CONNECTION_POLL |
 				IEEE80211_STA_BEACON_POLL);
@@ -1343,6 +1352,7 @@ static void ieee80211_rx_mgmt_beacon(str
 				     struct ieee80211_rx_status *rx_status)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
 	size_t baselen;
 	struct ieee802_11_elems elems;
 	struct ieee80211_local *local = sdata->local;
@@ -1378,6 +1388,41 @@ static void ieee80211_rx_mgmt_beacon(str
 	if (memcmp(bssid, mgmt->bssid, ETH_ALEN) != 0)
 		return;
 
+	/* Track average RSSI from the Beacon frames of the current AP */
+	ifmgd->last_beacon_signal = rx_status->signal;
+	if (ifmgd->flags & IEEE80211_STA_RESET_SIGNAL_AVE) {
+		ifmgd->flags &= ~IEEE80211_STA_RESET_SIGNAL_AVE;
+		ifmgd->ave_beacon_signal = rx_status->signal;
+		ifmgd->last_cqm_event_signal = 0;
+	} else {
+		ifmgd->ave_beacon_signal =
+			(IEEE80211_SIGNAL_AVE_WEIGHT * rx_status->signal * 16 +
+			 (16 - IEEE80211_SIGNAL_AVE_WEIGHT) *
+			 ifmgd->ave_beacon_signal) / 16;
+	}
+	if (bss_conf->cqm_rssi_thold &&
+	    !(local->hw.flags & IEEE80211_HW_SUPPORTS_CQM_RSSI)) {
+		int sig = ifmgd->ave_beacon_signal / 16;
+		int last_event = ifmgd->last_cqm_event_signal;
+		int thold = bss_conf->cqm_rssi_thold;
+		int hyst = bss_conf->cqm_rssi_hyst;
+		if (sig < thold &&
+		    (last_event == 0 || sig < last_event - hyst)) {
+			ifmgd->last_cqm_event_signal = sig;
+			ieee80211_cqm_rssi_notify(
+				&sdata->vif,
+				NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
+				GFP_KERNEL);
+		} else if (sig > thold &&
+			   (last_event == 0 || sig > last_event + hyst)) {
+			ifmgd->last_cqm_event_signal = sig;
+			ieee80211_cqm_rssi_notify(
+				&sdata->vif,
+				NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
+				GFP_KERNEL);
+		}
+	}
+
 	if (ifmgd->flags & IEEE80211_STA_BEACON_POLL) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		if (net_ratelimit()) {
--- wireless-testing.orig/net/mac80211/cfg.c	2010-03-28 12:05:02.000000000 -0700
+++ wireless-testing/net/mac80211/cfg.c	2010-03-28 12:06:47.000000000 -0700
@@ -1411,9 +1411,6 @@ static int ieee80211_set_cqm_rssi_config
 	struct ieee80211_vif *vif = &sdata->vif;
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 
-	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_CQM_RSSI))
-		return -EOPNOTSUPP;
-
 	if (rssi_thold == bss_conf->cqm_rssi_thold &&
 	    rssi_hyst == bss_conf->cqm_rssi_hyst)
 		return 0;
@@ -1421,6 +1418,12 @@ static int ieee80211_set_cqm_rssi_config
 	bss_conf->cqm_rssi_thold = rssi_thold;
 	bss_conf->cqm_rssi_hyst = rssi_hyst;
 
+	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_CQM_RSSI)) {
+		if (sdata->vif.type != NL80211_IFTYPE_STATION)
+			return -EOPNOTSUPP;
+		return 0;
+	}
+
 	/* tell the driver upon association, unless already associated */
 	if (sdata->u.mgd.associated)
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_CQM);

-- 
Jouni Malinen                                            PGP id EFC895FA
