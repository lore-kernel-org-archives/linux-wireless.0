Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42866 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752387AbdJKJGH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 05:06:07 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: Two rtlwifi drivers?
References: <20170824100832.lcmbwcjhzwlgozeh@mwanda>
        <87h8wxw4bq.fsf@kamboji.qca.qualcomm.com>
        <652d42ad-a077-530b-743f-d38ddf3ff677@lwfinger.net>
Date: Wed, 11 Oct 2017 12:06:00 +0300
In-Reply-To: <652d42ad-a077-530b-743f-d38ddf3ff677@lwfinger.net> (Larry
        Finger's message of "Thu, 24 Aug 2017 09:41:24 -0500")
Message-ID: <87k202qcjr.fsf@kamboji.qca.qualcomm.com> (sfid-20171011_110613_177514_A09F768D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Sorry for taking so long with the reply, I wanted first to check what
the rtlwifi in staging contains.)

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 08/24/2017 07:14 AM, Kalle Valo wrote:
>> Dan Carpenter <dan.carpenter@oracle.com> writes:
>>
>>> Smatch is distrustful of the "capab" value and marks it as user
>>> controlled.  I think it actually comes from the firmware?  Anyway, I
>>> looked at other drivers and they added a bounds check and it seems like
>>> a harmless thing to have so I have added it here as well.
>>>
>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>>
>>> diff --git a/drivers/staging/rtlwifi/base.c b/drivers/staging/rtlwifi/base.c
>>> index f7f207cbaee3..a30b928d5ee1 100644
>>> --- a/drivers/staging/rtlwifi/base.c
>>> +++ b/drivers/staging/rtlwifi/base.c
>>
>> I'm getting slightly annoyed that we now apparently have two duplicate
>> rtlwifi drivers (with the same name!) and I'm being spammed by staging
>> patches. Was this really a smart thing to do? And what will be the
>> future of these two drivers?
>>
>> (Of course this is not directed to Dan, he is just fixing bugs found by
>> smatch, but more like a general question.)
>
> That was the decision that you and Greg made. The version in
> wireless-drivers needs many patches to handle the new device. The
> progress in applying these to wireless-drivers was very slow for many
> reasons. Keeping a single version of that code would have required
> coordination between you and Greg, which was discouraged.

I don't recall deciding anything, all I did was asking for more info
about the new code. I was against the idea since I first saw your mail
but I tried to be diplomatic and not shot it down immeadiately. Shows
that diplomacy is not really my thing...

We always take extra measures to avoid forking code, why is it now all
of sudden ok? Also this gives the wrong message to Realtek, and other
vendors, that they can just fork the driver and push all sort of crap to
staging.

So just to make clear to everyone: I think forking drivers like this is
a HORRIBLE idea and I do not want to have anything to do with that. If
schedule goes over quality then a much better approach is to move to the
whole driver to staging than to have duplicated drivers like we have
now.

> The future, as stated in the TODO in staging, is to merge all the
> changes in the support drivers into wireless-drivers, and then move
> the new RTL8822BE driver out of staging.

And how many years will that take? (If that will ever happen) Also I see
that multiple patches are applied to staging version of rtlwifi which is
not in net version of rtlwifi. That all should be synced somehow, the
bigger the delta becomes the more difficult everything is.

> I'm sorry about the fallout affecting you, and I probably should have
> changed the directory names. In any case, ignore any patches that
> belong in staging. If I see any that do not include GregKH in the "To"
> list, I will NACK them and request proper routing.

Thanks, but that doesn't really help as I apply patches from patchwork
and it doesn't show the To field. I'll try to be extra careful and not
apply patches the staging version of rtlwifi patches, but mistakes
always happen.

-- 
Kalle Valo
