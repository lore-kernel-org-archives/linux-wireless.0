Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36926 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbbEaLRu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 07:17:50 -0400
Received: by wifw1 with SMTP id w1so72553840wif.0
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2015 04:17:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433068947.2370.5.camel@sipsolutions.net>
References: <1433028494-9665-1-git-send-email-chaitanya.mgit@gmail.com>
 <1433061092.2370.1.camel@sipsolutions.net> <CABPxzYK-8TtYdiFeFrX7AVcsXQFaa3oxHREq+jgohHh1tCg5GQ@mail.gmail.com>
 <1433068947.2370.5.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sun, 31 May 2015 16:47:28 +0530
Message-ID: <CABPxzY+9FwDPwRcZ4QT4QcfhMqmaQsrs=LT5E8tDKQG2t+wFRA@mail.gmail.com> (sfid-20150531_131936_316646_50E06058)
Subject: Re: [PATCH v2] cfg80211: Don't re-use the skb for larger NL messages.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 31, 2015 at 4:12 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2015-05-31 at 15:31 +0530, Krishna Chaitanya wrote:
>
>> In our case the data size is 411KB, and each message carries around 3072
>> bytes, so total messages would be 138. The first message we get, we
>> retrieve the data, and for subsequent messages we just fill the skb,
>> we are not interacting with the hardware.
>>
>> Without this patch, heres the sequence:
>> genl->cfg80211->retrieve the dump from HW, skb_put: 3072
>>          cfg80211->skb_put, fail
>> genl->cfg80211->skb_put: 3072.
>>
>> With this patch:
>>
>> genl->cfg80211->retrive the dump from HW, skb_put: 3072
>> genl->cfg80211->skb_put: 3072.
>
> You've failed to explain why this is so much of a problem that you're
> trying to "fix" it. I suspect the "fail" part inside your driver is
> needlessly expensive, I don't think the function call can be expensive
> enough to worry anyone.

"Fail" is a simple nla_put, its not at all expensive. We don't interact with
the hardware at that time. We in our tests we saw that this improved
the time to transport the dump (collection not included) to user space.

> Note # of "messages" as you say is actually irrelevant - you should look

Well with 138 messages the function and each message 3072 bytes
calls b/w cfg80211 and driver
       without the patch: would be 276 calls
       with this patch: would be 138 calls
Thats a lot of function calls, don't you think?

> at how often the kernel/user boundary is crossed, that's really far more
> interesting, and your patch makes that MUCH worse when the put size is
> small (say 100 bytes) because then you're practically doing that twice
> as often.

My patch doesn't deteriorate the situation, and not change the kernel to
user boundary. With/Without the patch 3072 bytes are transported in a
single message from kernel to user.

My patch only affects cfg80211 <--> Driver interaction as explained above.

> Anyway - I stand by your patch being a terrible idea. End of story.





-- 
Thanks,
Regards,
Chaitanya T K.
