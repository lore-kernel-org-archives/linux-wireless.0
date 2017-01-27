Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:35800 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750790AbdA0UER (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 15:04:17 -0500
Received: by mail-pg0-f44.google.com with SMTP id 194so83619048pgd.2
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jan 2017 12:03:22 -0800 (PST)
Subject: Re: iwlwifi: fix kernel crash when unregistering thermal zone
To: Kalle Valo <kvalo@codeaurora.org>
References: <b6a2209c-1343-cbda-c6c2-ae5eb93148d3@kernel.dk>
 <20170121125917.2E08F609D0@smtp.codeaurora.org>
 <1e6ae9d2-fef7-1ce0-53fc-4948f81ae27d@kernel.dk>
 <874m0k46ub.fsf@kamboji.qca.qualcomm.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <9ebce69c-7b70-d124-63ad-b78c171c285f@kernel.dk> (sfid-20170127_212406_912285_37235F9E)
Date: Fri, 27 Jan 2017 12:55:10 -0700
MIME-Version: 1.0
In-Reply-To: <874m0k46ub.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/27/2017 12:54 PM, Kalle Valo wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 01/21/2017 05:59 AM, Kalle Valo wrote:
>>> Jens Axboe <axboe@kernel.dk> wrote:
>>>> A recent firmware change seems to have enabled thermal zones on the
>>>> iwlwifi driver. Unfortunately, my device fails when registering the
>>>> thermal zone. This doesn't stop the driver from attempting to unregister
>>>> the thermal zone at unload time, triggering a NULL pointer deference in
>>>> strlen() off the thermal_zone_device_unregister() path.
>>>>
>>>> Don't unregister if name is NULL, for that case we failed registering.
>>>> Do the same for the cooling zone.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@fb.com>
>>>
>>> Patch applied to wireless-drivers.git, thanks.
>>>
>>> 92549cdc288f iwlwifi: fix kernel crash when unregistering thermal zone
>>
>> When is this going out?
> 
> Trying to send a pull request to Dave tomorrow.

Great, thanks!

-- 
Jens Axboe
