Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:46988 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752038AbcHYTZW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 15:25:22 -0400
Subject: Re: [PATCH 4/4] ath10k: fix spurious tx/rx during boot
To: Michal Kazior <michal.kazior@tieto.com>
References: <1468924452-23877-1-git-send-email-michal.kazior@tieto.com>
 <1468924452-23877-5-git-send-email-michal.kazior@tieto.com>
 <a9bf9a29-f020-7118-79ee-b6c1aaa95ffe@candelatech.com>
 <CA+BoTQk5GPFnC7tT5qoG6aiN0hSNbiDAVNv7O7j2SXgCvUUjBA@mail.gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Marek Puzyniak <marek.puzyniak@tieto.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <f48178bc-0775-5b60-1c9a-cead97005fbb@candelatech.com> (sfid-20160825_212526_258183_57376964)
Date: Thu, 25 Aug 2016 12:19:13 -0700
MIME-Version: 1.0
In-Reply-To: <CA+BoTQk5GPFnC7tT5qoG6aiN0hSNbiDAVNv7O7j2SXgCvUUjBA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/24/2016 11:18 PM, Michal Kazior wrote:

>> I was looking at firmware to make sure that I fixed what I could there....
>>
>> From what I can tell, 10.4 should not have this bug.  Did you see this only
>> on 10.1/10.2 firmware?  It is of course possible that I am mis-understanding
>> 10.4....
>
> I did see it on 10.1 and 10.2. Don't recall seeing it on 10.4 though.
> If you didn't see warnings on 10.4 even after adding msleep() as per
> commit log then I guess it doesn't suffer from the bug.

I can still occasionally see that message with a 15000 ms sleep.

Based on debugging, it seems my firmware is now setting the mac-mask properly.

But, as you mention, the rxfilter is enabled very early.  So, probably
it is still possible to see packets early if they are multicast, bcast, etc.

I don't think it is worth re-working the entire rx-filter calc in
the concurrency logic properly for 10.1 firmware, so I'm going to figure
my fix is good enough as is as long as it sets the mac-mask properly.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
