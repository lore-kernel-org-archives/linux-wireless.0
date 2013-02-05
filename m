Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47646 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab3BEP5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 10:57:43 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: move TSF into IEs
Date: Tue,  5 Feb 2013 16:58:06 +0100
Message-Id: <1360079886-25168-1-git-send-email-johannes@sipsolutions.net> (sfid-20130205_165746_901093_2ED9F28C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

While technically the TSF isn't an IE, it can be
necessary to distinguish between the TSF from a
beacon and a probe response, in particular in
order to know the next DTIM TBTT, as not all APs
are spec compliant wrt. TSF==0 being a DTIM TBTT
and thus the DTIM count needs to be taken into
account as well.

To allow this, move the TSF into the IE struct
so it can be known whence it came.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c |  2 +-
 include/net/cfg80211.h                   |  5 ++---
 net/mac80211/ibss.c                      | 14 ++++++++++----
 net/mac80211/mlme.c                      |  6 +++++-
 net/wireless/nl80211.c                   | 27 ++++++++++++++++-----------
 net/wireless/scan.c                      |  7 +++----
 6 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 8866a2b..0d01846 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -164,6 +164,7 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 	ies = rcu_dereference(bss->ies);
 	beacon_ie = kmemdup(ies->data, ies->len, GFP_ATOMIC);
 	beacon_ie_len = ies->len;
+	bss_desc->timestamp = ies->tsf;
 	rcu_read_unlock();
 
 	if (!beacon_ie) {
@@ -179,7 +180,6 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 	bss_desc->cap_info_bitmap = bss->capability;
 	bss_desc->bss_band = bss_priv->band;
 	bss_desc->fw_tsf = bss_priv->fw_tsf;
-	bss_desc->timestamp = bss->tsf;
 	if (bss_desc->cap_info_bitmap & WLAN_CAPABILITY_PRIVACY) {
 		dev_dbg(priv->adapter->dev, "info: InterpretIE: AP WEP enabled\n");
 		bss_desc->privacy = MWIFIEX_802_11_PRIV_FILTER_8021X_WEP;
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7b73267..ce8e23c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1278,11 +1278,13 @@ enum cfg80211_signal_type {
 
 /**
  * struct cfg80211_bss_ie_data - BSS entry IE data
+ * @tsf: TSF contained in the frame that carried these IEs
  * @rcu_head: internal use, for freeing
  * @len: length of the IEs
  * @data: IE data
  */
 struct cfg80211_bss_ies {
+	u64 tsf;
 	struct rcu_head rcu_head;
 	int len;
 	u8 data[];
@@ -1296,7 +1298,6 @@ struct cfg80211_bss_ies {
  *
  * @channel: channel this BSS is on
  * @bssid: BSSID of the BSS
- * @tsf: timestamp of last received update
  * @beacon_interval: the beacon interval as from the frame
  * @capability: the capability field in host byte order
  * @ies: the information elements (Note that there is no guarantee that these
@@ -1316,8 +1317,6 @@ struct cfg80211_bss_ies {
  * @priv: private area for driver use, has at least wiphy->bss_priv_size bytes
  */
 struct cfg80211_bss {
-	u64 tsf;
-
 	struct ieee80211_channel *channel;
 
 	const struct cfg80211_bss_ies __rcu *ies;
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 71c55cc..055fa94 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -242,6 +242,8 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	u32 basic_rates;
 	int i, j;
 	u16 beacon_int = cbss->beacon_interval;
+	const struct cfg80211_bss_ies *ies;
+	u64 tsf;
 
 	lockdep_assert_held(&sdata->u.ibss.mtx);
 
@@ -265,13 +267,17 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+	rcu_read_lock();
+	ies = rcu_dereference(cbss->ies);
+	tsf = ies->tsf;
+	rcu_read_unlock();
+
 	__ieee80211_sta_join_ibss(sdata, cbss->bssid,
 				  beacon_int,
 				  cbss->channel,
 				  basic_rates,
 				  cbss->capability,
-				  cbss->tsf,
-				  false);
+				  tsf, false);
 }
 
 static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta,
@@ -535,8 +541,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 
 	cbss = container_of((void *)bss, struct cfg80211_bss, priv);
 
-	/* was just updated in ieee80211_bss_info_update */
-	beacon_timestamp = cbss->tsf;
+	/* same for beacon and probe response */
+	beacon_timestamp = le64_to_cpu(mgmt->u.beacon.timestamp);
 
 	/* check if we need to merge IBSS */
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 396a740..b49c484 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3693,6 +3693,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 		bool have_higher_than_11mbit;
 		int min_rate = INT_MAX, min_rate_index = -1;
 		struct ieee80211_supported_band *sband;
+		const struct cfg80211_bss_ies *ies;
 
 		sband = local->hw.wiphy->bands[cbss->channel->band];
 
@@ -3736,7 +3737,10 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 
 		/* set timing information */
 		sdata->vif.bss_conf.beacon_int = cbss->beacon_interval;
-		sdata->vif.bss_conf.sync_tsf = cbss->tsf;
+		rcu_read_lock();
+		ies = rcu_dereference(cbss->ies);
+		sdata->vif.bss_conf.sync_tsf = ies->tsf;
+		rcu_read_unlock();
 		sdata->vif.bss_conf.sync_device_ts = bss->device_ts;
 
 		/* tell driver about BSSID, basic rates and timing */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5f1ad38..cae3968 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5075,6 +5075,7 @@ static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 	const struct cfg80211_bss_ies *ies;
 	void *hdr;
 	struct nlattr *bss;
+	bool tsf = false;
 
 	ASSERT_WDEV_LOCK(wdev);
 
@@ -5098,22 +5099,24 @@ static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 
 	rcu_read_lock();
 	ies = rcu_dereference(res->ies);
-	if (ies && ies->len && nla_put(msg, NL80211_BSS_INFORMATION_ELEMENTS,
-				       ies->len, ies->data)) {
-		rcu_read_unlock();
-		goto nla_put_failure;
+	if (ies) {
+		if (nla_put_u64(msg, NL80211_BSS_TSF, ies->tsf))
+			goto fail_unlock_rcu;
+		tsf = true;
+		if (ies->len && nla_put(msg, NL80211_BSS_INFORMATION_ELEMENTS,
+					ies->len, ies->data))
+			goto fail_unlock_rcu;
 	}
 	ies = rcu_dereference(res->beacon_ies);
-	if (ies && ies->len && nla_put(msg, NL80211_BSS_BEACON_IES,
-				       ies->len, ies->data)) {
-		rcu_read_unlock();
-		goto nla_put_failure;
+	if (ies) {
+		if (!tsf && nla_put_u64(msg, NL80211_BSS_TSF, ies->tsf))
+			goto fail_unlock_rcu;
+		if (ies->len && nla_put(msg, NL80211_BSS_BEACON_IES,
+					ies->len, ies->data))
+			goto fail_unlock_rcu;
 	}
 	rcu_read_unlock();
 
-	if (res->tsf &&
-	    nla_put_u64(msg, NL80211_BSS_TSF, res->tsf))
-		goto nla_put_failure;
 	if (res->beacon_interval &&
 	    nla_put_u16(msg, NL80211_BSS_BEACON_INTERVAL, res->beacon_interval))
 		goto nla_put_failure;
@@ -5158,6 +5161,8 @@ static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 
 	return genlmsg_end(msg, hdr);
 
+ fail_unlock_rcu:
+	rcu_read_unlock();
  nla_put_failure:
 	genlmsg_cancel(msg, hdr);
 	return -EMSGSIZE;
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 02a2383..b7a1679 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -695,7 +695,6 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 
 	if (found) {
 		found->pub.beacon_interval = tmp->pub.beacon_interval;
-		found->pub.tsf = tmp->pub.tsf;
 		found->pub.signal = tmp->pub.signal;
 		found->pub.capability = tmp->pub.capability;
 		found->ts = tmp->ts;
@@ -880,7 +879,6 @@ cfg80211_inform_bss(struct wiphy *wiphy,
 	memcpy(tmp.pub.bssid, bssid, ETH_ALEN);
 	tmp.pub.channel = channel;
 	tmp.pub.signal = signal;
-	tmp.pub.tsf = tsf;
 	tmp.pub.beacon_interval = beacon_interval;
 	tmp.pub.capability = capability;
 	/*
@@ -895,6 +893,7 @@ cfg80211_inform_bss(struct wiphy *wiphy,
 	if (!ies)
 		return NULL;
 	ies->len = ielen;
+	ies->tsf = tsf;
 	memcpy(ies->data, ie, ielen);
 
 	rcu_assign_pointer(tmp.pub.beacon_ies, ies);
@@ -951,6 +950,7 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 	if (!ies)
 		return NULL;
 	ies->len = ielen;
+	ies->tsf = le64_to_cpu(mgmt->u.probe_resp.timestamp);
 	memcpy(ies->data, mgmt->u.probe_resp.variable, ielen);
 
 	if (ieee80211_is_probe_resp(mgmt->frame_control))
@@ -962,7 +962,6 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 	memcpy(tmp.pub.bssid, mgmt->bssid, ETH_ALEN);
 	tmp.pub.channel = channel;
 	tmp.pub.signal = signal;
-	tmp.pub.tsf = le64_to_cpu(mgmt->u.probe_resp.timestamp);
 	tmp.pub.beacon_interval = le16_to_cpu(mgmt->u.probe_resp.beacon_int);
 	tmp.pub.capability = le16_to_cpu(mgmt->u.probe_resp.capab_info);
 
@@ -1409,7 +1408,7 @@ ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
 	if (buf) {
 		memset(&iwe, 0, sizeof(iwe));
 		iwe.cmd = IWEVCUSTOM;
-		sprintf(buf, "tsf=%016llx", (unsigned long long)(bss->pub.tsf));
+		sprintf(buf, "tsf=%016llx", (unsigned long long)(ies->tsf));
 		iwe.u.data.length = strlen(buf);
 		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
 						  &iwe, buf);
-- 
1.8.0

