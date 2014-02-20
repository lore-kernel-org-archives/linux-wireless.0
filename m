Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59605 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaBTHHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 02:07:30 -0500
Message-ID: <1392880043.5073.1.camel@jlt4.sipsolutions.net> (sfid-20140220_080757_342839_2C57F2AC)
Subject: Re: [PATCH] mac80211: check if the ps_buf skb queue hasn't been
 drained
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Date: Thu, 20 Feb 2014 08:07:23 +0100
In-Reply-To: <1392877117-17869-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1392877117-17869-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 08:18 +0200, Emmanuel Grumbach wrote:
> There is a race between the Tx path and the STA wake up
> flow.
> If a station is asleep, mac80211 buffers frames, but up to
> a certain limit. When this limit is reached, mac80211 begins
> to drop the oldest buffered frames. This is done in the Tx
> path.
> When a station wakes up, mac80211 will go over the buffered
> frames list and send them.
> Since these two flows can run concurrently, we can get to a
> situation where the buffered frame list is emptied after the
> Tx path checked the length of the list. In that case the Tx
> path would get a NULL skb and crash.

I think you should rewrite the commit log - the real fix now isn't
really that it can't crash any more, I'd see that as a side effect of
the below:

> This is only a noisy consequence of another bigger issue:
> since ieee80211_tx_h_unicast_ps_buf is not synced against
> ieee80211_sta_ps_deliver_wakeup, Tx path could think that
> the STA is still sleeping and put the packet on the PS skb
> list while in fact the STA is awake already. In this case,
> the frame would sit on the PS skb list until the next time
> the STA wakes up and then, it'd be sent out of order.


> @@ -486,6 +499,7 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
>  			ieee80211_free_txskb(&local->hw, old);
>  		} else
>  			tx->local->total_ps_buffered++;
> +		spin_unlock(&sta->lock);

That needs to be after adding the frame to the queue.

johannes

