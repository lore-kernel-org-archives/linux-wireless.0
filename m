Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbaBSPHP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 10:07:15 -0500
Date: Wed, 19 Feb 2014 16:09:39 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: protect skb_queue_len(&ps->bc_buf) by lock
Message-ID: <20140219150937.GH1851@redhat.com> (sfid-20140219_160741_597590_41F2929B)
References: <1392812916-13656-1-git-send-email-sgruszka@redhat.com>
 <1392812916-13656-2-git-send-email-sgruszka@redhat.com>
 <1392815649.4733.23.camel@jlt4.sipsolutions.net>
 <20140219133546.GE1851@redhat.com>
 <1392821503.4733.26.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392821503.4733.26.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 19, 2014 at 03:51:43PM +0100, Johannes Berg wrote:
> On Wed, 2014-02-19 at 14:35 +0100, Stanislaw Gruszka wrote:
> 
> > > It ultimately makes no difference at all, it just makes this code more
> > > difficult to read and understand.
> > 
> > It make difference when queue length value is modified on different CPU
> > and read on different CPU. Without lock you can 'see' old length value
> > on CPU that run ieee80211_tx_h_multicast_ps_buf() for undefined
> > period of time (ok maybe not undefined on x86), and current oldest
> > frame can be not necessarily dropped.
> 
> I don't see how that can be true, since the modifications of the queue
> length are under spinlock with the implied memory barriers.

On processor that read value there is no memory barrier. If you do:

CPU1				CPU2

				b = a;
spin_lock(a_lock)
a = 1;				...
spin_unlock(a_lock)

				b = a;

There is nothing that guarantee that on CPU2 b will be 1.

Stanislaw
