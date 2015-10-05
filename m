Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57106 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751311AbbJEOhR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 10:37:17 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Assaf Krauss <assaf.krauss@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:40 +0300
Message-Id: <1444055820-27506-9-git-send-email-luca@coelho.fi> (sfid-20151005_163816_141788_E131B2BE)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 09/29] iwlwifi: mvm: Fix tof debugfs formats (dec vs. hex)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

Make some input formats more natural, e.g. bandwidth and periods
are more natural in decimal than in hexadecimal.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c | 40 ++++++++++++++------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 334ae56..15ab543 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -913,11 +913,11 @@ static ssize_t iwl_dbgfs_tof_range_request_write(struct ieee80211_vif *vif,
 		u8 *mac = ap.bssid;
 		unsigned int i;
 
-		if (sscanf(data, "%u %hhd %hhx %hhx"
+		if (sscanf(data, "%u %hhd %hhd %hhd"
 			   "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx"
-			   "%hhx %hhx %hx"
-			   "%hhx %hhx %x"
-			   "%hhx %hhx %hhx %hhx",
+			   "%hhd %hhd %hd"
+			   "%hhd %hhd %d"
+			   "%hhx %hhd %hhd %hhd",
 			   &i, &ap.channel_num, &ap.bandwidth,
 			   &ap.ctrl_ch_position,
 			   mac, mac + 1, mac + 2, mac + 3, mac + 4, mac + 5,
@@ -994,16 +994,18 @@ static ssize_t iwl_dbgfs_tof_range_request_read(struct file *file,
 		struct iwl_tof_range_req_ap_entry *ap = &cmd->ap[i];
 
 		pos += scnprintf(buf + pos, bufsz - pos,
-				"ap %.2d: channel_num=%hhx bw=%hhx"
-				" control=%hhx bssid=%pM type=%hhx"
-				" num_of_bursts=%hhx burst_period=%hx ftm=%hhx"
-				" retries=%hhx tsf_delta=%x location_req=%hhx "
-				" asap=%hhx enable=%hhx rssi=%hhx\n",
+				"ap %.2d: channel_num=%hhd bw=%hhd"
+				" control=%hhd bssid=%pM type=%hhd"
+				" num_of_bursts=%hhd burst_period=%hd ftm=%hhd"
+				" retries=%hhd tsf_delta=%d"
+				" tsf_delta_direction=%hhd location_req=0x%hhx "
+				" asap=%hhd enable=%hhd rssi=%hhd\n",
 				i, ap->channel_num, ap->bandwidth,
 				ap->ctrl_ch_position, ap->bssid,
 				ap->measure_type, ap->num_of_bursts,
 				ap->burst_period, ap->samples_per_burst,
 				ap->retries_per_sample, ap->tsf_delta,
+				ap->tsf_delta_direction,
 				ap->location_req, ap->asap_mode,
 				ap->enable_dyn_ack, ap->rssi);
 	}
@@ -1099,18 +1101,18 @@ static ssize_t iwl_dbgfs_tof_range_req_ext_read(struct file *file,
 	mutex_lock(&mvm->mutex);
 
 	pos += scnprintf(buf + pos, bufsz - pos,
-			 "tsf_timer_offset_msec = %hx\n",
+			 "tsf_timer_offset_msec = %hd\n",
 			 cmd->tsf_timer_offset_msec);
-	pos += scnprintf(buf + pos, bufsz - pos, "min_delta_ftm = %hhx\n",
+	pos += scnprintf(buf + pos, bufsz - pos, "min_delta_ftm = %hhd\n",
 			 cmd->min_delta_ftm);
 	pos += scnprintf(buf + pos, bufsz - pos,
-			 "ftm_format_and_bw20M = %hhx\n",
+			 "ftm_format_and_bw20M = %hhd\n",
 			 cmd->ftm_format_and_bw20M);
 	pos += scnprintf(buf + pos, bufsz - pos,
-			 "ftm_format_and_bw40M = %hhx\n",
+			 "ftm_format_and_bw40M = %hhd\n",
 			 cmd->ftm_format_and_bw40M);
 	pos += scnprintf(buf + pos, bufsz - pos,
-			 "ftm_format_and_bw80M = %hhx\n",
+			 "ftm_format_and_bw80M = %hhd\n",
 			 cmd->ftm_format_and_bw80M);
 
 	mutex_unlock(&mvm->mutex);
@@ -1205,11 +1207,11 @@ static ssize_t iwl_dbgfs_tof_range_response_read(struct file *file,
 		struct iwl_tof_range_rsp_ap_entry_ntfy *ap = &cmd->ap[i];
 
 		pos += scnprintf(buf + pos, bufsz - pos,
-				"ap %.2d: bssid=%pM status=%hhx bw=%hhx"
-				" rtt=%x rtt_var=%x rtt_spread=%x"
-				" rssi=%hhx  rssi_spread=%hhx"
-				" range=%x range_var=%x"
-				" time_stamp=%x\n",
+				"ap %.2d: bssid=%pM status=%hhd bw=%hhd"
+				" rtt=%d rtt_var=%d rtt_spread=%d"
+				" rssi=%hhd  rssi_spread=%hhd"
+				" range=%d range_var=%d"
+				" time_stamp=%d\n",
 				i, ap->bssid, ap->measure_status,
 				ap->measure_bw,
 				ap->rtt, ap->rtt_variance, ap->rtt_spread,
-- 
2.5.3

