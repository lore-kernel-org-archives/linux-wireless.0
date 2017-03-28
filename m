Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36077 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754514AbdC1Oq4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 10:46:56 -0400
Received: by mail-wm0-f51.google.com with SMTP id o81so552264wmb.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Mar 2017 07:46:50 -0700 (PDT)
Subject: Re: [PATCH for-4.11 2/2] cfg80211: check rdev resume callback only
 for registered wiphy
To: Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
References: <1490688691-20100-1-git-send-email-arend.vanspriel@broadcom.com>
 <1490688691-20100-3-git-send-email-arend.vanspriel@broadcom.com>
 <1490704473.18052.1.camel@sipsolutions.net>
 <0ad46312-df78-4d80-8526-1a33e1e86acf@broadcom.com>
 <1490711151.18052.2.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Daniel J Blueman <daniel@quora.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d2985a7e-5d11-284d-25f8-c4a255c24da6@broadcom.com> (sfid-20170328_164753_815473_A7BB14CC)
Date: Tue, 28 Mar 2017 16:46:47 +0200
MIME-Version: 1.0
In-Reply-To: <1490711151.18052.2.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 28-3-2017 16:25, Johannes Berg wrote:
> 
>>>> -	if (rdev->ops->resume) {
>>>> -		rtnl_lock();
>>>> -		if (rdev->wiphy.registered)
>>>> -			ret = rdev_resume(rdev);
>>>> -		rtnl_unlock();
>>>> -	}
>>>> +	rtnl_lock();
>>>> +	if (rdev->wiphy.registered && rdev->ops->resume)
>>>> +		ret = rdev_resume(rdev);
>>>> +	rtnl_unlock();
>>>
>>> Hmm? Commit message seems ... old perhaps?
>>
>> Hmmm, why? Before the patch rdev->ops was accessed before checking
>> rdev->wiphy.registered. When rdev->wiphy.registers is false we no
>> longer access rdev->ops after the patch. So a driver doing a
>> wiphy_unregister() can safely kfree() the callback struct after it.
> 
> Oh, right. Looks like I misinterpreted things.

So apparently my choice of words was poor. Do you want me to rephrase?

Regards,
Arend
