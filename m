Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47404 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324AbcFBSCt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 14:02:49 -0400
Subject: Re: Bug 119151 - [regression] ath10k no longer authenitcates and
 freezes system
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
References: <8760trzoiw.fsf@kamboji.qca.qualcomm.com>
 <871t4fzn1x.fsf@kamboji.qca.qualcomm.com> <57504F05.3040200@candelatech.com>
 <1464887026467.72937@qti.qualcomm.com> <57506BA1.2090303@candelatech.com>
 <6c6f208f9abc81cb262d763f6f6d684d@codeaurora.org>
Cc: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
	linux-wireless@vger.kernel.org, mike@fireburn.co.uk
From: Ben Greear <greearb@candelatech.com>
Message-ID: <575074C7.50009@candelatech.com> (sfid-20160602_200253_912916_7F3C930A)
Date: Thu, 2 Jun 2016 11:02:47 -0700
MIME-Version: 1.0
In-Reply-To: <6c6f208f9abc81cb262d763f6f6d684d@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/02/2016 10:41 AM, Rajkumar Manoharan wrote:
> On 2016-06-02 22:53, Ben Greear wrote:
>> On 06/02/2016 10:03 AM, Manoharan, Rajkumar wrote:
>>> On Thursday, June 2, 2016 8:51 PM, Ben Greear <greearb@candelatech.com> wrote:
>>>> On 06/02/2016 07:24 AM, Valo, Kalle wrote:
>>>>> Kalle Valo <kvalo@qca.qualcomm.com> writes:
>>>>>
>>>>>> there's a regression in ath10k:
>>>>>>
>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=119151
>>>>>>
>>>>>> Reporter bisected it to this:
>>>>>>
>>>>>> 5c86d97bcc1d42ce7f75685a61be4dad34ee8183 is the first bad commit
>>>>>> commit 5c86d97bcc1d42ce7f75685a61be4dad34ee8183
>>>>>> Author: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
>>>>>> Date:   Tue Mar 22 17:22:19 2016 +0530
>>>>>>
>>>>>> ath10k: combine txrx and replenish task
>>>>>>
> [...]
>
>>>> I found a lot of problems with this code as well, and the 5 patches
>>>> starting from the URL below fixed the issues for me.
>>>>
>>> Ben,
>>>
>>> Can you please explain the sort of issues you have observed with this change?
>>
>> I imported a bunch of upstream patches at once, so not sure exactly what commit
>> caused it.  And, this was about 2 months ago...  Upon review, I'm not
>> sure I even have
>> the patch this particular bug was bisected to, so maybe that is some
>> other issue.
>>
> Please keep track of buggy commit and report them asap.

I posted to the list at the time.  When I was debugging this, there
were so many conflicting issues that it was hard to find a single
regression point.

>> But, the problems I saw were deadlocks and memory corruption.  A lot of it was
>> because I was debugging new firmware at the time and so peer creation
>> was failing
>> sometimes, and things like that.  The error handling in ath10k for this was
>> faulty and racy and such.  We have not seen any performance regressions,
>> but we mostly run on very powerful CPUs.
>>
>> Please take a look at those 5 patches.  A good review would be much appreciated,
>> and by reading them you will better be able to see the problems I was hitting
>> and trying to fix.
>>
> Below two patches are critical and I already shared my feedback.
>
> https://patchwork.kernel.org/patch/8727841/
> https://patchwork.kernel.org/patch/9073471/
>
> Others are LGTM.

Not sure what LGTM means.

This one fixes memory corruption:
http://dmz2.candelatech.com/?p=linux-4.4.dev.y/.git;a=blobdiff;f=drivers/net/wireless/ath/ath10k/htt_tx.c;h=58e88d392fb56a65304db17d11a9eaf0b0397dc7;hp=07b960e9704f509b3dddf1e45730e76a4c39e51e;hb=fddb6661a0f5772853fbb9feb7232f325d5f74c5;hpb=ed1757f8345064181664e4a62e2b917e694a665e

This one fixes use-after-free memory bugs:
http://dmz2.candelatech.com/?p=linux-4.4.dev.y/.git;a=blobdiff;f=drivers/net/wireless/ath/ath10k/mac.c;h=5e5cc9c6c1d82524b9b77a7c6d2c1341c5268732;hp=8783119b9ba84e0ddb292d521e6513bf7d68a40b;hb=5ae13cea64004afc673ecc22cd70ac51179168c6;hpb=fddb6661a0f5772853fbb9feb7232f325d5f74c5

As does this one:
http://dmz2.candelatech.com/?p=linux-4.4.dev.y/.git;a=blobdiff;f=drivers/net/wireless/ath/ath10k/mac.c;h=020dd25752224d9786da37a6dfd10a69e646b138;hp=5e5cc9c6c1d82524b9b77a7c6d2c1341c5268732;hb=c4b9566416a5e7b8d4c446d1bad34aabcbeff9f5;hpb=9bd9c11c1a2e61261c268ac2b6d791d4f6b6fe26

>
>> In case you want to look at the full context of those patches, you can find
>> them here (around 24 patches down from the top...)
>>
> Quite a big list :)
>
>> http://dmz2.candelatech.com/?p=linux-4.4.dev.y/.git;a=summary
>>
>> For now, I am sticking with 4.4 + what I pulled in, but will rebase
>> against upstream someday
>> soon-ish and then we can start testing it all over again :)
>>
> Will go through the list. Better to post them to public if not.

Many of these patches are related to features only in my firmware.  The ~20
patch patch-bomb was a start at adding some of the hopefully less controversial
support.  If I can ever get that upstream, then I will pick off another
set of patches and try to get them ready for upstream.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

