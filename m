Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50194 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab2FIBL0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 21:11:26 -0400
Received: by wgbdr13 with SMTP id dr13so1363979wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2012 18:11:25 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Sean Patrick Santos <quantheory@gmail.com>
Subject: [RFC] mac80211: follow 802.11-2007 11.5.3 Error recovery upon HT BA failure
Date: Sat, 9 Jun 2012 03:11:20 +0200
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	helmut.schaa@googlemail.com, mar.kolya@gmail.com,
	"Per-Erik Westerberg" <per-erik.westerberg@bredband.net>,
	=?utf-8?q?Miko=C5=82aj_Kuligowski?= <mikolaj.q@wp.pl>
References: <CAFR4AqbeMC23w5j5vdN+hx2pH7M0Aw2epJiBmi29ARPAFeDDQg@mail.gmail.com> <CAFR4AqahHPR9s4vn+1HFMFk+-oi2ROxLGrqa79ufLJ=Gmzb5rQ@mail.gmail.com> <201206090218.27603.chunkeey@googlemail.com>
In-Reply-To: <201206090218.27603.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201206090311.21153.chunkeey@googlemail.com> (sfid-20120609_031203_315241_7A41DF31)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit:

commit 285fa6958c1d56469ec8a0e879ae7487a4e62840
Author: Nikolay Martynov <mar.kolya@gmail.com>
Date:   Tue Nov 22 21:50:28 2011 -0500

mac80211: timeout tx agg sessions in way similar to rx agg sessions

introduced a TX BA session timeout timer. However the
timer was reset for each outgoing transmission instead
what 802.11-2007 11.5.3 specifies: 
"The inactivity timer at the originator is reset when a
BlockAck frame corresponding to the TID for which the
Block Ack policy is set is received."

Reported-by: Sean Patrick Santos <quantheory@gmail.com>
Reported-by: Mikołaj Kuligowski <mikolaj.q@wp.pl>
Reported-by: Per-Erik Westerberg <per-erik.westerberg@bredband.net>
Cc: mar.kolya@gmail.com
---
Note:

This patch was only compile-tested and the design has 
some rather big problems: 

 - The spec says we should test for BlockAcks, however
   that is not feasible because it is a control frame
   (so FIF_CONTROL might filter it on some hardware).

 - The IEEE80211_HW_REPORTS_TX_ACK_STATUS feature flag 
   does not necessairly extends to BlockAck as well, so
   this would need to be changed as well.

 (- The session timeout adds a delay.)

Regards,
	Chr
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
index 6b4f425..96eebb6 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -439,6 +439,29 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			}
 		}
 
+		if (ieee80211_is_data_qos(fc) && acked &&
+		    info->flags & IEEE80211_TX_CTL_AMPDU &&
+		    local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) {
+			struct tid_ampdu_tx *tid_tx;
+			u8 *qc;
+			u16 tid;
+
+			qc = ieee80211_get_qos_ctl(hdr);
+			tid = qc[0] & 0xf;
+			tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
+			if (!tid_tx)
+				return;
+
+			/*
+			 * 802.11-2007 11.5.3 Error recovery upon a peer failure
+			 *
+			 * The inactivity timer at the originator is reset when
+			 * a BlockAck frame corresponding to the TID for which
+			 * the Block Ack policy is set is received.
+			 */
+			tid_tx->last_tx = jiffies;
+		}
+
 		if (info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
 			ieee80211_handle_filtered_frame(local, sta, skb);
 			rcu_read_unlock();
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index af25c4e..d3abee9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1098,7 +1098,8 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 			/* do nothing, let packet pass through */
 		} else if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
 			info->flags |= IEEE80211_TX_CTL_AMPDU;
-			reset_agg_timer = true;
+			if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL))
+				reset_agg_timer = true;
 		} else {
 			queued = true;
 			info->control.vif = &tx->sdata->vif;

