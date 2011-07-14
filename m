Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:52788 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1GNBdC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 21:33:02 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mwifiex: remove wireless.h inclusion and fix resulting bugs
Date: Wed, 13 Jul 2011 18:38:34 -0700
Message-Id: <1310607514-30808-1-git-send-email-bzhao@marvell.com> (sfid-20110714_033306_319477_6D83AF9A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

replace IW_MAX_AP & IW_CUSTOM_MAX with local definitions
and remove usage of struct iw_statistics.

Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
This patch depends on Johannes Berg's patches:

[PATCH 01/11] cfg80211: split wext compatibility to separate header
[PATCH 10/11] mwifiex: add wext include

 drivers/net/wireless/mwifiex/cfg80211.c  |    2 +-
 drivers/net/wireless/mwifiex/init.c      |    4 ++--
 drivers/net/wireless/mwifiex/ioctl.h     |    5 +++--
 drivers/net/wireless/mwifiex/main.h      |    6 +++---
 drivers/net/wireless/mwifiex/scan.c      |    6 +++---
 drivers/net/wireless/mwifiex/sta_event.c |    6 +++---
 drivers/net/wireless/mwifiex/sta_ioctl.c |   18 ++++--------------
 7 files changed, 19 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 352d2c5..c979a90 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -547,7 +547,7 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 	sinfo->tx_bytes = priv->stats.tx_bytes;
 	sinfo->rx_packets = priv->stats.rx_packets;
 	sinfo->tx_packets = priv->stats.tx_packets;
-	sinfo->signal = priv->w_stats.qual.level;
+	sinfo->signal = priv->qual_level;
 	sinfo->txrate.legacy = rate.rate;
 
 	return ret;
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 3f1559e..a57c8de 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -156,7 +156,7 @@ static int mwifiex_allocate_adapter(struct mwifiex_adapter *adapter)
 	struct mwifiex_bssdescriptor *temp_scan_table;
 
 	/* Allocate buffer to store the BSSID list */
-	buf_size = sizeof(struct mwifiex_bssdescriptor) * IW_MAX_AP;
+	buf_size = sizeof(struct mwifiex_bssdescriptor) * MWIFIEX_MAX_AP;
 	temp_scan_table = kzalloc(buf_size, GFP_KERNEL);
 	if (!temp_scan_table) {
 		dev_err(adapter->dev, "%s: failed to alloc temp_scan_table\n",
@@ -224,7 +224,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 
 	adapter->num_in_scan_table = 0;
 	memset(adapter->scan_table, 0,
-	       (sizeof(struct mwifiex_bssdescriptor) * IW_MAX_AP));
+	       (sizeof(struct mwifiex_bssdescriptor) * MWIFIEX_MAX_AP));
 	adapter->scan_probes = 1;
 
 	memset(adapter->bcn_buf, 0, sizeof(adapter->bcn_buf));
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index f1962bb..9929749 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -20,7 +20,6 @@
 #ifndef _MWIFIEX_IOCTL_H_
 #define _MWIFIEX_IOCTL_H_
 
-#include <linux/wireless.h>
 #include <net/mac80211.h>
 
 enum {
@@ -307,10 +306,12 @@ struct mwifiex_ds_read_eeprom {
 	u8 value[MAX_EEPROM_DATA];
 };
 
+#define IEEE_MAX_IE_SIZE		256
+
 struct mwifiex_ds_misc_gen_ie {
 	u32 type;
 	u32 len;
-	u8 ie_data[IW_CUSTOM_MAX];
+	u8 ie_data[IEEE_MAX_IE_SIZE];
 };
 
 struct mwifiex_ds_misc_cmd {
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 03691c0..84f780d 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -54,6 +54,8 @@ struct mwifiex_drv_mode {
 };
 
 
+#define MWIFIEX_MAX_AP				64
+
 #define MWIFIEX_DEFAULT_WATCHDOG_TIMEOUT	(5 * HZ)
 
 #define MWIFIEX_TIMER_10S			10000
@@ -246,8 +248,6 @@ struct ieee_types_obss_scan_param {
 
 #define MWIFIEX_SUPPORTED_RATES_EXT             32
 
-#define IEEE_MAX_IE_SIZE			256
-
 struct ieee_types_vendor_specific {
 	struct ieee_types_vendor_header vend_hdr;
 	u8 data[IEEE_MAX_IE_SIZE - sizeof(struct ieee_types_vendor_header)];
@@ -468,7 +468,7 @@ struct mwifiex_private {
 	struct dentry *dfs_dev_dir;
 #endif
 	u8 nick_name[16];
-	struct iw_statistics w_stats;
+	u8 qual_level, qual_noise;
 	u16 current_key_index;
 	struct semaphore async_sem;
 	u8 scan_pending_on_block;
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 6f88c8a..1fdfd41 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -2308,7 +2308,7 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 
 	if (!keep_previous_scan) {
 		memset(adapter->scan_table, 0x00,
-		       sizeof(struct mwifiex_bssdescriptor) * IW_MAX_AP);
+		       sizeof(struct mwifiex_bssdescriptor) * MWIFIEX_MAX_AP);
 		adapter->num_in_scan_table = 0;
 		adapter->bcn_buf_end = adapter->bcn_buf;
 	}
@@ -2430,7 +2430,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		scan_rsp = &resp->params.scan_resp;
 
 
-	if (scan_rsp->number_of_sets > IW_MAX_AP) {
+	if (scan_rsp->number_of_sets > MWIFIEX_MAX_AP) {
 		dev_err(adapter->dev, "SCAN_RESP: too many AP returned (%d)\n",
 		       scan_rsp->number_of_sets);
 		ret = -1;
@@ -2542,7 +2542,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		if (bss_idx == num_in_table) {
 			/* Range check the bss_idx, keep it limited to
 			   the last entry */
-			if (bss_idx == IW_MAX_AP)
+			if (bss_idx == MWIFIEX_MAX_AP)
 				bss_idx--;
 			else
 				num_in_table++;
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index fc265ca..6e8b198 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -130,8 +130,8 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv)
 	if (netif_carrier_ok(priv->netdev))
 		netif_carrier_off(priv->netdev);
 	/* Reset wireless stats signal info */
-	priv->w_stats.qual.level = 0;
-	priv->w_stats.qual.noise = 0;
+	priv->qual_level = 0;
+	priv->qual_noise = 0;
 }
 
 /*
@@ -301,7 +301,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		dev_dbg(adapter->dev, "event: BGS_REPORT\n");
 		/* Clear the previous scan result */
 		memset(adapter->scan_table, 0x00,
-		       sizeof(struct mwifiex_bssdescriptor) * IW_MAX_AP);
+		       sizeof(struct mwifiex_bssdescriptor) * MWIFIEX_MAX_AP);
 		adapter->num_in_scan_table = 0;
 		adapter->bcn_buf_end = adapter->bcn_buf;
 		ret = mwifiex_send_cmd_async(priv,
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index d05907d..6547013 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1266,9 +1266,9 @@ int mwifiex_get_signal_info(struct mwifiex_private *priv,
 
 	if (!status) {
 		if (signal->selector & BCN_RSSI_AVG_MASK)
-			priv->w_stats.qual.level = signal->bcn_rssi_avg;
+			priv->qual_level = signal->bcn_rssi_avg;
 		if (signal->selector & BCN_NF_AVG_MASK)
-			priv->w_stats.qual.noise = signal->bcn_nf_avg;
+			priv->qual_noise = signal->bcn_nf_avg;
 	}
 
 	return status;
@@ -1327,18 +1327,8 @@ int
 mwifiex_get_stats_info(struct mwifiex_private *priv,
 		       struct mwifiex_ds_get_stats *log)
 {
-	int ret;
-
-	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_GET_LOG,
+	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_GET_LOG,
 				    HostCmd_ACT_GEN_GET, 0, log);
-
-	if (!ret) {
-		priv->w_stats.discard.fragment = log->fcs_error;
-		priv->w_stats.discard.retries = log->retry;
-		priv->w_stats.discard.misc = log->ack_failure;
-	}
-
-	return ret;
 }
 
 /*
@@ -1580,7 +1570,7 @@ mwifiex_set_gen_ie(struct mwifiex_private *priv, u8 *ie, int ie_len)
 {
 	struct mwifiex_ds_misc_gen_ie gen_ie;
 
-	if (ie_len > IW_CUSTOM_MAX)
+	if (ie_len > IEEE_MAX_IE_SIZE)
 		return -EFAULT;
 
 	gen_ie.type = MWIFIEX_IE_TYPE_GEN_IE;
-- 
1.7.0.2

