Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:15435 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYEHPZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 11:25:54 -0400
Received: by ug-out-1314.google.com with SMTP id h2so106733ugf.16
        for <linux-wireless@vger.kernel.org>; Thu, 08 May 2008 08:25:50 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: 015-mac80211-tx-info-skb-cb.patch
Date: Thu, 8 May 2008 17:34:23 +0200
Cc: linux-wireless@vger.kernel.org
References: <200805081503.41025.IvDoorn@gmail.com> <200805081710.03869.IvDoorn@gmail.com> <1210259130.3547.59.camel@johannes.berg>
In-Reply-To: <1210259130.3547.59.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805081734.23354.IvDoorn@gmail.com> (sfid-20080508_172454_002061_443CE0BF)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 08 May 2008, Johannes Berg wrote:
> 
> > > Right :) I'm pretty much done with the skb->cb conversion too except for
> > > ath5k (nick) and rt2x00 (you)
> > 
> > I'm going to rebase rt2x00.git this weekend to update from wireless-testing,
> > since the skb->cb patches now depends on HW crypto which is not ready
> > for upstream yet, I am going to reverse the patch order so the skb->cb patches
> > and some other updates can go upstream more easily.
> 
> Cool, thanks. If you have a single patch that can pretty much go into
> wireless-testing you can send it to me and I'll roll it into my patch.

Well at the moment I have it split into 2 patches, one that is only
preperation work by splitting a particular function to guarentee the skb->cb
rules are being followed. And the second patch is the actual conversion.
Those 2 can easily be merged into a single patch which you can roll into your
patch.

> If it depends on another rt2x00 merge then just let me know, I can wait
> with this. I'd like to do it soonish though, it removes ~200 lines of
> code (touching roughly 1000) and a lot of kmemdup/memcpy/kmalloc calls.

Hehe, well I am kind of hoping the patch can be in included soon as well,
(as well as your QOS patches). Unwinding the HW crypto dependency shouldn't
be that hard, after which the patch won't have any dependencies anymore.

> I'm just rebasing things a bit myself as well so I can give people a
> patch to test.

Ivo
