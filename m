Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:63491 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab3BFNdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 08:33:25 -0500
Received: by mail-bk0-f43.google.com with SMTP id jm19so631767bkc.16
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2013 05:33:23 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Amit SHAKYA <amit.shakya@stericsson.com>
Subject: Re: [PATCH] mac80211: Fix PN corruption in case of multiple virtual interface
Date: Wed, 6 Feb 2013 14:33:19 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <1359976737-28059-1-git-send-email-amit.shakya@stericsson.com> <1359991708.10311.15.camel@jlt4.sipsolutions.net> <ECD438FDEF6BD742895E554C24725A40236E82519C@EXDCVYMBSTM005.EQ1STM.local>
In-Reply-To: <ECD438FDEF6BD742895E554C24725A40236E82519C@EXDCVYMBSTM005.EQ1STM.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201302061433.19375.chunkeey@googlemail.com> (sfid-20130206_143333_044200_1A411488)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, February 06, 2013 07:56:46 AM Amit SHAKYA wrote:
> From: Johannes Berg [mailto:johannes@sipsolutions.net]
> On Mon, 2013-02-04 at 16:48 +0530, Amit Shakya wrote:
> > @@ -2790,7 +2791,20 @@ static void ieee80211_rx_handlers(struct 
> > ieee80211_rx_data *rx)
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

> I wonder if this could lead to leaking frames here, if the station 
> disconnects or something while there are frames for it on the queue?
> IOW, the "just skip that frame" piece seems a bit questionable.
> 
>[AS] BTW we did test this out and didn’t observe any such issue. Can you
>     please help me understand the flow which could lead to the same? 
I read it like this: If a station suddenly disappears (for good) while
it still has some data in the reorder buffer, the reorder release timer
will put these orphaned frames into rx_skb_queue. 
With this patch, they will never be cleared from the queue, until
ieee80211_unregister_hw is called [when the device is unregistered].

So, you would need to go through the rx_skb_queue everytime a HT 
station is torn down and remove the affected frames from there.

>     Also in case this is an issue, can we take care of this in the cleanup
>     related to disconnect?
Sure, you could do that in ieee80211_sta_tear_down_BA_sessions. But you
don't need to. On Monday, I posted a patch:
<http://www.spinics.net/lists/linux-wireless/msg102725.html>
it should take care of the issue. So, can you test it please? 

>     Here it seems a conscious effort has been made to avoid spinlock
>     (rx->local->rx_skb_queue.lock), as this lock is taken only for the
>     duration of dequeue. The suggested solution avoids using spinlock.
Oh no, the locking is there. skb_unlink is defined in net/core/skbuff.c 
as a spin_lock wrapped __skb_unlink. The same is true for skb_queue_tail
and __skb_queue_tail. (Or are you talking about something else?)

Regards

Christian
