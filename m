Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47820 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab0DSGpA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 02:45:00 -0400
Subject: Re: regression: soft lockup with ath9k on master-2010-04-14
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <871veclztk.fsf@purkki.valot.fi>
References: <87pr20mrez.fsf@purkki.valot.fi>
	 <20100415195812.GC3020@tuxdriver.com>  <871veclztk.fsf@purkki.valot.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 08:43:17 +0200
Message-ID: <1271659397.3873.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-19 at 09:29 +0300, Kalle Valo wrote:

> > It might be useful to do a bisect.  If you choose to do that, you
> > might want to use wireless-next-2.6 instead, since that doesn't have
> > the occasional pulls from Linus that make bisecting wireless-testing
> > more painful.
> 
> Thanks for the tip, it helped a lot. My new laptop is really slow to
> compile kernels :/
> 
> I bisected it finally and found the culprit:
> 
> 66b0470aeef10a3b0f9a6a1c60d908b5a06c62ae is the first bad commit
> commit 66b0470aeef10a3b0f9a6a1c60d908b5a06c62ae
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Tue Apr 6 11:18:45 2010 +0200
> 
>     mac80211: remove ieee80211_sta_stop_rx_ba_session

[...]

> I took a quick peek of the patches but I wasn't able to immediately
> say what was wrong. This just made me suspicious:
> 
> -       ieee80211_sta_stop_rx_ba_session(sta->sdata, sta->sta.addr,
> -                                        (u16)*ptid, WLAN_BACK_TIMER,
> -                                        WLAN_REASON_QSTA_TIMEOUT);
> +       __ieee80211_stop_rx_ba_session(sta, *ptid,
> -                                        WLAN_BACK_RECIPIENT,
> +                                      WLAN_REASON_QSTA_TIMEOUT);
> 
> WLAN_BACK_TIMER was changed to WLAN_BACK_RECIPIENT, but I don't know
> if it was in purpose or not. Johannes, any ideas?

That was on purpose but belongs into
098a607091426e79178b9a6c318d993fea131791 not this patch ... :(

However that shouldn't be the problem. Or rather, that could be the
reason you're seeing the problem on this patch, rather than the 098a
one.

Try the patch below?

johannes

--- wireless-testing.orig/net/mac80211/agg-rx.c	2010-04-19 08:40:17.000000000 +0200
+++ wireless-testing/net/mac80211/agg-rx.c	2010-04-19 08:40:27.000000000 +0200
@@ -47,11 +47,6 @@ void __ieee80211_stop_rx_ba_session(stru
 		printk(KERN_DEBUG "HW problem - can not stop rx "
 				"aggregation for tid %d\n", tid);
 
-	/* check if this is a self generated aggregation halt */
-	if (initiator == WLAN_BACK_RECIPIENT)
-		ieee80211_send_delba(sta->sdata, sta->sta.addr,
-				     tid, 0, reason);
-
 	/* free the reordering buffer */
 	for (i = 0; i < tid_rx->buf_size; i++) {
 		if (tid_rx->reorder_buf[i]) {
@@ -69,6 +64,11 @@ void __ieee80211_stop_rx_ba_session(stru
 
 	spin_unlock_bh(&sta->lock);
 
+	/* check if this is a self generated aggregation halt */
+	if (initiator == WLAN_BACK_RECIPIENT)
+		ieee80211_send_delba(sta->sdata, sta->sta.addr,
+				     tid, 0, reason);
+
 	del_timer_sync(&tid_rx->session_timer);
 	kfree(tid_rx);
 }


