Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost04.isp.att.net ([207.115.11.54]:45308 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbZGDBJP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2009 21:09:15 -0400
Message-ID: <4A4EABC7.9060005@lwfinger.net>
Date: Fri, 03 Jul 2009 20:09:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [WIP] p54: deal with allocation failures in rx path
References: <200907040053.05654.chunkeey@web.de>
In-Reply-To: <200907040053.05654.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> This patch tries to address a long standing issue: 
> how to survive serve memory starvation situations,
> without losing the device due to missing transfer-buffers.
> 
> And with a flick of __GFP_NOWARN, we're able to handle ?all? memory
> allocation failures on the rx-side during operation without much fuss.
> 
> However, there is still an issue within the xmit-part.
> This is likely due to p54's demand for a large free headroom for
> every outgoing frame:
> 
>  + transport header (differs from device to device)
>       -> 16 bytes transport header (USB 1st gen)
>       -> 8 bytes for (USB 2nd gen)
>       -> 0 bytes for spi & pci
>  + 12 bytes for p54_hdr
>  + 44 bytes for p54_tx_data
>  + up to 3 bytes for alignment
> (+ 802.11 header as well? )
> 
> and this is where ieee80211_skb_resize comes into the play...
> which will try to _relocate_ (alloc new, copy, free old) frame data,
> as the headroom is most of the time simply not enough.
> =>
>  Call Trace: (from Larry - Bug #13319 )
>  [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
>  [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
>  [<ffffffff802b6362>] new_slab+0xcf/0x28b
>  [<ffffffff802b4d1f>] ? unfreeze_slab+0x4c/0xbd
>  [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
>  [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
>  [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
>  [<ffffffff802b7e60>] __kmalloc+0x119/0x194
>  [<ffffffff803e7bee>] pskb_expand_head+0x52/0x166
>  [<ffffffffa02913d6>] ieee80211_skb_resize+0x91/0xc7 [mac80211]
>  [<ffffffffa0291c0f>] ieee80211_master_start_xmit+0x298/0x319 [mac80211]
>  [<ffffffff803ef72a>] dev_hard_start_xmit+0x229/0x2a8
> (sl*b debug option will help to bloat even more.)
> 
> So?! how to prevent ieee80211_skb_resize from raping
> the bits of memory left?
> 
> the simplest answer is probably this one:
> https://dev.openwrt.org/changeset/15761

Christian,

I have not had a change to review and/or test this patch. I applaud
attempts to reduce memory, but the problem that I reported will be
fixed in 2.6.31. Whenever the SLUB debugging would force the order of
the request to increase, debugging will be turned off for that request
and a notification will be logged. This solution represents a
compromise among the developers - as usual none of them are really
happy with this approach, and it is expected that there will be
further development for 2.6.32.

After I test this patch, I will try reverting the change that reduced
MTU on the chance that it will no longer be necessary.

Larry
