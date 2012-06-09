Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:56103 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab2FIOBl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 10:01:41 -0400
Received: by wgbds11 with SMTP id ds11so2070813wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 09 Jun 2012 07:01:39 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC v3] mac80211: follow 802.11-2007 11.5.3 Error recovery upon HT BA failure
Date: Sat, 9 Jun 2012 16:01:34 +0200
Cc: Sean Patrick Santos <quantheory@gmail.com>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org,
	helmut.schaa@googlemail.com, mar.kolya@gmail.com,
	"Per-Erik Westerberg" <per-erik.westerberg@bredband.net>,
	=?utf-8?q?Miko=C5=82aj_Kuligowski?= <mikolaj.q@wp.pl>
References: <CAFR4AqbeMC23w5j5vdN+hx2pH7M0Aw2epJiBmi29ARPAFeDDQg@mail.gmail.com> <201206091414.41940.chunkeey@googlemail.com> <1339244892.5763.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1339244892.5763.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201206091601.34601.chunkeey@googlemail.com> (sfid-20120609_160217_146293_628916A3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 09 June 2012 14:28:12 Johannes Berg wrote:
> On Sat, 2012-06-09 at 14:14 +0200, Christian Lamparter wrote:
> > yeah, I should. But 802.11-2012 is not yet available for
> > free like the old 802.11-2007 through IEEE 802 Get. 
> 
> Hah, ok. I guess I can fix the references when I apply it.
Yeah that would be nice.
The path is
11. -> MLME
	5. -> Block Ack operation
		3. -> Error Recovery upon a peer failure

> > > >  - The spec says we should test for BlockAcks, however
> > > >    that is not feasible because it is a control frame
> > > >    (so FIF_CONTROL might filter it on some hardware).
> > > 
> > > In some way, all devices are going to have to report these
> > > frames. Maybe not as the frame itself, but as some other
> > > notification, to allow cleaning up the TX queues
> > > accordingly, I think? There's a BA notification in iwlwifi
> > > for example.
> > Alright, I guess this means that we probably need a new HW
> > feature flag like:
> > 	IEEE80211_HW_REPORTS_BA_NOTIFICATION
> > for hardware/firmware which filter BA frames, but have a BA
> > notification trap. And every other driver need to pass BA
> > to the stack where a new rx handler will update the last_tx
> > accordingly. 
> 
> But that notification trap would also have to call some function
> in the stack, and the drivers that don't have it (or don't
> implement it yet) need something more like this patch?

(see v3 attached to this mail). 

Yes, drivers that don't pass BAs to the stack and won't call
ieee80211_ba_notification will have their BA sessions "removed" in v3.
Of course, we can also retain the old behavoir and reset the
tx ba session timeout until we know we don't break anything.

> I haven't actually looked into the specifics yet at all, will do
> that on Monday.
No problem (after all - I could never reproduce this issue). In
the mean time, I'll try to come up with better names for
ieee80211_ba_notification and a proper docbook text.

Regards,
	Chr
---
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d152f54..eb66bda 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3531,6 +3531,21 @@ void ieee80211_resume_disconnect(struct ieee80211_vif *vif);
 void ieee80211_disable_dyn_ps(struct ieee80211_vif *vif);
 
 /**
+ * ieee80211_ba_notification - update block ack timeout timer
+ *
+ * @sta: &struct ieee80211_sta pointer of the received BA
+ * @tid: the TID of the received BA.
+ *
+ * Some hardware filters BlockAck and therefore the stack
+ * an alternative way of notifying the stack that a specific
+ * BA session was active, otherwise the session will time
+ * out.
+ *
+ * This function must be called under RCU lock.
+ */
+void ieee80211_ba_notification(struct ieee80211_sta *sta, const u16 tid);
+
+/**
  * ieee80211_enable_dyn_ps - restore dynamic psm after being disabled
  *
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6fd2cb0..e14f314 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2055,6 +2055,23 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 	return RX_QUEUED;
 }
 
+/* needs to be called under rcu_read_lock */
+static void _ieee80211_ba_notification(struct sta_info *sta, u16 tid)
+{
+	struct tid_ampdu_tx *tid_tx;
+	tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
+	if (tid_tx) {
+		/*
+		 * 802.11-2007 11.5.3 Error recovery upon a peer failure
+		 *
+		 * The inactivity timer at the originator is reset when
+		 * a BlockAck frame corresponding to the TID for which
+		 * the Block Ack policy is set is received.
+		 */
+		tid_tx->last_tx = jiffies;
+	}
+}
+
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx)
 {
@@ -2069,6 +2086,21 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx)
 	if (likely(!ieee80211_is_ctl(bar->frame_control)))
 		return RX_CONTINUE;
 
+	if (ieee80211_is_back(bar->frame_control) && rx->sta) {
+		__le16 ba_control;
+
+		if (!skb_copy_bits(skb,
+		    offsetof(struct ieee80211_bar, control),
+		    &ba_control, sizeof(ba_control))) {
+			u16 control = le16_to_cpu(ba_control);
+			if (!(control & IEEE80211_BAR_CTRL_MULTI_TID)) {
+				u16 tid = (control & IEEE80211_BAR_CTRL_TID_INFO_MASK)
+					  >> IEEE80211_BAR_CTRL_TID_INFO_SHIFT;
+				_ieee80211_ba_notification(rx->sta, tid);
+			}
+		}
+	}
+
 	if (ieee80211_is_back_req(bar->frame_control)) {
 		struct {
 			__le16 control, start_seq_num;
@@ -3101,6 +3133,13 @@ void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
 }
 EXPORT_SYMBOL(ieee80211_rx);
 
+void ieee80211_ba_notification(struct ieee80211_sta *pubsta, const u16 tid)
+{
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	_ieee80211_ba_notification(sta, tid);
+}
+EXPORT_SYMBOL(ieee80211_ba_notification);
+
 /* This is a version of the rx handler that can be called from hard irq
  * context. Post the skb on the queue and schedule the tasklet */
 void ieee80211_rx_irqsafe(struct ieee80211_hw *hw, struct sk_buff *skb)
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 3bb24a1..fbe84a7 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -103,7 +103,7 @@ enum ieee80211_sta_info_flags {
  * @dialog_token: dialog token for aggregation session
  * @timeout: session timeout value to be filled in ADDBA requests
  * @state: session state (see above)
- * @last_tx: jiffies of last tx activity
+ * @last_tx: jiffies of last successful tx activity
  * @stop_initiator: initiator of a session stop
  * @tx_stop: TX DelBA frame when stopping
  * @buf_size: reorder buffer size at receiver
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index af25c4e..dd02a1f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1061,12 +1061,10 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 				  int tid)
 {
 	bool queued = false;
-	bool reset_agg_timer = false;
 	struct sk_buff *purge_skb = NULL;
 
 	if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
 		info->flags |= IEEE80211_TX_CTL_AMPDU;
-		reset_agg_timer = true;
 	} else if (test_bit(HT_AGG_STATE_WANT_START, &tid_tx->state)) {
 		/*
 		 * nothing -- this aggregation session is being started
@@ -1098,7 +1096,6 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 			/* do nothing, let packet pass through */
 		} else if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
 			info->flags |= IEEE80211_TX_CTL_AMPDU;
-			reset_agg_timer = true;
 		} else {
 			queued = true;
 			info->control.vif = &tx->sdata->vif;
@@ -1112,11 +1109,6 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 		if (purge_skb)
 			dev_kfree_skb(purge_skb);
 	}
-
-	/* reset session timer */
-	if (reset_agg_timer && tid_tx->timeout)
-		tid_tx->last_tx = jiffies;
-
 	return queued;
 }
 
