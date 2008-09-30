Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:9233 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115AbYI3UHc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 16:07:32 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/2] mac80211: modify SM_PS state upon change in power save state
Date: Tue, 30 Sep 2008 23:07:25 +0300
Message-Id: <1222805245-31166-2-git-send-email-tomas.winkler@intel.com> (sfid-20080930_220736_415710_7E589876)
In-Reply-To: <1222805245-31166-1-git-send-email-tomas.winkler@intel.com>
References: <1222805245-31166-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Upon change in power save state the driver may want to change also the SM_PS
state. PS and SM_PS are generally independent but it's logical to tight them together
to narrow the interface.
In PS mode driver if switches off RX chains, it also might need to change
to DYNAMIC SM_PS state.
When going back to CAM mode, the driver may need to go to DISABLE SM_PS state.

This patch allows the driver to configure which SM_SP state to switch to
upon change in power state.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 include/net/mac80211.h |    8 ++++++++
 net/mac80211/ht.c      |    5 +++++
 net/mac80211/main.c    |    5 +++++
 net/mac80211/mlme.c    |    3 +++
 net/mac80211/wext.c    |   32 ++++++++++++++++++++++----------
 5 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f15e495..0edcd18 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -459,6 +459,8 @@ enum ieee80211_conf_flags {
  * @max_antenna_gain: maximum antenna gain (in dBi)
  * @antenna_sel_tx: transmit antenna selection, 0: default/diversity,
  *	1/2: antenna 0/1
+ * @sm_ps_mode: spatial multiplexing power save mode
+ * 	takes values of: WLAN_HT_CAP_SM_PS_YYYY
  * @antenna_sel_rx: receive antenna selection, like @antenna_sel_tx
  * @ht_conf: describes current self configuration of 802.11n HT capabilies
  * @ht_bss_conf: describes current BSS configuration of 802.11n HT parameters
@@ -474,6 +476,8 @@ struct ieee80211_conf {
 	int max_antenna_gain;
 	u8 antenna_sel_tx;
 	u8 antenna_sel_rx;
+	u8 sm_ps_mode;
+
 
 	struct ieee80211_channel *channel;
 
@@ -828,6 +832,8 @@ enum ieee80211_hw_flags {
  *	within &struct ieee80211_vif.
  * @sta_data_size: size (in bytes) of the drv_priv data area
  *	within &struct ieee80211_sta.
+ * @sm_ps_psp_mode: what sm_ps mode should be use while in PSP mode
+ * @sm_ps_cam_mode: what sm_ps mode should be use while in CAM mode
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -843,6 +849,8 @@ struct ieee80211_hw {
 	u16 queues;
 	u16 ampdu_queues;
 	u16 max_listen_interval;
+	u8 sm_ps_psp_mode;
+	u8 sm_ps_cam_mode;
 	s8 max_signal;
 };
 
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index e468137..c0f7454 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -1061,11 +1061,16 @@ void ieee80211_sm_ps_update(struct ieee80211_hw *hw, u8 new_mode)
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_local *local = hw_to_local(hw);
 
+	if (local->hw.conf.sm_ps_mode == new_mode)
+		return;
+
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		ieee80211_send_sm_ps(sdata, new_mode);
 	}
 	rcu_read_unlock();
+
+	local->hw.conf.sm_ps_mode = new_mode;
 }
 EXPORT_SYMBOL(ieee80211_sm_ps_update);
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d608c44..ba5834b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -760,6 +760,11 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	local->short_retry_limit = 7;
 	local->long_retry_limit = 4;
 	local->hw.conf.radio_enabled = 1;
+	
+	local->hw.sm_ps_psp_mode = WLAN_HT_CAP_SM_PS_DISABLED;
+	local->hw.sm_ps_cam_mode = WLAN_HT_CAP_SM_PS_DISABLED;
+	local->hw.conf.sm_ps_mode = WLAN_HT_CAP_SM_PS_DISABLED;
+	
 
 	INIT_LIST_HEAD(&local->interfaces);
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4c9dc81..1ead57b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -416,6 +416,9 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 			break;
 		}
 
+		cap &= ~IEEE80211_HT_CAP_SM_PS;
+		cap |= local->hw.conf.sm_ps_mode << 2;
+
 		tmp = cpu_to_le16(cap);
 		pos = skb_put(skb, sizeof(struct ieee80211_ht_cap)+2);
 		*pos++ = WLAN_EID_HT_CAPABILITY;
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 7e0d53a..ba907f4 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -977,21 +977,33 @@ static int ieee80211_ioctl_siwpower(struct net_device *dev,
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_conf *conf = &local->hw.conf;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	u8 sm_ps_mode;
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP)
+		return -EOPNOTSUPP;
 
 	if (wrq->disabled) {
 		conf->flags &= ~IEEE80211_CONF_PS;
-		return ieee80211_hw_config(local);
+		sm_ps_mode = local->hw.sm_ps_cam_mode;
+	} else {
+		switch (wrq->flags & IW_POWER_MODE) {
+		case IW_POWER_ON:       /* If not specified */
+		case IW_POWER_MODE:     /* If set all mask */
+		case IW_POWER_ALL_R:    /* If explicitely state all */
+			conf->flags |= IEEE80211_CONF_PS;
+			sm_ps_mode = local->hw.sm_ps_psp_mode;
+			break;
+		default:                /* Otherwise we don't support it */
+			return -EINVAL;
+		}
 	}
 
-	switch (wrq->flags & IW_POWER_MODE) {
-	case IW_POWER_ON:       /* If not specified */
-	case IW_POWER_MODE:     /* If set all mask */
-	case IW_POWER_ALL_R:    /* If explicitely state all */
-		conf->flags |= IEEE80211_CONF_PS;
-		break;
-	default:                /* Otherwise we don't support it */
-		return -EINVAL;
-	}
+	if (sdata->bss_conf.assoc_ht)
+		/* we need to update the AP about the change.
+		 * If we are in HT, then we are in STA mode
+		 * conf->sm_ps_mode is updated insde the function*/
+		ieee80211_sm_ps_update(&local->hw, sm_ps_mode);
 
 	return ieee80211_hw_config(local);
 }
-- 
1.5.4.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

