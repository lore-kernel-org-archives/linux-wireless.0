Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46461 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab3BKVuN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 16:50:13 -0500
Date: Mon, 11 Feb 2013 15:50:04 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH v4 1/2] mac80211: Fix tx queue handling during scans
Message-ID: <20130211215004.GI13768@thinkpad-t410> (sfid-20130211_225017_806736_84B5C985)
References: <20130211171829.GD13768@thinkpad-t410>
 <1360603268-28594-1-git-send-email-seth.forshee@canonical.com>
 <1360618844.8738.49.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360618844.8738.49.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 11, 2013 at 10:40:44PM +0100, Johannes Berg wrote:
> On Mon, 2013-02-11 at 11:21 -0600, Seth Forshee wrote:
> 
> > + * @IEEE80211_TX_CTL_OFFCHAN_TX_OK: Internal to mac80211. Used to indicate
> > + *	that a frame can be transmitted while the queues are stopped for
> > + *	off-channel operation.
> 
> I'm renaming this to INTFL_ instead of CTL_, any objections? I don't
> think drivers should (need to) use it.

No objections. The drivers shouldn't need to use it, I just wasn't aware
of the distinction.

> > --- a/net/mac80211/tx.c
> > +++ b/net/mac80211/tx.c
> > @@ -1228,8 +1228,21 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
> >  #endif
> >  
> >  		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
> > -		if (local->queue_stop_reasons[q] ||
> > -		    (!txpending && !skb_queue_empty(&local->pending[q]))) {
> > +		if (unlikely(info->flags & IEEE80211_TX_CTL_OFFCHAN_TX_OK)) {
> > +			/*
> > +			 * Drop off-channel frames if queues are stopped for
> > +			 * any reason other than off-channel operation. Never
> > +			 * queue them.
> > +			 */
> > +			if (local->queue_stop_reasons[q] &
> > +			    ~BIT(IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL)) {
> > +				spin_unlock_irqrestore(&local->queue_stop_reason_lock,
> > +						       flags);
> > +				ieee80211_purge_tx_queue(&local->hw, skbs);
> > +				return true;
> > +			}
> > +		} else if (local->queue_stop_reasons[q] ||
> > +			   (!txpending && !skb_queue_empty(&local->pending[q]))) {
> 
> I think this bit would be better written like this:
> 
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1230,6 +1230,21 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
>  		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
>  		if (local->queue_stop_reasons[q] ||
>  		    (!txpending && !skb_queue_empty(&local->pending[q]))) {
> +			if (unlikely(info->flags &
> +					IEEE80211_TX_INTFL_OFFCHAN_TX_OK &&
> +				     local->queue_stop_reasons[q] &
> +					~BIT(IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL))) {
> +				/*
> +				 * Drop off-channel frames if queues are stopped
> +				 * for any reason other than off-channel
> +				 * operation. Never queue them.
> +				 */
> +				spin_unlock_irqrestore(
> +					&local->queue_stop_reason_lock, flags);
> +				ieee80211_purge_tx_queue(&local->hw, skbs);
> +				return true;
> +			}
> +
>  			/*
>  			 * Since queue is stopped, queue up frames for later
>  			 * transmission from the tx-pending tasklet when the
> 
> That would avoid hitting the fast-path as much, since the queues being
> stopped is already something of a slow-path (and if they're stopped it
> doesn't matter much ... packets won't go out soon anyway.)

Your version is fine with me.

> I've made those changes, so just let me know if that seems OK, patch 2 I
> also applied.

Everything looks good. Thanks!

Seth

