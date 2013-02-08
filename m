Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60267 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab3BHR2h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 12:28:37 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 12/14] mac80211: add ieee80211_vif_change_bandwidth
Date: Fri,  8 Feb 2013 18:25:42 +0100
Message-Id: <1360344344-15742-13-git-send-email-johannes@sipsolutions.net> (sfid-20130208_183543_684982_0B82E846)
In-Reply-To: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net>
References: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For HT and VHT the current bandwidth can change,
add the function ieee80211_vif_change_bandwidth()
to take care of this. It returns a failure if the
new bandwidth isn't compatible with the existing
channel context, the caller has to handle that.
When it happens, also inform the driver that the
bandwidth changed for this virtual interface (no
drivers would actually care today though.)

Changing to/from HT/VHT isn't allowed though.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |  4 ++++
 net/mac80211/chan.c        | 49 ++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |  4 ++++
 3 files changed, 57 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a3a0bdf..db5330a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -210,6 +210,9 @@ struct ieee80211_chanctx_conf {
  *	changed (currently only in P2P client mode, GO mode will be later)
  * @BSS_CHANGED_DTIM_PERIOD: the DTIM period value was changed (set when
  *	it becomes valid, managed mode only)
+ * @BSS_CHANGED_BANDWIDTH: The bandwidth used by this interface changed,
+ *	note that this is only called when it changes after the channel
+ *	context had been assigned.
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -233,6 +236,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_TXPOWER		= 1<<18,
 	BSS_CHANGED_P2P_PS		= 1<<19,
 	BSS_CHANGED_DTIM_PERIOD		= 1<<20,
+	BSS_CHANGED_BANDWIDTH		= 1<<21,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 8fc56e4..2ad6c4d 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -336,6 +336,55 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 	return ret;
 }
 
+int ieee80211_vif_change_bandwidth(struct ieee80211_sub_if_data *sdata,
+				   const struct cfg80211_chan_def *chandef,
+				   u32 *changed)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *conf;
+	struct ieee80211_chanctx *ctx;
+	int ret;
+
+	if (!cfg80211_chandef_usable(sdata->local->hw.wiphy, chandef,
+				     IEEE80211_CHAN_DISABLED))
+		return -EINVAL;
+
+	mutex_lock(&local->chanctx_mtx);
+	if (cfg80211_chandef_identical(chandef, &sdata->vif.bss_conf.chandef)) {
+		ret = 0;
+		goto out;
+	}
+
+	if (chandef->width == NL80211_CHAN_WIDTH_20_NOHT ||
+	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_20_NOHT) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+					 lockdep_is_held(&local->chanctx_mtx));
+	if (!conf) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ctx = container_of(conf, struct ieee80211_chanctx, conf);
+	if (!cfg80211_chandef_compatible(&conf->def, chandef)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	sdata->vif.bss_conf.chandef = *chandef;
+
+	ieee80211_recalc_chanctx_chantype(local, ctx);
+
+	*changed |= BSS_CHANGED_BANDWIDTH;
+	ret = 0;
+ out:
+	mutex_unlock(&local->chanctx_mtx);
+	return ret;
+}
+
 void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
 {
 	WARN_ON(sdata->dev && netif_carrier_ok(sdata->dev));
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9ee9e63..57e390b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1609,6 +1609,10 @@ int __must_check
 ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 			  const struct cfg80211_chan_def *chandef,
 			  enum ieee80211_chanctx_mode mode);
+int __must_check
+ieee80211_vif_change_bandwidth(struct ieee80211_sub_if_data *sdata,
+			       const struct cfg80211_chan_def *chandef,
+			       u32 *changed);
 void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata);
 void ieee80211_vif_vlan_copy_chanctx(struct ieee80211_sub_if_data *sdata);
 void ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *sdata,
-- 
1.8.0

