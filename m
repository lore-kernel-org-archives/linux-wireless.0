Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33421 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab0ITWWc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 18:22:32 -0400
Received: by bwz11 with SMTP id 11so4662757bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Sep 2010 15:22:30 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: clear txflags for ps-filtered frames
Date: Tue, 21 Sep 2010 00:22:26 +0200
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <201009182133.50104.chunkeey@googlemail.com> <1284978231.3688.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1284978231.3688.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201009210022.27383.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes stale mac80211_tx_control_flags for
filtered / retried frames.

Because ieee80211_handle_filtered_frame injects the skbs
back into the tx path, they have to be stripped of old tx
flags so they won't confuse the stack, driver or device.

Cc: <stable@kernel.org>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
On Monday 20 September 2010 12:23:50 Johannes Berg wrote:
> On Sat, 2010-09-18 at 21:33 +0200, Christian Lamparter wrote:
> > +	info->flags &= ~(IEEE80211_TX_CTL_RATE_CTRL_PROBE |
> > [...]
> > +			 IEEE80211_TX_STAT_AMPDU);
> 
> Theo nly thing I wonder is if we should introduce some #define for the
> temporary flags here and put it into mac80211.h so we'll be less likely
> to forget updating it when adding new flags?
hmm, we are running out of bits. 

Anyway, here is v1 (with define + doc). Not sure if this is sufficient.
---
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 12a49f0..5d1187d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -321,6 +321,9 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_LDPC: tells the driver to use LDPC for this frame
  * @IEEE80211_TX_CTL_STBC: Enables Space-Time Block Coding (STBC) for this
  *	frame and selects the maximum number of streams that it can use.
+ *
+ * Note: If you have to add new flags to the enumeration, then don't
+ *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
@@ -350,6 +353,19 @@ enum mac80211_tx_control_flags {
 
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
 
+/*
+ * This definition is used as a mask to clear all temporary flags, which are
+ * set by the tx handlers for each transmission attempt by the mac80211 stack.
+ */
+#define IEEE80211_TX_TEMPORARY_FLAGS (IEEE80211_TX_CTL_NO_ACK |		      \
+	IEEE80211_TX_CTL_CLEAR_PS_FILT | IEEE80211_TX_CTL_FIRST_FRAGMENT |    \
+	IEEE80211_TX_CTL_SEND_AFTER_DTIM | IEEE80211_TX_CTL_AMPDU |	      \
+	IEEE80211_TX_STAT_TX_FILTERED |	IEEE80211_TX_STAT_ACK |		      \
+	IEEE80211_TX_STAT_AMPDU | IEEE80211_TX_STAT_AMPDU_NO_BACK |	      \
+	IEEE80211_TX_CTL_RATE_CTRL_PROBE | IEEE80211_TX_CTL_PSPOLL_RESPONSE | \
+	IEEE80211_TX_CTL_MORE_FRAMES | IEEE80211_TX_CTL_LDPC |		      \
+	IEEE80211_TX_CTL_STBC)
+
 /**
  * enum mac80211_rate_control_flags - per-rate flags set by the
  *	Rate Control algorithm.
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 58eab9e..309ed70 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -129,9 +129,7 @@ static void sta_rx_agg_reorder_timer_expired(unsigned long data)
 			timer_to_tid[0]);
 
 	rcu_read_lock();
-	spin_lock(&sta->lock);
 	ieee80211_release_reorder_timeout(sta, *ptid);
-	spin_unlock(&sta->lock);
 	rcu_read_unlock();
 }
 
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 571b32b..dd85006 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -58,6 +58,7 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 	info->control.vif = &sta->sdata->vif;
 	info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING |
 		       IEEE80211_TX_INTFL_RETRANSMISSION;
+	info->flags &= ~IEEE80211_TX_TEMPORARY_FLAGS;
 
 	sta->tx_filtered_count++;
 
