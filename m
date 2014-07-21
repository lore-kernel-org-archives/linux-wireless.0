Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45054 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbaGUJrL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 05:47:11 -0400
Message-ID: <1405936026.32255.6.camel@jlt4.sipsolutions.net> (sfid-20140721_114714_991501_32667548)
Subject: Re: mac80211: A-MPDU reordering issue when RX_FLAG_AMSDU_MORE
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 21 Jul 2014 11:47:06 +0200
In-Reply-To: <CALhHN=ofbPoy6z+Bj2L4vTroYDde+2+VWY6f6FVgzrY9ZC+xEA@mail.gmail.com> (sfid-20140709_101618_515891_5735B725)
References: <CALhHN=ofbPoy6z+Bj2L4vTroYDde+2+VWY6f6FVgzrY9ZC+xEA@mail.gmail.com>
	 (sfid-20140709_101618_515891_5735B725)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-07-09 at 10:16 +0200, Janusz Dziedzic wrote:
> Hello Johannes,
> 
> Seems current mac80211 A-MPDU reordering implementation don't work
> correctly with drivers that prefer to report separate A-MSDU subframes
> instead of one huge frame (using RX_FLAG_AMSDU_MORE). Seems there is a
> table where index is a sequence number (ampdu sn), so don't work
> correctly while we report few A-MSDU frames with the same SN.
> 
> We see this problem with ath10k driver. As I understand correctly, we
> will have to change/rewrite mac80211 reordering code to support
> correctly A-MSDU packets with RX_FLAG_AMSDU_MORE?
> 
> Or
> 
> Maybe we should report A-MSDU frames as a list to the mac80211 (skb->next set).
> Queue such frame like this in mac80211 more or less:
>     while(skb->next && RX_FLAG_AMSDU_MORE)
>           __skb_queue_tail(frames, skb);
> 
> And dequeue into skb (mpdu) again:
>      while (RX_FLAG_AMSDU_MORE)
>            skb->next = __skb_dequeue(frames);
> 
> In such case we will have one skb (mpdu) that will contain all amsdu
> subframes, so more or less no changes in reordering code will be
> required. Insert will be "atomic" while we will add whole mpdu in one
> step.
> For sure we will have to handle this skb list in
> ieee80211_amsdu_to_8023s() + dev_kfree_skb_any() + some more work I
> think
> 
> What do you think?

Looks like Michal did the former in the meantime? I was moving so was
out for a while ...

johannes

