Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55151 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751375AbcJJKKU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Oct 2016 06:10:20 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: make multi-channel ops const
Date: Mon, 10 Oct 2016 12:09:52 +0200
Message-Id: <1476094192-28698-1-git-send-email-johannes@sipsolutions.net> (sfid-20161010_121042_618601_9766C05C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of building the multi-channel ops at runtime, declare
the common ops with a macro and build both that way, so that
the multi-channel ops can also be const.

As a side effect, due to the removed code, this decreases the
size of the module (while shifting data from .bss to .text
due to the newly added const).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 79 ++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 431f13b4faf6..f9ba0772e471 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2256,35 +2256,51 @@ static void mac80211_hwsim_get_et_stats(struct ieee80211_hw *hw,
 	WARN_ON(i != MAC80211_HWSIM_SSTATS_LEN);
 }
 
+#define HWSIM_COMMON_OPS					\
+	.tx = mac80211_hwsim_tx,				\
+	.start = mac80211_hwsim_start,				\
+	.stop = mac80211_hwsim_stop,				\
+	.add_interface = mac80211_hwsim_add_interface,		\
+	.change_interface = mac80211_hwsim_change_interface,	\
+	.remove_interface = mac80211_hwsim_remove_interface,	\
+	.config = mac80211_hwsim_config,			\
+	.configure_filter = mac80211_hwsim_configure_filter,	\
+	.bss_info_changed = mac80211_hwsim_bss_info_changed,	\
+	.sta_add = mac80211_hwsim_sta_add,			\
+	.sta_remove = mac80211_hwsim_sta_remove,		\
+	.sta_notify = mac80211_hwsim_sta_notify,		\
+	.set_tim = mac80211_hwsim_set_tim,			\
+	.conf_tx = mac80211_hwsim_conf_tx,			\
+	.get_survey = mac80211_hwsim_get_survey,		\
+	CFG80211_TESTMODE_CMD(mac80211_hwsim_testmode_cmd)	\
+	.ampdu_action = mac80211_hwsim_ampdu_action,		\
+	.flush = mac80211_hwsim_flush,				\
+	.get_tsf = mac80211_hwsim_get_tsf,			\
+	.set_tsf = mac80211_hwsim_set_tsf,			\
+	.get_et_sset_count = mac80211_hwsim_get_et_sset_count,	\
+	.get_et_stats = mac80211_hwsim_get_et_stats,		\
+	.get_et_strings = mac80211_hwsim_get_et_strings,
+
 static const struct ieee80211_ops mac80211_hwsim_ops = {
-	.tx = mac80211_hwsim_tx,
-	.start = mac80211_hwsim_start,
-	.stop = mac80211_hwsim_stop,
-	.add_interface = mac80211_hwsim_add_interface,
-	.change_interface = mac80211_hwsim_change_interface,
-	.remove_interface = mac80211_hwsim_remove_interface,
-	.config = mac80211_hwsim_config,
-	.configure_filter = mac80211_hwsim_configure_filter,
-	.bss_info_changed = mac80211_hwsim_bss_info_changed,
-	.sta_add = mac80211_hwsim_sta_add,
-	.sta_remove = mac80211_hwsim_sta_remove,
-	.sta_notify = mac80211_hwsim_sta_notify,
-	.set_tim = mac80211_hwsim_set_tim,
-	.conf_tx = mac80211_hwsim_conf_tx,
-	.get_survey = mac80211_hwsim_get_survey,
-	CFG80211_TESTMODE_CMD(mac80211_hwsim_testmode_cmd)
-	.ampdu_action = mac80211_hwsim_ampdu_action,
+	HWSIM_COMMON_OPS
 	.sw_scan_start = mac80211_hwsim_sw_scan,
 	.sw_scan_complete = mac80211_hwsim_sw_scan_complete,
-	.flush = mac80211_hwsim_flush,
-	.get_tsf = mac80211_hwsim_get_tsf,
-	.set_tsf = mac80211_hwsim_set_tsf,
-	.get_et_sset_count = mac80211_hwsim_get_et_sset_count,
-	.get_et_stats = mac80211_hwsim_get_et_stats,
-	.get_et_strings = mac80211_hwsim_get_et_strings,
 };
 
-static struct ieee80211_ops mac80211_hwsim_mchan_ops;
+static const struct ieee80211_ops mac80211_hwsim_mchan_ops = {
+	HWSIM_COMMON_OPS
+	.hw_scan = mac80211_hwsim_hw_scan,
+	.cancel_hw_scan = mac80211_hwsim_cancel_hw_scan,
+	.sw_scan_start = NULL,
+	.sw_scan_complete = NULL,
+	.remain_on_channel = mac80211_hwsim_roc,
+	.cancel_remain_on_channel = mac80211_hwsim_croc,
+	.add_chanctx = mac80211_hwsim_add_chanctx,
+	.remove_chanctx = mac80211_hwsim_remove_chanctx,
+	.change_chanctx = mac80211_hwsim_change_chanctx,
+	.assign_vif_chanctx = mac80211_hwsim_assign_vif_chanctx,
+	.unassign_vif_chanctx = mac80211_hwsim_unassign_vif_chanctx,
+};
 
 struct hwsim_new_radio_params {
 	unsigned int channels;
@@ -3360,21 +3376,6 @@ static int __init init_mac80211_hwsim(void)
 	if (channels < 1)
 		return -EINVAL;
 
-	mac80211_hwsim_mchan_ops = mac80211_hwsim_ops;
-	mac80211_hwsim_mchan_ops.hw_scan = mac80211_hwsim_hw_scan;
-	mac80211_hwsim_mchan_ops.cancel_hw_scan = mac80211_hwsim_cancel_hw_scan;
-	mac80211_hwsim_mchan_ops.sw_scan_start = NULL;
-	mac80211_hwsim_mchan_ops.sw_scan_complete = NULL;
-	mac80211_hwsim_mchan_ops.remain_on_channel = mac80211_hwsim_roc;
-	mac80211_hwsim_mchan_ops.cancel_remain_on_channel = mac80211_hwsim_croc;
-	mac80211_hwsim_mchan_ops.add_chanctx = mac80211_hwsim_add_chanctx;
-	mac80211_hwsim_mchan_ops.remove_chanctx = mac80211_hwsim_remove_chanctx;
-	mac80211_hwsim_mchan_ops.change_chanctx = mac80211_hwsim_change_chanctx;
-	mac80211_hwsim_mchan_ops.assign_vif_chanctx =
-		mac80211_hwsim_assign_vif_chanctx;
-	mac80211_hwsim_mchan_ops.unassign_vif_chanctx =
-		mac80211_hwsim_unassign_vif_chanctx;
-
 	spin_lock_init(&hwsim_radio_lock);
 
 	err = register_pernet_device(&hwsim_net_ops);
-- 
2.8.1
