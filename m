Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:18558 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078Ab0AVWXO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 17:23:14 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 16/17] iwlwifi: cleanup spectrum measurement command support
Date: Fri, 22 Jan 2010 14:22:57 -0800
Message-Id: <1264198978-5915-17-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
References: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

In iwlagn the support for spectrum measurement command has been
disabled since v2.6.29 without any requests for it. In addition to this
when this command is indeed enabled it has been found to trigger firmware
SYSASSERT on at least 4965 and 5100 hardware (see
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=1952 ). Since then
this code has been bitrotting and cannot just be enabled without porting.

Remove support for spectrum measurement command from iwlagn. It can be
added back if there is a future need and the firmware problem it triggers
has been fixed. Support for the spectrim measurement notification remains
as it has been enabled all the time.

In addition to this remove the 3945 spectrum measurement command Kconfig
option and make this command always supported. The code added by this
enabling is minimal and only run when user triggers a spectrum measurement
request via sysfs.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |   12 --
 drivers/net/wireless/iwlwifi/Makefile       |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   11 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |   10 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    3 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   18 +++
 drivers/net/wireless/iwlwifi/iwl-spectrum.c |  198 ---------------------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   27 ++---
 8 files changed, 33 insertions(+), 247 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-spectrum.c

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index e44e572..dc8ed15 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -3,12 +3,6 @@ config IWLWIFI
 	depends on PCI && MAC80211
 	select FW_LOADER
 
-config IWLWIFI_SPECTRUM_MEASUREMENT
-	bool "Enable Spectrum Measurement in iwlagn driver"
-	depends on IWLWIFI
-	---help---
-	  This option will enable spectrum measurement for the iwlagn driver.
-
 config IWLWIFI_DEBUG
 	bool "Enable full debugging output in iwlagn and iwl3945 drivers"
 	depends on IWLWIFI
@@ -120,9 +114,3 @@ config IWL3945
 	  inserted in and removed from the running kernel whenever you want),
 	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
 	  module will be called iwl3945.
-
-config IWL3945_SPECTRUM_MEASUREMENT
-	bool "Enable Spectrum Measurement in iwl3945 driver"
-	depends on IWL3945
-	---help---
-	  This option will enable spectrum measurement for the iwl3945 driver.
diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index bdaa924..4e378fa 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -3,7 +3,6 @@ iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o
 iwlcore-objs 		+= iwl-rx.o iwl-tx.o iwl-sta.o iwl-calib.o
 iwlcore-objs 		+= iwl-scan.o iwl-led.o
 iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
-iwlcore-$(CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT) += iwl-spectrum.o
 iwlcore-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
 
 CFLAGS_iwl-devtrace.o := -I$(src)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5537369..d59192f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -73,13 +73,7 @@
 #define VD
 #endif
 
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
-#define VS "s"
-#else
-#define VS
-#endif
-
-#define DRV_VERSION     IWLWIFI_VERSION VD VS
+#define DRV_VERSION     IWLWIFI_VERSION VD
 
 
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
@@ -889,6 +883,8 @@ static void iwl_setup_rx_handlers(struct iwl_priv *priv)
 	priv->rx_handlers[REPLY_ALIVE] = iwl_rx_reply_alive;
 	priv->rx_handlers[REPLY_ERROR] = iwl_rx_reply_error;
 	priv->rx_handlers[CHANNEL_SWITCH_NOTIFICATION] = iwl_rx_csa;
+	priv->rx_handlers[SPECTRUM_MEASURE_NOTIFICATION] =
+			iwl_rx_spectrum_measure_notif;
 	priv->rx_handlers[PM_SLEEP_NOTIFICATION] = iwl_rx_pm_sleep_notif;
 	priv->rx_handlers[PM_DEBUG_STATISTIC_NOTIFIC] =
 	    iwl_rx_pm_debug_statistics_notif;
@@ -902,7 +898,6 @@ static void iwl_setup_rx_handlers(struct iwl_priv *priv)
 	priv->rx_handlers[REPLY_STATISTICS_CMD] = iwl_reply_statistics;
 	priv->rx_handlers[STATISTICS_NOTIFICATION] = iwl_rx_statistics;
 
-	iwl_setup_spectrum_handlers(priv);
 	iwl_setup_rx_scan_handlers(priv);
 
 	/* status change handler */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e14e329..ec1fe1d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -429,6 +429,8 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index);
 /* Handlers */
 void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 			       struct iwl_rx_mem_buffer *rxb);
+void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
+					  struct iwl_rx_mem_buffer *rxb);
 void iwl_rx_statistics(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb);
 void iwl_reply_statistics(struct iwl_priv *priv,
@@ -531,14 +533,6 @@ int iwl_send_calib_results(struct iwl_priv *priv);
 int iwl_calib_set(struct iwl_calib_result *res, const u8 *buf, int len);
 void iwl_calib_free_results(struct iwl_priv *priv);
 
-/*******************************************************************************
- * Spectrum Measureemtns in  iwl-spectrum.c
- ******************************************************************************/
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
-void iwl_setup_spectrum_handlers(struct iwl_priv *priv);
-#else
-static inline void iwl_setup_spectrum_handlers(struct iwl_priv *priv) {}
-#endif
 /*****************************************************
  *   S e n d i n g     H o s t     C o m m a n d s   *
  *****************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index d9f325b..9b0a5cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1055,11 +1055,10 @@ struct iwl_priv {
 
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
 
-#if defined(CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT) || defined(CONFIG_IWL3945_SPECTRUM_MEASUREMENT)
 	/* spectrum measurement report caching */
 	struct iwl_spectrum_notification measure_report;
 	u8 measurement_status;
-#endif
+
 	/* ucode beacon time */
 	u32 ucode_beacon_time;
 	int missed_beacon_threshold;
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index ea309f4..5df6638 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -512,6 +512,24 @@ void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwl_rx_missed_beacon_notif);
 
+void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
+					  struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_spectrum_notification *report = &(pkt->u.spectrum_notif);
+
+	if (!report->state) {
+		IWL_DEBUG_11H(priv,
+			"Spectrum Measure Notification: Start\n");
+		return;
+	}
+
+	memcpy(&priv->measure_report, report, sizeof(*report));
+	priv->measurement_status |= MEASUREMENT_READY;
+}
+EXPORT_SYMBOL(iwl_rx_spectrum_measure_notif);
+
+
 
 /* Calculate noise level, based on measurements during network silence just
  *   before arriving beacon.  This measurement can be done only if we know
diff --git a/drivers/net/wireless/iwlwifi/iwl-spectrum.c b/drivers/net/wireless/iwlwifi/iwl-spectrum.c
deleted file mode 100644
index da166d1..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-spectrum.c
+++ /dev/null
@@ -1,198 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
- *
- * Portions of this file are derived from the ipw3945 project, as well
- * as portions of the ieee80211 subsystem header files.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- *****************************************************************************/
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/pci.h>
-#include <linux/delay.h>
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
-#include <linux/wireless.h>
-
-#include <net/mac80211.h>
-
-#include "iwl-eeprom.h"
-#include "iwl-dev.h"
-#include "iwl-core.h"
-#include "iwl-io.h"
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
-/* TOOD: was used in sysfs debug interface need to add to mac */
-#if 0
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
-		IWL_ERR(priv, "Bad return from REPLY_RX_ON_ASSOC command\n");
-		rc = -EIO;
-	}
-
-	spectrum_resp_status = le16_to_cpu(res->u.spectrum.status);
-	switch (spectrum_resp_status) {
-	case 0:		/* Command will be handled */
-		if (res->u.spectrum.id != 0xff) {
-			IWL_DEBUG_INFO(priv,
-				"Replaced existing measurement: %d\n",
-				res->u.spectrum.id);
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
-
-static void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
-					  struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_spectrum_notification *report = &(pkt->u.spectrum_notif);
-
-	if (!report->state) {
-		IWL_DEBUG_11H(priv,
-			"Spectrum Measure Notification: Start\n");
-		return;
-	}
-
-	memcpy(&priv->measure_report, report, sizeof(*report));
-	priv->measurement_status |= MEASUREMENT_READY;
-}
-
-void iwl_setup_spectrum_handlers(struct iwl_priv *priv)
-{
-	priv->rx_handlers[SPECTRUM_MEASURE_NOTIFICATION] =
-			iwl_rx_spectrum_measure_notif;
-}
-EXPORT_SYMBOL(iwl_setup_spectrum_handlers);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 9c0b6eb..cd42b58 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -56,6 +56,7 @@
 #include "iwl-helpers.h"
 #include "iwl-core.h"
 #include "iwl-dev.h"
+#include "iwl-spectrum.h"
 
 /*
  * module name, copyright, version, etc.
@@ -70,13 +71,12 @@
 #define VD
 #endif
 
-#ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
-#define VS "s"
-#else
-#define VS
-#endif
-
-#define DRV_VERSION  IWLWIFI_VERSION VD VS
+/*
+ * add "s" to indicate spectrum measurement included.
+ * we add it here to be consistent with previous releases in which
+ * this was configurable.
+ */
+#define DRV_VERSION  IWLWIFI_VERSION VD "s"
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2010 Intel Corporation"
 #define DRV_AUTHOR     "<ilw@linux.intel.com>"
 
@@ -689,10 +689,6 @@ drop:
 	return -1;
 }
 
-#ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
-
-#include "iwl-spectrum.h"
-
 #define BEACON_TIME_MASK_LOW	0x00FFFFFF
 #define BEACON_TIME_MASK_HIGH	0xFF000000
 #define TIME_UNIT		1024
@@ -819,7 +815,6 @@ static int iwl3945_get_measurement(struct iwl_priv *priv,
 
 	return rc;
 }
-#endif
 
 static void iwl3945_rx_reply_alive(struct iwl_priv *priv,
 			       struct iwl_rx_mem_buffer *rxb)
@@ -962,6 +957,8 @@ static void iwl3945_setup_rx_handlers(struct iwl_priv *priv)
 	priv->rx_handlers[REPLY_ADD_STA] = iwl3945_rx_reply_add_sta;
 	priv->rx_handlers[REPLY_ERROR] = iwl_rx_reply_error;
 	priv->rx_handlers[CHANNEL_SWITCH_NOTIFICATION] = iwl_rx_csa;
+	priv->rx_handlers[SPECTRUM_MEASURE_NOTIFICATION] =
+			iwl_rx_spectrum_measure_notif;
 	priv->rx_handlers[PM_SLEEP_NOTIFICATION] = iwl_rx_pm_sleep_notif;
 	priv->rx_handlers[PM_DEBUG_STATISTIC_NOTIFIC] =
 	    iwl_rx_pm_debug_statistics_notif;
@@ -975,7 +972,6 @@ static void iwl3945_setup_rx_handlers(struct iwl_priv *priv)
 	priv->rx_handlers[REPLY_STATISTICS_CMD] = iwl3945_hw_rx_statistics;
 	priv->rx_handlers[STATISTICS_NOTIFICATION] = iwl3945_hw_rx_statistics;
 
-	iwl_setup_spectrum_handlers(priv);
 	iwl_setup_rx_scan_handlers(priv);
 	priv->rx_handlers[CARD_STATE_NOTIFICATION] = iwl3945_rx_card_state_notif;
 
@@ -3569,8 +3565,6 @@ static ssize_t store_filter_flags(struct device *d,
 static DEVICE_ATTR(filter_flags, S_IWUSR | S_IRUGO, show_filter_flags,
 		   store_filter_flags);
 
-#ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
-
 static ssize_t show_measurement(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
@@ -3640,7 +3634,6 @@ static ssize_t store_measurement(struct device *d,
 
 static DEVICE_ATTR(measurement, S_IRUSR | S_IWUSR,
 		   show_measurement, store_measurement);
-#endif /* CONFIG_IWL3945_SPECTRUM_MEASUREMENT */
 
 static ssize_t store_retry_rate(struct device *d,
 				struct device_attribute *attr,
@@ -3823,9 +3816,7 @@ static struct attribute *iwl3945_sysfs_entries[] = {
 	&dev_attr_dump_errors.attr,
 	&dev_attr_flags.attr,
 	&dev_attr_filter_flags.attr,
-#ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 	&dev_attr_measurement.attr,
-#endif
 	&dev_attr_retry_rate.attr,
 	&dev_attr_statistics.attr,
 	&dev_attr_status.attr,
-- 
1.6.3.3

