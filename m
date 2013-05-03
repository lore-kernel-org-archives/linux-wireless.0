Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:52838 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932913Ab3ECQLz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 12:11:55 -0400
Received: by mail-bk0-f43.google.com with SMTP id jm19so799022bkc.30
        for <linux-wireless@vger.kernel.org>; Fri, 03 May 2013 09:11:54 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 3.10] mac80211: fix spurious RCU warning and update documentation
Date: Fri, 3 May 2013 18:11:46 +0200
Cc: linux-wireless@vger.kernel.org
References: <1367568063-24859-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1367568063-24859-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201305031811.46945.chunkeey@googlemail.com> (sfid-20130503_181159_839215_9DE83DE1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, May 03, 2013 10:01:03 AM Felix Fietkau wrote:
> Document rx vs tx status concurrency requirements.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Thanks. As you know, I was playing with this before. I wrote
a patch, but I didn't have the change to test it yet properly.
If you find anything useful in this (now no longer needed)
take it, if not ignore it :-D. (i.e: the rcu_dereference with
sta->hnext == NULL instead of true).

Regards,
	Christian 
---
Subject: [RFT] mac80211: more rate control api work

In a discussion of my previous patch [1]:
"mac80211: fix spurious use of rcu_dereference"

Johannes discovered that the band-aid fix proposed in
the mail [adding rcu_read_(un)lock] was inadequate:

>+	rcu_read_lock();
>	old = rcu_dereference(sta->rates);
>	rcu_assign_pointer(sta->rates, new);
>	if (old)
>		kfree_rcu(old);
>+	rcu_read_unlock();

"The problem here is that even the rcu_read_lock() around here
that's actually there in most cases *isn't* what's protecting
this code. What's protecting this assignment is the fact that
we require drivers to not call ieee80211_tx_status()
concurrently.

If this wasn't the case, then calling the function could cause
double-free or so by having two CPUs read the old pointer and
both call kfree_rcu() on it." [2]

This patch moves the rcu-protected rates pointer into mac80211's
private station structure. This prevents drivers from modifying
the pointer (in an unsafe way). If a driver wants to access the
rates table, it should use the rate control api function:
	ieee80211_get_tx_rates

Furthermore, it also adds a lock in rate_control_set_rates to
avoid double freeing old rates if the function is called
concurrently.

At last, the patch fixes suspicious RCU usage in
rate_control_set_rates during initialization by
adding an exception for stations which are not
yet added to the station hash table.

[1] Message-Id: <201304230258.08359.chunkeey@googlemail.com>
[2] Message-Id: <1366802638.21854.11.camel@jlt4.sipsolutions.net>
---
 include/net/mac80211.h  |    2 --
 net/mac80211/rate.c     |   20 ++++++++++++++++----
 net/mac80211/sta_info.h |    2 ++
 net/mac80211/tx.c       |    2 +-
 4 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 04c2d46..4457ea2 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1276,7 +1276,6 @@ struct ieee80211_sta_rates {
  *	notifications and capabilities. The value is only valid after
  *	the station moves to associated state.
  * @smps_mode: current SMPS mode (off, static or dynamic)
- * @tx_rates: rate control selection table
  */
 struct ieee80211_sta {
 	u32 supp_rates[IEEE80211_NUM_BANDS];
@@ -1290,7 +1289,6 @@ struct ieee80211_sta {
 	u8 rx_nss;
 	enum ieee80211_sta_rx_bandwidth bandwidth;
 	enum ieee80211_smps_mode smps_mode;
-	struct ieee80211_sta_rates __rcu *rates;
 
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 0d51877..a049ff7 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -530,7 +530,7 @@ static void rate_fixup_ratelist(struct ieee80211_vif *vif,
 }
 
 
-static void rate_control_fill_sta_table(struct ieee80211_sta *sta,
+static void rate_control_fill_sta_table(struct ieee80211_sta *pubsta,
 					struct ieee80211_tx_info *info,
 					struct ieee80211_tx_rate *rates,
 					int max_rates)
@@ -538,8 +538,11 @@ static void rate_control_fill_sta_table(struct ieee80211_sta *sta,
 	struct ieee80211_sta_rates *ratetbl = NULL;
 	int i;
 
-	if (sta && !info->control.skip_table)
+	if (pubsta && !info->control.skip_table) {
+		struct sta_info *sta = container_of(pubsta, struct sta_info,
+						    sta);
 		ratetbl = rcu_dereference(sta->rates);
+	}
 
 	/* Fill remaining rate slots with data from the sta rate table. */
 	max_rates = min_t(int, max_rates, IEEE80211_TX_RATE_TABLE_SIZE);
@@ -688,9 +691,18 @@ int rate_control_set_rates(struct ieee80211_hw *hw,
 			   struct ieee80211_sta *pubsta,
 			   struct ieee80211_sta_rates *rates)
 {
-	struct ieee80211_sta_rates *old = rcu_dereference(pubsta->rates);
+	struct sta_info *sta;
+	struct ieee80211_sta_rates *old;
+
+	sta = container_of(pubsta, struct sta_info, sta);
+
+	spin_lock_bh(&sta->lock);
+	old = rcu_dereference_check(sta->rates,
+		rcu_access_pointer(sta->hnext) != NULL);
+
+	rcu_assign_pointer(sta->rates, rates);
+	spin_unlock_bh(&sta->lock);
 
-	rcu_assign_pointer(pubsta->rates, rates);
 	if (old)
 		kfree_rcu(old, rcu_head);
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index adc3004..29169f2 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -234,6 +234,7 @@ struct sta_ampdu_mlme {
  * @gtk: group keys negotiated with this station, if any
  * @rate_ctrl: rate control algorithm reference
  * @rate_ctrl_priv: rate control private per-STA pointer
+ * @rates: rate control selection table
  * @last_tx_rate: rate used for last transmit, to report to userspace as
  *	"the" transmit rate
  * @last_rx_rate_idx: rx status rate index of the last data packet
@@ -309,6 +310,7 @@ struct sta_info {
 	struct ieee80211_key __rcu *ptk;
 	struct rate_control_ref *rate_ctrl;
 	void *rate_ctrl_priv;
+	struct ieee80211_sta_rates __rcu *rates;
 	spinlock_t lock;
 
 	struct work_struct drv_unblock_wk;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 4a5fbf8..fdf5bc4 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -693,7 +693,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	rate_control_get_rate(tx->sdata, tx->sta, &txrc);
 
 	if (tx->sta && !info->control.skip_table)
-		ratetbl = rcu_dereference(tx->sta->sta.rates);
+		ratetbl = rcu_dereference(tx->sta->rates);
 
 	if (unlikely(info->control.rates[0].idx < 0)) {
 		if (ratetbl) {
-- 
1.7.10.4

