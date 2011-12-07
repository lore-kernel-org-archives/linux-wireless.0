Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37397 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab1LGVJo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 16:09:44 -0500
Received: by yenm11 with SMTP id m11so466303yen.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2011 13:09:44 -0800 (PST)
Message-ID: <4EDFD614.4050400@lwfinger.net> (sfid-20111207_220948_324206_5530DE41)
Date: Wed, 07 Dec 2011 15:09:40 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Philipp Dreimann <philipp@dreimann.net>
CC: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
	mikem@ring3k.org, John Linville <linville@tuxdriver.com>
Subject: Re: rtlwifi, rtl8192se bug soft-lockup
References: <CADYPuQ7W2B9HjR_TiV=dhD3vW-3pR4Y+s_9oJzTC-CdL+hr=9w@mail.gmail.com> <4ED44089.7010102@lwfinger.net> <CADYPuQ61D997MA2JCw1WD_xOosaKvaWK-_RHeBkLtabydDj2iw@mail.gmail.com> <4EDFA124.7010804@lwfinger.net> <CADYPuQ5io_nKkzqwY3uM5bre-bfUvrmH080MBpwqYpNeot5yHA@mail.gmail.com>
In-Reply-To: <CADYPuQ5io_nKkzqwY3uM5bre-bfUvrmH080MBpwqYpNeot5yHA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/07/2011 02:47 PM, Philipp Dreimann wrote:
> On 7 December 2011 15:23, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>> On 12/07/2011 07:59 AM, Philipp Dreimann wrote:
>>>
>>> On 29 November 2011 00:16, Larry Finger<Larry.Finger@lwfinger.net>    wrote:
>>>>
>>>> On 11/28/2011 06:58 PM, Philipp Dreimann wrote:
>>>>   From a quick look, Stanislaw's patch should fix your system. If not,
>>>> then
>>>> please consider pulling a git tree and checking out commit 34ddb20, which
>>>> is
>>>> the one before 67fc6052.
>>>
>>>
>>> It fixed the issue *but* I am currently back to kernel v3.0.3, as it
>>> is the most stable for me. I am not sure whether new issues were
>>> introduced by using a v3.2-rc or if there is more wrong in the
>>> rtl8192se driver itself. I had random sound and standby issues at
>>> which I will have a look some other day.
>>
>>
>> The bug that affected 3.2-rcX and fixed by Stanislaw's patch was not
>> introduced until 3.1. A patch to fix it there was just queued by GregKH.
>
> I had Stanislaw's patch included.
>
>>> Another idea about the problem:
>>> I omitted for some reason the following line in the first email about
>>> the problem:
>>> [  732.056049] BUG: soft lockup - CPU#0 stuck for 22s! [kworker/0:3:2112]
>>
>>
>> That was a serious omission.
>
> Yes.
>
>>> While looking at the Call Trace and the code I have no idea why
>>> rtl92s_phy_set_rf_power_state needs that much time for the ERFSLEEP
>>> operation. I suspected an issue in the loop but did not find it so
>>> far.
>>
>>
>> With a modern CPU, no loop can take 22s unless it involves a spin lock that
>> never is released.
>
> Yes, and it should not, as the loop has the lock!
>
> Putting things together:
>
> - Stanislaw's patch prevents the occurrence of the issue with using
> the irq safe spin lock.
>    This is kind of an an revert of
> 312d5479dcfaca2b8aa451201b5388fdb8c8684a (I did not check
> everything!).
>
> - The loop-issue is still around but won't be noticed unless the
> delayed execution of rtl_lps_leave() has side-effects..
>
> - As it took up to an hour  to hit the issue, I suspect that there is
> something else going wrong which interferes with the loop...

I ran for almost 36 hours and never hit the issue. I have no idea what the 
difference is between our two systems. In fact, I have never hit the "stalled" 
CPU issue, even with the bug that Stanislaw fixed. You will need to do the testing.

Larry
