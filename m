Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:18253 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005AbXGTVSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 17:18:12 -0400
Received: by ug-out-1314.google.com with SMTP id j3so691684ugf
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jul 2007 14:18:10 -0700 (PDT)
To: Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: Add LONG_RETRY flag to ieee80211_tx_control
Date: Fri, 20 Jul 2007 23:20:12 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707202320.12597.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 informs the driver what the short and long retry values are through
set_retry_limit(), but when packets are being transmitted it did not inform the
driver which of the 2 retry limits should actually be used.
Instead it sends the actual value, but for drivers that can only set the retry limit
and the register and in the descriptor need to indicate which of the limits should
be used this is not really useful.

This patch will add a IEEE80211_TXCTL_LONG_RETRY_LIMIT flag to the
ieee80211_tx_control structure. By default the short retry limit should be
used but if the flag is set the long retry should be used.

This does not prevent the driver to ignore the request for "no retry" packets,
but at least those will be send out with the short retry limit. But there is no
perfect cure for this problem.. :(

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c132be7..aab0fbd 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -192,9 +192,15 @@ struct ieee80211_tx_control {
 #define IEEE80211_TXCTL_FIRST_FRAGMENT	(1<<8) /* this is a first fragment of
 						* the frame */
 #define IEEE80211_TXCTL_TKIP_NEW_PHASE1_KEY (1<<9)
+#define IEEE80211_TXCTL_LONG_RETRY_LIMIT (1<<10) /* this frame should be send
+						  * using the through
+						  * set_retry_limit configured
+						  * long retry value */
 	u32 flags;			       /* tx control flags defined
 						* above */
-	u8 retry_limit;		/* 1 = only first attempt, 2 = one retry, .. */
+	u8 retry_limit;		/* 1 = only first attempt, 2 = one retry, ..
+				 * This could be used when set_retry_limit
+				 * is not implemented by the driver */
 	u8 power_level;		/* per-packet transmit power level, in dBm */
 	u8 antenna_sel_tx; 	/* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */
 	s8 key_idx;		/* -1 = do not encrypt, >= 0 keyidx from
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 22c19ad..3bb2e10 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -847,6 +847,7 @@ ieee80211_tx_h_misc(struct ieee80211_txrx_data *tx)
 		if (tx->skb->len + FCS_LEN > tx->local->rts_threshold &&
 		    tx->local->rts_threshold < IEEE80211_MAX_RTS_THRESHOLD) {
 			control->flags |= IEEE80211_TXCTL_USE_RTS_CTS;
+			control->flags |= IEEE80211_TXCTL_LONG_RETRY_LIMIT;
 			control->retry_limit =
 				tx->local->long_retry_limit;
 		} else {
