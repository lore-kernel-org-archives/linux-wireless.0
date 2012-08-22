Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933315Ab2HVVQu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2012 17:16:50 -0400
Date: Wed, 22 Aug 2012 23:16:31 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	Sergei Poselenov <sposelenov@emcraft.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: Re: [rt2x00-users] [PATCH] compat-wireless:rt2800usb: Added rx
 packet length validity check
Message-ID: <20120822211630.GA3742@redhat.com> (sfid-20120822_231655_076973_2A1570C9)
References: <20120820205355.7ccc0450@emcraft.com>
 <20120821114343.GB2380@redhat.com>
 <CAOZOX0V5ehfSZKQ=tPpowH35ct230nBXk6wSBiTcb10UUbieCA@mail.gmail.com>
 <20120821141842.GF2380@redhat.com>
 <A1D107E0-1E78-4123-88C1-9550064DC9AC@gmail.com>
 <20120822092715.GC4959@redhat.com>
 <70A1AEFB-59F7-4947-B2A0-A89C29C3108B@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <70A1AEFB-59F7-4947-B2A0-A89C29C3108B@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gertjan
 
On Wed, Aug 22, 2012 at 10:41:42PM +0200, Gertjan van Wingerde wrote:
> > IIRC this is basically what I proposed, except without setting
> > rxdesc->size, unlikely() and rx_pkt_len == 0 check. It will work as
> > rxdesc->size will be 0. But I think it would be better, if WARNING on
> > rt2x00lib_rxdone() will print actual corrupted size instead of 0.
> > Having unlikely is good too - this must be unlikely situation.
> 
> OK, I agree with the use of unlikely(). An rx_pkt_len of 0 doesn't seem to happen in practice, so testing for it seems superfluous, but may be providing some extra safety. Don't really care about that. I really don't think we should set rxdesc->size, as we cannot determine it. If we want to print the value, then do it in this function. Adding a hack to having it printed somewhere else doesn't seem right to me.
> Also, it should be an error log message, not a WARNING. There's no need to have a stack trace as the buffer is filled by HW, not by some other function. So, the use of WARNING, with its stack dumping functionality is overkill.
> 
> 
> > 
> > BTW: would be good to fix reason of that corruption if possible
> > (as long this is not a H/W or F/W bug). But for now, let just
> > stop kernel crashing. Printing WARNING on this situation will
> > help to identify there is something wrong if someone will observe
> > performance problems or similar.
> 
> I think this is a HW issue. As mentioned above, I believe a WARNING here is overkill, as we don't need the stack trace.

I was talking about this WARNING in rt2x00lib_rxdone() (which is not
WARN_ON() or WARN() - so no stactrace):

	/*
	 * Check for valid size in case we get corrupted descriptor from
	 * hardware.
	 */
	if (unlikely(rxdesc.size == 0 ||
		     rxdesc.size > entry->queue->data_size)) {
		WARNING(rt2x00dev, "Wrong frame size %d max %d.\n",
			rxdesc.size, entry->queue->data_size);
		dev_kfree_skb(entry->skb);
		goto renew_skb;
	}


I agree that using ERROR is better.
 
> Anyway, Sergei, would you be able to modify the patch along the lines of the discussion?

I hope so :-)

Thanks
Stanislaw
