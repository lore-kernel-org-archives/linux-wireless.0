Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbaBSNdY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 08:33:24 -0500
Date: Wed, 19 Feb 2014 14:35:46 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: protect skb_queue_len(&ps->bc_buf) by lock
Message-ID: <20140219133546.GE1851@redhat.com> (sfid-20140219_143328_063534_FD8A185B)
References: <1392812916-13656-1-git-send-email-sgruszka@redhat.com>
 <1392812916-13656-2-git-send-email-sgruszka@redhat.com>
 <1392815649.4733.23.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392815649.4733.23.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 19, 2014 at 02:14:09PM +0100, Johannes Berg wrote:
> On Wed, 2014-02-19 at 13:28 +0100, Stanislaw Gruszka wrote:
> > Similar change as on current patch "mac80211: fix calling
> > ieee80211_free_txskb with NULL skb", but for multicast queue. Patch does
> > not prevent crash, as dev_kfree_skb() checks against NULL skb, but it
> > help to prevent not necessary frame drop, when bc_buf queue was
> > partially flushed and no longer exceeds AP_MAX_BC_BUFFER .
> 
> I don't think this makes sense. It doesn't really change anything,
> holding a spinlock isn't something magic that makes other things go
> away, so instead of
>
>  * check queue length, is >= limit
>  * free frame from queue, even if somebody else is dequeuing as well
> 
> as before, you'd just have
>  * check queue length, is >= limit
>  * take lock
>  * check queue length, is >= limit
>  * drop frame
>  * unlock
>  * somebody else who was dequeuing now wakes up from waiting on the lock
> and
>    finds no frame there
> 
> It ultimately makes no difference at all, it just makes this code more
> difficult to read and understand.

It make difference when queue length value is modified on different CPU
and read on different CPU. Without lock you can 'see' old length value
on CPU that run ieee80211_tx_h_multicast_ps_buf() for undefined
period of time (ok maybe not undefined on x86), and current oldest
frame can be not necessarily dropped.

I can remove first call skb_queue_len(&ps->bc_buf) and take spinlock
unconditionally, will that help with code readability ? 

Stanislaw

