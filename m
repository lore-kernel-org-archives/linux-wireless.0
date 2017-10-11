Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:53746 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752561AbdJKOUB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 10:20:01 -0400
Subject: Re: Two rtlwifi drivers?
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20170824100832.lcmbwcjhzwlgozeh@mwanda>
 <87h8wxw4bq.fsf@kamboji.qca.qualcomm.com>
 <652d42ad-a077-530b-743f-d38ddf3ff677@lwfinger.net>
 <87k202qcjr.fsf@kamboji.qca.qualcomm.com> <20171011131310.GF32250@kroah.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <18efa551-f8fe-6bd2-71b9-69c867467db3@lwfinger.net> (sfid-20171011_162102_715723_82DDCA51)
Date: Wed, 11 Oct 2017 09:19:57 -0500
MIME-Version: 1.0
In-Reply-To: <20171011131310.GF32250@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2017 08:13 AM, Greg Kroah-Hartman wrote:
> On Wed, Oct 11, 2017 at 12:06:00PM +0300, Kalle Valo wrote:
>> (Sorry for taking so long with the reply, I wanted first to check what
>> the rtlwifi in staging contains.)
>>
>> Larry Finger <Larry.Finger@lwfinger.net> writes:
>>
>>> On 08/24/2017 07:14 AM, Kalle Valo wrote:
>>>> Dan Carpenter <dan.carpenter@oracle.com> writes:
>>>>
>>>>> Smatch is distrustful of the "capab" value and marks it as user
>>>>> controlled.  I think it actually comes from the firmware?  Anyway, I
>>>>> looked at other drivers and they added a bounds check and it seems like
>>>>> a harmless thing to have so I have added it here as well.
>>>>>
>>>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>>>>
>>>>> diff --git a/drivers/staging/rtlwifi/base.c b/drivers/staging/rtlwifi/base.c
>>>>> index f7f207cbaee3..a30b928d5ee1 100644
>>>>> --- a/drivers/staging/rtlwifi/base.c
>>>>> +++ b/drivers/staging/rtlwifi/base.c
>>>>
>>>> I'm getting slightly annoyed that we now apparently have two duplicate
>>>> rtlwifi drivers (with the same name!) and I'm being spammed by staging
>>>> patches. Was this really a smart thing to do? And what will be the
>>>> future of these two drivers?
>>>>
>>>> (Of course this is not directed to Dan, he is just fixing bugs found by
>>>> smatch, but more like a general question.)
>>>
>>> That was the decision that you and Greg made. The version in
>>> wireless-drivers needs many patches to handle the new device. The
>>> progress in applying these to wireless-drivers was very slow for many
>>> reasons. Keeping a single version of that code would have required
>>> coordination between you and Greg, which was discouraged.
>>
>> I don't recall deciding anything, all I did was asking for more info
>> about the new code. I was against the idea since I first saw your mail
>> but I tried to be diplomatic and not shot it down immeadiately. Shows
>> that diplomacy is not really my thing...
>>
>> We always take extra measures to avoid forking code, why is it now all
>> of sudden ok? Also this gives the wrong message to Realtek, and other
>> vendors, that they can just fork the driver and push all sort of crap to
>> staging.
>>
>> So just to make clear to everyone: I think forking drivers like this is
>> a HORRIBLE idea and I do not want to have anything to do with that. If
>> schedule goes over quality then a much better approach is to move to the
>> whole driver to staging than to have duplicated drivers like we have
>> now.
> 
> I think it's horrid too.  But, if no one is able to do the real work
> here, we hurt users who just need to use their hardware to get things
> done.
> 
> And it seems like the company isn't willing to do the real work, so
> dumping this in staging is the best we can do at the moment.
> 
> However, if this causes you problems, that's not good at all either.
> Getting "real" support for this hardware is key, and hopefully can
> happen somehow.  But fixing up the staging driver is almost never the
> way to do it, as you know :)
> 
> So what to do?  Any ideas?  What makes your life easier?  You can just
> ignore the staging tree, as it should not affect your portion of the
> kernel at all, right?

Greg and Kalle,

We can all agree that this situation is bad; however, several of the points made 
in your E-mails need to be addressed.

First of all, I am not an employee of Realtek, and I have no knowledge of the 
internals of any of their chips. I have never signed a non-disclosure agreement, 
and the only thing that I have received from them are sample chips for testing. 
My main interest is in helping the user experience. As there are a number of 
users with the new RTL8822BE device, that meant getting an in-kernel driver to 
them as soon as possible. As stated earlier, adding this particular device to 
the rtlwifi family involved roughly 120K lines of new code. Given our recent 
experience in getting code accepted into the wireless tree meant that this 
additional code would not have been accepted for many months. For that reason, 
we chose the staging route. It is important that we get this right as Realtek 
tells me that there will be two additional new drivers in the coming 6 months.

As to the convergence of the rtlwifi code between staging and wireless, I 
applied the 40 or 50 patches in my queue to the wireless version to create the 
version that went into staging. If any of the current patches to wireless do not 
seem to be in the staging version, sometimes temporary changes are necessary so 
that the intermediate drivers will build and work. Yes, it is code churn, but 
necessary to keep patches small. In keeping with Kalle's requests, only a 
fraction of those patches have been submitted to him.

My intent is to have the RTL8822BE driver moved from staging to mainline no 
later than 4.17. The affected drivers rtl_pci, rtlwifi and becoex will be moved 
in that order. Of course, the required changes will need to be in wireless 
before staging is changed, which will slow the process. As I see it, the switch 
can only occur with a new version.

My opinion is that the company has gone a long ways toward meeting the 
requirements of the Linux kernel. A lot of their code is written for Windows and 
Linux, with emphasis on Windows, which complicates matters as not all of the 
changes for Linux can be backported. Prior to the introduction of these drivers 
in 2.6.38, drivers were released periodically as tar files with no information 
regarding intermediate steps were recorded other than the SVN modification 
number. At least now, we get relatively small changes.

I have been pleased and surprised at the stability and performance of the driver 
in staging. Other than possible changes required by reviewers when it is moved, 
it is ready for the wireless tree.

Finally, I have notified my Realtek contact that I do not plan to continue as 
the maintainer of these drivers very much longer due to my age. I still have the 
interest, but not always the energy. The people at Realtek have proposed a plan 
that seems workable. Of course, there will be hiccups, but the current process 
does not seem to be that smooth.

Larry
