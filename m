Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12449 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbYFLBt4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:49:56 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 20/29] iwlwifi: move scan to iwl-scan.c iwlcore
Date: Thu, 12 Jun 2008 09:47:10 +0800
Message-Id: <1213235239-2954-21-git-send-email-yi.zhu@intel.com> (sfid-20080612_041913_487388_BFEC2C52)
In-Reply-To: <1213235239-2954-20-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-5-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-6-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-7-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-8-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-9-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-10-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-11-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-12-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-13-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-14-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-15-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-16-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-17-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-18-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-19-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-20-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves scan code to iwl-scan.c file in iwlcore module.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile       |    5 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |   24 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |   10 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |  896 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  881 +-------------------------
 6 files changed, 946 insertions(+), 872 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-scan.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 184fdee..1f52b92 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_IWLCORE)	+= iwlcore.o
-iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o iwl-calib.o
-iwlcore-objs 		+= iwl-rx.o iwl-tx.o iwl-sta.o
+iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o
+iwlcore-objs 		+= iwl-rx.o iwl-tx.o iwl-sta.o iwl-calib.o
+iwlcore-objs 		+= iwl-scan.o
 iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlcore-$(CONFIG_IWLWIFI_LEDS) += iwl-led.o
 iwlcore-$(CONFIG_IWLWIFI_RFKILL) += iwl-rfkill.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index b58f796..058e764 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2100,7 +2100,7 @@ struct iwl4965_ct_kill_config {
  *****************************************************************************/
 
 /**
- * struct iwl4965_scan_channel - entry in REPLY_SCAN_CMD channel table
+ * struct iwl_scan_channel - entry in REPLY_SCAN_CMD channel table
  *
  * One for each channel in the scan list.
  * Each channel can independently select:
@@ -2110,7 +2110,7 @@ struct iwl4965_ct_kill_config {
  *     quiet_plcp_th, good_CRC_th)
  *
  * To avoid uCode errors, make sure the following are true (see comments
- * under struct iwl4965_scan_cmd about max_out_time and quiet_time):
+ * under struct iwl_scan_cmd about max_out_time and quiet_time):
  * 1)  If using passive_dwell (i.e. passive_dwell != 0):
  *     active_dwell <= passive_dwell (< max_out_time if max_out_time != 0)
  * 2)  quiet_time <= active_dwell
@@ -2118,7 +2118,7 @@ struct iwl4965_ct_kill_config {
  *     passive_dwell < max_out_time
  *     active_dwell < max_out_time
  */
-struct iwl4965_scan_channel {
+struct iwl_scan_channel {
 	/*
 	 * type is defined as:
 	 * 0:0 1 = active, 0 = passive
@@ -2134,13 +2134,13 @@ struct iwl4965_scan_channel {
 } __attribute__ ((packed));
 
 /**
- * struct iwl4965_ssid_ie - directed scan network information element
+ * struct iwl_ssid_ie - directed scan network information element
  *
  * Up to 4 of these may appear in REPLY_SCAN_CMD, selected by "type" field
  * in struct iwl4965_scan_channel; each channel may select different ssids from
  * among the 4 entries.  SSID IEs get transmitted in reverse order of entry.
  */
-struct iwl4965_ssid_ie {
+struct iwl_ssid_ie {
 	u8 id;
 	u8 len;
 	u8 ssid[32];
@@ -2201,9 +2201,9 @@ struct iwl4965_ssid_ie {
  * Driver must use separate scan commands for 2.4 vs. 5 GHz bands.
  *
  * To avoid uCode errors, see timing restrictions described under
- * struct iwl4965_scan_channel.
+ * struct iwl_scan_channel.
  */
-struct iwl4965_scan_cmd {
+struct iwl_scan_cmd {
 	__le16 len;
 	u8 reserved0;
 	u8 channel_count;	/* # channels in channel list */
@@ -2227,7 +2227,7 @@ struct iwl4965_scan_cmd {
 	struct iwl_tx_cmd tx_cmd;
 
 	/* For directed active scans (set to all-0s otherwise) */
-	struct iwl4965_ssid_ie direct_scan[PROBE_OPTION_MAX];
+	struct iwl_ssid_ie direct_scan[PROBE_OPTION_MAX];
 
 	/*
 	 * Probe request frame, followed by channel list.
@@ -2255,14 +2255,14 @@ struct iwl4965_scan_cmd {
 /*
  * REPLY_SCAN_CMD = 0x80 (response)
  */
-struct iwl4965_scanreq_notification {
+struct iwl_scanreq_notification {
 	__le32 status;		/* 1: okay, 2: cannot fulfill request */
 } __attribute__ ((packed));
 
 /*
  * SCAN_START_NOTIFICATION = 0x82 (notification only, not a command)
  */
-struct iwl4965_scanstart_notification {
+struct iwl_scanstart_notification {
 	__le32 tsf_low;
 	__le32 tsf_high;
 	__le32 beacon_timer;
@@ -2279,7 +2279,7 @@ struct iwl4965_scanstart_notification {
 /*
  * SCAN_RESULTS_NOTIFICATION = 0x83 (notification only, not a command)
  */
-struct iwl4965_scanresults_notification {
+struct iwl_scanresults_notification {
 	u8 channel;
 	u8 band;
 	u8 reserved[2];
@@ -2291,7 +2291,7 @@ struct iwl4965_scanresults_notification {
 /*
  * SCAN_COMPLETE_NOTIFICATION = 0x84 (notification only, not a command)
  */
-struct iwl4965_scancomplete_notification {
+struct iwl_scancomplete_notification {
 	u8 scanned_channels;
 	u8 status;
 	u8 reserved;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 5bae691..5837577 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -243,6 +243,16 @@ int iwl_txq_check_empty(struct iwl_priv *priv, int sta_id, u8 tid, int txq_id);
  ****************************************************/
 int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force);
 
+/*******************************************************************************
+ * Scanning
+ ******************************************************************************/
+int iwl_scan_cancel(struct iwl_priv *priv);
+int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms);
+const char *iwl_escape_essid(const char *essid, u8 essid_len);
+int iwl_scan_initiate(struct iwl_priv *priv);
+void iwl_setup_rx_scan_handlers(struct iwl_priv *priv);
+void iwl_setup_scan_deferred_work(struct iwl_priv *priv);
+
 /*****************************************************
  *   S e n d i n g     H o s t     C o m m a n d s   *
  *****************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index b420f64..e586987 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -976,7 +976,7 @@ struct iwl_priv {
 	int one_direct_scan;
 	u8 direct_ssid_len;
 	u8 direct_ssid[IW_ESSID_MAX_SIZE];
-	struct iwl4965_scan_cmd *scan;
+	struct iwl_scan_cmd *scan;
 
 	/* spinlock */
 	spinlock_t lock;	/* protect general shared data */
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
new file mode 100644
index 0000000..c2ed7c1
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -0,0 +1,896 @@
+/******************************************************************************
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ * Tomas Winkler <tomas.winkler@intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *****************************************************************************/
+#include <net/mac80211.h>
+#include <linux/etherdevice.h>
+
+#include "iwl-eeprom.h"
+#include "iwl-dev.h"
+#include "iwl-core.h"
+#include "iwl-sta.h"
+#include "iwl-io.h"
+#include "iwl-helpers.h"
+
+/* For active scan, listen ACTIVE_DWELL_TIME (msec) on each channel after
+ * sending probe req.  This should be set long enough to hear probe responses
+ * from more than one AP.  */
+#define IWL_ACTIVE_DWELL_TIME_24    (20)       /* all times in msec */
+#define IWL_ACTIVE_DWELL_TIME_52    (10)
+
+/* For faster active scanning, scan will move to the next channel if fewer than
+ * PLCP_QUIET_THRESH packets are heard on this channel within
+ * ACTIVE_QUIET_TIME after sending probe request.  This shortens the dwell
+ * time if it's a quiet channel (nothing responded to our probe, and there's
+ * no other traffic).
+ * Disable "quiet" feature by setting PLCP_QUIET_THRESH to 0. */
+#define IWL_PLCP_QUIET_THRESH       __constant_cpu_to_le16(1)  /* packets */
+#define IWL_ACTIVE_QUIET_TIME       __constant_cpu_to_le16(5)  /* msec */
+
+/* For passive scan, listen PASSIVE_DWELL_TIME (msec) on each channel.
+ * Must be set longer than active dwell time.
+ * For the most reliable scan, set > AP beacon interval (typically 100msec). */
+#define IWL_PASSIVE_DWELL_TIME_24   (20)       /* all times in msec */
+#define IWL_PASSIVE_DWELL_TIME_52   (10)
+#define IWL_PASSIVE_DWELL_BASE      (100)
+#define IWL_CHANNEL_TUNE_TIME       5
+
+
+
+static int iwl_is_empty_essid(const char *essid, int essid_len)
+{
+	/* Single white space is for Linksys APs */
+	if (essid_len == 1 && essid[0] == ' ')
+		return 1;
+
+	/* Otherwise, if the entire essid is 0, we assume it is hidden */
+	while (essid_len) {
+		essid_len--;
+		if (essid[essid_len] != '\0')
+			return 0;
+	}
+
+	return 1;
+}
+
+
+
+const char *iwl_escape_essid(const char *essid, u8 essid_len)
+{
+	static char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
+	const char *s = essid;
+	char *d = escaped;
+
+	if (iwl_is_empty_essid(essid, essid_len)) {
+		memcpy(escaped, "<hidden>", sizeof("<hidden>"));
+		return escaped;
+	}
+
+	essid_len = min(essid_len, (u8) IW_ESSID_MAX_SIZE);
+	while (essid_len--) {
+		if (*s == '\0') {
+			*d++ = '\\';
+			*d++ = '0';
+			s++;
+		} else
+			*d++ = *s++;
+	}
+	*d = '\0';
+	return escaped;
+}
+EXPORT_SYMBOL(iwl_escape_essid);
+
+/**
+ * iwl_scan_cancel - Cancel any currently executing HW scan
+ *
+ * NOTE: priv->mutex is not required before calling this function
+ */
+int iwl_scan_cancel(struct iwl_priv *priv)
+{
+	if (!test_bit(STATUS_SCAN_HW, &priv->status)) {
+		clear_bit(STATUS_SCANNING, &priv->status);
+		return 0;
+	}
+
+	if (test_bit(STATUS_SCANNING, &priv->status)) {
+		if (!test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
+			IWL_DEBUG_SCAN("Queuing scan abort.\n");
+			set_bit(STATUS_SCAN_ABORTING, &priv->status);
+			queue_work(priv->workqueue, &priv->abort_scan);
+
+		} else
+			IWL_DEBUG_SCAN("Scan abort already in progress.\n");
+
+		return test_bit(STATUS_SCANNING, &priv->status);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(iwl_scan_cancel);
+/**
+ * iwl_scan_cancel_timeout - Cancel any currently executing HW scan
+ * @ms: amount of time to wait (in milliseconds) for scan to abort
+ *
+ * NOTE: priv->mutex must be held before calling this function
+ */
+int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
+{
+	unsigned long now = jiffies;
+	int ret;
+
+	ret = iwl_scan_cancel(priv);
+	if (ret && ms) {
+		mutex_unlock(&priv->mutex);
+		while (!time_after(jiffies, now + msecs_to_jiffies(ms)) &&
+				test_bit(STATUS_SCANNING, &priv->status))
+			msleep(1);
+		mutex_lock(&priv->mutex);
+
+		return test_bit(STATUS_SCANNING, &priv->status);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(iwl_scan_cancel_timeout);
+
+static int iwl_send_scan_abort(struct iwl_priv *priv)
+{
+	int ret = 0;
+	struct iwl_rx_packet *res;
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_SCAN_ABORT_CMD,
+		.meta.flags = CMD_WANT_SKB,
+	};
+
+	/* If there isn't a scan actively going on in the hardware
+	 * then we are in between scan bands and not actually
+	 * actively scanning, so don't send the abort command */
+	if (!test_bit(STATUS_SCAN_HW, &priv->status)) {
+		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
+		return 0;
+	}
+
+	ret = iwl_send_cmd_sync(priv, &cmd);
+	if (ret) {
+		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
+		return ret;
+	}
+
+	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
+	if (res->u.status != CAN_ABORT_STATUS) {
+		/* The scan abort will return 1 for success or
+		 * 2 for "failure".  A failure condition can be
+		 * due to simply not being in an active scan which
+		 * can occur if we send the scan abort before we
+		 * the microcode has notified us that a scan is
+		 * completed. */
+		IWL_DEBUG_INFO("SCAN_ABORT returned %d.\n", res->u.status);
+		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
+		clear_bit(STATUS_SCAN_HW, &priv->status);
+	}
+
+	dev_kfree_skb_any(cmd.meta.u.skb);
+
+	return ret;
+}
+
+
+/* Service response to REPLY_SCAN_CMD (0x80) */
+static void iwl_rx_reply_scan(struct iwl_priv *priv,
+			      struct iwl_rx_mem_buffer *rxb)
+{
+#ifdef CONFIG_IWLWIFI_DEBUG
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_scanreq_notification *notif =
+	    (struct iwl_scanreq_notification *)pkt->u.raw;
+
+	IWL_DEBUG_RX("Scan request status = 0x%x\n", notif->status);
+#endif
+}
+
+/* Service SCAN_START_NOTIFICATION (0x82) */
+static void iwl_rx_scan_start_notif(struct iwl_priv *priv,
+				    struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_scanstart_notification *notif =
+	    (struct iwl_scanstart_notification *)pkt->u.raw;
+	priv->scan_start_tsf = le32_to_cpu(notif->tsf_low);
+	IWL_DEBUG_SCAN("Scan start: "
+		       "%d [802.11%s] "
+		       "(TSF: 0x%08X:%08X) - %d (beacon timer %u)\n",
+		       notif->channel,
+		       notif->band ? "bg" : "a",
+		       notif->tsf_high,
+		       notif->tsf_low, notif->status, notif->beacon_timer);
+}
+
+/* Service SCAN_RESULTS_NOTIFICATION (0x83) */
+static void iwl_rx_scan_results_notif(struct iwl_priv *priv,
+				      struct iwl_rx_mem_buffer *rxb)
+{
+#ifdef CONFIG_IWLWIFI_DEBUG
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_scanresults_notification *notif =
+	    (struct iwl_scanresults_notification *)pkt->u.raw;
+
+	IWL_DEBUG_SCAN("Scan ch.res: "
+		       "%d [802.11%s] "
+		       "(TSF: 0x%08X:%08X) - %d "
+		       "elapsed=%lu usec (%dms since last)\n",
+		       notif->channel,
+		       notif->band ? "bg" : "a",
+		       le32_to_cpu(notif->tsf_high),
+		       le32_to_cpu(notif->tsf_low),
+		       le32_to_cpu(notif->statistics[0]),
+		       le32_to_cpu(notif->tsf_low) - priv->scan_start_tsf,
+		       jiffies_to_msecs(elapsed_jiffies
+					(priv->last_scan_jiffies, jiffies)));
+#endif
+
+	priv->last_scan_jiffies = jiffies;
+	priv->next_scan_jiffies = 0;
+}
+
+/* Service SCAN_COMPLETE_NOTIFICATION (0x84) */
+static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
+				       struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
+
+	IWL_DEBUG_SCAN("Scan complete: %d channels (TSF 0x%08X:%08X) - %d\n",
+		       scan_notif->scanned_channels,
+		       scan_notif->tsf_low,
+		       scan_notif->tsf_high, scan_notif->status);
+
+	/* The HW is no longer scanning */
+	clear_bit(STATUS_SCAN_HW, &priv->status);
+
+	/* The scan completion notification came in, so kill that timer... */
+	cancel_delayed_work(&priv->scan_check);
+
+	IWL_DEBUG_INFO("Scan pass on %sGHz took %dms\n",
+		       (priv->scan_bands == 2) ? "2.4" : "5.2",
+		       jiffies_to_msecs(elapsed_jiffies
+					(priv->scan_pass_start, jiffies)));
+
+	/* Remove this scanned band from the list
+	 * of pending bands to scan */
+	priv->scan_bands--;
+
+	/* If a request to abort was given, or the scan did not succeed
+	 * then we reset the scan state machine and terminate,
+	 * re-queuing another scan if one has been requested */
+	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
+		IWL_DEBUG_INFO("Aborted scan completed.\n");
+		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
+	} else {
+		/* If there are more bands on this scan pass reschedule */
+		if (priv->scan_bands > 0)
+			goto reschedule;
+	}
+
+	priv->last_scan_jiffies = jiffies;
+	priv->next_scan_jiffies = 0;
+	IWL_DEBUG_INFO("Setting scan to off\n");
+
+	clear_bit(STATUS_SCANNING, &priv->status);
+
+	IWL_DEBUG_INFO("Scan took %dms\n",
+		jiffies_to_msecs(elapsed_jiffies(priv->scan_start, jiffies)));
+
+	queue_work(priv->workqueue, &priv->scan_completed);
+
+	return;
+
+reschedule:
+	priv->scan_pass_start = jiffies;
+	queue_work(priv->workqueue, &priv->request_scan);
+}
+
+void iwl_setup_rx_scan_handlers(struct iwl_priv *priv)
+{
+	/* scan handlers */
+	priv->rx_handlers[REPLY_SCAN_CMD] = iwl_rx_reply_scan;
+	priv->rx_handlers[SCAN_START_NOTIFICATION] = iwl_rx_scan_start_notif;
+	priv->rx_handlers[SCAN_RESULTS_NOTIFICATION] =
+					iwl_rx_scan_results_notif;
+	priv->rx_handlers[SCAN_COMPLETE_NOTIFICATION] =
+					iwl_rx_scan_complete_notif;
+}
+EXPORT_SYMBOL(iwl_setup_rx_scan_handlers);
+
+static inline u16 iwl_get_active_dwell_time(struct iwl_priv *priv,
+						enum ieee80211_band band)
+{
+	if (band == IEEE80211_BAND_5GHZ)
+		return IWL_ACTIVE_DWELL_TIME_52;
+	else
+		return IWL_ACTIVE_DWELL_TIME_24;
+}
+
+static u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
+					  enum ieee80211_band band)
+{
+	u16 active = iwl_get_active_dwell_time(priv, band);
+	u16 passive = (band != IEEE80211_BAND_5GHZ) ?
+	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_24 :
+	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_52;
+
+	if (iwl_is_associated(priv)) {
+		/* If we're associated, we clamp the maximum passive
+		 * dwell time to be 98% of the beacon interval (minus
+		 * 2 * channel tune time) */
+		passive = priv->beacon_int;
+		if ((passive > IWL_PASSIVE_DWELL_BASE) || !passive)
+			passive = IWL_PASSIVE_DWELL_BASE;
+		passive = (passive * 98) / 100 - IWL_CHANNEL_TUNE_TIME * 2;
+	}
+
+	if (passive <= active)
+		passive = active + 1;
+
+	return passive;
+}
+
+static int iwl_get_channels_for_scan(struct iwl_priv *priv,
+				     enum ieee80211_band band,
+				     u8 is_active, u8 direct_mask,
+				     struct iwl_scan_channel *scan_ch)
+{
+	const struct ieee80211_channel *channels = NULL;
+	const struct ieee80211_supported_band *sband;
+	const struct iwl_channel_info *ch_info;
+	u16 passive_dwell = 0;
+	u16 active_dwell = 0;
+	int added, i;
+
+	sband = iwl_get_hw_mode(priv, band);
+	if (!sband)
+		return 0;
+
+	channels = sband->channels;
+
+	active_dwell = iwl_get_active_dwell_time(priv, band);
+	passive_dwell = iwl_get_passive_dwell_time(priv, band);
+
+	for (i = 0, added = 0; i < sband->n_channels; i++) {
+		if (channels[i].flags & IEEE80211_CHAN_DISABLED)
+			continue;
+
+		scan_ch->channel =
+			ieee80211_frequency_to_channel(channels[i].center_freq);
+
+		ch_info = iwl_get_channel_info(priv, band,
+					 scan_ch->channel);
+		if (!is_channel_valid(ch_info)) {
+			IWL_DEBUG_SCAN("Channel %d is INVALID for this SKU.\n",
+				       scan_ch->channel);
+			continue;
+		}
+
+		if (!is_active || is_channel_passive(ch_info) ||
+		    (channels[i].flags & IEEE80211_CHAN_PASSIVE_SCAN))
+			scan_ch->type = 0;	/* passive */
+		else
+			scan_ch->type = 1;	/* active */
+
+		if (scan_ch->type & 1)
+			scan_ch->type |= (direct_mask << 1);
+
+		scan_ch->active_dwell = cpu_to_le16(active_dwell);
+		scan_ch->passive_dwell = cpu_to_le16(passive_dwell);
+
+		/* Set txpower levels to defaults */
+		scan_ch->tpc.dsp_atten = 110;
+		/* scan_pwr_info->tpc.dsp_atten; */
+
+		/*scan_pwr_info->tpc.tx_gain; */
+		if (band == IEEE80211_BAND_5GHZ)
+			scan_ch->tpc.tx_gain = ((1 << 5) | (3 << 3)) | 3;
+		else {
+			scan_ch->tpc.tx_gain = ((1 << 5) | (5 << 3));
+			/* NOTE: if we were doing 6Mb OFDM for scans we'd use
+			 * power level:
+			 * scan_ch->tpc.tx_gain = ((1 << 5) | (2 << 3)) | 3;
+			 */
+		}
+
+		IWL_DEBUG_SCAN("Scanning %d [%s %d]\n",
+			       scan_ch->channel,
+			       (scan_ch->type & 1) ? "ACTIVE" : "PASSIVE",
+			       (scan_ch->type & 1) ?
+			       active_dwell : passive_dwell);
+
+		scan_ch++;
+		added++;
+	}
+
+	IWL_DEBUG_SCAN("total channels to scan %d \n", added);
+	return added;
+}
+
+int iwl_scan_initiate(struct iwl_priv *priv)
+{
+	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
+		IWL_ERROR("APs don't scan.\n");
+		return 0;
+	}
+
+	if (!iwl_is_ready_rf(priv)) {
+		IWL_DEBUG_SCAN("Aborting scan due to not ready.\n");
+		return -EIO;
+	}
+
+	if (test_bit(STATUS_SCANNING, &priv->status)) {
+		IWL_DEBUG_SCAN("Scan already in progress.\n");
+		return -EAGAIN;
+	}
+
+	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
+		IWL_DEBUG_SCAN("Scan request while abort pending.  "
+			       "Queuing.\n");
+		return -EAGAIN;
+	}
+
+	IWL_DEBUG_INFO("Starting scan...\n");
+	priv->scan_bands = 2;
+	set_bit(STATUS_SCANNING, &priv->status);
+	priv->scan_start = jiffies;
+	priv->scan_pass_start = priv->scan_start;
+
+	queue_work(priv->workqueue, &priv->request_scan);
+
+	return 0;
+}
+EXPORT_SYMBOL(iwl_scan_initiate);
+
+#define IWL_SCAN_CHECK_WATCHDOG (7 * HZ)
+
+static void iwl_bg_scan_check(struct work_struct *data)
+{
+	struct iwl_priv *priv =
+	    container_of(data, struct iwl_priv, scan_check.work);
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	mutex_lock(&priv->mutex);
+	if (test_bit(STATUS_SCANNING, &priv->status) ||
+	    test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
+		IWL_DEBUG(IWL_DL_SCAN, "Scan completion watchdog resetting "
+			"adapter (%dms)\n",
+			jiffies_to_msecs(IWL_SCAN_CHECK_WATCHDOG));
+
+		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
+			iwl_send_scan_abort(priv);
+	}
+	mutex_unlock(&priv->mutex);
+}
+/**
+ * iwl_supported_rate_to_ie - fill in the supported rate in IE field
+ *
+ * return : set the bit for each supported rate insert in ie
+ */
+static u16 iwl_supported_rate_to_ie(u8 *ie, u16 supported_rate,
+				    u16 basic_rate, int *left)
+{
+	u16 ret_rates = 0, bit;
+	int i;
+	u8 *cnt = ie;
+	u8 *rates = ie + 1;
+
+	for (bit = 1, i = 0; i < IWL_RATE_COUNT; i++, bit <<= 1) {
+		if (bit & supported_rate) {
+			ret_rates |= bit;
+			rates[*cnt] = iwl_rates[i].ieee |
+				((bit & basic_rate) ? 0x80 : 0x00);
+			(*cnt)++;
+			(*left)--;
+			if ((*left <= 0) ||
+			    (*cnt >= IWL_SUPPORTED_RATES_IE_LEN))
+				break;
+		}
+	}
+
+	return ret_rates;
+}
+
+
+static void iwl_ht_cap_to_ie(const struct ieee80211_supported_band *sband,
+			u8 *pos, int *left)
+{
+	struct ieee80211_ht_cap *ht_cap;
+
+	if (!sband || !sband->ht_info.ht_supported)
+		return;
+
+	if (*left < sizeof(struct ieee80211_ht_cap))
+		return;
+
+	*pos++ = sizeof(struct ieee80211_ht_cap);
+	ht_cap = (struct ieee80211_ht_cap *) pos;
+
+	ht_cap->cap_info = cpu_to_le16(sband->ht_info.cap);
+	memcpy(ht_cap->supp_mcs_set, sband->ht_info.supp_mcs_set, 16);
+	ht_cap->ampdu_params_info =
+		(sband->ht_info.ampdu_factor & IEEE80211_HT_CAP_AMPDU_FACTOR) |
+		((sband->ht_info.ampdu_density << 2) &
+			IEEE80211_HT_CAP_AMPDU_DENSITY);
+	*left -= sizeof(struct ieee80211_ht_cap);
+}
+
+/**
+ * iwl_fill_probe_req - fill in all required fields and IE for probe request
+ */
+static u16 iwl_fill_probe_req(struct iwl_priv *priv,
+				  enum ieee80211_band band,
+				  struct ieee80211_mgmt *frame,
+				  int left, int is_direct)
+{
+	int len = 0;
+	u8 *pos = NULL;
+	u16 active_rates, ret_rates, cck_rates, active_rate_basic;
+	const struct ieee80211_supported_band *sband =
+						iwl_get_hw_mode(priv, band);
+
+	/* Make sure there is enough space for the probe request,
+	 * two mandatory IEs and the data */
+	left -= 24;
+	if (left < 0)
+		return 0;
+	len += 24;
+
+	frame->frame_control = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
+	memcpy(frame->da, iwl_bcast_addr, ETH_ALEN);
+	memcpy(frame->sa, priv->mac_addr, ETH_ALEN);
+	memcpy(frame->bssid, iwl_bcast_addr, ETH_ALEN);
+	frame->seq_ctrl = 0;
+
+	/* fill in our indirect SSID IE */
+	/* ...next IE... */
+
+	left -= 2;
+	if (left < 0)
+		return 0;
+	len += 2;
+	pos = &(frame->u.probe_req.variable[0]);
+	*pos++ = WLAN_EID_SSID;
+	*pos++ = 0;
+
+	/* fill in our direct SSID IE... */
+	if (is_direct) {
+		/* ...next IE... */
+		left -= 2 + priv->essid_len;
+		if (left < 0)
+			return 0;
+		/* ... fill it in... */
+		*pos++ = WLAN_EID_SSID;
+		*pos++ = priv->essid_len;
+		memcpy(pos, priv->essid, priv->essid_len);
+		pos += priv->essid_len;
+		len += 2 + priv->essid_len;
+	}
+
+	/* fill in supported rate */
+	/* ...next IE... */
+	left -= 2;
+	if (left < 0)
+		return 0;
+
+	/* ... fill it in... */
+	*pos++ = WLAN_EID_SUPP_RATES;
+	*pos = 0;
+
+	/* exclude 60M rate */
+	active_rates = priv->rates_mask;
+	active_rates &= ~IWL_RATE_60M_MASK;
+
+	active_rate_basic = active_rates & IWL_BASIC_RATES_MASK;
+
+	cck_rates = IWL_CCK_RATES_MASK & active_rates;
+	ret_rates = iwl_supported_rate_to_ie(pos, cck_rates,
+			active_rate_basic, &left);
+	active_rates &= ~ret_rates;
+
+	ret_rates = iwl_supported_rate_to_ie(pos, active_rates,
+				 active_rate_basic, &left);
+	active_rates &= ~ret_rates;
+
+	len += 2 + *pos;
+	pos += (*pos) + 1;
+	if (active_rates == 0)
+		goto fill_end;
+
+	/* fill in supported extended rate */
+	/* ...next IE... */
+	left -= 2;
+	if (left < 0)
+		return 0;
+	/* ... fill it in... */
+	*pos++ = WLAN_EID_EXT_SUPP_RATES;
+	*pos = 0;
+	iwl_supported_rate_to_ie(pos, active_rates,
+				 active_rate_basic, &left);
+	if (*pos > 0)
+		len += 2 + *pos;
+
+ fill_end:
+	/* fill in HT IE */
+	left -= 2;
+	if (left < 0)
+		return 0;
+
+	*pos++ = WLAN_EID_HT_CAPABILITY;
+	*pos = 0;
+
+	iwl_ht_cap_to_ie(sband, pos, &left);
+
+	if (*pos > 0)
+		len += 2 + *pos;
+	return (u16)len;
+}
+
+static void iwl_bg_request_scan(struct work_struct *data)
+{
+	struct iwl_priv *priv =
+	    container_of(data, struct iwl_priv, request_scan);
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_SCAN_CMD,
+		.len = sizeof(struct iwl_scan_cmd),
+		.meta.flags = CMD_SIZE_HUGE,
+	};
+	struct iwl_scan_cmd *scan;
+	struct ieee80211_conf *conf = NULL;
+	u16 cmd_len;
+	enum ieee80211_band band;
+	u8 direct_mask;
+	int ret = 0;
+
+	conf = ieee80211_get_hw_conf(priv->hw);
+
+	mutex_lock(&priv->mutex);
+
+	if (!iwl_is_ready(priv)) {
+		IWL_WARNING("request scan called when driver not ready.\n");
+		goto done;
+	}
+
+	/* Make sure the scan wasn't cancelled before this queued work
+	 * was given the chance to run... */
+	if (!test_bit(STATUS_SCANNING, &priv->status))
+		goto done;
+
+	/* This should never be called or scheduled if there is currently
+	 * a scan active in the hardware. */
+	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
+		IWL_DEBUG_INFO("Multiple concurrent scan requests in parallel. "
+			       "Ignoring second request.\n");
+		ret = -EIO;
+		goto done;
+	}
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
+		IWL_DEBUG_SCAN("Aborting scan due to device shutdown\n");
+		goto done;
+	}
+
+	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
+		IWL_DEBUG_HC("Scan request while abort pending.  Queuing.\n");
+		goto done;
+	}
+
+	if (iwl_is_rfkill(priv)) {
+		IWL_DEBUG_HC("Aborting scan due to RF Kill activation\n");
+		goto done;
+	}
+
+	if (!test_bit(STATUS_READY, &priv->status)) {
+		IWL_DEBUG_HC("Scan request while uninitialized.  Queuing.\n");
+		goto done;
+	}
+
+	if (!priv->scan_bands) {
+		IWL_DEBUG_HC("Aborting scan due to no requested bands\n");
+		goto done;
+	}
+
+	if (!priv->scan) {
+		priv->scan = kmalloc(sizeof(struct iwl_scan_cmd) +
+				     IWL_MAX_SCAN_SIZE, GFP_KERNEL);
+		if (!priv->scan) {
+			ret = -ENOMEM;
+			goto done;
+		}
+	}
+	scan = priv->scan;
+	memset(scan, 0, sizeof(struct iwl_scan_cmd) + IWL_MAX_SCAN_SIZE);
+
+	scan->quiet_plcp_th = IWL_PLCP_QUIET_THRESH;
+	scan->quiet_time = IWL_ACTIVE_QUIET_TIME;
+
+	if (iwl_is_associated(priv)) {
+		u16 interval = 0;
+		u32 extra;
+		u32 suspend_time = 100;
+		u32 scan_suspend_time = 100;
+		unsigned long flags;
+
+		IWL_DEBUG_INFO("Scanning while associated...\n");
+
+		spin_lock_irqsave(&priv->lock, flags);
+		interval = priv->beacon_int;
+		spin_unlock_irqrestore(&priv->lock, flags);
+
+		scan->suspend_time = 0;
+		scan->max_out_time = cpu_to_le32(200 * 1024);
+		if (!interval)
+			interval = suspend_time;
+
+		extra = (suspend_time / interval) << 22;
+		scan_suspend_time = (extra |
+		    ((suspend_time % interval) * 1024));
+		scan->suspend_time = cpu_to_le32(scan_suspend_time);
+		IWL_DEBUG_SCAN("suspend_time 0x%X beacon interval %d\n",
+			       scan_suspend_time, interval);
+	}
+
+	/* We should add the ability for user to lock to PASSIVE ONLY */
+	if (priv->one_direct_scan) {
+		IWL_DEBUG_SCAN
+		    ("Kicking off one direct scan for '%s'\n",
+		     iwl_escape_essid(priv->direct_ssid,
+				      priv->direct_ssid_len));
+		scan->direct_scan[0].id = WLAN_EID_SSID;
+		scan->direct_scan[0].len = priv->direct_ssid_len;
+		memcpy(scan->direct_scan[0].ssid,
+		       priv->direct_ssid, priv->direct_ssid_len);
+		direct_mask = 1;
+	} else if (!iwl_is_associated(priv) && priv->essid_len) {
+		IWL_DEBUG_SCAN
+		  ("Kicking off one direct scan for '%s' when not associated\n",
+		   iwl_escape_essid(priv->essid, priv->essid_len));
+		scan->direct_scan[0].id = WLAN_EID_SSID;
+		scan->direct_scan[0].len = priv->essid_len;
+		memcpy(scan->direct_scan[0].ssid, priv->essid, priv->essid_len);
+		direct_mask = 1;
+	} else {
+		IWL_DEBUG_SCAN("Kicking off one indirect scan.\n");
+		direct_mask = 0;
+	}
+
+	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
+	scan->tx_cmd.sta_id = priv->hw_params.bcast_sta_id;
+	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
+
+
+	switch (priv->scan_bands) {
+	case 2:
+		scan->flags = RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK;
+		scan->tx_cmd.rate_n_flags =
+				iwl4965_hw_set_rate_n_flags(IWL_RATE_1M_PLCP,
+				RATE_MCS_ANT_B_MSK|RATE_MCS_CCK_MSK);
+
+		scan->good_CRC_th = 0;
+		band = IEEE80211_BAND_2GHZ;
+		break;
+
+	case 1:
+		scan->tx_cmd.rate_n_flags =
+				iwl4965_hw_set_rate_n_flags(IWL_RATE_6M_PLCP,
+				RATE_MCS_ANT_B_MSK);
+		scan->good_CRC_th = IWL_GOOD_CRC_TH;
+		band = IEEE80211_BAND_5GHZ;
+		break;
+
+	default:
+		IWL_WARNING("Invalid scan band count\n");
+		goto done;
+	}
+
+	/* We don't build a direct scan probe request; the uCode will do
+	 * that based on the direct_mask added to each channel entry */
+	cmd_len = iwl_fill_probe_req(priv, band,
+					(struct ieee80211_mgmt *)scan->data,
+					IWL_MAX_SCAN_SIZE - sizeof(*scan), 0);
+
+	scan->tx_cmd.len = cpu_to_le16(cmd_len);
+	/* select Rx chains */
+
+	/* Force use of chains B and C (0x6) for scan Rx.
+	 * Avoid A (0x1) because of its off-channel reception on A-band.
+	 * MIMO is not used here, but value is required to make uCode happy. */
+	scan->rx_chain = RXON_RX_CHAIN_DRIVER_FORCE_MSK |
+			cpu_to_le16((0x7 << RXON_RX_CHAIN_VALID_POS) |
+			(0x6 << RXON_RX_CHAIN_FORCE_SEL_POS) |
+			(0x7 << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS));
+
+	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR)
+		scan->filter_flags = RXON_FILTER_PROMISC_MSK;
+
+	if (direct_mask)
+		scan->channel_count =
+			iwl_get_channels_for_scan(
+				priv, band, 1, /* active */
+				direct_mask,
+				(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
+	else
+		scan->channel_count =
+			iwl_get_channels_for_scan(
+				priv, band, 0, /* passive */
+				direct_mask,
+				(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
+
+	scan->filter_flags |= (RXON_FILTER_ACCEPT_GRP_MSK |
+			       RXON_FILTER_BCON_AWARE_MSK);
+	cmd.len += le16_to_cpu(scan->tx_cmd.len) +
+	    scan->channel_count * sizeof(struct iwl_scan_channel);
+	cmd.data = scan;
+	scan->len = cpu_to_le16(cmd.len);
+
+	set_bit(STATUS_SCAN_HW, &priv->status);
+	ret = iwl_send_cmd_sync(priv, &cmd);
+	if (ret)
+		goto done;
+
+	queue_delayed_work(priv->workqueue, &priv->scan_check,
+			   IWL_SCAN_CHECK_WATCHDOG);
+
+	mutex_unlock(&priv->mutex);
+	return;
+
+ done:
+	/* inform mac80211 scan aborted */
+	queue_work(priv->workqueue, &priv->scan_completed);
+	mutex_unlock(&priv->mutex);
+}
+
+static void iwl_bg_abort_scan(struct work_struct *work)
+{
+	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
+
+	if (!iwl_is_ready(priv))
+		return;
+
+	mutex_lock(&priv->mutex);
+
+	set_bit(STATUS_SCAN_ABORTING, &priv->status);
+	iwl_send_scan_abort(priv);
+
+	mutex_unlock(&priv->mutex);
+}
+
+void iwl_setup_scan_deferred_work(struct iwl_priv *priv)
+{
+	/*  FIXME: move here when resolved PENDING
+	 *  INIT_WORK(&priv->scan_completed, iwl_bg_scan_completed); */
+	INIT_WORK(&priv->request_scan, iwl_bg_request_scan);
+	INIT_WORK(&priv->abort_scan, iwl_bg_abort_scan);
+	INIT_DELAYED_WORK(&priv->scan_check, iwl_bg_scan_check);
+}
+EXPORT_SYMBOL(iwl_setup_scan_deferred_work);
+
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index af44819..4183bd5 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -87,46 +87,6 @@ MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT);
 MODULE_LICENSE("GPL");
 
-static int iwl4965_is_empty_essid(const char *essid, int essid_len)
-{
-	/* Single white space is for Linksys APs */
-	if (essid_len == 1 && essid[0] == ' ')
-		return 1;
-
-	/* Otherwise, if the entire essid is 0, we assume it is hidden */
-	while (essid_len) {
-		essid_len--;
-		if (essid[essid_len] != '\0')
-			return 0;
-	}
-
-	return 1;
-}
-
-static const char *iwl4965_escape_essid(const char *essid, u8 essid_len)
-{
-	static char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
-	const char *s = essid;
-	char *d = escaped;
-
-	if (iwl4965_is_empty_essid(essid, essid_len)) {
-		memcpy(escaped, "<hidden>", sizeof("<hidden>"));
-		return escaped;
-	}
-
-	essid_len = min(essid_len, (u8) IW_ESSID_MAX_SIZE);
-	while (essid_len--) {
-		if (*s == '\0') {
-			*d++ = '\\';
-			*d++ = '0';
-			s++;
-		} else
-			*d++ = *s++;
-	}
-	*d = '\0';
-	return escaped;
-}
-
 /*************** STATION TABLE MANAGEMENT ****
  * mac80211 should be examined to determine if sta_info is duplicating
  * the functionality provided here
@@ -419,47 +379,6 @@ static int iwl4965_send_bt_config(struct iwl_priv *priv)
 				sizeof(struct iwl4965_bt_cmd), &bt_cmd);
 }
 
-static int iwl4965_send_scan_abort(struct iwl_priv *priv)
-{
-	int ret = 0;
-	struct iwl_rx_packet *res;
-	struct iwl_host_cmd cmd = {
-		.id = REPLY_SCAN_ABORT_CMD,
-		.meta.flags = CMD_WANT_SKB,
-	};
-
-	/* If there isn't a scan actively going on in the hardware
-	 * then we are in between scan bands and not actually
-	 * actively scanning, so don't send the abort command */
-	if (!test_bit(STATUS_SCAN_HW, &priv->status)) {
-		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
-		return 0;
-	}
-
-	ret = iwl_send_cmd_sync(priv, &cmd);
-	if (ret) {
-		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
-		return ret;
-	}
-
-	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
-	if (res->u.status != CAN_ABORT_STATUS) {
-		/* The scan abort will return 1 for success or
-		 * 2 for "failure".  A failure condition can be
-		 * due to simply not being in an active scan which
-		 * can occur if we send the scan abort before we
-		 * the microcode has notified us that a scan is
-		 * completed. */
-		IWL_DEBUG_INFO("SCAN_ABORT returned %d.\n", res->u.status);
-		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
-		clear_bit(STATUS_SCAN_HW, &priv->status);
-	}
-
-	dev_kfree_skb_any(cmd.meta.u.skb);
-
-	return ret;
-}
-
 /*
  * CARD_STATE_CMD
  *
@@ -605,35 +524,6 @@ static int iwl4965_send_beacon_cmd(struct iwl_priv *priv)
  *
  ******************************************************************************/
 
-/**
- * iwl4965_supported_rate_to_ie - fill in the supported rate in IE field
- *
- * return : set the bit for each supported rate insert in ie
- */
-static u16 iwl4965_supported_rate_to_ie(u8 *ie, u16 supported_rate,
-				    u16 basic_rate, int *left)
-{
-	u16 ret_rates = 0, bit;
-	int i;
-	u8 *cnt = ie;
-	u8 *rates = ie + 1;
-
-	for (bit = 1, i = 0; i < IWL_RATE_COUNT; i++, bit <<= 1) {
-		if (bit & supported_rate) {
-			ret_rates |= bit;
-			rates[*cnt] = iwl_rates[i].ieee |
-				((bit & basic_rate) ? 0x80 : 0x00);
-			(*cnt)++;
-			(*left)--;
-			if ((*left <= 0) ||
-			    (*cnt >= IWL_SUPPORTED_RATES_IE_LEN))
-				break;
-		}
-	}
-
-	return ret_rates;
-}
-
 static void iwl4965_ht_conf(struct iwl_priv *priv,
 			    struct ieee80211_bss_conf *bss_conf)
 {
@@ -686,140 +576,6 @@ static void iwl4965_ht_conf(struct iwl_priv *priv,
 	IWL_DEBUG_MAC80211("leave\n");
 }
 
-static void iwl_ht_cap_to_ie(const struct ieee80211_supported_band *sband,
-			u8 *pos, int *left)
-{
-	struct ieee80211_ht_cap *ht_cap;
-
-	if (!sband || !sband->ht_info.ht_supported)
-		return;
-
-	if (*left < sizeof(struct ieee80211_ht_cap))
-		return;
-
-	*pos++ = sizeof(struct ieee80211_ht_cap);
-	ht_cap = (struct ieee80211_ht_cap *) pos;
-
-	ht_cap->cap_info = cpu_to_le16(sband->ht_info.cap);
-	memcpy(ht_cap->supp_mcs_set, sband->ht_info.supp_mcs_set, 16);
-	ht_cap->ampdu_params_info =
-		(sband->ht_info.ampdu_factor & IEEE80211_HT_CAP_AMPDU_FACTOR) |
-		((sband->ht_info.ampdu_density << 2) &
-			IEEE80211_HT_CAP_AMPDU_DENSITY);
-	*left -= sizeof(struct ieee80211_ht_cap);
-}
-
-/**
- * iwl4965_fill_probe_req - fill in all required fields and IE for probe request
- */
-static u16 iwl4965_fill_probe_req(struct iwl_priv *priv,
-				  enum ieee80211_band band,
-				  struct ieee80211_mgmt *frame,
-				  int left, int is_direct)
-{
-	int len = 0;
-	u8 *pos = NULL;
-	u16 active_rates, ret_rates, cck_rates, active_rate_basic;
-	const struct ieee80211_supported_band *sband =
-						iwl_get_hw_mode(priv, band);
-
-	/* Make sure there is enough space for the probe request,
-	 * two mandatory IEs and the data */
-	left -= 24;
-	if (left < 0)
-		return 0;
-	len += 24;
-
-	frame->frame_control = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
-	memcpy(frame->da, iwl_bcast_addr, ETH_ALEN);
-	memcpy(frame->sa, priv->mac_addr, ETH_ALEN);
-	memcpy(frame->bssid, iwl_bcast_addr, ETH_ALEN);
-	frame->seq_ctrl = 0;
-
-	/* fill in our indirect SSID IE */
-	/* ...next IE... */
-
-	left -= 2;
-	if (left < 0)
-		return 0;
-	len += 2;
-	pos = &(frame->u.probe_req.variable[0]);
-	*pos++ = WLAN_EID_SSID;
-	*pos++ = 0;
-
-	/* fill in our direct SSID IE... */
-	if (is_direct) {
-		/* ...next IE... */
-		left -= 2 + priv->essid_len;
-		if (left < 0)
-			return 0;
-		/* ... fill it in... */
-		*pos++ = WLAN_EID_SSID;
-		*pos++ = priv->essid_len;
-		memcpy(pos, priv->essid, priv->essid_len);
-		pos += priv->essid_len;
-		len += 2 + priv->essid_len;
-	}
-
-	/* fill in supported rate */
-	/* ...next IE... */
-	left -= 2;
-	if (left < 0)
-		return 0;
-
-	/* ... fill it in... */
-	*pos++ = WLAN_EID_SUPP_RATES;
-	*pos = 0;
-
-	/* exclude 60M rate */
-	active_rates = priv->rates_mask;
-	active_rates &= ~IWL_RATE_60M_MASK;
-
-	active_rate_basic = active_rates & IWL_BASIC_RATES_MASK;
-
-	cck_rates = IWL_CCK_RATES_MASK & active_rates;
-	ret_rates = iwl4965_supported_rate_to_ie(pos, cck_rates,
-			active_rate_basic, &left);
-	active_rates &= ~ret_rates;
-
-	ret_rates = iwl4965_supported_rate_to_ie(pos, active_rates,
-				 active_rate_basic, &left);
-	active_rates &= ~ret_rates;
-
-	len += 2 + *pos;
-	pos += (*pos) + 1;
-	if (active_rates == 0)
-		goto fill_end;
-
-	/* fill in supported extended rate */
-	/* ...next IE... */
-	left -= 2;
-	if (left < 0)
-		return 0;
-	/* ... fill it in... */
-	*pos++ = WLAN_EID_EXT_SUPP_RATES;
-	*pos = 0;
-	iwl4965_supported_rate_to_ie(pos, active_rates,
-				 active_rate_basic, &left);
-	if (*pos > 0)
-		len += 2 + *pos;
-
- fill_end:
-	/* fill in HT IE */
-	left -= 2;
-	if (left < 0)
-		return 0;
-
-	*pos++ = WLAN_EID_HT_CAPABILITY;
-	*pos = 0;
-
-	iwl_ht_cap_to_ie(sband, pos, &left);
-
-	if (*pos > 0)
-		len += 2 + *pos;
-	return (u16)len;
-}
-
 /*
  * QoS  support
 */
@@ -897,60 +653,6 @@ int iwl4965_is_network_packet(struct iwl_priv *priv, struct ieee80211_hdr *heade
 	return 1;
 }
 
-
-
-/**
- * iwl4965_scan_cancel - Cancel any currently executing HW scan
- *
- * NOTE: priv->mutex is not required before calling this function
- */
-static int iwl4965_scan_cancel(struct iwl_priv *priv)
-{
-	if (!test_bit(STATUS_SCAN_HW, &priv->status)) {
-		clear_bit(STATUS_SCANNING, &priv->status);
-		return 0;
-	}
-
-	if (test_bit(STATUS_SCANNING, &priv->status)) {
-		if (!test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-			IWL_DEBUG_SCAN("Queuing scan abort.\n");
-			set_bit(STATUS_SCAN_ABORTING, &priv->status);
-			queue_work(priv->workqueue, &priv->abort_scan);
-
-		} else
-			IWL_DEBUG_SCAN("Scan abort already in progress.\n");
-
-		return test_bit(STATUS_SCANNING, &priv->status);
-	}
-
-	return 0;
-}
-
-/**
- * iwl4965_scan_cancel_timeout - Cancel any currently executing HW scan
- * @ms: amount of time to wait (in milliseconds) for scan to abort
- *
- * NOTE: priv->mutex must be held before calling this function
- */
-static int iwl4965_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
-{
-	unsigned long now = jiffies;
-	int ret;
-
-	ret = iwl4965_scan_cancel(priv);
-	if (ret && ms) {
-		mutex_unlock(&priv->mutex);
-		while (!time_after(jiffies, now + msecs_to_jiffies(ms)) &&
-				test_bit(STATUS_SCANNING, &priv->status))
-			msleep(1);
-		mutex_lock(&priv->mutex);
-
-		return test_bit(STATUS_SCANNING, &priv->status);
-	}
-
-	return ret;
-}
-
 static void iwl4965_sequence_reset(struct iwl_priv *priv)
 {
 	/* Reset ieee stats */
@@ -962,7 +664,7 @@ static void iwl4965_sequence_reset(struct iwl_priv *priv)
 	priv->last_frag_num = -1;
 	priv->last_packet_time = 0;
 
-	iwl4965_scan_cancel(priv);
+	iwl_scan_cancel(priv);
 }
 
 #define MAX_UCODE_BEACON_INTERVAL	4096
@@ -1037,41 +739,6 @@ static void iwl4965_setup_rxon_timing(struct iwl_priv *priv)
 		le16_to_cpu(priv->rxon_timing.atim_window));
 }
 
-static int iwl4965_scan_initiate(struct iwl_priv *priv)
-{
-	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
-		IWL_ERROR("APs don't scan.\n");
-		return 0;
-	}
-
-	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_SCAN("Aborting scan due to not ready.\n");
-		return -EIO;
-	}
-
-	if (test_bit(STATUS_SCANNING, &priv->status)) {
-		IWL_DEBUG_SCAN("Scan already in progress.\n");
-		return -EAGAIN;
-	}
-
-	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_SCAN("Scan request while abort pending.  "
-			       "Queuing.\n");
-		return -EAGAIN;
-	}
-
-	IWL_DEBUG_INFO("Starting scan...\n");
-	priv->scan_bands = 2;
-	set_bit(STATUS_SCANNING, &priv->status);
-	priv->scan_start = jiffies;
-	priv->scan_pass_start = priv->scan_start;
-
-	queue_work(priv->workqueue, &priv->request_scan);
-
-	return 0;
-}
-
-
 static void iwl_set_flags_for_band(struct iwl_priv *priv,
 				   enum ieee80211_band band)
 {
@@ -1191,7 +858,7 @@ static int iwl4965_set_mode(struct iwl_priv *priv, int mode)
 		return -EAGAIN;
 
 	cancel_delayed_work(&priv->scan_check);
-	if (iwl4965_scan_cancel_timeout(priv, 100)) {
+	if (iwl_scan_cancel_timeout(priv, 100)) {
 		IWL_WARNING("Aborted scan still in progress after 100ms\n");
 		IWL_DEBUG_MAC80211("leaving - scan abort failed.\n");
 		return -EAGAIN;
@@ -1260,7 +927,7 @@ int iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 			  disable_radio ? "OFF" : "ON");
 
 	if (disable_radio) {
-		iwl4965_scan_cancel(priv);
+		iwl_scan_cancel(priv);
 		/* FIXME: This is a workaround for AP */
 		if (priv->iw_mode != IEEE80211_IF_TYPE_AP) {
 			spin_lock_irqsave(&priv->lock, flags);
@@ -1680,118 +1347,6 @@ static void iwl4965_rx_beacon_notif(struct iwl_priv *priv,
 		queue_work(priv->workqueue, &priv->beacon_update);
 }
 
-/* Service response to REPLY_SCAN_CMD (0x80) */
-static void iwl4965_rx_reply_scan(struct iwl_priv *priv,
-			      struct iwl_rx_mem_buffer *rxb)
-{
-#ifdef CONFIG_IWLWIFI_DEBUG
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	struct iwl4965_scanreq_notification *notif =
-	    (struct iwl4965_scanreq_notification *)pkt->u.raw;
-
-	IWL_DEBUG_RX("Scan request status = 0x%x\n", notif->status);
-#endif
-}
-
-/* Service SCAN_START_NOTIFICATION (0x82) */
-static void iwl4965_rx_scan_start_notif(struct iwl_priv *priv,
-				    struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	struct iwl4965_scanstart_notification *notif =
-	    (struct iwl4965_scanstart_notification *)pkt->u.raw;
-	priv->scan_start_tsf = le32_to_cpu(notif->tsf_low);
-	IWL_DEBUG_SCAN("Scan start: "
-		       "%d [802.11%s] "
-		       "(TSF: 0x%08X:%08X) - %d (beacon timer %u)\n",
-		       notif->channel,
-		       notif->band ? "bg" : "a",
-		       notif->tsf_high,
-		       notif->tsf_low, notif->status, notif->beacon_timer);
-}
-
-/* Service SCAN_RESULTS_NOTIFICATION (0x83) */
-static void iwl4965_rx_scan_results_notif(struct iwl_priv *priv,
-				      struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	struct iwl4965_scanresults_notification *notif =
-	    (struct iwl4965_scanresults_notification *)pkt->u.raw;
-
-	IWL_DEBUG_SCAN("Scan ch.res: "
-		       "%d [802.11%s] "
-		       "(TSF: 0x%08X:%08X) - %d "
-		       "elapsed=%lu usec (%dms since last)\n",
-		       notif->channel,
-		       notif->band ? "bg" : "a",
-		       le32_to_cpu(notif->tsf_high),
-		       le32_to_cpu(notif->tsf_low),
-		       le32_to_cpu(notif->statistics[0]),
-		       le32_to_cpu(notif->tsf_low) - priv->scan_start_tsf,
-		       jiffies_to_msecs(elapsed_jiffies
-					(priv->last_scan_jiffies, jiffies)));
-
-	priv->last_scan_jiffies = jiffies;
-	priv->next_scan_jiffies = 0;
-}
-
-/* Service SCAN_COMPLETE_NOTIFICATION (0x84) */
-static void iwl4965_rx_scan_complete_notif(struct iwl_priv *priv,
-				       struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	struct iwl4965_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
-
-	IWL_DEBUG_SCAN("Scan complete: %d channels (TSF 0x%08X:%08X) - %d\n",
-		       scan_notif->scanned_channels,
-		       scan_notif->tsf_low,
-		       scan_notif->tsf_high, scan_notif->status);
-
-	/* The HW is no longer scanning */
-	clear_bit(STATUS_SCAN_HW, &priv->status);
-
-	/* The scan completion notification came in, so kill that timer... */
-	cancel_delayed_work(&priv->scan_check);
-
-	IWL_DEBUG_INFO("Scan pass on %sGHz took %dms\n",
-		       (priv->scan_bands == 2) ? "2.4" : "5.2",
-		       jiffies_to_msecs(elapsed_jiffies
-					(priv->scan_pass_start, jiffies)));
-
-	/* Remove this scanned band from the list
-	 * of pending bands to scan */
-	priv->scan_bands--;
-
-	/* If a request to abort was given, or the scan did not succeed
-	 * then we reset the scan state machine and terminate,
-	 * re-queuing another scan if one has been requested */
-	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_INFO("Aborted scan completed.\n");
-		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
-	} else {
-		/* If there are more bands on this scan pass reschedule */
-		if (priv->scan_bands > 0)
-			goto reschedule;
-	}
-
-	priv->last_scan_jiffies = jiffies;
-	priv->next_scan_jiffies = 0;
-	IWL_DEBUG_INFO("Setting scan to off\n");
-
-	clear_bit(STATUS_SCANNING, &priv->status);
-
-	IWL_DEBUG_INFO("Scan took %dms\n",
-		jiffies_to_msecs(elapsed_jiffies(priv->scan_start, jiffies)));
-
-	queue_work(priv->workqueue, &priv->scan_completed);
-
-	return;
-
-reschedule:
-	priv->scan_pass_start = jiffies;
-	queue_work(priv->workqueue, &priv->request_scan);
-}
-
 /* Handle notification from uCode that card's power state is changing
  * due to software, hardware, or critical temperature RFKILL */
 static void iwl4965_rx_card_state_notif(struct iwl_priv *priv,
@@ -1852,7 +1407,7 @@ static void iwl4965_rx_card_state_notif(struct iwl_priv *priv,
 		clear_bit(STATUS_RF_KILL_SW, &priv->status);
 
 	if (!(flags & RXON_CARD_DISABLED))
-		iwl4965_scan_cancel(priv);
+		iwl_scan_cancel(priv);
 
 	if ((test_bit(STATUS_RF_KILL_HW, &status) !=
 	     test_bit(STATUS_RF_KILL_HW, &priv->status)) ||
@@ -1902,13 +1457,9 @@ static void iwl4965_setup_rx_handlers(struct iwl_priv *priv)
 	 */
 	priv->rx_handlers[REPLY_STATISTICS_CMD] = iwl4965_hw_rx_statistics;
 	priv->rx_handlers[STATISTICS_NOTIFICATION] = iwl4965_hw_rx_statistics;
-	/* scan handlers */
-	priv->rx_handlers[REPLY_SCAN_CMD] = iwl4965_rx_reply_scan;
-	priv->rx_handlers[SCAN_START_NOTIFICATION] = iwl4965_rx_scan_start_notif;
-	priv->rx_handlers[SCAN_RESULTS_NOTIFICATION] =
-	    iwl4965_rx_scan_results_notif;
-	priv->rx_handlers[SCAN_COMPLETE_NOTIFICATION] =
-	    iwl4965_rx_scan_complete_notif;
+
+	iwl_setup_rx_scan_handlers(priv);
+
 	/* status change handler */
 	priv->rx_handlers[CARD_STATE_NOTIFICATION] = iwl4965_rx_card_state_notif;
 
@@ -2456,138 +2007,6 @@ static irqreturn_t iwl4965_isr(int irq, void *data)
 	return IRQ_NONE;
 }
 
-/* For active scan, listen ACTIVE_DWELL_TIME (msec) on each channel after
- * sending probe req.  This should be set long enough to hear probe responses
- * from more than one AP.  */
-#define IWL_ACTIVE_DWELL_TIME_24    (20)	/* all times in msec */
-#define IWL_ACTIVE_DWELL_TIME_52    (10)
-
-/* For faster active scanning, scan will move to the next channel if fewer than
- * PLCP_QUIET_THRESH packets are heard on this channel within
- * ACTIVE_QUIET_TIME after sending probe request.  This shortens the dwell
- * time if it's a quiet channel (nothing responded to our probe, and there's
- * no other traffic).
- * Disable "quiet" feature by setting PLCP_QUIET_THRESH to 0. */
-#define IWL_PLCP_QUIET_THRESH       __constant_cpu_to_le16(1)	/* packets */
-#define IWL_ACTIVE_QUIET_TIME       __constant_cpu_to_le16(5)	/* msec */
-
-/* For passive scan, listen PASSIVE_DWELL_TIME (msec) on each channel.
- * Must be set longer than active dwell time.
- * For the most reliable scan, set > AP beacon interval (typically 100msec). */
-#define IWL_PASSIVE_DWELL_TIME_24   (20)	/* all times in msec */
-#define IWL_PASSIVE_DWELL_TIME_52   (10)
-#define IWL_PASSIVE_DWELL_BASE      (100)
-#define IWL_CHANNEL_TUNE_TIME       5
-
-static inline u16 iwl4965_get_active_dwell_time(struct iwl_priv *priv,
-						enum ieee80211_band band)
-{
-	if (band == IEEE80211_BAND_5GHZ)
-		return IWL_ACTIVE_DWELL_TIME_52;
-	else
-		return IWL_ACTIVE_DWELL_TIME_24;
-}
-
-static u16 iwl4965_get_passive_dwell_time(struct iwl_priv *priv,
-					  enum ieee80211_band band)
-{
-	u16 active = iwl4965_get_active_dwell_time(priv, band);
-	u16 passive = (band != IEEE80211_BAND_5GHZ) ?
-	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_24 :
-	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_52;
-
-	if (iwl_is_associated(priv)) {
-		/* If we're associated, we clamp the maximum passive
-		 * dwell time to be 98% of the beacon interval (minus
-		 * 2 * channel tune time) */
-		passive = priv->beacon_int;
-		if ((passive > IWL_PASSIVE_DWELL_BASE) || !passive)
-			passive = IWL_PASSIVE_DWELL_BASE;
-		passive = (passive * 98) / 100 - IWL_CHANNEL_TUNE_TIME * 2;
-	}
-
-	if (passive <= active)
-		passive = active + 1;
-
-	return passive;
-}
-
-static int iwl4965_get_channels_for_scan(struct iwl_priv *priv,
-					 enum ieee80211_band band,
-				     u8 is_active, u8 direct_mask,
-				     struct iwl4965_scan_channel *scan_ch)
-{
-	const struct ieee80211_channel *channels = NULL;
-	const struct ieee80211_supported_band *sband;
-	const struct iwl_channel_info *ch_info;
-	u16 passive_dwell = 0;
-	u16 active_dwell = 0;
-	int added, i;
-
-	sband = iwl_get_hw_mode(priv, band);
-	if (!sband)
-		return 0;
-
-	channels = sband->channels;
-
-	active_dwell = iwl4965_get_active_dwell_time(priv, band);
-	passive_dwell = iwl4965_get_passive_dwell_time(priv, band);
-
-	for (i = 0, added = 0; i < sband->n_channels; i++) {
-		if (channels[i].flags & IEEE80211_CHAN_DISABLED)
-			continue;
-
-		scan_ch->channel = ieee80211_frequency_to_channel(channels[i].center_freq);
-
-		ch_info = iwl_get_channel_info(priv, band,
-					 scan_ch->channel);
-		if (!is_channel_valid(ch_info)) {
-			IWL_DEBUG_SCAN("Channel %d is INVALID for this SKU.\n",
-				       scan_ch->channel);
-			continue;
-		}
-
-		if (!is_active || is_channel_passive(ch_info) ||
-		    (channels[i].flags & IEEE80211_CHAN_PASSIVE_SCAN))
-			scan_ch->type = 0;	/* passive */
-		else
-			scan_ch->type = 1;	/* active */
-
-		if (scan_ch->type & 1)
-			scan_ch->type |= (direct_mask << 1);
-
-		scan_ch->active_dwell = cpu_to_le16(active_dwell);
-		scan_ch->passive_dwell = cpu_to_le16(passive_dwell);
-
-		/* Set txpower levels to defaults */
-		scan_ch->tpc.dsp_atten = 110;
-		/* scan_pwr_info->tpc.dsp_atten; */
-
-		/*scan_pwr_info->tpc.tx_gain; */
-		if (band == IEEE80211_BAND_5GHZ)
-			scan_ch->tpc.tx_gain = ((1 << 5) | (3 << 3)) | 3;
-		else {
-			scan_ch->tpc.tx_gain = ((1 << 5) | (5 << 3));
-			/* NOTE: if we were doing 6Mb OFDM for scans we'd use
-			 * power level:
-			 * scan_ch->tpc.tx_gain = ((1 << 5) | (2 << 3)) | 3;
-			 */
-		}
-
-		IWL_DEBUG_SCAN("Scanning %d [%s %d]\n",
-			       scan_ch->channel,
-			       (scan_ch->type & 1) ? "ACTIVE" : "PASSIVE",
-			       (scan_ch->type & 1) ?
-			       active_dwell : passive_dwell);
-
-		scan_ch++;
-		added++;
-	}
-
-	IWL_DEBUG_SCAN("total channels to scan %d \n", added);
-	return added;
-}
-
 /******************************************************************************
  *
  * uCode download functions
@@ -3200,243 +2619,6 @@ static void iwl4965_bg_set_monitor(struct work_struct *work)
 	mutex_unlock(&priv->mutex);
 }
 
-#define IWL_SCAN_CHECK_WATCHDOG (7 * HZ)
-
-static void iwl4965_bg_scan_check(struct work_struct *data)
-{
-	struct iwl_priv *priv =
-	    container_of(data, struct iwl_priv, scan_check.work);
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	mutex_lock(&priv->mutex);
-	if (test_bit(STATUS_SCANNING, &priv->status) ||
-	    test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG(IWL_DL_SCAN, "Scan completion watchdog resetting "
-			"adapter (%dms)\n",
-			jiffies_to_msecs(IWL_SCAN_CHECK_WATCHDOG));
-
-		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
-			iwl4965_send_scan_abort(priv);
-	}
-	mutex_unlock(&priv->mutex);
-}
-
-static void iwl4965_bg_request_scan(struct work_struct *data)
-{
-	struct iwl_priv *priv =
-	    container_of(data, struct iwl_priv, request_scan);
-	struct iwl_host_cmd cmd = {
-		.id = REPLY_SCAN_CMD,
-		.len = sizeof(struct iwl4965_scan_cmd),
-		.meta.flags = CMD_SIZE_HUGE,
-	};
-	struct iwl4965_scan_cmd *scan;
-	struct ieee80211_conf *conf = NULL;
-	u16 cmd_len;
-	enum ieee80211_band band;
-	u8 direct_mask;
-	int ret = 0;
-
-	conf = ieee80211_get_hw_conf(priv->hw);
-
-	mutex_lock(&priv->mutex);
-
-	if (!iwl_is_ready(priv)) {
-		IWL_WARNING("request scan called when driver not ready.\n");
-		goto done;
-	}
-
-	/* Make sure the scan wasn't cancelled before this queued work
-	 * was given the chance to run... */
-	if (!test_bit(STATUS_SCANNING, &priv->status))
-		goto done;
-
-	/* This should never be called or scheduled if there is currently
-	 * a scan active in the hardware. */
-	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
-		IWL_DEBUG_INFO("Multiple concurrent scan requests in parallel. "
-			       "Ignoring second request.\n");
-		ret = -EIO;
-		goto done;
-	}
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
-		IWL_DEBUG_SCAN("Aborting scan due to device shutdown\n");
-		goto done;
-	}
-
-	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_HC("Scan request while abort pending.  Queuing.\n");
-		goto done;
-	}
-
-	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_HC("Aborting scan due to RF Kill activation\n");
-		goto done;
-	}
-
-	if (!test_bit(STATUS_READY, &priv->status)) {
-		IWL_DEBUG_HC("Scan request while uninitialized.  Queuing.\n");
-		goto done;
-	}
-
-	if (!priv->scan_bands) {
-		IWL_DEBUG_HC("Aborting scan due to no requested bands\n");
-		goto done;
-	}
-
-	if (!priv->scan) {
-		priv->scan = kmalloc(sizeof(struct iwl4965_scan_cmd) +
-				     IWL_MAX_SCAN_SIZE, GFP_KERNEL);
-		if (!priv->scan) {
-			ret = -ENOMEM;
-			goto done;
-		}
-	}
-	scan = priv->scan;
-	memset(scan, 0, sizeof(struct iwl4965_scan_cmd) + IWL_MAX_SCAN_SIZE);
-
-	scan->quiet_plcp_th = IWL_PLCP_QUIET_THRESH;
-	scan->quiet_time = IWL_ACTIVE_QUIET_TIME;
-
-	if (iwl_is_associated(priv)) {
-		u16 interval = 0;
-		u32 extra;
-		u32 suspend_time = 100;
-		u32 scan_suspend_time = 100;
-		unsigned long flags;
-
-		IWL_DEBUG_INFO("Scanning while associated...\n");
-
-		spin_lock_irqsave(&priv->lock, flags);
-		interval = priv->beacon_int;
-		spin_unlock_irqrestore(&priv->lock, flags);
-
-		scan->suspend_time = 0;
-		scan->max_out_time = cpu_to_le32(200 * 1024);
-		if (!interval)
-			interval = suspend_time;
-
-		extra = (suspend_time / interval) << 22;
-		scan_suspend_time = (extra |
-		    ((suspend_time % interval) * 1024));
-		scan->suspend_time = cpu_to_le32(scan_suspend_time);
-		IWL_DEBUG_SCAN("suspend_time 0x%X beacon interval %d\n",
-			       scan_suspend_time, interval);
-	}
-
-	/* We should add the ability for user to lock to PASSIVE ONLY */
-	if (priv->one_direct_scan) {
-		IWL_DEBUG_SCAN
-		    ("Kicking off one direct scan for '%s'\n",
-		     iwl4965_escape_essid(priv->direct_ssid,
-				      priv->direct_ssid_len));
-		scan->direct_scan[0].id = WLAN_EID_SSID;
-		scan->direct_scan[0].len = priv->direct_ssid_len;
-		memcpy(scan->direct_scan[0].ssid,
-		       priv->direct_ssid, priv->direct_ssid_len);
-		direct_mask = 1;
-	} else if (!iwl_is_associated(priv) && priv->essid_len) {
-		IWL_DEBUG_SCAN
-		  ("Kicking off one direct scan for '%s' when not associated\n",
-		   iwl4965_escape_essid(priv->essid, priv->essid_len));
-		scan->direct_scan[0].id = WLAN_EID_SSID;
-		scan->direct_scan[0].len = priv->essid_len;
-		memcpy(scan->direct_scan[0].ssid, priv->essid, priv->essid_len);
-		direct_mask = 1;
-	} else {
-		IWL_DEBUG_SCAN("Kicking off one indirect scan.\n");
-		direct_mask = 0;
-	}
-
-	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
-	scan->tx_cmd.sta_id = priv->hw_params.bcast_sta_id;
-	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
-
-
-	switch (priv->scan_bands) {
-	case 2:
-		scan->flags = RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK;
-		scan->tx_cmd.rate_n_flags =
-				iwl4965_hw_set_rate_n_flags(IWL_RATE_1M_PLCP,
-				RATE_MCS_ANT_B_MSK|RATE_MCS_CCK_MSK);
-
-		scan->good_CRC_th = 0;
-		band = IEEE80211_BAND_2GHZ;
-		break;
-
-	case 1:
-		scan->tx_cmd.rate_n_flags =
-				iwl4965_hw_set_rate_n_flags(IWL_RATE_6M_PLCP,
-				RATE_MCS_ANT_B_MSK);
-		scan->good_CRC_th = IWL_GOOD_CRC_TH;
-		band = IEEE80211_BAND_5GHZ;
-		break;
-
-	default:
-		IWL_WARNING("Invalid scan band count\n");
-		goto done;
-	}
-
-	/* We don't build a direct scan probe request; the uCode will do
-	 * that based on the direct_mask added to each channel entry */
-	cmd_len = iwl4965_fill_probe_req(priv, band,
-					(struct ieee80211_mgmt *)scan->data,
-					IWL_MAX_SCAN_SIZE - sizeof(*scan), 0);
-
-	scan->tx_cmd.len = cpu_to_le16(cmd_len);
-	/* select Rx chains */
-
-	/* Force use of chains B and C (0x6) for scan Rx.
-	 * Avoid A (0x1) because of its off-channel reception on A-band.
-	 * MIMO is not used here, but value is required to make uCode happy. */
-	scan->rx_chain = RXON_RX_CHAIN_DRIVER_FORCE_MSK |
-			cpu_to_le16((0x7 << RXON_RX_CHAIN_VALID_POS) |
-			(0x6 << RXON_RX_CHAIN_FORCE_SEL_POS) |
-			(0x7 << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS));
-
-	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR)
-		scan->filter_flags = RXON_FILTER_PROMISC_MSK;
-
-	if (direct_mask)
-		scan->channel_count =
-			iwl4965_get_channels_for_scan(
-				priv, band, 1, /* active */
-				direct_mask,
-				(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
-	else
-		scan->channel_count =
-			iwl4965_get_channels_for_scan(
-				priv, band, 0, /* passive */
-				direct_mask,
-				(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
-
-	scan->filter_flags |= (RXON_FILTER_ACCEPT_GRP_MSK |
-			       RXON_FILTER_BCON_AWARE_MSK);
-	cmd.len += le16_to_cpu(scan->tx_cmd.len) +
-	    scan->channel_count * sizeof(struct iwl4965_scan_channel);
-	cmd.data = scan;
-	scan->len = cpu_to_le16(cmd.len);
-
-	set_bit(STATUS_SCAN_HW, &priv->status);
-	ret = iwl_send_cmd_sync(priv, &cmd);
-	if (ret)
-		goto done;
-
-	queue_delayed_work(priv->workqueue, &priv->scan_check,
-			   IWL_SCAN_CHECK_WATCHDOG);
-
-	mutex_unlock(&priv->mutex);
-	return;
-
- done:
-	/* inform mac80211 scan aborted */
-	queue_work(priv->workqueue, &priv->scan_completed);
-	mutex_unlock(&priv->mutex);
-}
-
 static void iwl_bg_run_time_calib_work(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv,
@@ -3521,7 +2703,7 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 	if (!priv->vif || !priv->is_open)
 		return;
 
-	iwl4965_scan_cancel_timeout(priv, 200);
+	iwl_scan_cancel_timeout(priv, 200);
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
@@ -3615,24 +2797,9 @@ static void iwl4965_bg_post_associate(struct work_struct *data)
 
 }
 
-static void iwl4965_bg_abort_scan(struct work_struct *work)
-{
-	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
-
-	if (!iwl_is_ready(priv))
-		return;
-
-	mutex_lock(&priv->mutex);
-
-	set_bit(STATUS_SCAN_ABORTING, &priv->status);
-	iwl4965_send_scan_abort(priv);
-
-	mutex_unlock(&priv->mutex);
-}
-
 static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
 
-static void iwl4965_bg_scan_completed(struct work_struct *work)
+static void iwl_bg_scan_completed(struct work_struct *work)
 {
 	struct iwl_priv *priv =
 	    container_of(work, struct iwl_priv, scan_completed);
@@ -3759,7 +2926,7 @@ static void iwl4965_mac_stop(struct ieee80211_hw *hw)
 		 * RXON_FILTER_ASSOC_MSK BIT
 		 */
 		mutex_lock(&priv->mutex);
-		iwl4965_scan_cancel_timeout(priv, 100);
+		iwl_scan_cancel_timeout(priv, 100);
 		cancel_delayed_work(&priv->post_associate);
 		mutex_unlock(&priv->mutex);
 	}
@@ -4071,7 +3238,7 @@ static int iwl4965_mac_config_interface(struct ieee80211_hw *hw,
 	    !is_multicast_ether_addr(conf->bssid)) {
 		/* If there is currently a HW scan going on in the background
 		 * then we need to cancel it else the RXON below will fail. */
-		if (iwl4965_scan_cancel_timeout(priv, 100)) {
+		if (iwl_scan_cancel_timeout(priv, 100)) {
 			IWL_WARNING("Aborted scan still in progress "
 				    "after 100ms\n");
 			IWL_DEBUG_MAC80211("leaving - scan abort failed.\n");
@@ -4096,7 +3263,7 @@ static int iwl4965_mac_config_interface(struct ieee80211_hw *hw,
 		}
 
 	} else {
-		iwl4965_scan_cancel_timeout(priv, 100);
+		iwl_scan_cancel_timeout(priv, 100);
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwl4965_commit_rxon(priv);
 	}
@@ -4154,7 +3321,7 @@ static void iwl4965_mac_remove_interface(struct ieee80211_hw *hw,
 	mutex_lock(&priv->mutex);
 
 	if (iwl_is_ready_rf(priv)) {
-		iwl4965_scan_cancel_timeout(priv, 100);
+		iwl_scan_cancel_timeout(priv, 100);
 		cancel_delayed_work(&priv->post_associate);
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwl4965_commit_rxon(priv);
@@ -4268,7 +3435,7 @@ static int iwl4965_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 	}
 	if (len) {
 		IWL_DEBUG_SCAN("direct scan for %s [%d]\n ",
-			       iwl4965_escape_essid(ssid, len), (int)len);
+			       iwl_escape_essid(ssid, len), (int)len);
 
 		priv->one_direct_scan = 1;
 		priv->direct_ssid_len = (u8)
@@ -4277,7 +3444,7 @@ static int iwl4965_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 	} else
 		priv->one_direct_scan = 0;
 
-	rc = iwl4965_scan_initiate(priv);
+	rc = iwl_scan_initiate(priv);
 
 	IWL_DEBUG_MAC80211("leave\n");
 
@@ -4308,7 +3475,7 @@ static void iwl4965_mac_update_tkip_key(struct ieee80211_hw *hw,
 		return;
 	}
 
-	iwl4965_scan_cancel_timeout(priv, 100);
+	iwl_scan_cancel_timeout(priv, 100);
 
 	key_flags |= (STA_KEY_FLG_TKIP | STA_KEY_FLG_MAP_KEY_MSK);
 	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
@@ -4366,7 +3533,7 @@ static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	}
 
 	mutex_lock(&priv->mutex);
-	iwl4965_scan_cancel_timeout(priv, 100);
+	iwl_scan_cancel_timeout(priv, 100);
 	mutex_unlock(&priv->mutex);
 
 	/* If we are getting WEP group key and we didn't receive any key mapping
@@ -4562,7 +3729,7 @@ static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
 	 * clear RXON_FILTER_ASSOC_MSK bit
 	 */
 	if (priv->iw_mode != IEEE80211_IF_TYPE_AP) {
-		iwl4965_scan_cancel_timeout(priv, 100);
+		iwl_scan_cancel_timeout(priv, 100);
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwl4965_commit_rxon(priv);
 	}
@@ -4759,7 +3926,7 @@ static ssize_t store_flags(struct device *d,
 	mutex_lock(&priv->mutex);
 	if (le32_to_cpu(priv->staging_rxon.flags) != flags) {
 		/* Cancel any currently running scans... */
-		if (iwl4965_scan_cancel_timeout(priv, 100))
+		if (iwl_scan_cancel_timeout(priv, 100))
 			IWL_WARNING("Could not cancel scan.\n");
 		else {
 			IWL_DEBUG_INFO("Committing rxon.flags = 0x%04X\n",
@@ -4794,7 +3961,7 @@ static ssize_t store_filter_flags(struct device *d,
 	mutex_lock(&priv->mutex);
 	if (le32_to_cpu(priv->staging_rxon.filter_flags) != filter_flags) {
 		/* Cancel any currently running scans... */
-		if (iwl4965_scan_cancel_timeout(priv, 100))
+		if (iwl_scan_cancel_timeout(priv, 100))
 			IWL_WARNING("Could not cancel scan.\n");
 		else {
 			IWL_DEBUG_INFO("Committing rxon.filter_flags = "
@@ -5062,9 +4229,6 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	INIT_WORK(&priv->up, iwl4965_bg_up);
 	INIT_WORK(&priv->restart, iwl4965_bg_restart);
 	INIT_WORK(&priv->rx_replenish, iwl4965_bg_rx_replenish);
-	INIT_WORK(&priv->scan_completed, iwl4965_bg_scan_completed);
-	INIT_WORK(&priv->request_scan, iwl4965_bg_request_scan);
-	INIT_WORK(&priv->abort_scan, iwl4965_bg_abort_scan);
 	INIT_WORK(&priv->rf_kill, iwl4965_bg_rf_kill);
 	INIT_WORK(&priv->beacon_update, iwl4965_bg_beacon_update);
 	INIT_WORK(&priv->set_monitor, iwl4965_bg_set_monitor);
@@ -5072,7 +4236,10 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	INIT_DELAYED_WORK(&priv->post_associate, iwl4965_bg_post_associate);
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl_bg_init_alive_start);
 	INIT_DELAYED_WORK(&priv->alive_start, iwl_bg_alive_start);
-	INIT_DELAYED_WORK(&priv->scan_check, iwl4965_bg_scan_check);
+
+	/* FIXME : remove when resolved PENDING */
+	INIT_WORK(&priv->scan_completed, iwl_bg_scan_completed);
+	iwl_setup_scan_deferred_work(priv);
 
 	if (priv->cfg->ops->lib->setup_deferred_work)
 		priv->cfg->ops->lib->setup_deferred_work(priv);
-- 
1.5.3.6

