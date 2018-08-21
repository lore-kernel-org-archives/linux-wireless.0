Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59242 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbeHVAro (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 20:47:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 21 Aug 2018 14:25:54 -0700
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 3/3] mac80211: add ieee80211_reorder_txq
In-Reply-To: <87a7pfaovy.fsf@toke.dk>
References: <1534202011-13101-1-git-send-email-rmanohar@codeaurora.org>
 <1534202011-13101-4-git-send-email-rmanohar@codeaurora.org>
 <87a7pfaovy.fsf@toke.dk>
Message-ID: <d8775275d843cc7aa65c5005fd4c42af@codeaurora.org> (sfid-20180821_232558_466351_95210704)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-08-21 05:24, Toke Høiland-Jørgensen wrote:
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> 
>> This allows the driver to refill airtime fairness deficit
>> where the driver will not access txqs by ieee80211_next_txq.
>> In tx push mode data path, high priority txqs will be scheduled
>> for data transmission by ieee80211_next_txq and driver will not
>> prioritize txqs whereas in push-pull mode, the drivers can
>> prioritize txqs and access them directly. In such mode, airtime
>> deficit can not filled by ieee80211_next_txq.
>> 
[...]
> 
> This needs to check that the txq is currently at the head of
> local->active_txqs[txqi->txq.ac]; otherwise fairness enforcement 
> doesn't
> work. And with this check I'm not sure the reorder function is terribly
> useful for what you want to use it for?
> 
Hmm.. I tried to keep the same policy of next_txq(). i.e do not allow 
serving
txqs when the deficit is negative. reorder_txq() limits over serving the 
same
txq by driver. So that driver is given chance to serve other txqs.

As mentioned earlier, next_txq() can not be used for fetching txq 
directly.
So reorder_txq() needs to take care of refilling txq after serving them.

-Rajkumar
