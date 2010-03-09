Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab0CINXc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 08:23:32 -0500
Date: Tue, 9 Mar 2010 14:21:14 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [RFC] mac80211,iwlwifi: disabling qos queues
Message-ID: <20100309132113.GA2462@dhcp-lab-161.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm trying to solve connection fails to quite old b/g only AP.

wlan0: associate with AP 00:0c:f6:3f:0d:3e
wlan0: RX AssocResp from 00:0c:f6:3f:0d:3e (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociated (Reason: 14)
wlan0: deauthenticated (Reason: 6)
wlan0: direct probe to AP 00:0c:f6:3f:0d:3e try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:0c:f6:3f:0d:3e
wlan0: authenticated
wlan0: associate with AP 00:0c:f6:3f:0d:3e
wlan0: RX ReassocResp from 00:0c:f6:3f:0d:3e (capab=0x411 status=12
aid=1)
wlan0: AP denied association (code=12)
wlan0: associate with AP 00:0c:f6:3f:0d:3e
wlan0: RX AssocResp from 00:0c:f6:3f:0d:3e (capab=0x411 status=12 aid=1)
wlan0: AP denied association (code=12)
wlan0: associate with AP 00:0c:f6:3f:0d:3e
wlan0: RX AssocResp from 00:0c:f6:3f:0d:3e (capab=0x411 status=12 aid=1)
wlan0: AP denied association (code=12)
wlan0: association with AP 00:0c:f6:3f:0d:3e timed out

More details are here:
http://bugzilla.redhat.com/show_bug.cgi?id=539878

Since bug is regression, I did bisection and bad commit is:

commit aa837e1d6bd1a71b3c30c7738b6c29d41512fe7d  
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Thu May 7 16:16:24 2009 +0200            

    mac80211: set default QoS values according to spec

After reverting commit on 2.6.31 kernel, I was able to successfully
and permanently associate with AP. But reverting commit on 2.6.33 kernel
do not give positive result, seems something else was changed. 

Problem is that we enable QoS queues, when AP do not send us any QoS
parameters. I think when AP not support QoS and does not tell anything
about that, we should not enable QoS in H/W. I prepared a draft patch,
it fixes the issue. However I'm not sure if this is right approach,
perhaps we should find something better.

Cheers
Stanislaw

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 1c9866d..64639fc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3253,6 +3253,8 @@ static struct attribute_group iwl_attribute_group = {
 	.attrs = iwl_sysfs_entries,
 };
 
+extern int iwl_mac_reset_tx(struct ieee80211_hw *);
+
 static struct ieee80211_ops iwl_hw_ops = {
 	.tx = iwl_mac_tx,
 	.start = iwl_mac_start,
@@ -3266,6 +3268,7 @@ static struct ieee80211_ops iwl_hw_ops = {
 	.get_stats = iwl_mac_get_stats,
 	.get_tx_stats = iwl_mac_get_tx_stats,
 	.conf_tx = iwl_mac_conf_tx,
+	.reset_tx = iwl_mac_reset_tx,
 	.reset_tsf = iwl_mac_reset_tsf,
 	.bss_info_changed = iwl_bss_info_changed,
 	.ampdu_action = iwl_mac_ampdu_action,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index f36f804..cce3ef6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2287,6 +2287,15 @@ int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 }
 EXPORT_SYMBOL(iwl_mac_conf_tx);
 
+int iwl_mac_reset_tx(struct ieee80211_hw *hw)
+{
+	struct iwl_priv *priv = hw->priv;
+	
+	iwl_reset_qos(priv);
+	return 0;
+}
+EXPORT_SYMBOL(iwl_mac_reset_tx);
+
 static void iwl_ht_conf(struct iwl_priv *priv,
 			struct ieee80211_bss_conf *bss_conf)
 {
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0bf3697..772474c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1523,6 +1523,7 @@ struct ieee80211_ops {
 			enum sta_notify_cmd, struct ieee80211_sta *sta);
 	int (*conf_tx)(struct ieee80211_hw *hw, u16 queue,
 		       const struct ieee80211_tx_queue_params *params);
+	int (*reset_tx)(struct ieee80211_hw *hw);
 	int (*get_tx_stats)(struct ieee80211_hw *hw,
 			    struct ieee80211_tx_queue_stats *stats);
 	u64 (*get_tsf)(struct ieee80211_hw *hw);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 921dd9c..30b0e89 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -198,6 +198,15 @@ static inline int drv_conf_tx(struct ieee80211_local *local, u16 queue,
 	return ret;
 }
 
+static inline int drv_reset_tx(struct ieee80211_local *local)
+{
+	int ret = -EOPNOTSUPP;
+	if (local->ops->reset_tx)
+		ret = local->ops->reset_tx(&local->hw);
+//	trace_drv_conf_tx(local, queue, params, ret);
+	return ret;
+}
+
 static inline int drv_get_tx_stats(struct ieee80211_local *local,
 				   struct ieee80211_tx_queue_stats *stats)
 {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 05a18f4..b6cc1b5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1596,7 +1596,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 		ieee80211_sta_wmm_params(local, ifmgd, elems.wmm_param,
 					 elems.wmm_param_len);
 	else
-		ieee80211_set_wmm_default(sdata);
+		drv_reset_tx(local);
 
 	if (elems.ht_info_elem && elems.wmm_param &&
 	    (ifmgd->flags & IEEE80211_STA_WMM_ENABLED) &&

