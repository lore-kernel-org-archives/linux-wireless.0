Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbaBSOqK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 09:46:10 -0500
Date: Wed, 19 Feb 2014 15:48:31 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: fix calling ieee80211_free_txskb with NULL
 skb
Message-ID: <20140219144831.GF1851@redhat.com> (sfid-20140219_154613_761752_287AD590)
References: <1392812916-13656-1-git-send-email-sgruszka@redhat.com>
 <1392813218.4733.20.camel@jlt4.sipsolutions.net>
 <20140219132134.GD1851@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140219132134.GD1851@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 19, 2014 at 02:21:35PM +0100, Stanislaw Gruszka wrote:
> > In any case, while this solves the crash which is a good thing, it still
> > leaves the code buggy. This crash seems to occur in the following racy
> > scenario:
> > 
> >  * station is sleeping
> >  * frame TX to station begins
> >  * station wakes up
> >  * frame TX goes into the queue length check, finds long queue
> >  * pending frames are transmitted
> >  * queue is now empty
> >  * old = skb_dequeue() returns NULL
> >  * *kaboom*
> > 
> > The problem is that you're just fixing the "*kaboom*" part, so the code
> > will continue like this:
> > 
> >  * old is NULL
> >  * no kaboom
> >  * new frame is queued on ps_tx_buf queue
> >  * frame never gets transmitted
> 
> When started to look at that code I found at least 3 bugs, but miss
> this one :-)
> 
> Why frame will not be transmitted, we are disabling PS, but buffers
> stays not empty ?

Ok, I think I see this, it seems to be race condition in 
ieee80211_sta_ps_deliver_wakeup().

Perhaps it could be solved by modifying
ieee80211_add_pending_skbs_fn() to take list of queues as argument,
that function seems properly stop queues, add buffered frames to
pending queue, clear WLAN_STA_PS_STA and then wake up queues. Or
just  stop using ieee80211_add_pending_skbs_fn() and do the same
sequence directly on ieee80211_sta_ps_deliver_wakeup() .
 
Stanislaw
