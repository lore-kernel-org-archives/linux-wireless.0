Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52480 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754943AbeDWNrr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 09:47:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: pkshih@realtek.com, linux-wireless@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] rtlwifi: cleanup 8723be ant_sel definition
References: <20180420023009.3182-1-pkshih@realtek.com>
        <87zi1ygk8d.fsf@kamboji.qca.qualcomm.com>
        <db66387b-9271-2563-ae77-449716795150@lwfinger.net>
Date: Mon, 23 Apr 2018 16:47:42 +0300
In-Reply-To: <db66387b-9271-2563-ae77-449716795150@lwfinger.net> (Larry
        Finger's message of "Fri, 20 Apr 2018 15:56:26 -0500")
Message-ID: <87o9iadog1.fsf@kamboji.qca.qualcomm.com> (sfid-20180423_154755_774668_DFCD4D8A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 04/20/2018 07:01 AM, Kalle Valo wrote:
>> <pkshih@realtek.com> writes:
>>
>>> From: Ping-Ke Shih <pkshih@realtek.com>
>>>
>>> The module parameter ant_sel is used to control antenna number and path.
>>> There is an existing enum ANT_{X2,X1} defined the antenna number, so
>>> add a new enum ANT_{MAIN,AUX} to make it readable. After this work,
>>> incorrect given values depend on ant_sel were exposed, so refill values
>>> according following definition:
>>>    ant_sel   ant_num   ant_path  print_label
>>>       1      ANT_X1    ANT_AUX        #2
>>>       2      ANT_X2    ANT_MAIN       #1
>>> Then, a workaround resulted from the incorrect values in halbtcoutsrc.c was
>>> removed. These is a existing bug in the workaround while ant_sel=2, but the
>>> case is rare use so user is hard to observe this bug.
>>>
>>> The experimental results with single antenna connected to specific path
>>> are in following:
>>>    ant_sel  ANT_MAIN(#1)  ANT_AUX(#2)
>>>       0        -8            -62
>>>       1        -62           -10
>>>       2        -6            -60
>>>
>>> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
>>> Cc: Stable <stable@vger.kernel.org> # 4.7+
>>> Reviewed-by: Larry Finger <Larry.Finger@lwfinger.net>
>>> ---
>>> v2: Add more description about fixed bugs in end of first paragraph.
>>
>> Sorry, I still don't understand the bug you are fixing. It shouldn't
>> take more than one minute to understand a commit log.
>>
>> I prose that you rewrite the commit log, or at least parts of if it.
>> When you are describing a bug don't talk about enums or source files,
>> that's an implementation detail, and instead talk how the bug looks like
>> from users point of view. For example:
>>
>>    "On HP laptop model 1234 with Realtex 4321 device users are supposed
>>     to use ant_sel module parameter with value 77 to use the correct
>>     antenna. But instead rtlwifi incorrectly chose antenna 88 with lower
>>     transmit power and that caused packet loss. Fix it so that the user
>>     gets better transmit power and..."
>>
>> (that's of course all made up information as I don't know what the
>> actual bug is)
>>
>> And after that you can write rtlwifi internals in the commit log as much
>> as you want :) But there needs to be a clear generic description of the
>> bug first and it needs to understandable in one read.
>>
>> To make this faster I propose that you send the new commit log as a
>> reply to this mail and I can then comment faster.
>
> Kalle,
>
> As I have some responsibility in creating this mess, let me try to
> write a new commit log. I hope this answers your questions.
>
> Thanks,
>
> Larry
>
> ====================================
>
> Some HP laptops have only a single wifi antenna. This would not be a
> problem except that they were shipped with an incorrectly encoded
> EFUSE. It should have been possible to open the computer and transfer
> the antenna connection to the other terminal except that such action
> might void the warranty, and moving the antenna broke the Windows
> driver. The fix was to add a module option that would override the
> EFUSE encoding. That was done with commit c18d8f509571 ("rtlwifi:
> rtl8723be: Add antenna select module parameter"). There was still a
> problem with Bluetooth coexistence, which was addressed with commit
> baa170229095 ("rtlwifi: btcoexist: Implement antenna selection").
> There were still problems, thus there were commit 0ff78adeef11
> ("rtlwifi: rtl8723be: fix ant_sel code") and commit 6d6226928369
> ("rtlwifi: btcoexist: Fix antenna selection code"). Despite all these
> attempts at fixing the problem, the code is not yet right. A proper
> fix is important as there are now instances of laptops having
> RTL8723DE chips with the same problem.

This looks better, thanks.

> The module parameter ant_sel is used to control antenna number and path.
> At present enum ANT_{X2,X1} is used to define the antenna number, but
> this choice is not intuitive, thus change to a new enum ANT_{MAIN,AUX}
> to make it more readable. This change showed examples where incorrect
> values were used. It was also possible to remove a workaround in
> halbtcoutsrc.c.
>
> The experimental results with single antenna connected to specific path
> are now as follows:
>   ant_sel  ANT_MAIN(#1)  ANT_AUX(#2)
>      0        -8            -62
>      1        -62           -10
>      2        -6            -60

But after reading this I'm still not sure if users are supposed to do
anything. I guess they will continue using existing values with the
ant_sel module parameter and nothing changes in that regard?

-- 
Kalle Valo
