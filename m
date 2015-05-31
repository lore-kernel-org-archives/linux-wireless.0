Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33527 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbbEaLjk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 07:39:40 -0400
Received: by wicmx19 with SMTP id mx19so48465847wic.0
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2015 04:39:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433071305.2370.14.camel@sipsolutions.net>
References: <1433028494-9665-1-git-send-email-chaitanya.mgit@gmail.com>
 <1433061092.2370.1.camel@sipsolutions.net> <CABPxzYK-8TtYdiFeFrX7AVcsXQFaa3oxHREq+jgohHh1tCg5GQ@mail.gmail.com>
 <1433068947.2370.5.camel@sipsolutions.net> <CABPxzY+9FwDPwRcZ4QT4QcfhMqmaQsrs=LT5E8tDKQG2t+wFRA@mail.gmail.com>
 <1433071305.2370.14.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sun, 31 May 2015 17:09:18 +0530
Message-ID: <CABPxzY+ZcHCGBENCsT=pc+nvkWOmkVQXMQwyLCvuScZzoJuzCA@mail.gmail.com> (sfid-20150531_133944_148282_AF9CC774)
Subject: Re: [PATCH v2] cfg80211: Don't re-use the skb for larger NL messages.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 31, 2015 at 4:51 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2015-05-31 at 16:47 +0530, Krishna Chaitanya wrote:
>
>> > Note # of "messages" as you say is actually irrelevant - you should look
>>
>> Well with 138 messages the function and each message 3072 bytes
>> calls b/w cfg80211 and driver
>>        without the patch: would be 276 calls
>>        with this patch: would be 138 calls
>> Thats a lot of function calls, don't you think?
>
> No, I don't think so. That really should be within the noise, it's all
> in the icache already after the first round.

Agree, but there's a scope for improvement (at least functionally), so
i took a shot.

>
>> > at how often the kernel/user boundary is crossed, that's really far more
>> > interesting, and your patch makes that MUCH worse when the put size is
>> > small (say 100 bytes) because then you're practically doing that twice
>> > as often.
>>
>> My patch doesn't deteriorate the situation, and not change the kernel to
>> user boundary. With/Without the patch 3072 bytes are transported in a
>> single message from kernel to user.
>
> *in your case*
>
> In the case that somebody is creating smaller messages it makes things
> MUCH worse by allowing only half the data to be carried across the
> kernel/userspace boundary each time any data crosses it, so it will
> result in many more syscalls in that case. If you're worried about the
> overhead of a simple function (pointer) call in the kernel, then surely
> you should be far more worried about this.

Thats why we have the threshold so that smaller messages (<2048)
do not suffer.
