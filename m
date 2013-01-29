Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43075 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3A2Xru (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 18:47:50 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3/7] mac80211: Improve error handling for off-channel operation
Date: Tue, 29 Jan 2013 17:47:31 -0600
Message-Id: <1359503255-18270-4-git-send-email-seth.forshee@canonical.com> (sfid-20130130_004755_536086_AAD54B71)
In-Reply-To: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
References: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Errors in sending nullfunc or probe request frames during off-channel
operation may have undesirable consequences, e.g. failure to set
powersave at the AP. Add error handling for failures to transmit these
frames. In the case of a nullfunc failure, fail to go off-channel and
return an error to userspace. In the case of a failed probe request,
abort the scan.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 net/mac80211/ieee80211_i.h |    6 +++---
 net/mac80211/mlme.c        |    6 +++---
 net/mac80211/offchannel.c  |   24 ++++++++++++++++++------
 net/mac80211/scan.c        |   41 ++++++++++++++++++++++++++++-------------
 net/mac80211/util.c        |   12 ++++++++----
 5 files changed, 60 insertions(+), 29 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8374763..c062d20 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1369,7 +1369,7 @@ int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sched_scan_stopped_work(struct work_struct *work);
 
 /* off-channel helpers */
-void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local);
+bool ieee80211_offchannel_stop_vifs(struct ieee80211_local *local);
 void ieee80211_offchannel_return(struct ieee80211_local *local);
 void ieee80211_roc_setup(struct ieee80211_local *local);
 void ieee80211_start_next_roc(struct ieee80211_local *local);
@@ -1582,7 +1582,7 @@ u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
 void ieee80211_dynamic_ps_enable_work(struct work_struct *work);
 void ieee80211_dynamic_ps_disable_work(struct work_struct *work);
 void ieee80211_dynamic_ps_timer(unsigned long data);
-void ieee80211_send_nullfunc(struct ieee80211_local *local,
+bool ieee80211_send_nullfunc(struct ieee80211_local *local,
 			     struct ieee80211_sub_if_data *sdata,
 			     int powersave);
 void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
@@ -1627,7 +1627,7 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 					  const u8 *ssid, size_t ssid_len,
 					  const u8 *ie, size_t ie_len,
 					  bool directed);
-void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
+bool ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			      const u8 *ssid, size_t ssid_len,
 			      const u8 *ie, size_t ie_len,
 			      u32 ratemask, bool directed, bool no_cck,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6757ee2..7211344 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -664,7 +664,7 @@ void ieee80211_send_pspoll(struct ieee80211_local *local,
 	ieee80211_tx_skb(sdata, skb);
 }
 
-void ieee80211_send_nullfunc(struct ieee80211_local *local,
+bool ieee80211_send_nullfunc(struct ieee80211_local *local,
 			     struct ieee80211_sub_if_data *sdata,
 			     int powersave)
 {
@@ -674,7 +674,7 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 
 	skb = ieee80211_nullfunc_get(&local->hw, &sdata->vif);
 	if (!skb)
-		return;
+		return false;
 
 	nullfunc = (struct ieee80211_hdr_3addr *) skb->data;
 	if (powersave)
@@ -685,7 +685,7 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 			    IEEE80211_STA_CONNECTION_POLL))
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_USE_MINRATE;
 
-	ieee80211_tx_skb_offchannel(sdata, skb);
+	return ieee80211_tx_skb_offchannel(sdata, skb) == IEEE80211_TX_OK;
 }
 
 static void ieee80211_send_4addr_nullfunc(struct ieee80211_local *local,
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 5b9b3b8..650af94 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -24,10 +24,11 @@
  * because we *may* be doing work on-operating channel, and want our
  * hardware unconditionally awake, but still let the AP send us normal frames.
  */
-static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
+static bool ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	bool ret = true;
 
 	local->offchannel_ps_enabled = false;
 
@@ -57,7 +58,9 @@ static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 		 * to send a new nullfunc frame to inform the AP that we
 		 * are again sleeping.
 		 */
-		ieee80211_send_nullfunc(local, sdata, 1);
+		ret = ieee80211_send_nullfunc(local, sdata, 1);
+
+	return ret;
 }
 
 /* inform AP that we are awake again, unless power save is enabled */
@@ -102,12 +105,13 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 	ieee80211_sta_reset_conn_monitor(sdata);
 }
 
-void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local)
+bool ieee80211_offchannel_stop_vifs(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
+	bool ret = true;
 
 	if (WARN_ON(local->use_chanctx))
-		return;
+		return false;
 
 	/*
 	 * notify the AP about us leaving the channel and stop all
@@ -138,10 +142,18 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local)
 		}
 
 		if (sdata->vif.type == NL80211_IFTYPE_STATION &&
-		    sdata->u.mgd.associated)
-			ieee80211_offchannel_ps_enable(sdata);
+		    sdata->u.mgd.associated) {
+			ret = ieee80211_offchannel_ps_enable(sdata);
+			if (!ret)
+				break;
+		}
 	}
 	mutex_unlock(&local->iflist_mtx);
+
+	/* Attempt to recover if failed */
+	if (!ret)
+		ieee80211_offchannel_return(local);
+	return ret;
 }
 
 void ieee80211_offchannel_return(struct ieee80211_local *local)
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 607684c..894c95e 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -340,7 +340,8 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 	local->next_scan_state = SCAN_DECISION;
 	local->scan_channel_idx = 0;
 
-	ieee80211_offchannel_stop_vifs(local);
+	if (!ieee80211_offchannel_stop_vifs(local))
+		goto error;
 
 	ieee80211_configure_filter(local);
 
@@ -351,6 +352,10 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 				     &local->scan_work, 0);
 
 	return 0;
+
+error:
+	drv_sw_scan_complete(local);
+	return -EBUSY;
 }
 
 static bool ieee80211_can_scan(struct ieee80211_local *local,
@@ -390,26 +395,32 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 	int i;
 	struct ieee80211_sub_if_data *sdata;
 	enum ieee80211_band band = local->hw.conf.channel->band;
+	bool success = true;
 
 	sdata = rcu_dereference_protected(local->scan_sdata,
 					  lockdep_is_held(&local->mtx));
 
-	for (i = 0; i < local->scan_req->n_ssids; i++)
-		ieee80211_send_probe_req(
-			sdata, NULL,
-			local->scan_req->ssids[i].ssid,
-			local->scan_req->ssids[i].ssid_len,
-			local->scan_req->ie, local->scan_req->ie_len,
-			local->scan_req->rates[band], false,
-			local->scan_req->no_cck,
-			local->hw.conf.channel, true);
+	for (i = 0; success && i < local->scan_req->n_ssids; i++)
+		success = ieee80211_send_probe_req(
+				sdata, NULL,
+				local->scan_req->ssids[i].ssid,
+				local->scan_req->ssids[i].ssid_len,
+				local->scan_req->ie, local->scan_req->ie_len,
+				local->scan_req->rates[band], false,
+				local->scan_req->no_cck,
+				local->hw.conf.channel, true);
 
 	/*
 	 * After sending probe requests, wait for probe responses
 	 * on the channel.
 	 */
-	*next_delay = IEEE80211_CHANNEL_TIME;
-	local->next_scan_state = SCAN_DECISION;
+	if (success) {
+		*next_delay = IEEE80211_CHANNEL_TIME;
+		local->next_scan_state = SCAN_DECISION;
+	} else {
+		*next_delay = 0;
+		local->next_scan_state = SCAN_ABORT;
+	}
 }
 
 static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
@@ -688,7 +699,11 @@ static void ieee80211_scan_state_suspend(struct ieee80211_local *local,
 static void ieee80211_scan_state_resume(struct ieee80211_local *local,
 					unsigned long *next_delay)
 {
-	ieee80211_offchannel_stop_vifs(local);
+	if (!ieee80211_offchannel_stop_vifs(local)) {
+		*next_delay = 0;
+		local->next_scan_state = SCAN_ABORT;
+		return;
+	}
 
 	if (local->ops->flush) {
 		drv_flush(local, false);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 5259557..0923892 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1274,13 +1274,14 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 	return skb;
 }
 
-void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
+bool ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			      const u8 *ssid, size_t ssid_len,
 			      const u8 *ie, size_t ie_len,
 			      u32 ratemask, bool directed, bool no_cck,
 			      struct ieee80211_channel *channel, bool scan)
 {
 	struct sk_buff *skb;
+	enum ieee80211_tx_status tx_stat = IEEE80211_TX_DROPPED;
 
 	skb = ieee80211_build_probe_req(sdata, dst, ratemask, channel,
 					ssid, ssid_len,
@@ -1290,11 +1291,14 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			IEEE80211_SKB_CB(skb)->flags |=
 				IEEE80211_TX_CTL_NO_CCK_RATE;
 		if (scan)
-			ieee80211_tx_skb_tid_band(sdata, skb, 7,
-						  channel->band, true);
+			tx_stat = ieee80211_tx_skb_tid_band(sdata, skb, 7,
+							    channel->band,
+							    true);
 		else
-			ieee80211_tx_skb(sdata, skb);
+			tx_stat = ieee80211_tx_skb(sdata, skb);
 	}
+
+	return tx_stat != IEEE80211_TX_DROPPED;
 }
 
 u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
-- 
1.7.9.5

