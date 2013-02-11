Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44626 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932686Ab3BKVku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 16:40:50 -0500
Message-ID: <1360618844.8738.49.camel@jlt4.sipsolutions.net> (sfid-20130211_224054_322069_FB6A5E5A)
Subject: Re: [PATCH v4 1/2] mac80211: Fix tx queue handling during scans
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Date: Mon, 11 Feb 2013 22:40:44 +0100
In-Reply-To: <1360603268-28594-1-git-send-email-seth.forshee@canonical.com>
References: <20130211171829.GD13768@thinkpad-t410>
	 <1360603268-28594-1-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-11 at 11:21 -0600, Seth Forshee wrote:

> + * @IEEE80211_TX_CTL_OFFCHAN_TX_OK: Internal to mac80211. Used to indicate
> + *	that a frame can be transmitted while the queues are stopped for
> + *	off-channel operation.

I'm renaming this to INTFL_ instead of CTL_, any objections? I don't
think drivers should (need to) use it.


> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1228,8 +1228,21 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
>  #endif
>  
>  		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
> -		if (local->queue_stop_reasons[q] ||
> -		    (!txpending && !skb_queue_empty(&local->pending[q]))) {
> +		if (unlikely(info->flags & IEEE80211_TX_CTL_OFFCHAN_TX_OK)) {
> +			/*
> +			 * Drop off-channel frames if queues are stopped for
> +			 * any reason other than off-channel operation. Never
> +			 * queue them.
> +			 */
> +			if (local->queue_stop_reasons[q] &
> +			    ~BIT(IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL)) {
> +				spin_unlock_irqrestore(&local->queue_stop_reason_lock,
> +						       flags);
> +				ieee80211_purge_tx_queue(&local->hw, skbs);
> +				return true;
> +			}
> +		} else if (local->queue_stop_reasons[q] ||
> +			   (!txpending && !skb_queue_empty(&local->pending[q]))) {

I think this bit would be better written like this:

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1230,6 +1230,21 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 		if (local->queue_stop_reasons[q] ||
 		    (!txpending && !skb_queue_empty(&local->pending[q]))) {
+			if (unlikely(info->flags &
+					IEEE80211_TX_INTFL_OFFCHAN_TX_OK &&
+				     local->queue_stop_reasons[q] &
+					~BIT(IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL))) {
+				/*
+				 * Drop off-channel frames if queues are stopped
+				 * for any reason other than off-channel
+				 * operation. Never queue them.
+				 */
+				spin_unlock_irqrestore(
+					&local->queue_stop_reason_lock, flags);
+				ieee80211_purge_tx_queue(&local->hw, skbs);
+				return true;
+			}
+
 			/*
 			 * Since queue is stopped, queue up frames for later
 			 * transmission from the tx-pending tasklet when the

That would avoid hitting the fast-path as much, since the queues being
stopped is already something of a slow-path (and if they're stopped it
doesn't matter much ... packets won't go out soon anyway.)

I've made those changes, so just let me know if that seems OK, patch 2 I
also applied.

johannes

