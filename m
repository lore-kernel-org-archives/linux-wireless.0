Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50288 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729782AbeISAZj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 20:25:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 18 Sep 2018 11:51:43 -0700
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH RFC v4 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <87o9cvksiv.fsf@toke.dk>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1>
 <153711973109.9231.7094211814263758096.stgit@alrua-x1.karlstad.toke.dk>
 <13400b5f9bdb5e36c6afabd071cc7b0d@codeaurora.org> <87o9cvksiv.fsf@toke.dk>
Message-ID: <efa33810860b2e5db789a76747bb826b@codeaurora.org> (sfid-20180918_205148_235615_9D745C5A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-18 03:29, Toke Høiland-Jørgensen wrote:
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> 
>> On 2018-09-16 10:42, Toke Høiland-Jørgensen wrote:
>> return_txq() should return a bool to inform the driver that whether
>> txq is queued back or not.
> 
> What would the driver do with that return value, exactly?
> 
never mind.. got lost with earlier schedule_txq API.

>> Otherwise the same txq will be served indefinitely until txq becomes
>> empty. This problem occurs when the driver is running out of hw
>> descriptors or driver sends only N frames (< backlog_packets).
> 
> No, if it's using next_txq(), the API guarantees that the same TXQ will
> not be returned more than once between a set of calls to
> schedule_start()/schedule_end() (by way of the seqno mechanism). I
> didn't add the same check to may_transmit(), because I assumed the
> driver would not be looping in this case. Is that not correct?
> 
Yeah.. you are correct. sorry for the noise.

>> Also an option to add the node at head or tail would be preferred. If
>> return_txq adds node at head of list, then it is forcing the driver to
>> serve same txq until it becomes empty. Also this will not allow the
>> driver to send N frames from each txqs.
> 
> The whole point of this patch set is to move those kinds of decisions
> out of the driver and into mac80211. The airtime scheduler won't 
> achieve
> fairness if it allows queues to be queued to the end of the rotation
> before its deficit turns negative. And obviously there's some lag in
> this since we're using after-the-fact airtime information.
> 
Hmm.. As you know ath10k kind of doing fairness by serving fixed frames
from each txq. This approach will be removed from ath10k.

> For ath9k this has not really been a problem in my tests; if the lag
> turns out to be too great for ath10k (which I suppose is a possibility
> since we don't get airtime information on every TX-compl), I figure we
> can use the same estimated airtime value that is used for throttling 
> the
> queues to adjust the deficit immediately...
> 
Thats true. I am porting Kan's changes of airtime estimation for each 
msdu
for firmware that does not report airtime.

-Rajkumar
