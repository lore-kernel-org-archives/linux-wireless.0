Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48048 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753730AbdAZK0G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jan 2017 05:26:06 -0500
Subject: Re: [PATCH 3/4] ath9k: check for deaf rx path state
To: Simon Wunderlich <sw@simonwunderlich.de>
References: <20170125163654.66431-1-nbd@nbd.name> <4839692.lfma8z9lJt@prime>
 <809a5011-4361-0459-2937-5dd5b0d619c2@nbd.name> <2448336.mzt5URIzpg@prime>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <8306f20d-ca2a-60fd-b0d9-5155f3bbd094@nbd.name> (sfid-20170126_112610_258768_20CAC347)
Date: Thu, 26 Jan 2017 11:26:03 +0100
MIME-Version: 1.0
In-Reply-To: <2448336.mzt5URIzpg@prime>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-01-26 11:15, Simon Wunderlich wrote:
> Hey,
> 
> On Thursday, January 26, 2017 11:02:53 AM CET Felix Fietkau wrote:
>> On 2017-01-26 10:50, Simon Wunderlich wrote:
>> > Hey Felix,
>> > 
>> > On Wednesday, January 25, 2017 5:36:53 PM CET Felix Fietkau wrote:
>> >> Various chips occasionally run into a state where the tx path still
>> >> appears to be working normally, but the rx path is deaf.
>> >> 
>> >> There is no known register signature to check for this state explicitly,
>> >> so use the lack of rx interrupts as an indicator.
>> >> 
>> >> This detection is prone to false positives, since a device could also
>> >> simply be in an environment where there are no frames on the air.
>> >> However, in this case doing a reset should be harmless since it's
>> >> obviously not interrupting any real activity. To avoid confusion, call
>> >> the reset counters in this case "Rx path inactive" instead of something
>> >> like "Rx path deaf", since it may not be an indication of a real
>> >> hardware failure.
>> >> 
>> >> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>> > 
>> > As we observed in the field, it may happen that there are still RX
>> > interrupts triggered, but just a very low number - in which case I
>> > believe your version wouldn't fix the problem. Therefore we had a
>> > threshold in our original patch [1].
>> 
>> It seems that you were seeing something different than what I was seeing
>> in my tests. Though it could be that my issues were actually caused by
>> something else. I had queued up these changes a while back before I
>> finally found and fixed the IRQ issue.
> 
> What we found a good threshold was to check for less than 1 RX interrupt per 
> second, and check the mean average (about) every 30 seconds. If there is any 
> other AP or a station connected, it will not reset the chip, and also there 
> will be no reset on short outages.
But if there's less than 1 Rx interrupt per second, then my patch should
also trigger, right?

- Felix
