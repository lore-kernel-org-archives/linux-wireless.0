Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43064 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab3A2Xrs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 18:47:48 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/7] mac80211: Fix tx queue handling during scans
Date: Tue, 29 Jan 2013 17:47:30 -0600
Message-Id: <1359503255-18270-3-git-send-email-seth.forshee@canonical.com> (sfid-20130130_004757_434420_4D57694D)
In-Reply-To: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
References: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Scans currently work by stopping the netdev tx queues but leaving the
mac80211 queues active. This stops the flow of incoming packets while
still allowing mac80211 to transmit nullfunc and probe request frames
to facilitate scanning. However, the driver may try to wake the
mac80211 queues while in this state, which will also wake the netdev
queues.

To prevent this, add a new queue stop reason,
IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL, to be used when stopping the tx
queues for off-channel operation. This prevents the netdev queues from
waking when a driver wakes the mac80211 queues.

This also stops all frames from being transmitted, even those required
for scanning. To get around this, add a new offchan_tx_ok argument to
most of the tx interfaces. This flag can be set for frames which need
to be transmitted during off-channel operation, allowing off-channel
frames to always be passed down to the driver as long as the driver
hasn't stopped the queues. Add ieee80211_tx_skb_offchannel() for
transmitting off-channel frames with this flag set.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 net/mac80211/agg-tx.c      |    4 ++--
 net/mac80211/cfg.c         |    2 +-
 net/mac80211/ht.c          |    2 +-
 net/mac80211/ieee80211_i.h |   25 ++++++++++++++++++-------
 net/mac80211/mlme.c        |    2 +-
 net/mac80211/offchannel.c  |   32 +++++++++++---------------------
 net/mac80211/sta_info.c    |    2 +-
 net/mac80211/tx.c          |   44 +++++++++++++++++++++++++++++---------------
 net/mac80211/util.c        |    3 ++-
 9 files changed, 66 insertions(+), 50 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 2f0ccbc..3c836fc 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -107,7 +107,7 @@ static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
 	mgmt->u.action.u.addba_req.start_seq_num =
 					cpu_to_le16(start_seq_num << 4);
 
-	ieee80211_tx_skb_tid(sdata, skb, tid);
+	ieee80211_tx_skb_tid(sdata, skb, tid, false);
 }
 
 void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn)
@@ -137,7 +137,7 @@ void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn)
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
 					IEEE80211_TX_CTL_REQ_TX_STATUS;
-	ieee80211_tx_skb_tid(sdata, skb, tid);
+	ieee80211_tx_skb_tid(sdata, skb, tid, false);
 }
 EXPORT_SYMBOL(ieee80211_send_bar);
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 661b878..fd38c37 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3211,7 +3211,7 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 		nullfunc->qos_ctrl = cpu_to_le16(7);
 
 	local_bh_disable();
-	ieee80211_xmit(sdata, skb, band);
+	ieee80211_xmit(sdata, skb, band, false);
 	local_bh_enable();
 	rcu_read_unlock();
 
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 61ac7c4..da61c41 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -311,7 +311,7 @@ void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
 	mgmt->u.action.u.delba.params = cpu_to_le16(params);
 	mgmt->u.action.u.delba.reason_code = cpu_to_le16(reason_code);
 
-	ieee80211_tx_skb_tid(sdata, skb, tid);
+	ieee80211_tx_skb_tid(sdata, skb, tid, false);
 }
 
 void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 13fd13a..8374763 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -842,6 +842,7 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_AGGREGATION,
 	IEEE80211_QUEUE_STOP_REASON_SUSPEND,
 	IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
+	IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL,
 };
 
 #ifdef CONFIG_MAC80211_LEDS
@@ -1510,22 +1511,23 @@ enum ieee80211_tx_status {
 
 enum ieee80211_tx_status
 ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-	       enum ieee80211_band band);
+	       enum ieee80211_band band, bool offchan_tx_ok);
 
 enum ieee80211_tx_status
 __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 			    struct sk_buff *skb, int tid,
-			    enum ieee80211_band band);
+			    enum ieee80211_band band, bool offchan_tx_ok);
 
 static inline enum ieee80211_tx_status
 ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 			  struct sk_buff *skb, int tid,
-			  enum ieee80211_band band)
+			  enum ieee80211_band band, bool offchan_tx_ok)
 {
 	enum ieee80211_tx_status ret;
 
 	rcu_read_lock();
-	ret = __ieee80211_tx_skb_tid_band(sdata, skb, tid, band);
+	ret = __ieee80211_tx_skb_tid_band(sdata, skb, tid, band,
+					  offchan_tx_ok);
 	rcu_read_unlock();
 
 	return ret;
@@ -1533,7 +1535,7 @@ ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 
 static inline enum ieee80211_tx_status
 ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-		     int tid)
+		     int tid, bool offchan_tx_ok)
 {
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	enum ieee80211_tx_status ret;
@@ -1547,7 +1549,8 @@ ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 	}
 
 	ret = __ieee80211_tx_skb_tid_band(sdata, skb, tid,
-					  chanctx_conf->def.chan->band);
+					  chanctx_conf->def.chan->band,
+					  offchan_tx_ok);
 	rcu_read_unlock();
 
 	return ret;
@@ -1557,7 +1560,15 @@ static inline enum ieee80211_tx_status
 ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 {
 	/* Send all internal mgmt frames on VO. Accordingly set TID to 7. */
-	return ieee80211_tx_skb_tid(sdata, skb, 7);
+	return ieee80211_tx_skb_tid(sdata, skb, 7, false);
+}
+
+static inline enum ieee80211_tx_status
+ieee80211_tx_skb_offchannel(struct ieee80211_sub_if_data *sdata,
+			    struct sk_buff *skb)
+{
+	/* Send all internal mgmt frames on VO. Accordingly set TID to 7. */
+	return ieee80211_tx_skb_tid(sdata, skb, 7, true);
 }
 
 void ieee802_11_parse_elems(u8 *start, size_t len,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e930175..6757ee2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -685,7 +685,7 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 			    IEEE80211_STA_CONNECTION_POLL))
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_USE_MINRATE;
 
-	ieee80211_tx_skb(sdata, skb);
+	ieee80211_tx_skb_offchannel(sdata, skb);
 }
 
 static void ieee80211_send_4addr_nullfunc(struct ieee80211_local *local,
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 82baf5b..5b9b3b8 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -113,6 +113,10 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local)
 	 * notify the AP about us leaving the channel and stop all
 	 * STA interfaces.
 	 */
+
+	ieee80211_stop_queues_by_reason(&local->hw,
+					IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL);
+
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (!ieee80211_sdata_running(sdata))
@@ -133,12 +137,9 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local)
 				sdata, BSS_CHANGED_BEACON_ENABLED);
 		}
 
-		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
-			netif_tx_stop_all_queues(sdata->dev);
-			if (sdata->vif.type == NL80211_IFTYPE_STATION &&
-			    sdata->u.mgd.associated)
-				ieee80211_offchannel_ps_enable(sdata);
-		}
+		if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+		    sdata->u.mgd.associated)
+			ieee80211_offchannel_ps_enable(sdata);
 	}
 	mutex_unlock(&local->iflist_mtx);
 }
@@ -166,20 +167,6 @@ void ieee80211_offchannel_return(struct ieee80211_local *local)
 		    sdata->u.mgd.associated)
 			ieee80211_offchannel_ps_disable(sdata);
 
-		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
-			/*
-			 * This may wake up queues even though the driver
-			 * currently has them stopped. This is not very
-			 * likely, since the driver won't have gotten any
-			 * (or hardly any) new packets while we weren't
-			 * on the right channel, and even if it happens
-			 * it will at most lead to queueing up one more
-			 * packet per queue in mac80211 rather than on
-			 * the interface qdisc.
-			 */
-			netif_tx_wake_all_queues(sdata->dev);
-		}
-
 		if (test_and_clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED,
 				       &sdata->state)) {
 			sdata->vif.bss_conf.enable_beacon = true;
@@ -188,6 +175,9 @@ void ieee80211_offchannel_return(struct ieee80211_local *local)
 		}
 	}
 	mutex_unlock(&local->iflist_mtx);
+
+	ieee80211_wake_queues_by_reason(&local->hw,
+					IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL);
 }
 
 void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc)
@@ -198,7 +188,7 @@ void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc)
 	if (roc->mgmt_tx_cookie) {
 		if (!WARN_ON(!roc->frame)) {
 			ieee80211_tx_skb_tid_band(roc->sdata, roc->frame, 7,
-						  roc->chan->band);
+						  roc->chan->band, true);
 			roc->frame = NULL;
 		}
 	} else {
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 9d864ed..d4e5915 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1122,7 +1122,7 @@ static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 
-	ieee80211_xmit(sdata, skb, chanctx_conf->def.chan->band);
+	ieee80211_xmit(sdata, skb, chanctx_conf->def.chan->band, false);
 	rcu_read_unlock();
 }
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7d25bb6..80b514a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1203,7 +1203,7 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 static enum ieee80211_tx_status
 ieee80211_tx_frags(struct ieee80211_local *local, struct ieee80211_vif *vif,
 		   struct ieee80211_sta *sta, struct sk_buff_head *skbs,
-		   bool txpending)
+		   bool txpending, bool offchan_tx_ok)
 {
 	struct ieee80211_tx_control control;
 	struct sk_buff *skb, *tmp;
@@ -1222,8 +1222,20 @@ ieee80211_tx_frags(struct ieee80211_local *local, struct ieee80211_vif *vif,
 #endif
 
 		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-		if (local->queue_stop_reasons[q] ||
-		    (!txpending && !skb_queue_empty(&local->pending[q]))) {
+		if (offchan_tx_ok) {
+			/*
+			 * Always directly transmit off-channel frames
+			 * unless the driver has stopped the queues.
+			 */
+			if (test_bit(IEEE80211_QUEUE_STOP_REASON_DRIVER,
+				     &local->queue_stop_reasons[q])) {
+				spin_unlock_irqrestore(&local->queue_stop_reason_lock,
+						       flags);
+				ieee80211_purge_tx_queue(&local->hw, skbs);
+				return IEEE80211_TX_DROPPED;
+			}
+		} else if (local->queue_stop_reasons[q] ||
+			   (!txpending && !skb_queue_empty(&local->pending[q]))) {
 			/*
 			 * Since queue is stopped, queue up frames for later
 			 * transmission from the tx-pending tasklet when the
@@ -1253,7 +1265,8 @@ ieee80211_tx_frags(struct ieee80211_local *local, struct ieee80211_vif *vif,
 
 static enum ieee80211_tx_status
 __ieee80211_tx(struct ieee80211_local *local, struct sk_buff_head *skbs,
-	       int led_len, struct sta_info *sta, bool txpending)
+	       int led_len, struct sta_info *sta, bool txpending,
+	       bool offchan_tx_ok)
 {
 	struct ieee80211_tx_info *info;
 	struct ieee80211_sub_if_data *sdata;
@@ -1301,7 +1314,7 @@ __ieee80211_tx(struct ieee80211_local *local, struct sk_buff_head *skbs,
 	}
 
 	result = ieee80211_tx_frags(local, vif, pubsta, skbs,
-				    txpending);
+				    txpending, offchan_tx_ok);
 
 	ieee80211_tpt_led_trig_tx(local, fc, led_len);
 	ieee80211_led_tx(local, 1);
@@ -1369,7 +1382,7 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 
 static enum ieee80211_tx_status
 ieee80211_tx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-	     bool txpending, enum ieee80211_band band)
+	     bool txpending, enum ieee80211_band band, bool offchan_tx_ok)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_data tx;
@@ -1412,7 +1425,7 @@ ieee80211_tx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 
 	if (!invoke_tx_handlers(&tx))
 		result = __ieee80211_tx(local, &tx.skbs, led_len,
-					tx.sta, txpending);
+					tx.sta, txpending, offchan_tx_ok);
 
 	return result;
 }
@@ -1450,7 +1463,7 @@ static int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
 
 enum ieee80211_tx_status
 ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-	       enum ieee80211_band band)
+	       enum ieee80211_band band, bool offchan_tx_ok)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -1483,7 +1496,7 @@ ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 	}
 
 	ieee80211_set_qos_hdr(sdata, skb);
-	return ieee80211_tx(sdata, skb, false, band);
+	return ieee80211_tx(sdata, skb, false, band, offchan_tx_ok);
 }
 
 static bool ieee80211_parse_tx_radiotap(struct sk_buff *skb)
@@ -1703,7 +1716,7 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 			    IEEE80211_CHAN_PASSIVE_SCAN)))
 		goto fail_rcu;
 
-	ieee80211_xmit(sdata, skb, chan->band);
+	ieee80211_xmit(sdata, skb, chan->band, false);
 	rcu_read_unlock();
 
 	return NETDEV_TX_OK;
@@ -2147,7 +2160,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	info->flags = info_flags;
 	info->ack_frame_id = info_id;
 
-	ieee80211_xmit(sdata, skb, band);
+	ieee80211_xmit(sdata, skb, band, false);
 	rcu_read_unlock();
 
 	return NETDEV_TX_OK;
@@ -2198,7 +2211,7 @@ ieee80211_tx_pending_skb(struct ieee80211_local *local, struct sk_buff *skb)
 			return IEEE80211_TX_DROPPED;
 		}
 		tx_stat = ieee80211_tx(sdata, skb, true,
-				       chanctx_conf->def.chan->band);
+				       chanctx_conf->def.chan->band, false);
 	} else {
 		struct sk_buff_head skbs;
 
@@ -2208,7 +2221,8 @@ ieee80211_tx_pending_skb(struct ieee80211_local *local, struct sk_buff *skb)
 		hdr = (struct ieee80211_hdr *)skb->data;
 		sta = sta_info_get(sdata, hdr->addr1);
 
-		tx_stat = __ieee80211_tx(local, &skbs, skb->len, sta, true);
+		tx_stat = __ieee80211_tx(local, &skbs, skb->len, sta, true,
+					 false);
 	}
 
 	return tx_stat;
@@ -2779,7 +2793,7 @@ EXPORT_SYMBOL(ieee80211_get_buffered_bc);
 enum ieee80211_tx_status
 __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 			    struct sk_buff *skb, int tid,
-			    enum ieee80211_band band)
+			    enum ieee80211_band band, bool offchan_tx_ok)
 {
 	int ac = ieee802_1d_to_ac[tid & 7];
 	enum ieee80211_tx_status ret;
@@ -2797,7 +2811,7 @@ __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 	 * requirements are that we do not come into tx with bhs on.
 	 */
 	local_bh_disable();
-	ret = ieee80211_xmit(sdata, skb, band);
+	ret = ieee80211_xmit(sdata, skb, band, offchan_tx_ok);
 	local_bh_enable();
 
 	return ret;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7519018..5259557 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1290,7 +1290,8 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			IEEE80211_SKB_CB(skb)->flags |=
 				IEEE80211_TX_CTL_NO_CCK_RATE;
 		if (scan)
-			ieee80211_tx_skb_tid_band(sdata, skb, 7, channel->band);
+			ieee80211_tx_skb_tid_band(sdata, skb, 7,
+						  channel->band, true);
 		else
 			ieee80211_tx_skb(sdata, skb);
 	}
-- 
1.7.9.5

