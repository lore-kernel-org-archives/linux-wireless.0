Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:1977 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbXL2KVQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Dec 2007 05:21:16 -0500
Received: by fg-out-1718.google.com with SMTP id e21so2131733fga.17
        for <linux-wireless@vger.kernel.org>; Sat, 29 Dec 2007 02:21:14 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Warning emited by 2.6.24-rc6-git5
Date: Sat, 29 Dec 2007 11:21:30 +0100
Cc: chris2553@googlemail.com, linux-wireless@vger.kernel.org
References: <200712290942.37396.chris2553@googlemail.com> <1198922056.4172.25.camel@johannes.berg>
In-Reply-To: <1198922056.4172.25.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712291121.31120.IvDoorn@gmail.com> (sfid-20071229_102122_535849_9856172A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 29 December 2007, Johannes Berg wrote:
> I didn't think that many drivers had this problem... The warning is
> harmless on machines that are ok with unaligned memory accesses.
> 
> > WARNING: at net/mac80211/rx.c:1486 __ieee80211_rx()
> > Pid: 0, comm: swapper Not tainted 2.6.24-rc6-git5 #11
> 
> comes from
>         /*
>          * Drivers are required to align the payload data to a four-byte
>          * boundary, so the last two bits of the address where it starts
>          * may not be set. The header is required to be directly before
>          * the payload data, padding like atheros hardware adds which is
>          * inbetween the 802.11 header and the payload is not supported,
>          * the driver is required to move the 802.11 header further back
>          * in that case.
>          */
>         hdrlen = ieee80211_get_hdrlen(rx.fc);
>         WARN_ON_ONCE(((unsigned long)(skb->data + hdrlen)) & 3);
> 
> 
> Although I'm starting to doubt my own sanity here with this sanity check
> if so many drivers can trigger it.

If it helps as reference, rt2x00 allocates and initializes the data as follows:

		skb_reserve(skb, NET_IP_ALIGN);
		skb_put(skb, desc.size); /* Always a multiple of 4 bytes */
		memcpy(skb->data, entry->data_addr, desc.size);

Should there have done more for the aligning of the data?

Ivo
