Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:11304 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbXL2POk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Dec 2007 10:14:40 -0500
Received: by fk-out-0910.google.com with SMTP id z23so4413384fkz.5
        for <linux-wireless@vger.kernel.org>; Sat, 29 Dec 2007 07:14:38 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Warning emited by 2.6.24-rc6-git5
Date: Sat, 29 Dec 2007 16:14:55 +0100
Cc: chris2553@googlemail.com, linux-wireless@vger.kernel.org
References: <200712290942.37396.chris2553@googlemail.com> <200712291529.10357.IvDoorn@gmail.com> <1198939208.4172.46.camel@johannes.berg>
In-Reply-To: <1198939208.4172.46.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712291614.55732.IvDoorn@gmail.com> (sfid-20071229_151454_868370_598533EF)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 29 December 2007, Johannes Berg wrote:
> 
> > Well Ralink doesn't seem to add this padding since this bug appeared,
> > remember all bytes from the DMA was copied to the skb buffer so if there
> > was any padding included it would have been copied as well. ;)
> 
> Not necessarily, Broadcom hardware adds the padding in front of the
> 802.11 header so if you'd start copying with the 802.11 header you'd run
> into the same thing. A quick look at the rt2x00pci.c file doesn't
> suggest that there's anything variable about the RX header though so I
> guess that indeed this may be a problem.
> 
> > Anyway, I have worked on a fix for the padding and I'll commit it to
> > rt2x00.git first to see if anybody reports any problems with it before
> > sending it to wireless-dev.
> 
> Great. I just posted a similar fix in the other thread for zd1211, does
> that look similar to yours as well? Should we have a static inline with
> this code "ieee80211_needs_padding()" or something?

My code looks more like:

	header_size = ieee80211_get_hdrlen_from_skb(entry->skb);
	if (header_size % 4 == 2) {
		/*
		 * Move entire frame 2 bytes to the front.
		 */
		skb_push(entry->skb, 2);
		memmove(entry->skb->data, entry->skb->data + 2,
			entry->skb->len - 2);
	}

Ivo
