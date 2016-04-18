Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35340 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbcDRFjS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 01:39:18 -0400
Received: by mail-wm0-f45.google.com with SMTP id a140so103224384wma.0
        for <linux-wireless@vger.kernel.org>; Sun, 17 Apr 2016 22:39:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1460845267.2075.26.camel@sipsolutions.net>
References: <1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
	<1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
	<1460636302-31161-2-git-send-email-michal.kazior@tieto.com>
	<1460845267.2075.26.camel@sipsolutions.net>
Date: Mon, 18 Apr 2016 07:39:16 +0200
Message-ID: <CA+BoTQnzd1d2iP0xd10VJWNn69qR0oFypz90Jq2cXP+gzThOHw@mail.gmail.com> (sfid-20160418_073920_989783_5D9FA9EF)
Subject: Re: [PATCHv3 1/5] mac80211: skip netdev queue control with software queuing
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dave Taht <dave.taht@gmail.com>,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net,
	Avery Pennarun <apenwarr@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 April 2016 at 00:21, Johannes Berg <johannes@sipsolutions.net> wrote:
>> +static void ieee80211_txq_enqueue(struct ieee80211_local *local,
>> +                               struct txq_info *txqi,
>> +                               struct sk_buff *skb)
>> +{
>> +     lockdep_assert_held(&txqi->queue.lock);
> [...]
>> +     atomic_inc(&local->num_tx_queued);
>
> This global kinda bothers me - anything we can do about removing it?

I don't think so. Re-counting via sta/vif/txq iteration every time is
rather a bad idea.

FWIW This is removed by the "fq" patch. The main purpose of taildrop
patch is to make some comparisons easier.


> We obviously didn't have it now - just one (even bigger limit!) per
> queue, so that's 4000 frames default per interface ... now you're down
> to 512 for the entire hardware. Perhaps keeping it per interface at
> least gets away the worst of the contention here?

The default qdisc limits were arguably already too big anyway.
Nevertheless it makes sense to have the 512 limit per interface
instead of per radio. I'll move num_tx_queued to sdata.


Michał
