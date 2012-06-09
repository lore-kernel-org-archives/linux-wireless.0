Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:38050 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2FIMOr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 08:14:47 -0400
Received: by weyu7 with SMTP id u7so1112719wey.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Jun 2012 05:14:46 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC v2] mac80211: follow 802.11-2007 11.5.3 Error recovery upon HT BA failure
Date: Sat, 9 Jun 2012 14:14:41 +0200
Cc: Sean Patrick Santos <quantheory@gmail.com>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org,
	helmut.schaa@googlemail.com, mar.kolya@gmail.com,
	"Per-Erik Westerberg" <per-erik.westerberg@bredband.net>,
	=?utf-8?q?Miko=C5=82aj_Kuligowski?= <mikolaj.q@wp.pl>
References: <CAFR4AqbeMC23w5j5vdN+hx2pH7M0Aw2epJiBmi29ARPAFeDDQg@mail.gmail.com> <201206090311.21153.chunkeey@googlemail.com> <1339228767.4539.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1339228767.4539.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201206091414.41940.chunkeey@googlemail.com> (sfid-20120609_141451_401939_31759A70)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 09 June 2012 09:59:27 Johannes Berg wrote:
> > introduced a TX BA session timeout timer. However the
> > timer was reset for each outgoing transmission instead
> > what 802.11-2007 11.5.3 specifies: 
> 
> You should probably reference 802.11-2012 now since some
> things were renumbered.
yeah, I should. But 802.11-2012 is not yet available for
free like the old 802.11-2007 through IEEE 802 Get. 
 
> > "The inactivity timer at the originator is reset when a
> > BlockAck frame corresponding to the TID for which the
> > Block Ack policy is set is received."
> 
> > This patch was only compile-tested and the design has 
> > some rather big problems: 
> 
> Maybe then we should just revert Nikolay's patch?
(I was referring to this RFC patch and not his patch)
I don't think we can/should revert it, just change it
a bit so the timeout reset is triggered by a received
BA from the peer.

> >  - The spec says we should test for BlockAcks, however
> >    that is not feasible because it is a control frame
> >    (so FIF_CONTROL might filter it on some hardware).
> 
> In some way, all devices are going to have to report these
> frames. Maybe not as the frame itself, but as some other
> notification, to allow cleaning up the TX queues
> accordingly, I think? There's a BA notification in iwlwifi
> for example.
Alright, I guess this means that we probably need a new HW
feature flag like:
	IEEE80211_HW_REPORTS_BA_NOTIFICATION
for hardware/firmware which filter BA frames, but have a BA
notification trap. And every other driver need to pass BA
to the stack where a new rx handler will update the last_tx
accordingly. 

(yeah, that IEEE80211_HW_HAS_RATE_CONTROL vs. ACK_REPORT mix-up
was a stupid error - anyway here's the last updated version
of this approach - v3 will use IEEE80211_HW_REPORTS_BA_NOTIFICATION)
---
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
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 6b4f425..dfc61de 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -439,6 +439,28 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			}
 		}
 
+		if (ieee80211_is_data_qos(fc) && acked &&
+		    info->flags & IEEE80211_TX_CTL_AMPDU &&
+		    local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
+			struct tid_ampdu_tx *tid_tx;
+			u8 *qc;
+			u16 tid;
+
+			qc = ieee80211_get_qos_ctl(hdr);
+			tid = qc[0] & 0xf;
+			tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
+			if (tid_tx) {
+				/*
+				 * 802.11-2007 11.5.3 Error recovery upon a peer failure
+				 *
+				 * The inactivity timer at the originator is reset when
+				 * a BlockAck frame corresponding to the TID for which
+				 * the Block Ack policy is set is received.
+				 */
+				tid_tx->last_tx = jiffies;
+			}
+		}
+
 		if (info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
 			ieee80211_handle_filtered_frame(local, sta, skb);
 			rcu_read_unlock();
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index af25c4e..67887c5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1098,7 +1098,9 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 			/* do nothing, let packet pass through */
 		} else if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
 			info->flags |= IEEE80211_TX_CTL_AMPDU;
-			reset_agg_timer = true;
+			if (!(tx->local->hw.flags &
+			      IEEE80211_HW_REPORTS_TX_ACK_STATUS))
+				reset_agg_timer = true;
 		} else {
 			queued = true;
 			info->control.vif = &tx->sdata->vif;
