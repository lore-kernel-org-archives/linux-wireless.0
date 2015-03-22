Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16906 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbbCVRVm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2015 13:21:42 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>, <stable@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 4/6] iwlwifi: mvm: protect rate scaling against non-mvm IBSS stations
Date: Sun, 22 Mar 2015 19:21:30 +0200
Message-Id: <1427044892-13907-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150322_182146_266683_A6609C80)
In-Reply-To: <1427044767.8611.4.camel@egrumbacBox>
References: <1427044767.8611.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the driver callback returns that it's out of space for new
stations, the mac80211 IBSS code still keeps the station so it
doesn't try to add it over and over again.

Since the rate scaling algorithm is separate in mac80211, it also
invokes the rate scaling algorithm for such stations. It doesn't
know that our rate scaling algorithm is tightly integrated with
the MVM code and relies on those data structures, and it cannot
as the abstraction doesn't allow for it.

This leads to crashes when the rate scaling algorithm tries to
use uninitialized data, notably the mvmsta->vif pointer.

Protect against this in the rate scaling algorithm. We cannot get
good rates with such peers anyway since the firmware cannot do
anything with them.

This should fix https://bugzilla.kernel.org/show_bug.cgi?id=93461

CC: <stable@vger.kernel.org>
Reported-by: Richard Taylor <rjt-kernel@thegrindstone.me.uk>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index efa9688..078f24c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1278,6 +1278,9 @@ static void rs_mac80211_tx_status(void *mvm_r,
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
+	if (!iwl_mvm_sta_from_mac80211(sta)->vif)
+		return;
+
 	if (!ieee80211_is_data(hdr->frame_control) ||
 	    info->flags & IEEE80211_TX_CTL_NO_ACK)
 		return;
@@ -2511,6 +2514,14 @@ static void rs_get_rate(void *mvm_r, struct ieee80211_sta *sta, void *mvm_sta,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl_lq_sta *lq_sta = mvm_sta;
 
+	if (sta && !iwl_mvm_sta_from_mac80211(sta)->vif) {
+		/* if vif isn't initialized mvm doesn't know about
+		 * this station, so don't do anything with the it
+		 */
+		sta = NULL;
+		mvm_sta = NULL;
+	}
+
 	/* TODO: handle rate_idx_mask and rate_idx_mcs_mask */
 
 	/* Treat uninitialized rate scaling data same as non-existing. */
@@ -2827,6 +2838,9 @@ static void rs_rate_update(void *mvm_r,
 			(struct iwl_op_mode *)mvm_r;
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 
+	if (!iwl_mvm_sta_from_mac80211(sta)->vif)
+		return;
+
 	/* Stop any ongoing aggregations as rs starts off assuming no agg */
 	for (tid = 0; tid < IWL_MAX_TID_COUNT; tid++)
 		ieee80211_stop_tx_ba_session(sta, tid);
@@ -3587,9 +3601,15 @@ static ssize_t iwl_dbgfs_ss_force_write(struct iwl_lq_sta *lq_sta, char *buf,
 
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(ss_force, 32);
 
-static void rs_add_debugfs(void *mvm, void *mvm_sta, struct dentry *dir)
+static void rs_add_debugfs(void *mvm, void *priv_sta, struct dentry *dir)
 {
-	struct iwl_lq_sta *lq_sta = mvm_sta;
+	struct iwl_lq_sta *lq_sta = priv_sta;
+	struct iwl_mvm_sta *mvmsta;
+
+	mvmsta = container_of(lq_sta, struct iwl_mvm_sta, lq_sta);
+
+	if (!mvmsta->vif)
+		return;
 
 	debugfs_create_file("rate_scale_table", S_IRUSR | S_IWUSR, dir,
 			    lq_sta, &rs_sta_dbgfs_scale_table_ops);
-- 
1.9.1

