Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:36222 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab3AIScr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 13:32:47 -0500
Received: by mail-bk0-f50.google.com with SMTP id jf3so1118405bkc.37
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jan 2013 10:32:45 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johan Danielsson <joda@kth.se>
Subject: Re: mac80211 and RX of A-MPDU with missing back agreement
Date: Wed, 9 Jan 2013 19:32:39 +0100
Cc: linux-wireless@vger.kernel.org
References: <CAESKgcgVQYwT770OfOXZnB-06SnidfxV7DnUrAMquJZtLNsYHg@mail.gmail.com> <CAESKgcj1YD2-TwOQ4ZH3nFs8CCgfKHzp4gM4YUsjaqgn4cAMGw@mail.gmail.com> <201301091843.05314.chunkeey@googlemail.com>
In-Reply-To: <201301091843.05314.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201301091932.40056.chunkeey@googlemail.com> (sfid-20130109_193251_917662_901461DB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, January 09, 2013 06:43:05 PM Christian Lamparter wrote:
> On Wednesday, January 09, 2013 11:05:20 AM Johan Danielsson wrote:
> > > [...] I argued that if we have no (or no longer) a BA agreement
> > > [even if the peer never got the DELBA] we can discard the AMPDU data
> > > and sent a DELBAs to the HT peer once it tries sent us an A-MPDU
> > > (again). This is actually what we should do according to 802.11-2012
> > > 10.5.4 - instead of calling dont_reorder.
> > 
> > I think this is a reasonable interpretation, even though 10.5.4
> > doesn't explicitly cover this case (since the Ack Policy is set to
> > Normal Ack).
> 
> This is were RX_FLAG_AMPDU_DETAILS would come into the game. 
> If this rx flag is set we know that the frame was part of 
> an AMPDU and not a normal non-aggregated QoS-Data frame. 
> 
In fact, here's what I had in mind [top of wireless-testing.git
just compiled-tested. I hope it doesn't Oops].

Does this patch help in your case?

Note: This patch will only work with drivers which sets
RX_FLAG_AMPDU_DETAILS accordingly [currently: iwlwifi or
carl9170].
---
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0fa44a9..3fffc93 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -823,6 +823,7 @@ enum sdata_queue_type {
 	IEEE80211_SDATA_QUEUE_TYPE_FRAME	= 0,
 	IEEE80211_SDATA_QUEUE_AGG_START		= 1,
 	IEEE80211_SDATA_QUEUE_AGG_STOP		= 2,
+	IEEE80211_SDATA_QUEUE_AGG_KILL		= 3,
 };
 
 enum {
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 06fac29..16abbdc 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1086,6 +1086,31 @@ static void ieee80211_iface_work(struct work_struct *work)
 			ra_tid = (void *)&skb->cb;
 			ieee80211_stop_tx_ba_cb(&sdata->vif, ra_tid->ra,
 						ra_tid->tid);
+		} else if (skb->pkt_type == IEEE80211_SDATA_QUEUE_AGG_KILL) {
+			/* So the frame isn't mgmt, but frame_control
+			 * is at the right place anyway, of course, so
+			 * the if statement is correct.
+			 */
+			struct ieee80211_hdr *hdr = (void *)mgmt;
+
+			/* This can happen because:
+			 * - fragment of a frame, received while a block-ack
+			 *   session was active.
+			 * - AMPDU while no block-ack session was active.
+			 * That cannot be right, so terminate the session.
+			 */
+			mutex_lock(&local->sta_mtx);
+			sta = sta_info_get_bss(sdata, mgmt->sa);
+			if (sta) {
+				u16 tid = *ieee80211_get_qos_ctl(hdr) &
+						IEEE80211_QOS_CTL_TID_MASK;
+
+				__ieee80211_stop_rx_ba_session(
+					sta, tid, WLAN_BACK_RECIPIENT,
+					WLAN_REASON_QSTA_REQUIRE_SETUP,
+					true);
+			}
+			mutex_unlock(&local->sta_mtx);
 		} else if (ieee80211_is_action(mgmt->frame_control) &&
 			   mgmt->u.action.category == WLAN_CATEGORY_BACK) {
 			int len = skb->len;
@@ -1112,37 +1137,6 @@ static void ieee80211_iface_work(struct work_struct *work)
 				}
 			}
 			mutex_unlock(&local->sta_mtx);
-		} else if (ieee80211_is_data_qos(mgmt->frame_control)) {
-			struct ieee80211_hdr *hdr = (void *)mgmt;
-			/*
-			 * So the frame isn't mgmt, but frame_control
-			 * is at the right place anyway, of course, so
-			 * the if statement is correct.
-			 *
-			 * Warn if we have other data frame types here,
-			 * they must not get here.
-			 */
-			WARN_ON(hdr->frame_control &
-					cpu_to_le16(IEEE80211_STYPE_NULLFUNC));
-			WARN_ON(!(hdr->seq_ctrl &
-					cpu_to_le16(IEEE80211_SCTL_FRAG)));
-			/*
-			 * This was a fragment of a frame, received while
-			 * a block-ack session was active. That cannot be
-			 * right, so terminate the session.
-			 */
-			mutex_lock(&local->sta_mtx);
-			sta = sta_info_get_bss(sdata, mgmt->sa);
-			if (sta) {
-				u16 tid = *ieee80211_get_qos_ctl(hdr) &
-						IEEE80211_QOS_CTL_TID_MASK;
-
-				__ieee80211_stop_rx_ba_session(
-					sta, tid, WLAN_BACK_RECIPIENT,
-					WLAN_REASON_QSTA_REQUIRE_SETUP,
-					true);
-			}
-			mutex_unlock(&local->sta_mtx);
 		} else switch (sdata->vif.type) {
 		case NL80211_IFTYPE_STATION:
 			ieee80211_sta_rx_queued_mgmt(sdata, skb);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a190895..0ba5b56 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -871,6 +871,10 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
 	if (!ieee80211_is_data_qos(hdr->frame_control))
 		goto dont_reorder;
 
+	/* qos null data frames are excluded */
+	if (unlikely(hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_NULLFUNC)))
+		goto dont_reorder;
+
 	/*
 	 * filter the QoS data rx stream according to
 	 * STA/TID and check if this STA/TID is on aggregation
@@ -884,12 +888,12 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
 	tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
 
 	tid_agg_rx = rcu_dereference(sta->ampdu_mlme.tid_rx[tid]);
-	if (!tid_agg_rx)
-		goto dont_reorder;
-
-	/* qos null data frames are excluded */
-	if (unlikely(hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_NULLFUNC)))
-		goto dont_reorder;
+	if (!tid_agg_rx) {
+		if (status->flag & RX_FLAG_AMPDU_DETAILS)
+			goto ba_teardown;
+		else
+			goto dont_reorder;
+	}
 
 	/* not part of a BA session */
 	if (ack_policy != IEEE80211_QOS_CTL_ACK_POLICY_BLOCKACK &&
@@ -908,12 +912,8 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
 
 	/* if this mpdu is fragmented - terminate rx aggregation session */
 	sc = le16_to_cpu(hdr->seq_ctrl);
-	if (sc & IEEE80211_SCTL_FRAG) {
-		skb->pkt_type = IEEE80211_SDATA_QUEUE_TYPE_FRAME;
-		skb_queue_tail(&rx->sdata->skb_queue, skb);
-		ieee80211_queue_work(&local->hw, &rx->sdata->work);
-		return;
-	}
+	if (sc & IEEE80211_SCTL_FRAG)
+		goto ba_teardown;
 
 	/*
 	 * No locking needed -- we will only ever process one
@@ -927,6 +927,12 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
 
  dont_reorder:
 	skb_queue_tail(&local->rx_skb_queue, skb);
+	return;
+
+ ba_teardown:
+	skb->pkt_type = IEEE80211_SDATA_QUEUE_AGG_KILL;
+	skb_queue_tail(&rx->sdata->skb_queue, skb);
+	ieee80211_queue_work(&local->hw, &rx->sdata->work);
 }
 
 static ieee80211_rx_result debug_noinline
