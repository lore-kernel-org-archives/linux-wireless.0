Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:40246 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab3GHNO1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 09:14:27 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv3 3/5] mac80211: allow chanctx to change channels
Date: Mon,  8 Jul 2013 15:14:08 +0200
Message-Id: <1373289250-12259-4-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130708_151444_878107_28DF7E68)
In-Reply-To: <1373289250-12259-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1373289250-12259-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds mac80211/chanctx code to allow to change a channel definition
of an active channel context. This will be used for the channel switch
command added later.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 include/net/mac80211.h     |    4 ++++
 net/mac80211/chan.c        |   55 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |    4 ++++
 3 files changed, 63 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7c5dc78..aadf4eb 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -152,11 +152,13 @@ struct ieee80211_low_level_stats {
  * @IEEE80211_CHANCTX_CHANGE_WIDTH: The channel width changed
  * @IEEE80211_CHANCTX_CHANGE_RX_CHAINS: The number of RX chains changed
  * @IEEE80211_CHANCTX_CHANGE_RADAR: radar detection flag changed
+ * @IEEE80211_CHANCTX_CHANGE_CHANNEL: switched to another operating channel
  */
 enum ieee80211_chanctx_change {
 	IEEE80211_CHANCTX_CHANGE_WIDTH		= BIT(0),
 	IEEE80211_CHANCTX_CHANGE_RX_CHAINS	= BIT(1),
 	IEEE80211_CHANCTX_CHANGE_RADAR		= BIT(2),
+	IEEE80211_CHANCTX_CHANGE_CHANNEL	= BIT(3)
 };
 
 /**
@@ -222,6 +224,7 @@ struct ieee80211_chanctx_conf {
  * @BSS_CHANGED_BANDWIDTH: The bandwidth used by this interface changed,
  *	note that this is only called when it changes after the channel
  *	context had been assigned.
+ * @BSS_CHANGED_CHANNEL: The operating channel of this interface changed.
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -246,6 +249,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_P2P_PS		= 1<<19,
 	BSS_CHANGED_BEACON_INFO		= 1<<20,
 	BSS_CHANGED_BANDWIDTH		= 1<<21,
+	BSS_CHANGED_CHANNEL		= 1<<22,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 03e8d2e..7816703 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -410,6 +410,61 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 	return ret;
 }
 
+int ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
+				 const struct cfg80211_chan_def *chandef,
+				 u32 *changed)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *conf;
+	struct ieee80211_chanctx *ctx;
+	int ret;
+	u32 chanctx_changed = 0;
+
+	if (!cfg80211_chandef_usable(sdata->local->hw.wiphy, chandef,
+				     IEEE80211_CHAN_DISABLED))
+		return -EINVAL;
+
+	mutex_lock(&local->chanctx_mtx);
+	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+					 lockdep_is_held(&local->chanctx_mtx));
+	if (!conf) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ctx = container_of(conf, struct ieee80211_chanctx, conf);
+	if (ctx->refcount != 1) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (sdata->vif.bss_conf.chandef.width != chandef->width) {
+		chanctx_changed = IEEE80211_CHANCTX_CHANGE_WIDTH;
+		*changed |= BSS_CHANGED_BANDWIDTH;
+	}
+
+	sdata->vif.bss_conf.chandef = *chandef;
+	ctx->conf.def = *chandef;
+
+	chanctx_changed |= IEEE80211_CHANCTX_CHANGE_CHANNEL;
+	*changed |= BSS_CHANGED_CHANNEL;
+	drv_change_chanctx(local, ctx, chanctx_changed);
+
+	if (!local->use_chanctx) {
+		local->_oper_chandef = *chandef;
+		ieee80211_hw_config(local, 0);
+	}
+
+	ieee80211_recalc_chanctx_chantype(local, ctx);
+	ieee80211_recalc_smps_chanctx(local, ctx);
+	ieee80211_recalc_radar_chanctx(local, ctx);
+
+	ret = 0;
+ out:
+	mutex_unlock(&local->chanctx_mtx);
+	return ret;
+}
+
 int ieee80211_vif_change_bandwidth(struct ieee80211_sub_if_data *sdata,
 				   const struct cfg80211_chan_def *chandef,
 				   u32 *changed)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 683751a..e34eb5f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1625,6 +1625,10 @@ int __must_check
 ieee80211_vif_change_bandwidth(struct ieee80211_sub_if_data *sdata,
 			       const struct cfg80211_chan_def *chandef,
 			       u32 *changed);
+int __must_check
+ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
+			     const struct cfg80211_chan_def *chandef,
+			     u32 *changed);
 void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata);
 void ieee80211_vif_vlan_copy_chanctx(struct ieee80211_sub_if_data *sdata);
 void ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *sdata,
-- 
1.7.10.4

