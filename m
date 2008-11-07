Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31244 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbYKGR6Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 12:58:16 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/13] iwlwifi: move spectrum measurement code to iwl-spectrum.c file
Date: Fri,  7 Nov 2008 09:58:41 -0800
Message-Id: <1226080726-24860-9-git-send-email-reinette.chatre@intel.com> (sfid-20081107_185828_811591_3B18CC75)
In-Reply-To: <1226080726-24860-8-git-send-email-reinette.chatre@intel.com>
References: <>
 <1226080726-24860-1-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-2-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-3-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-4-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-5-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-6-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-7-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves spectrum measurement code into iwl-sepctrum.c file.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile       |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  229 +--------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    8 +
 drivers/net/wireless/iwlwifi/iwl-spectrum.c |  198 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-spectrum.h |    1 +
 5 files changed, 209 insertions(+), 228 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-spectrum.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 47aa28f..8b45b30 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -5,6 +5,7 @@ iwlcore-objs 		+= iwl-scan.o
 iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlcore-$(CONFIG_IWLWIFI_LEDS) += iwl-led.o
 iwlcore-$(CONFIG_IWLWIFI_RFKILL) += iwl-rfkill.o
+iwlcore-$(CONFIG_IWLAGN_SPECTRUM_MEASUREMENT) += iwl-spectrum.o
 
 obj-$(CONFIG_IWLAGN)	+= iwlagn.o
 iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index bf736e7..996ed5b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -872,138 +872,6 @@ static void iwl_set_rate(struct iwl_priv *priv)
 		   (IWL_OFDM_BASIC_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
 }
 
-#ifdef CONFIG_IWLAGN_SPECTRUM_MEASUREMENT
-
-#include "iwl-spectrum.h"
-
-#define BEACON_TIME_MASK_LOW	0x00FFFFFF
-#define BEACON_TIME_MASK_HIGH	0xFF000000
-#define TIME_UNIT		1024
-
-/*
- * extended beacon time format
- * time in usec will be changed into a 32-bit value in 8:24 format
- * the high 1 byte is the beacon counts
- * the lower 3 bytes is the time in usec within one beacon interval
- */
-
-static u32 iwl_usecs_to_beacons(u32 usec, u32 beacon_interval)
-{
-	u32 quot;
-	u32 rem;
-	u32 interval = beacon_interval * 1024;
-
-	if (!interval || !usec)
-		return 0;
-
-	quot = (usec / interval) & (BEACON_TIME_MASK_HIGH >> 24);
-	rem = (usec % interval) & BEACON_TIME_MASK_LOW;
-
-	return (quot << 24) + rem;
-}
-
-/* base is usually what we get from ucode with each received frame,
- * the same as HW timer counter counting down
- */
-
-static __le32 iwl_add_beacon_time(u32 base, u32 addon, u32 beacon_interval)
-{
-	u32 base_low = base & BEACON_TIME_MASK_LOW;
-	u32 addon_low = addon & BEACON_TIME_MASK_LOW;
-	u32 interval = beacon_interval * TIME_UNIT;
-	u32 res = (base & BEACON_TIME_MASK_HIGH) +
-	    (addon & BEACON_TIME_MASK_HIGH);
-
-	if (base_low > addon_low)
-		res += base_low - addon_low;
-	else if (base_low < addon_low) {
-		res += interval + base_low - addon_low;
-		res += (1 << 24);
-	} else
-		res += (1 << 24);
-
-	return cpu_to_le32(res);
-}
-
-static int iwl_get_measurement(struct iwl_priv *priv,
-			       struct ieee80211_measurement_params *params,
-			       u8 type)
-{
-	struct iwl4965_spectrum_cmd spectrum;
-	struct iwl_rx_packet *res;
-	struct iwl_host_cmd cmd = {
-		.id = REPLY_SPECTRUM_MEASUREMENT_CMD,
-		.data = (void *)&spectrum,
-		.meta.flags = CMD_WANT_SKB,
-	};
-	u32 add_time = le64_to_cpu(params->start_time);
-	int rc;
-	int spectrum_resp_status;
-	int duration = le16_to_cpu(params->duration);
-
-	if (iwl_is_associated(priv))
-		add_time =
-		    iwl_usecs_to_beacons(
-			le64_to_cpu(params->start_time) - priv->last_tsf,
-			le16_to_cpu(priv->rxon_timing.beacon_interval));
-
-	memset(&spectrum, 0, sizeof(spectrum));
-
-	spectrum.channel_count = cpu_to_le16(1);
-	spectrum.flags =
-	    RXON_FLG_TSF2HOST_MSK | RXON_FLG_ANT_A_MSK | RXON_FLG_DIS_DIV_MSK;
-	spectrum.filter_flags = MEASUREMENT_FILTER_FLAG;
-	cmd.len = sizeof(spectrum);
-	spectrum.len = cpu_to_le16(cmd.len - sizeof(spectrum.len));
-
-	if (iwl_is_associated(priv))
-		spectrum.start_time =
-		    iwl_add_beacon_time(priv->last_beacon_time,
-				add_time,
-				le16_to_cpu(priv->rxon_timing.beacon_interval));
-	else
-		spectrum.start_time = 0;
-
-	spectrum.channels[0].duration = cpu_to_le32(duration * TIME_UNIT);
-	spectrum.channels[0].channel = params->channel;
-	spectrum.channels[0].type = type;
-	if (priv->active_rxon.flags & RXON_FLG_BAND_24G_MSK)
-		spectrum.flags |= RXON_FLG_BAND_24G_MSK |
-		    RXON_FLG_AUTO_DETECT_MSK | RXON_FLG_TGG_PROTECT_MSK;
-
-	rc = iwl_send_cmd_sync(priv, &cmd);
-	if (rc)
-		return rc;
-
-	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
-	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERROR("Bad return from REPLY_RX_ON_ASSOC command\n");
-		rc = -EIO;
-	}
-
-	spectrum_resp_status = le16_to_cpu(res->u.spectrum.status);
-	switch (spectrum_resp_status) {
-	case 0:		/* Command will be handled */
-		if (res->u.spectrum.id != 0xff) {
-			IWL_DEBUG_INFO
-			    ("Replaced existing measurement: %d\n",
-			     res->u.spectrum.id);
-			priv->measurement_status &= ~MEASUREMENT_READY;
-		}
-		priv->measurement_status |= MEASUREMENT_ACTIVE;
-		rc = 0;
-		break;
-
-	case 1:		/* Command will not be handled */
-		rc = -EAGAIN;
-		break;
-	}
-
-	dev_kfree_skb_any(cmd.meta.u.skb);
-
-	return rc;
-}
-#endif
 
 /******************************************************************************
  *
@@ -1073,24 +941,6 @@ static void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	priv->staging_rxon.channel = csa->channel;
 }
 
-static void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
-					  struct iwl_rx_mem_buffer *rxb)
-{
-#ifdef CONFIG_IWLAGN_SPECTRUM_MEASUREMENT
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	struct iwl4965_spectrum_notification *report = &(pkt->u.spectrum_notif);
-
-	if (!report->state) {
-		IWL_DEBUG(IWL_DL_11H,
-			"Spectrum Measure Notification: Start\n");
-		return;
-	}
-
-	memcpy(&priv->measure_report, report, sizeof(*report));
-	priv->measurement_status |= MEASUREMENT_READY;
-#endif
-}
-
 static void iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
 				      struct iwl_rx_mem_buffer *rxb)
 {
@@ -1299,8 +1149,6 @@ static void iwl_setup_rx_handlers(struct iwl_priv *priv)
 	priv->rx_handlers[REPLY_ALIVE] = iwl_rx_reply_alive;
 	priv->rx_handlers[REPLY_ERROR] = iwl_rx_reply_error;
 	priv->rx_handlers[CHANNEL_SWITCH_NOTIFICATION] = iwl_rx_csa;
-	priv->rx_handlers[SPECTRUM_MEASURE_NOTIFICATION] =
-	    iwl_rx_spectrum_measure_notif;
 	priv->rx_handlers[PM_SLEEP_NOTIFICATION] = iwl_rx_pm_sleep_notif;
 	priv->rx_handlers[PM_DEBUG_STATISTIC_NOTIFIC] =
 	    iwl_rx_pm_debug_statistics_notif;
@@ -1314,6 +1162,7 @@ static void iwl_setup_rx_handlers(struct iwl_priv *priv)
 	priv->rx_handlers[REPLY_STATISTICS_CMD] = iwl_rx_statistics;
 	priv->rx_handlers[STATISTICS_NOTIFICATION] = iwl_rx_statistics;
 
+	iwl_setup_spectrum_handlers(priv);
 	iwl_setup_rx_scan_handlers(priv);
 
 	/* status change handler */
@@ -3781,79 +3630,6 @@ static ssize_t store_filter_flags(struct device *d,
 static DEVICE_ATTR(filter_flags, S_IWUSR | S_IRUGO, show_filter_flags,
 		   store_filter_flags);
 
-#ifdef CONFIG_IWLAGN_SPECTRUM_MEASUREMENT
-
-static ssize_t show_measurement(struct device *d,
-				struct device_attribute *attr, char *buf)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	struct iwl4965_spectrum_notification measure_report;
-	u32 size = sizeof(measure_report), len = 0, ofs = 0;
-	u8 *data = (u8 *)&measure_report;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	if (!(priv->measurement_status & MEASUREMENT_READY)) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return 0;
-	}
-	memcpy(&measure_report, &priv->measure_report, size);
-	priv->measurement_status = 0;
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	while (size && (PAGE_SIZE - len)) {
-		hex_dump_to_buffer(data + ofs, size, 16, 1, buf + len,
-				   PAGE_SIZE - len, 1);
-		len = strlen(buf);
-		if (PAGE_SIZE - len)
-			buf[len++] = '\n';
-
-		ofs += 16;
-		size -= min(size, 16U);
-	}
-
-	return len;
-}
-
-static ssize_t store_measurement(struct device *d,
-				 struct device_attribute *attr,
-				 const char *buf, size_t count)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	struct ieee80211_measurement_params params = {
-		.channel = le16_to_cpu(priv->active_rxon.channel),
-		.start_time = cpu_to_le64(priv->last_tsf),
-		.duration = cpu_to_le16(1),
-	};
-	u8 type = IWL_MEASURE_BASIC;
-	u8 buffer[32];
-	u8 channel;
-
-	if (count) {
-		char *p = buffer;
-		strncpy(buffer, buf, min(sizeof(buffer), count));
-		channel = simple_strtoul(p, NULL, 0);
-		if (channel)
-			params.channel = channel;
-
-		p = buffer;
-		while (*p && *p != ' ')
-			p++;
-		if (*p)
-			type = simple_strtoul(p + 1, NULL, 0);
-	}
-
-	IWL_DEBUG_INFO("Invoking measurement of type %d on "
-		       "channel %d (for '%s')\n", type, params.channel, buf);
-	iwl_get_measurement(priv, &params, type);
-
-	return count;
-}
-
-static DEVICE_ATTR(measurement, S_IRUSR | S_IWUSR,
-		   show_measurement, store_measurement);
-#endif /* CONFIG_IWLAGN_SPECTRUM_MEASUREMENT */
-
 static ssize_t store_retry_rate(struct device *d,
 				struct device_attribute *attr,
 				const char *buf, size_t count)
@@ -4106,9 +3882,6 @@ static struct attribute *iwl_sysfs_entries[] = {
 	&dev_attr_channels.attr,
 	&dev_attr_flags.attr,
 	&dev_attr_filter_flags.attr,
-#ifdef CONFIG_IWLAGN_SPECTRUM_MEASUREMENT
-	&dev_attr_measurement.attr,
-#endif
 	&dev_attr_power_level.attr,
 	&dev_attr_retry_rate.attr,
 	&dev_attr_statistics.attr,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 1ae7a11..a1c3dc7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -289,6 +289,14 @@ int iwl_send_calib_results(struct iwl_priv *priv);
 int iwl_calib_set(struct iwl_calib_result *res, const u8 *buf, int len);
 void iwl_calib_free_results(struct iwl_priv *priv);
 
+/*******************************************************************************
+ * Spectrum Measureemtns in  iwl-spectrum.c
+ ******************************************************************************/
+#ifdef CONFIG_IWLAGN_SPECTRUM_MEASUREMENT
+void iwl_setup_spectrum_handlers(struct iwl_priv *priv);
+#else
+void iwl_setup_spectrum_handlers(struct iwl_priv *priv) {}
+#endif
 /*****************************************************
  *   S e n d i n g     H o s t     C o m m a n d s   *
  *****************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-spectrum.c b/drivers/net/wireless/iwlwifi/iwl-spectrum.c
new file mode 100644
index 0000000..ad319a1
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-spectrum.c
@@ -0,0 +1,198 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ *
+ * Portions of this file are derived from the ipw3945 project, as well
+ * as portions of the ieee80211 subsystem header files.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/delay.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/wireless.h>
+
+#include <net/mac80211.h>
+
+#include "iwl-eeprom.h"
+#include "iwl-dev.h"
+#include "iwl-core.h"
+#include "iwl-io.h"
+#include "iwl-spectrum.h"
+
+#define BEACON_TIME_MASK_LOW	0x00FFFFFF
+#define BEACON_TIME_MASK_HIGH	0xFF000000
+#define TIME_UNIT		1024
+
+/*
+ * extended beacon time format
+ * time in usec will be changed into a 32-bit value in 8:24 format
+ * the high 1 byte is the beacon counts
+ * the lower 3 bytes is the time in usec within one beacon interval
+ */
+
+/* TOOD: was used in sysfs debug interface need to add to mac */
+#if 0
+static u32 iwl_usecs_to_beacons(u32 usec, u32 beacon_interval)
+{
+	u32 quot;
+	u32 rem;
+	u32 interval = beacon_interval * 1024;
+
+	if (!interval || !usec)
+		return 0;
+
+	quot = (usec / interval) & (BEACON_TIME_MASK_HIGH >> 24);
+	rem = (usec % interval) & BEACON_TIME_MASK_LOW;
+
+	return (quot << 24) + rem;
+}
+
+/* base is usually what we get from ucode with each received frame,
+ * the same as HW timer counter counting down
+ */
+
+static __le32 iwl_add_beacon_time(u32 base, u32 addon, u32 beacon_interval)
+{
+	u32 base_low = base & BEACON_TIME_MASK_LOW;
+	u32 addon_low = addon & BEACON_TIME_MASK_LOW;
+	u32 interval = beacon_interval * TIME_UNIT;
+	u32 res = (base & BEACON_TIME_MASK_HIGH) +
+	    (addon & BEACON_TIME_MASK_HIGH);
+
+	if (base_low > addon_low)
+		res += base_low - addon_low;
+	else if (base_low < addon_low) {
+		res += interval + base_low - addon_low;
+		res += (1 << 24);
+	} else
+		res += (1 << 24);
+
+	return cpu_to_le32(res);
+}
+static int iwl_get_measurement(struct iwl_priv *priv,
+			       struct ieee80211_measurement_params *params,
+			       u8 type)
+{
+	struct iwl4965_spectrum_cmd spectrum;
+	struct iwl_rx_packet *res;
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_SPECTRUM_MEASUREMENT_CMD,
+		.data = (void *)&spectrum,
+		.meta.flags = CMD_WANT_SKB,
+	};
+	u32 add_time = le64_to_cpu(params->start_time);
+	int rc;
+	int spectrum_resp_status;
+	int duration = le16_to_cpu(params->duration);
+
+	if (iwl_is_associated(priv))
+		add_time =
+		    iwl_usecs_to_beacons(
+			le64_to_cpu(params->start_time) - priv->last_tsf,
+			le16_to_cpu(priv->rxon_timing.beacon_interval));
+
+	memset(&spectrum, 0, sizeof(spectrum));
+
+	spectrum.channel_count = cpu_to_le16(1);
+	spectrum.flags =
+	    RXON_FLG_TSF2HOST_MSK | RXON_FLG_ANT_A_MSK | RXON_FLG_DIS_DIV_MSK;
+	spectrum.filter_flags = MEASUREMENT_FILTER_FLAG;
+	cmd.len = sizeof(spectrum);
+	spectrum.len = cpu_to_le16(cmd.len - sizeof(spectrum.len));
+
+	if (iwl_is_associated(priv))
+		spectrum.start_time =
+		    iwl_add_beacon_time(priv->last_beacon_time,
+				add_time,
+				le16_to_cpu(priv->rxon_timing.beacon_interval));
+	else
+		spectrum.start_time = 0;
+
+	spectrum.channels[0].duration = cpu_to_le32(duration * TIME_UNIT);
+	spectrum.channels[0].channel = params->channel;
+	spectrum.channels[0].type = type;
+	if (priv->active_rxon.flags & RXON_FLG_BAND_24G_MSK)
+		spectrum.flags |= RXON_FLG_BAND_24G_MSK |
+		    RXON_FLG_AUTO_DETECT_MSK | RXON_FLG_TGG_PROTECT_MSK;
+
+	rc = iwl_send_cmd_sync(priv, &cmd);
+	if (rc)
+		return rc;
+
+	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
+	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
+		IWL_ERROR("Bad return from REPLY_RX_ON_ASSOC command\n");
+		rc = -EIO;
+	}
+
+	spectrum_resp_status = le16_to_cpu(res->u.spectrum.status);
+	switch (spectrum_resp_status) {
+	case 0:		/* Command will be handled */
+		if (res->u.spectrum.id != 0xff) {
+			IWL_DEBUG_INFO
+			    ("Replaced existing measurement: %d\n",
+			     res->u.spectrum.id);
+			priv->measurement_status &= ~MEASUREMENT_READY;
+		}
+		priv->measurement_status |= MEASUREMENT_ACTIVE;
+		rc = 0;
+		break;
+
+	case 1:		/* Command will not be handled */
+		rc = -EAGAIN;
+		break;
+	}
+
+	dev_kfree_skb_any(cmd.meta.u.skb);
+
+	return rc;
+}
+#endif
+
+static void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
+					  struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl4965_spectrum_notification *report = &(pkt->u.spectrum_notif);
+
+	if (!report->state) {
+		IWL_DEBUG(IWL_DL_11H,
+			"Spectrum Measure Notification: Start\n");
+		return;
+	}
+
+	memcpy(&priv->measure_report, report, sizeof(*report));
+	priv->measurement_status |= MEASUREMENT_READY;
+}
+
+void iwl_setup_spectrum_handlers(struct iwl_priv *priv)
+{
+	priv->rx_handlers[SPECTRUM_MEASURE_NOTIFICATION] =
+			iwl_rx_spectrum_measure_notif;
+}
+EXPORT_SYMBOL(iwl_setup_spectrum_handlers);
diff --git a/drivers/net/wireless/iwlwifi/iwl-spectrum.h b/drivers/net/wireless/iwlwifi/iwl-spectrum.h
index a40a217..fa990a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-spectrum.h
+++ b/drivers/net/wireless/iwlwifi/iwl-spectrum.h
@@ -88,4 +88,5 @@ struct ieee80211_measurement_report {
 		struct ieee80211_basic_report basic[0];
 	} u;
 } __attribute__ ((packed));
+
 #endif
-- 
1.5.4.3

