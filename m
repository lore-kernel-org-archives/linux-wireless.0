Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:45252 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757838Ab3BKRVQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 12:21:16 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v4 1/2] mac80211: Fix tx queue handling during scans
Date: Mon, 11 Feb 2013 11:21:07 -0600
Message-Id: <1360603268-28594-1-git-send-email-seth.forshee@canonical.com> (sfid-20130211_182120_459280_4B2385DA)
In-Reply-To: <20130211171829.GD13768@thinkpad-t410>
References: <20130211171829.GD13768@thinkpad-t410>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Scans currently work by stopping the netdev tx queues but leaving the
mac80211 queues active. This stops the flow of incoming packets while
still allowing mac80211 to transmit nullfunc and probe request frames to
facilitate scanning. However, the driver may try to wake the mac80211
queues while in this state, which will also wake the netdev queues.

To prevent this, add a new queue stop reason,
IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL, to be used when stopping the tx
queues for off-channel operation. This prevents the netdev queues from
waking when a driver wakes the mac80211 queues.

This also stops all frames from being transmitted, even those meant to
be sent off-channel. Add a new tx control flag,
IEEE80211_TX_CTL_OFFCHAN_TX_OK, which allows frames to be transmitted
when the queues are stopped only for the off-channel stop reason. Update
all locations transmitting off-channel frames to use this flag.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 include/net/mac80211.h     |    4 ++++
 net/mac80211/cfg.c         |    3 ++-
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |    3 ++-
 net/mac80211/offchannel.c  |   30 ++++++++++--------------------
 net/mac80211/scan.c        |    9 ++++++---
 net/mac80211/tx.c          |   17 +++++++++++++++--
 7 files changed, 40 insertions(+), 27 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7da1121..8f51e96 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -391,6 +391,9 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_RATE_CTRL_PROBE: internal to mac80211, can be
  *	set by rate control algorithms to indicate probe rate, will
  *	be cleared for fragmented frames (except on the last fragment)
+ * @IEEE80211_TX_CTL_OFFCHAN_TX_OK: Internal to mac80211. Used to indicate
+ *	that a frame can be transmitted while the queues are stopped for
+ *	off-channel operation.
  * @IEEE80211_TX_INTFL_NEED_TXPROCESSING: completely internal to mac80211,
  *	used to indicate that a pending frame requires TX processing before
  *	it can be sent out.
@@ -456,6 +459,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_STAT_AMPDU			= BIT(10),
 	IEEE80211_TX_STAT_AMPDU_NO_BACK		= BIT(11),
 	IEEE80211_TX_CTL_RATE_CTRL_PROBE	= BIT(12),
+	IEEE80211_TX_CTL_OFFCHAN_TX_OK		= BIT(13),
 	IEEE80211_TX_INTFL_NEED_TXPROCESSING	= BIT(14),
 	IEEE80211_TX_INTFL_RETRIED		= BIT(15),
 	IEEE80211_TX_INTFL_DONT_ENCRYPT		= BIT(16),
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f4f7e76..3c7f9d8 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2747,7 +2747,8 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		goto out_unlock;
 	}
 
-	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_TX_OFFCHAN;
+	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_TX_OFFCHAN |
+					IEEE80211_TX_CTL_OFFCHAN_TX_OK;
 	if (local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)
 		IEEE80211_SKB_CB(skb)->hw_queue =
 			local->hw.offchannel_tx_hw_queue;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5fe9db7..815fb80 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -812,6 +812,7 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_AGGREGATION,
 	IEEE80211_QUEUE_STOP_REASON_SUSPEND,
 	IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
+	IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL,
 };
 
 #ifdef CONFIG_MAC80211_LEDS
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 353b690..b459f7a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -685,7 +685,8 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 	if (powersave)
 		nullfunc->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
 
-	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+	IEEE80211_SKB_CB(skb)->flags |= (IEEE80211_TX_INTFL_DONT_ENCRYPT |
+					 IEEE80211_TX_CTL_OFFCHAN_TX_OK);
 	if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
 			    IEEE80211_STA_CONNECTION_POLL))
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_USE_MINRATE;
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 82baf5b..4c3ee3e 100644
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
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 7f80f0a..29e7d6e 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -378,6 +378,11 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 	int i;
 	struct ieee80211_sub_if_data *sdata;
 	enum ieee80211_band band = local->hw.conf.channel->band;
+	u32 tx_flags;
+
+	tx_flags = IEEE80211_TX_CTL_OFFCHAN_TX_OK;
+	if (local->scan_req->no_cck)
+		tx_flags |= IEEE80211_TX_CTL_NO_CCK_RATE;
 
 	sdata = rcu_dereference_protected(local->scan_sdata,
 					  lockdep_is_held(&local->mtx));
@@ -389,9 +394,7 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 			local->scan_req->ssids[i].ssid_len,
 			local->scan_req->ie, local->scan_req->ie_len,
 			local->scan_req->rates[band], false,
-			local->scan_req->no_cck ?
-				IEEE80211_TX_CTL_NO_CCK_RATE : 0,
-			local->hw.conf.channel, true);
+			tx_flags, local->hw.conf.channel, true);
 
 	/*
 	 * After sending probe requests, wait for probe responses
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2ef0e19..ab603d7 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1228,8 +1228,21 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 #endif
 
 		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-		if (local->queue_stop_reasons[q] ||
-		    (!txpending && !skb_queue_empty(&local->pending[q]))) {
+		if (unlikely(info->flags & IEEE80211_TX_CTL_OFFCHAN_TX_OK)) {
+			/*
+			 * Drop off-channel frames if queues are stopped for
+			 * any reason other than off-channel operation. Never
+			 * queue them.
+			 */
+			if (local->queue_stop_reasons[q] &
+			    ~BIT(IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL)) {
+				spin_unlock_irqrestore(&local->queue_stop_reason_lock,
+						       flags);
+				ieee80211_purge_tx_queue(&local->hw, skbs);
+				return true;
+			}
+		} else if (local->queue_stop_reasons[q] ||
+			   (!txpending && !skb_queue_empty(&local->pending[q]))) {
 			/*
 			 * Since queue is stopped, queue up frames for later
 			 * transmission from the tx-pending tasklet when the
-- 
1.7.9.5

