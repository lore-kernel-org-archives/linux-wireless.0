Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:52587 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755996AbaIZTf3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 15:35:29 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: emmanuel.grumbach@intel.com, michal.kazior@tieto.com,
	linux-wireless@vger.kernel.org
Date: Fri, 26 Sep 2014 22:35:03 +0300
Message-Id: <1411760105-18614-6-git-send-email-luca@coelho.fi> (sfid-20140926_213541_922260_D1FDC3D8)
In-Reply-To: <1411760105-18614-1-git-send-email-luca@coelho.fi>
References: <1411760105-18614-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 5/7] mac80211: add post_channel_switch driver operation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

As a counterpart to the pre_channel_switch operation, add a
post_channel_switch operation.  This allows the drivers to go back to
a normal configuration after the channel switch is completed.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h    |  6 ++++++
 net/mac80211/cfg.c        |  7 ++++++-
 net/mac80211/driver-ops.h | 16 ++++++++++++++++
 net/mac80211/mlme.c       |  9 +++++++++
 net/mac80211/trace.h      |  6 ++++++
 5 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 19e4159..7861ed8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2836,6 +2836,9 @@ enum ieee80211_roc_type {
  *	before a channel switch procedure is started (ie. when a STA
  *	gets a CSA or an userspace initiated channel-switch), allowing
  *	the driver to prepare for the channel switch.
+ * @post_channel_switch: This is an optional callback that is called
+ *	after a channel switch procedure is completed, allowing the
+ *	driver to go back to a normal configuration.
  *
  * @join_ibss: Join an IBSS (on an IBSS interface); this is called after all
  *	information in bss_conf is set up and the beacon can be retrieved. A
@@ -3046,6 +3049,9 @@ struct ieee80211_ops {
 				  struct ieee80211_vif *vif,
 				  struct ieee80211_channel_switch *ch_switch);
 
+	int (*post_channel_switch)(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif);
+
 	int (*join_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 	void (*leave_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 	u32 (*get_expected_throughput)(struct ieee80211_sta *sta);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2caa7f0..ce81ff2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2868,7 +2868,6 @@ static int __ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 		return err;
 
 	ieee80211_bss_info_change_notify(sdata, changed);
-	cfg80211_ch_switch_notify(sdata->dev, &sdata->csa_chandef);
 
 	if (sdata->csa_block_tx) {
 		ieee80211_wake_vif_queues(local, sdata,
@@ -2876,6 +2875,12 @@ static int __ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 		sdata->csa_block_tx = false;
 	}
 
+	err = drv_post_channel_switch(sdata);
+	if (err)
+		return err;
+
+	cfg80211_ch_switch_notify(sdata->dev, &sdata->csa_chandef);
+
 	return 0;
 }
 
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 5522672..0a60906 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1214,6 +1214,22 @@ drv_pre_channel_switch(struct ieee80211_sub_if_data *sdata,
 	return ret;
 }
 
+static inline int
+drv_post_channel_switch(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	int ret = 0;
+
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
+
+	trace_drv_post_channel_switch(local, sdata);
+	if (local->ops->post_channel_switch)
+		ret = local->ops->post_channel_switch(&local->hw, &sdata->vif);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
 static inline int drv_join_ibss(struct ieee80211_local *local,
 				struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c5fa20f..2e29cc3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1010,6 +1010,15 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 		sdata->csa_block_tx = false;
 	}
 
+	ret = drv_post_channel_switch(sdata);
+	if (ret) {
+		sdata_info(sdata,
+			   "driver post channel switch failed, disconnecting\n");
+		ieee80211_queue_work(&local->hw,
+				     &ifmgd->csa_connection_drop_work);
+		goto out;
+	}
+
 	ieee80211_sta_reset_beacon_monitor(sdata);
 	ieee80211_sta_reset_conn_monitor(sdata);
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 30476d2..ca0e12d 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -2141,6 +2141,12 @@ TRACE_EVENT(drv_pre_channel_switch,
 	)
 );
 
+DEFINE_EVENT(local_sdata_evt, drv_post_channel_switch,
+	     TP_PROTO(struct ieee80211_local *local,
+		      struct ieee80211_sub_if_data *sdata),
+	     TP_ARGS(local, sdata)
+);
+
 
 #ifdef CONFIG_MAC80211_MESSAGE_TRACING
 #undef TRACE_SYSTEM
-- 
2.1.0

