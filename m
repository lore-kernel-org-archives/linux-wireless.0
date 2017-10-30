Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48808 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751469AbdJ3Kbe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 06:31:34 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Subject: Re: [1/5] qtnfmac: modify full Tx queue error reporting
References: <20171015205327.9966-2-sergey.matyukevich.os@quantenna.com>
        <20171027084814.B3FCB60314@smtp.codeaurora.org>
        <20171029153211.4ynfo6wrh7q76efd@bars>
        <87a8093vy7.fsf@kamboji.qca.qualcomm.com>
        <20171030094459.kj6nnrrc52wj2bsp@bars>
Date: Mon, 30 Oct 2017 12:31:29 +0200
In-Reply-To: <20171030094459.kj6nnrrc52wj2bsp@bars> (Sergey Matyukevich's
        message of "Mon, 30 Oct 2017 12:45:00 +0300")
Message-ID: <87k1zd2agu.fsf@kamboji.qca.qualcomm.com> (sfid-20171030_113137_834899_20417118)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

>> > My assumption is that by default all the patches should cleanly apply
>> > to wireless-drivers-next. I could apply the patch in question to
>> > wireless-drivers-next without any issues.
>> 
>> Odd. How did you apply it? My script uses 'git am -s -3' individually
>> for each patch in the series, but to my knowledge that shouldn't cause
>> any problems.
>
> It turns out I mechanically rebased my branch on top of w-d-n before writing
> the previous email. Now I could reproduce the same failure when using this
> command for the original patches downloaded from patchwork.

Ok, that makes sense. Most likely when git-rebase does a 3-way merge
automatically and that's why you were able to successfully apply them.
But as git-am was not able to use 3-way merge due to incorrect sha1
information it failed.

> The problem was in conflict with qtnfmac fixes pulled to w-d-n from
> w-d.

Ok, thanks for investigating the root cause.

-- 
Kalle Valo
