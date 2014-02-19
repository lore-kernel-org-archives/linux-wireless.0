Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56888 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbaBSQhE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 11:37:04 -0500
Message-ID: <1392827818.4733.27.camel@jlt4.sipsolutions.net> (sfid-20140219_173709_490802_0BF3F18F)
Subject: Re: [PATCH 2/2] mac80211: protect skb_queue_len(&ps->bc_buf) by lock
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Feb 2014 17:36:58 +0100
In-Reply-To: <20140219150937.GH1851@redhat.com>
References: <1392812916-13656-1-git-send-email-sgruszka@redhat.com>
	 <1392812916-13656-2-git-send-email-sgruszka@redhat.com>
	 <1392815649.4733.23.camel@jlt4.sipsolutions.net>
	 <20140219133546.GE1851@redhat.com>
	 <1392821503.4733.26.camel@jlt4.sipsolutions.net>
	 <20140219150937.GH1851@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-19 at 16:09 +0100, Stanislaw Gruszka wrote:
> On Wed, Feb 19, 2014 at 03:51:43PM +0100, Johannes Berg wrote:
> > On Wed, 2014-02-19 at 14:35 +0100, Stanislaw Gruszka wrote:
> > 
> > > > It ultimately makes no difference at all, it just makes this code more
> > > > difficult to read and understand.
> > > 
> > > It make difference when queue length value is modified on different CPU
> > > and read on different CPU. Without lock you can 'see' old length value
> > > on CPU that run ieee80211_tx_h_multicast_ps_buf() for undefined
> > > period of time (ok maybe not undefined on x86), and current oldest
> > > frame can be not necessarily dropped.
> > 
> > I don't see how that can be true, since the modifications of the queue
> > length are under spinlock with the implied memory barriers.
> 
> On processor that read value there is no memory barrier. If you do:
> 
> CPU1				CPU2
> 
> 				b = a;
> spin_lock(a_lock)
> a = 1;				...
> spin_unlock(a_lock)
> 
> 				b = a;
> 
> There is nothing that guarantee that on CPU2 b will be 1.

Well, OK, so there's some small window of time where the drop code isn't
perfect. Does it matter? I'd argue it doesn't - if you're getting close
to the drop case then the client is probably misbehaving anyway.

johannes

