Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40306 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbdJ3ICM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 04:02:12 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Subject: Re: [1/5] qtnfmac: modify full Tx queue error reporting
References: <20171015205327.9966-2-sergey.matyukevich.os@quantenna.com>
        <20171027084814.B3FCB60314@smtp.codeaurora.org>
        <20171029153211.4ynfo6wrh7q76efd@bars>
Date: Mon, 30 Oct 2017 10:02:08 +0200
In-Reply-To: <20171029153211.4ynfo6wrh7q76efd@bars> (Sergey Matyukevich's
        message of "Sun, 29 Oct 2017 18:32:12 +0300")
Message-ID: <87a8093vy7.fsf@kamboji.qca.qualcomm.com> (sfid-20171030_090218_213459_7B68F521)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> Hello Kalle,
>
>> Failed to apply:
>> 
>> fatal: sha1 information is lacking or useless
>> (drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c).
>> error: could not build fake ancestor
>> Applying: qtnfmac: modify full Tx queue recovery
>> Patch failed at 0001 qtnfmac: modify full Tx queue recovery
>> The copy of the patch that failed is found in: .git/rebase-apply/patch
>> 
>> 5 patches set to Changes Requested.
>> 
>> 10007281 [1/5] qtnfmac: modify full Tx queue error reporting
>> 10007279 [2/5] qtnfmac: enable registration of more mgmt frames
>> 10007283 [3/5] qtnfmac: drop nonexistent function declaration
>> 10007285 [4/5] qtnfmac: modify full Tx queue recovery
>> 10007287 [5/5] qtnfmac: advertise support of inactivity timeout
>
> My assumption is that by default all the patches should cleanly apply
> to wireless-drivers-next. I could apply the patch in question to
> wireless-drivers-next without any issues.

Odd. How did you apply it? My script uses 'git am -s -3' individually
for each patch in the series, but to my knowledge that shouldn't cause
any problems.

> Rebase of the whole series on top of wireless-drivers-next looks good
> as well. I will resend rebased patches as v2.

Thanks, sending v2 is the easiest for me. If there are problems again
I'll investigate in detail what's going on.

> Meanwhile do you have any idea what could go wrong ? The error message
> looks scary...

You mean the "sha1 information is lacking", right? It means that git was
not able to find a common ancestor for the file which it could use to
create the 3-way merge. Usually that happens when people have
out-of-tree patches on the branch they are submitting from.

And that's why I recommend to use the w-d-next master branch as the
baseline when submitting patches, and not have any other custom patches
applied on the branch. This should keep sha1 information correct and
make it possible for git to use 3-way merge.

-- 
Kalle Valo
