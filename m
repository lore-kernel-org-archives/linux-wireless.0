Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48046 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab2C0MID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 08:08:03 -0400
Message-ID: <1332850079.3938.8.camel@jlt3.sipsolutions.net> (sfid-20120327_140808_814100_064A49EF)
Subject: [PATCH] mwifiex: don't use IEEE80211_MAX_QUEUES
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bing Zhao <bzhao@marvell.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 27 Mar 2012 14:07:59 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

IEEE80211_MAX_QUEUES is an internal mac80211 value,
it is not guaranteed to be always 4. The firmware
API in mwifiex almost certainly doesn't care about
mac80211 changing though, so mwifiex shouldn't use
this value.

Maybe it should use IEEE80211_NUM_ACS instead and
that is what I'm doing here as at least that value
will probably never change, but maybe it should
have its own define instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mwifiex/fw.h   |    4 ++--
 drivers/net/wireless/mwifiex/main.h |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/mwifiex/fw.h	2012-03-26 12:25:00.000000000 +0200
+++ b/drivers/net/wireless/mwifiex/fw.h	2012-03-27 14:05:01.000000000 +0200
@@ -1007,7 +1007,7 @@ struct ieee_types_wmm_parameter {
 	struct ieee_types_vendor_header vend_hdr;
 	u8 qos_info_bitmap;
 	u8 reserved;
-	struct ieee_types_wmm_ac_parameters ac_params[IEEE80211_MAX_QUEUES];
+	struct ieee_types_wmm_ac_parameters ac_params[IEEE80211_NUM_ACS];
 } __packed;
 
 struct ieee_types_wmm_info {
@@ -1028,7 +1028,7 @@ struct ieee_types_wmm_info {
 
 struct host_cmd_ds_wmm_get_status {
 	u8 queue_status_tlv[sizeof(struct mwifiex_ie_types_wmm_queue_status) *
-			      IEEE80211_MAX_QUEUES];
+			      IEEE80211_NUM_ACS];
 	u8 wmm_param_tlv[sizeof(struct ieee_types_wmm_parameter) + 2];
 } __packed;
 
--- a/drivers/net/wireless/mwifiex/main.h	2012-03-26 12:25:00.000000000 +0200
+++ b/drivers/net/wireless/mwifiex/main.h	2012-03-27 14:05:01.000000000 +0200
@@ -201,10 +201,10 @@ struct mwifiex_wmm_desc {
 	u32 packets_out[MAX_NUM_TID];
 	/* spin lock to protect ra_list */
 	spinlock_t ra_list_spinlock;
-	struct mwifiex_wmm_ac_status ac_status[IEEE80211_MAX_QUEUES];
-	enum mwifiex_wmm_ac_e ac_down_graded_vals[IEEE80211_MAX_QUEUES];
+	struct mwifiex_wmm_ac_status ac_status[IEEE80211_NUM_ACS];
+	enum mwifiex_wmm_ac_e ac_down_graded_vals[IEEE80211_NUM_ACS];
 	u32 drv_pkt_delay_max;
-	u8 queue_priority[IEEE80211_MAX_QUEUES];
+	u8 queue_priority[IEEE80211_NUM_ACS];
 	u32 user_pri_pkt_tx_ctrl[WMM_HIGHEST_PRIORITY + 1];	/* UP: 0 to 7 */
 	/* Number of transmit packets queued */
 	atomic_t tx_pkts_queued;


