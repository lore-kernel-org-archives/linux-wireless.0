Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002Ab0CJPXr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 10:23:47 -0500
Date: Wed, 10 Mar 2010 16:21:35 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [RFC PATCH 1/2] mac80211: disable_qos callback
Message-ID: <20100310152134.GC2969@dhcp-lab-161.englab.brq.redhat.com>
References: <20100309132113.GA2462@dhcp-lab-161.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100309132113.GA2462@dhcp-lab-161.englab.brq.redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add disable_qos callback and use it when AP do not send
QoS (WMM) information.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 include/net/mac80211.h    |    1 +
 net/mac80211/driver-ops.h |    9 +++++++++
 net/mac80211/mlme.c       |    5 ++++-
 3 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 998c30f..e646e8f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1504,6 +1504,7 @@ struct ieee80211_ops {
 			enum sta_notify_cmd, struct ieee80211_sta *sta);
 	int (*conf_tx)(struct ieee80211_hw *hw, u16 queue,
 		       const struct ieee80211_tx_queue_params *params);
+	int (*disable_qos)(struct ieee80211_hw *hw);
 	int (*get_tx_stats)(struct ieee80211_hw *hw,
 			    struct ieee80211_tx_queue_stats *stats);
 	u64 (*get_tsf)(struct ieee80211_hw *hw);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 020a94a..471e297 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -198,6 +198,15 @@ static inline int drv_conf_tx(struct ieee80211_local *local, u16 queue,
 	return ret;
 }
 
+static inline int drv_disable_qos(struct ieee80211_local *local)
+{
+	int ret = -EOPNOTSUPP;
+	if (local->ops->disable_qos)
+		ret = local->ops->disable_qos(&local->hw);
+	/* TODO trace_drv_disable_qos(local); */
+	return ret;
+}
+
 static inline int drv_get_tx_stats(struct ieee80211_local *local,
 				   struct ieee80211_tx_queue_stats *stats)
 {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6cae295..928cc07 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1584,8 +1584,11 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	if (elems.wmm_param)
 		ieee80211_sta_wmm_params(local, ifmgd, elems.wmm_param,
 					 elems.wmm_param_len);
-	else
+	else {
+		/* set QoS default parameters but disable it */
 		ieee80211_set_wmm_default(sdata);
+		drv_disable_qos(sdata->local);
+	}
 
 	if (elems.ht_info_elem && elems.wmm_param &&
 	    (ifmgd->flags & IEEE80211_STA_WMM_ENABLED) &&
-- 
1.6.6

