Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52560 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751609AbdIULWr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2017 07:22:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [v2,1/2] qtnfmac: lock access to h/w in tx path
References: <20170918122950.32612-2-sergey.matyukevich.os@quantenna.com>
        <20170920123553.7121D6070F@smtp.codeaurora.org>
        <20170921080147.tvcztifyfwy2lp7g@bars>
Date: Thu, 21 Sep 2017 14:22:40 +0300
In-Reply-To: <20170921080147.tvcztifyfwy2lp7g@bars> (Sergey Matyukevich's
        message of "Thu, 21 Sep 2017 11:01:48 +0300")
Message-ID: <878th870u7.fsf@codeaurora.org> (sfid-20170921_132250_922244_A1CDD54B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> Hello Kalle,
>
>> > Fix tx path regression. Lock should be held when queuing packets
>> > to h/w fifos in order to properly handle configurations with
>> > multiple enabled interfaces.
>> >
>> > Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
>> 
>> 2 patches applied to wireless-drivers.git, thanks.
>> 
>> 20da2ec06bfa qtnfmac: lock access to h/w in tx path
>> a715b3a0efe7 qtnfmac: cancel scans on wireless interface changes
>
> Could you please clarify a couple of points regarding wireless-drivers-next
> and wireless-drivers trees. I checked development process article at
> wireless.wiki.kernel.org, but it looks a bit outdated.

You mean this page:

https://wireless.wiki.kernel.org/en/developers/process

Yeah, that is outdated :)

> So am I correct assuming the following: - these two fixes were applied
> to wireless-drivers because I asked to to queue them to 4.14

Correct.

> - these two fixes will show up in wireless-drivers-next at some point
> in the future after you move wireless-drivers-next forward, rebasing
> it on top of one of the upcoming "-rc"

I would not use the term "rebase" here, as that means rewriting the
history which should be avoided on public trees. What I usually do is to
"merge" (git pull) or "fast forward" (git pull --ff-only).

You are correct that eventually commits from wireless-drivers trickle
down to wireless-drivers-next, I guess usually it takes something like
2-4 weeks. Most of them time they trickle down when Dave merges net to
net-next and I fast forward wireless-drivers-next to latest net-next
(after Dave has pulled from me). But occasionally I also merge
wireless-drivers to wireless-drivers-next myself, for example I did that
last cycle as there were major conflicts on iwlwifi and we wanted to fix
those early on. The earlier the conflicts are resolved the smoother it
is for everyone.

So if you have needs for getting the commits from wireless-drivers to
wireless-drivers-next please let me know and let's see what's the best
way forward.

Did this help?

-- 
Kalle Valo
