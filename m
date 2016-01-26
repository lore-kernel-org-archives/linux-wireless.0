Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:57561 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934375AbcAZMEj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 07:04:39 -0500
Subject: Re: [PATCH 2/2] mac80211: expose txq queue depth and size to drivers
To: Michal Kazior <michal.kazior@tieto.com>
References: <1453382588-27105-1-git-send-email-michal.kazior@tieto.com>
 <1453382588-27105-2-git-send-email-michal.kazior@tieto.com>
 <56A74E51.80609@openwrt.org>
 <CA+BoTQk+7cpP9jZ8UyUjOrnPc309LdgYN8BbNBfEOyTSUDBcAw@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56A760C8.3050300@openwrt.org> (sfid-20160126_130442_203243_4B9D7BE3)
Date: Tue, 26 Jan 2016 13:04:24 +0100
MIME-Version: 1.0
In-Reply-To: <CA+BoTQk+7cpP9jZ8UyUjOrnPc309LdgYN8BbNBfEOyTSUDBcAw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-01-26 12:56, Michal Kazior wrote:
> On 26 January 2016 at 11:45, Felix Fietkau <nbd@openwrt.org> wrote:
>> On 2016-01-21 14:23, Michal Kazior wrote:
>>> This will allow drivers to make more educated
>>> decisions whether to defer transmission or not.
>>>
>>> Relying on wake_tx_queue() call count implicitly
>>> was not possible because it could be called
>>> without queued frame count actually changing on
>>> software tx aggregation start/stop code paths.
>>>
>>> It was also not possible to know how long
>>> byte-wise queue was without dequeueing.
>>>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> Instead of exposing these in the struct to the driver directly, please
>> make a function to get them. Since the number of frames is already
>> tracked in txqi->queue, you can avoid counter duplication that way.
> 
> Hmm, so you suggest to have something like:
> 
>  void
>  ieee80211_get_txq_depth(struct ieee80211_txq *txq,
>                          unsigned int *frame_cnt,
>                          unsigned int *byte_count) {
>    struct txq_info *txqi = txq_to_info(txq);
> 
>    if (frame_cnt)
>      *frame_cnt = txqi->queue.qlen;
> 
>    if (byte_count)
>      *byte_cnt = txqi->byte_cnt;
>  }
> 
> Correct?
> 
> Sounds reasonable.
Right.

>> Also, that way you can fix a race condition between accessing the number
>> of frames counter and the bytes counter.
> 
> I don't see a point in maintaining coherency between the two counters
> with regard to each other alone. Do you have a use-case that would
> actually make use of that property?
> 
> I'd like to avoid any unnecessary spinlocks.
OK. I guess we can leave them out for now. How frequently are you going
to call this function?

- Felix
