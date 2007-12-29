Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:64862 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbXL2Lrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Dec 2007 06:47:39 -0500
Received: by fg-out-1718.google.com with SMTP id e21so2144711fga.17
        for <linux-wireless@vger.kernel.org>; Sat, 29 Dec 2007 03:47:37 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Warning emited by 2.6.24-rc6-git5
Date: Sat, 29 Dec 2007 12:47:53 +0100
Cc: chris2553@googlemail.com, linux-wireless@vger.kernel.org
References: <200712290942.37396.chris2553@googlemail.com> <200712291121.31120.IvDoorn@gmail.com> <1198924603.4172.34.camel@johannes.berg>
In-Reply-To: <1198924603.4172.34.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712291247.54258.IvDoorn@gmail.com> (sfid-20071229_114742_952160_05D678BD)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 29 December 2007, Johannes Berg wrote:
> 
> > If it helps as reference, rt2x00 allocates and initializes the data as follows:
> > 
> > 		skb_reserve(skb, NET_IP_ALIGN);
> > 		skb_put(skb, desc.size); /* Always a multiple of 4 bytes */
> > 		memcpy(skb->data, entry->data_addr, desc.size);
> 
> So why do you copy all the data anyway? You have DMA queues and no need
> to not have the hardware dump the data into the frame to start with, no?

True, if no further aligning would be required that would be true,
but since the payload should be aligned to a 4 byte boundrary anyway
this would mean we must use memcpy() in all cases anyway since we
can't predict what header length the frame will contain. :(

Although it would safe the initial allocation of the DMA buffer...
I'll look into it to see if it would be useful.

> In any case, with wireless NET_IP_ALIGN is pretty useless unless you
> want to add two to it and then align the result. Maybe the mac80211
> warning should be relaxed to take NET_IP_ALIGN into account.

Ok, I'll look into better aligning of the skb buffer then.

Ivo
