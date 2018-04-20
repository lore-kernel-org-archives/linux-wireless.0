Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51856 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754591AbeDTMBb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 08:01:31 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: <pkshih@realtek.com>
Cc: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH v2] rtlwifi: cleanup 8723be ant_sel definition
References: <20180420023009.3182-1-pkshih@realtek.com>
Date: Fri, 20 Apr 2018 15:01:22 +0300
In-Reply-To: <20180420023009.3182-1-pkshih@realtek.com> (pkshih@realtek.com's
        message of "Fri, 20 Apr 2018 10:30:09 +0800")
Message-ID: <87zi1ygk8d.fsf@kamboji.qca.qualcomm.com> (sfid-20180420_140134_562229_27C94695)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<pkshih@realtek.com> writes:

> From: Ping-Ke Shih <pkshih@realtek.com>
>
> The module parameter ant_sel is used to control antenna number and path.
> There is an existing enum ANT_{X2,X1} defined the antenna number, so
> add a new enum ANT_{MAIN,AUX} to make it readable. After this work,
> incorrect given values depend on ant_sel were exposed, so refill values
> according following definition:
>   ant_sel   ant_num   ant_path  print_label
>      1      ANT_X1    ANT_AUX        #2
>      2      ANT_X2    ANT_MAIN       #1
> Then, a workaround resulted from the incorrect values in halbtcoutsrc.c was
> removed. These is a existing bug in the workaround while ant_sel=2, but the
> case is rare use so user is hard to observe this bug.
>
> The experimental results with single antenna connected to specific path
> are in following:
>   ant_sel  ANT_MAIN(#1)  ANT_AUX(#2)
>      0        -8            -62
>      1        -62           -10
>      2        -6            -60
>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Stable <stable@vger.kernel.org> # 4.7+
> Reviewed-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> v2: Add more description about fixed bugs in end of first paragraph.

Sorry, I still don't understand the bug you are fixing. It shouldn't
take more than one minute to understand a commit log.

I prose that you rewrite the commit log, or at least parts of if it.
When you are describing a bug don't talk about enums or source files,
that's an implementation detail, and instead talk how the bug looks like
from users point of view. For example:

  "On HP laptop model 1234 with Realtex 4321 device users are supposed
   to use ant_sel module parameter with value 77 to use the correct
   antenna. But instead rtlwifi incorrectly chose antenna 88 with lower
   transmit power and that caused packet loss. Fix it so that the user
   gets better transmit power and..."

(that's of course all made up information as I don't know what the
actual bug is)

And after that you can write rtlwifi internals in the commit log as much
as you want :) But there needs to be a clear generic description of the
bug first and it needs to understandable in one read.

To make this faster I propose that you send the new commit log as a
reply to this mail and I can then comment faster.

-- 
Kalle Valo
