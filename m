Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:47022 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab1A3TLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 14:11:13 -0500
Message-ID: <4D45B7C4.2010601@davizone.at>
Date: Sun, 30 Jan 2011 20:11:00 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: [PATCH 07/18] wl1251: implement connection quality monitoring
References: <4D45A5C1.8050503@davizone.at>
In-Reply-To: <4D45A5C1.8050503@davizone.at>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement connection quality monitoring similar to the wl1271 driver.
It triggers ieee80211_cqm_rssi_notify with the corresponding event when
RSSI drops blow RSSI threshold or rises again above the RSSI threshold.
It should be noted that wl1251 doesn't support RSSI hysteresis, instead it
uses RSSI averageing and delays events until a certain count of frames
proved RSSI change.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
---
Sorry for the partly broken patches, I thought I configured my client the
right way. I tried to stop the mails at my mailserver, but it was mostly
already too late.
---
 drivers/net/wireless/wl1251/acx.c    |   25 +++++++++++++++++++
 drivers/net/wireless/wl1251/acx.h    |   45 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl1251/event.c  |   18 +++++++++++++
 drivers/net/wireless/wl1251/main.c   |   15 ++++++++++-
 drivers/net/wireless/wl1251/wl1251.h |    5 ++++
 5 files changed, 107 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl1251/acx.c b/drivers/net/wireless/wl1251/acx.c
index f1e90e1..d43695a 100644
--- a/drivers/net/wireless/wl1251/acx.c
+++ b/drivers/net/wireless/wl1251/acx.c
@@ -811,6 +811,31 @@ out:
 	return ret;
 }
 
+int wl1251_acx_low_rssi(struct wl1251 *wl, s8 threshold, u8 weight,
+			u8 depth, enum wl1251_acx_low_rssi_type type)
+{
+	struct acx_low_rssi *rssi;
+	int ret;
+
+	wl1251_debug(DEBUG_ACX, "acx low rssi");
+
+	rssi = kzalloc(sizeof(*rssi), GFP_KERNEL);
+	if (!rssi)
+		return -ENOMEM;
+
+	rssi->threshold = threshold;
+	rssi->weight = weight;
+	rssi->depth = depth;
+	rssi->type = type;
+
+	ret = wl1251_cmd_configure(wl, ACX_LOW_RSSI, rssi, sizeof(*rssi));
+	if (ret < 0)
+		wl1251_warning("failed to set low rssi threshold: %d", ret);
+
+	kfree(rssi);
+	return ret;
+}
+
 int wl1251_acx_set_preamble(struct wl1251 *wl, enum acx_preamble_type preamble)
 {
 	struct acx_preamble *acx;
diff --git a/drivers/net/wireless/wl1251/acx.h b/drivers/net/wireless/wl1251/acx.h
index 5a44c76..99ea80e 100644
--- a/drivers/net/wireless/wl1251/acx.h
+++ b/drivers/net/wireless/wl1251/acx.h
@@ -399,6 +399,49 @@ struct acx_rts_threshold {
 	u8 pad[2];
 } __packed;
 
+enum wl1251_acx_low_rssi_type {
+	/*
+	 * The event is a "Level" indication which keeps triggering
+	 * as long as the average RSSI is below the threshold.
+	 */
+	WL1251_ACX_LOW_RSSI_TYPE_LEVEL = 0,
+
+	/*
+	 * The event is an "Edge" indication which triggers
+	 * only when the RSSI threshold is crossed from above.
+	 */
+	WL1251_ACX_LOW_RSSI_TYPE_EDGE = 1,
+};
+
+struct acx_low_rssi {
+	struct acx_header header;
+
+	/*
+	 * The threshold (in dBm) below (or above after low rssi
+	 * indication) which the firmware generates an interrupt to the
+	 * host. This parameter is signed.
+	 */
+	s8 threshold;
+
+	/*
+	 * The weight of the current RSSI sample, before adding the new
+	 * sample, that is used to calculate the average RSSI.
+	 */
+	u8 weight;
+
+	/*
+	 * The number of Beacons/Probe response frames that will be
+	 * received before issuing the Low or Regained RSSI event.
+	 */
+	u8 depth;
+
+	/*
+	 * Configures how the Low RSSI Event is triggered. Refer to
+	 * enum wl1251_acx_low_rssi_type for more.
+	 */
+	u8 type;
+} __packed;
+
 struct acx_beacon_filter_option {
 	struct acx_header header;
 
@@ -1420,6 +1463,8 @@ int wl1251_acx_cca_threshold(struct wl1251 *wl);
 int wl1251_acx_bcn_dtim_options(struct wl1251 *wl);
 int wl1251_acx_aid(struct wl1251 *wl, u16 aid);
 int wl1251_acx_event_mbox_mask(struct wl1251 *wl, u32 event_mask);
+int wl1251_acx_low_rssi(struct wl1251 *wl, s8 threshold, u8 weight,
+			u8 depth, enum wl1251_acx_low_rssi_type type);
 int wl1251_acx_set_preamble(struct wl1251 *wl, enum acx_preamble_type preamble);
 int wl1251_acx_cts_protect(struct wl1251 *wl,
 			    enum acx_ctsprotect_type ctsprotect);
diff --git a/drivers/net/wireless/wl1251/event.c b/drivers/net/wireless/wl1251/event.c
index 1f931e3..7428c9f 100644
--- a/drivers/net/wireless/wl1251/event.c
+++ b/drivers/net/wireless/wl1251/event.c
@@ -134,6 +134,24 @@ static int wl1251_event_process(struct wl1251 *wl, struct event_mailbox *mbox)
 		}
 	}
 
+	if (wl->vif && wl->rssi_thold) {
+		if (vector & ROAMING_TRIGGER_LOW_RSSI_EVENT_ID) {
+			wl1251_debug(DEBUG_EVENT,
+				     "ROAMING_TRIGGER_LOW_RSSI_EVENT");
+			ieee80211_cqm_rssi_notify(wl->vif,
+				NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
+				GFP_KERNEL);
+		}
+
+		if (vector & ROAMING_TRIGGER_REGAINED_RSSI_EVENT_ID) {
+			wl1251_debug(DEBUG_EVENT,
+				     "ROAMING_TRIGGER_REGAINED_RSSI_EVENT");
+			ieee80211_cqm_rssi_notify(wl->vif,
+				NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
+				GFP_KERNEL);
+		}
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/wl1251/main.c b/drivers/net/wireless/wl1251/main.c
index 591080a..c0a7fd5 100644
--- a/drivers/net/wireless/wl1251/main.c
+++ b/drivers/net/wireless/wl1251/main.c
@@ -504,6 +504,7 @@ static void wl1251_op_stop(struct ieee80211_hw *hw)
 	wl->psm_entry_retry = 0;
 	wl->tx_queue_stopped = false;
 	wl->power_level = WL1251_DEFAULT_POWER_LEVEL;
+	wl->rssi_thold = 0;
 	wl->channel = WL1251_DEFAULT_CHANNEL;
 
 	wl1251_debugfs_reset(wl);
@@ -962,6 +963,16 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
+	if (changed & BSS_CHANGED_CQM) {
+		ret = wl1251_acx_low_rssi(wl, bss_conf->cqm_rssi_thold,
+					  WL1251_DEFAULT_LOW_RSSI_WEIGHT,
+					  WL1251_DEFAULT_LOW_RSSI_DEPTH,
+					  WL1251_ACX_LOW_RSSI_TYPE_EDGE);
+		if (ret < 0)
+			goto out;
+		wl->rssi_thold = bss_conf->cqm_rssi_thold;
+	}
+
 	if (changed & BSS_CHANGED_BSSID) {
 		memcpy(wl->bssid, bss_conf->bssid, ETH_ALEN);
 
@@ -1401,7 +1412,8 @@ int wl1251_init_ieee80211(struct wl1251 *wl)
 	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_SUPPORTS_PS |
 		IEEE80211_HW_BEACON_FILTER |
-		IEEE80211_HW_SUPPORTS_UAPSD;
+		IEEE80211_HW_SUPPORTS_UAPSD |
+		IEEE80211_HW_SUPPORTS_CQM_RSSI;
 
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 	wl->hw->wiphy->max_scan_ssids = 1;
@@ -1482,6 +1494,7 @@ struct ieee80211_hw *wl1251_alloc_hw(void)
 	wl->psm_entry_retry = 0;
 	wl->tx_queue_stopped = false;
 	wl->power_level = WL1251_DEFAULT_POWER_LEVEL;
+	wl->rssi_thold = 0;
 	wl->beacon_int = WL1251_DEFAULT_BEACON_INT;
 	wl->dtim_period = WL1251_DEFAULT_DTIM_PERIOD;
 	wl->vif = NULL;
diff --git a/drivers/net/wireless/wl1251/wl1251.h b/drivers/net/wireless/wl1251/wl1251.h
index fc778a7..d2a289d 100644
--- a/drivers/net/wireless/wl1251/wl1251.h
+++ b/drivers/net/wireless/wl1251/wl1251.h
@@ -379,6 +379,8 @@ struct wl1251 {
 	/* in dBm */
 	int power_level;
 
+	int rssi_thold;
+
 	struct wl1251_stats stats;
 	struct wl1251_debugfs debugfs;
 
@@ -444,4 +446,7 @@ void wl1251_disable_interrupts(struct wl1251 *wl);
 #define WL1251_PART_WORK_REG_START	REGISTERS_BASE
 #define WL1251_PART_WORK_REG_SIZE	REGISTERS_WORK_SIZE
 
+#define WL1251_DEFAULT_LOW_RSSI_WEIGHT          10
+#define WL1251_DEFAULT_LOW_RSSI_DEPTH           10
+
 #endif
-- 
1.7.0.4


