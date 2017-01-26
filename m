Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47697 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753367AbdAZKC5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jan 2017 05:02:57 -0500
Subject: Re: [PATCH 3/4] ath9k: check for deaf rx path state
To: Simon Wunderlich <sw@simonwunderlich.de>
References: <20170125163654.66431-1-nbd@nbd.name>
 <20170125163654.66431-3-nbd@nbd.name> <4839692.lfma8z9lJt@prime>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <809a5011-4361-0459-2937-5dd5b0d619c2@nbd.name> (sfid-20170126_110302_141032_78E53862)
Date: Thu, 26 Jan 2017 11:02:53 +0100
MIME-Version: 1.0
In-Reply-To: <4839692.lfma8z9lJt@prime>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-01-26 10:50, Simon Wunderlich wrote:
> Hey Felix,
> 
> 
> On Wednesday, January 25, 2017 5:36:53 PM CET Felix Fietkau wrote:
>> Various chips occasionally run into a state where the tx path still
>> appears to be working normally, but the rx path is deaf.
>> 
>> There is no known register signature to check for this state explicitly,
>> so use the lack of rx interrupts as an indicator.
>> 
>> This detection is prone to false positives, since a device could also
>> simply be in an environment where there are no frames on the air.
>> However, in this case doing a reset should be harmless since it's
>> obviously not interrupting any real activity. To avoid confusion, call
>> the reset counters in this case "Rx path inactive" instead of something
>> like "Rx path deaf", since it may not be an indication of a real
>> hardware failure.
>> 
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> 
> As we observed in the field, it may happen that there are still RX interrupts 
> triggered, but just a very low number - in which case I believe your version 
> wouldn't fix the problem. Therefore we had a threshold in our original patch 
> [1].
It seems that you were seeing something different than what I was seeing
in my tests. Though it could be that my issues were actually caused by
something else. I had queued up these changes a while back before I
finally found and fixed the IRQ issue.

> We would also appreciate if you can at least briefly mention our work if you 
> resend/rework our stuff.
Sorry about that. I rebased this from older experimental patches and
forgot to put in all the relevant context.

Kalle, please drop this change for now.

- Felix
