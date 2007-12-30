Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:36279 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbXL3LuB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Dec 2007 06:50:01 -0500
Received: by fg-out-1718.google.com with SMTP id e21so2385439fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 30 Dec 2007 03:50:00 -0800 (PST)
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: Warning emited by 2.6.24-rc6-git5
Date: Sun, 30 Dec 2007 11:49:39 +0000
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <200712290942.37396.chris2553@googlemail.com> <1198939208.4172.46.camel@johannes.berg> <200712291614.55732.IvDoorn@gmail.com>
In-Reply-To: <200712291614.55732.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712301149.39388.chris2553@googlemail.com> (sfid-20071230_115007_700156_77B6A02D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 29 December 2007, Ivo van Doorn wrote:
> On Saturday 29 December 2007, Johannes Berg wrote:
> > > Well Ralink doesn't seem to add this padding since this bug appeared,
> > > remember all bytes from the DMA was copied to the skb buffer so if
> > > there was any padding included it would have been copied as well. ;)
> >
> > Not necessarily, Broadcom hardware adds the padding in front of the
> > 802.11 header so if you'd start copying with the 802.11 header you'd run
> > into the same thing. A quick look at the rt2x00pci.c file doesn't
> > suggest that there's anything variable about the RX header though so I
> > guess that indeed this may be a problem.
> >
> > > Anyway, I have worked on a fix for the padding and I'll commit it to
> > > rt2x00.git first to see if anybody reports any problems with it before
> > > sending it to wireless-dev.
> >

If it would help, I'd be happy to test your fix, but I'm not a git user, so 
you would need to post a patch that I could use...

> > Great. I just posted a similar fix in the other thread for zd1211, does
> > that look similar to yours as well? Should we have a static inline with
> > this code "ieee80211_needs_padding()" or something?
>
> My code looks more like:
>
> 	header_size = ieee80211_get_hdrlen_from_skb(entry->skb);
> 	if (header_size % 4 == 2) {
> 		/*
> 		 * Move entire frame 2 bytes to the front.
> 		 */
> 		skb_push(entry->skb, 2);
> 		memmove(entry->skb->data, entry->skb->data + 2,
> 			entry->skb->len - 2);
> 	}
>
> Ivo

Chris

-- 
Beer is proof that God loves us and wants us to be happy - Benjamin Franklin
