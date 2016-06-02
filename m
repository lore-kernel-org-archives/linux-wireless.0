Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44540 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbcFBRmA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 13:42:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 02 Jun 2016 23:11:57 +0530
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: Ben Greear <greearb@candelatech.com>
Cc: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
	linux-wireless@vger.kernel.org, mike@fireburn.co.uk
Subject: Re: Bug 119151 - [regression] ath10k no longer authenitcates and
 freezes system
In-Reply-To: <57506BA1.2090303@candelatech.com>
References: <8760trzoiw.fsf@kamboji.qca.qualcomm.com>
 <871t4fzn1x.fsf@kamboji.qca.qualcomm.com> <57504F05.3040200@candelatech.com>
 <1464887026467.72937@qti.qualcomm.com> <57506BA1.2090303@candelatech.com>
Message-ID: <6c6f208f9abc81cb262d763f6f6d684d@codeaurora.org> (sfid-20160602_194205_393681_03C49D9F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-06-02 22:53, Ben Greear wrote:
> On 06/02/2016 10:03 AM, Manoharan, Rajkumar wrote:
>> On Thursday, June 2, 2016 8:51 PM, Ben Greear 
>> <greearb@candelatech.com> wrote:
>>> On 06/02/2016 07:24 AM, Valo, Kalle wrote:
>>>> Kalle Valo <kvalo@qca.qualcomm.com> writes:
>>>> 
>>>>> there's a regression in ath10k:
>>>>> 
>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=119151
>>>>> 
>>>>> Reporter bisected it to this:
>>>>> 
>>>>> 5c86d97bcc1d42ce7f75685a61be4dad34ee8183 is the first bad commit
>>>>> commit 5c86d97bcc1d42ce7f75685a61be4dad34ee8183
>>>>> Author: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
>>>>> Date:   Tue Mar 22 17:22:19 2016 +0530
>>>>> 
>>>>> ath10k: combine txrx and replenish task
>>>>> 
[...]

>>> I found a lot of problems with this code as well, and the 5 patches
>>> starting from the URL below fixed the issues for me.
>>> 
>> Ben,
>> 
>> Can you please explain the sort of issues you have observed with this 
>> change?
> 
> I imported a bunch of upstream patches at once, so not sure exactly 
> what commit
> caused it.  And, this was about 2 months ago...  Upon review, I'm not
> sure I even have
> the patch this particular bug was bisected to, so maybe that is some
> other issue.
> 
Please keep track of buggy commit and report them asap.

> But, the problems I saw were deadlocks and memory corruption.  A lot of 
> it was
> because I was debugging new firmware at the time and so peer creation
> was failing
> sometimes, and things like that.  The error handling in ath10k for this 
> was
> faulty and racy and such.  We have not seen any performance 
> regressions,
> but we mostly run on very powerful CPUs.
> 
> Please take a look at those 5 patches.  A good review would be much 
> appreciated,
> and by reading them you will better be able to see the problems I was 
> hitting
> and trying to fix.
> 
Below two patches are critical and I already shared my feedback.

https://patchwork.kernel.org/patch/8727841/
https://patchwork.kernel.org/patch/9073471/

Others are LGTM.

> In case you want to look at the full context of those patches, you can 
> find
> them here (around 24 patches down from the top...)
> 
Quite a big list :)

> http://dmz2.candelatech.com/?p=linux-4.4.dev.y/.git;a=summary
> 
> For now, I am sticking with 4.4 + what I pulled in, but will rebase
> against upstream someday
> soon-ish and then we can start testing it all over again :)
> 
Will go through the list. Better to post them to public if not.

-Rajkumar
