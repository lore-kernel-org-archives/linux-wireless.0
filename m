Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:63681 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab3BDROO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 12:14:14 -0500
Received: by mail-bk0-f49.google.com with SMTP id w11so2914953bku.36
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2013 09:14:13 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Fix PN corruption in case of multiple virtual interface
Date: Mon, 4 Feb 2013 18:14:11 +0100
Cc: Amit Shakya <amit.shakya@stericsson.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <1359976737-28059-1-git-send-email-amit.shakya@stericsson.com> <1359991708.10311.15.camel@jlt4.sipsolutions.net>
In-Reply-To: <1359991708.10311.15.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201302041814.11894.chunkeey@googlemail.com> (sfid-20130204_181418_665511_0081944C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, February 04, 2013 04:28:28 PM Johannes Berg wrote:
> On Mon, 2013-02-04 at 16:48 +0530, Amit Shakya wrote:
> > @@ -2790,7 +2791,20 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx)
> >  
> >  	rx->local->running_rx_handler = true;
> >  
> > -	while ((skb = __skb_dequeue(&rx->local->rx_skb_queue))) {
> > +	skb_queue_walk_safe(&rx->local->rx_skb_queue, skb, tmp) {
> > +		if (!skb)
> > +			break;
> > +		hdr = (struct ieee80211_hdr *) skb->data;
> > +		/*
> > +		* Additional check to ensure that the packets corresponding
> > +		* to same sta entry as in rx->sta are de-queued. The queue
> > +		* can have different interface packets in case of multiple vifs
> > +		*/
> > +		if ((rx->sta && hdr) && (ieee80211_is_data(hdr->frame_control))
> > +			&& (memcmp(rx->sta->sta.addr, hdr->addr2, ETH_ALEN)))
> > +					continue;
> > +		__skb_unlink(skb, &rx->local->rx_skb_queue);
> 
> Christian, is there any reason to not just have the queue be on the
> stack, and use a separate spinlock in the local struct to lock out the
> unwanted concurrency?
Let's see.

The original "AMPDU rx reorder timeout timer" had the rx_skb_queue (frames)
on the stack. But that didn't work because the rx-path isn't thread-safe. This
issue was addressed by "mac80211: serialize rx path workers" (24a8fda). 
Interestingly, the RFC [1] of this patch mentioned the reason why I/we didn't
go for a rx-path lock:
"	1. Locking is easy to implement but hard to maintain.
	   Furthermore, Johannes worked very hard to get rid
	   of as many as possible."

> It seems to me that should work just as well, since there are never frames
> on the rx_skb_queue for very long, right?
Yes it should. At least we didn't find anything wrong with it back then.

Regards,
	Christian

[1] <http://article.gmane.org/gmane.linux.kernel.wireless.general/62240>
