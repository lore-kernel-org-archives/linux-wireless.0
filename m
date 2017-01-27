Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55332 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751308AbdA0Uke (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 15:40:34 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: iwlwifi: fix kernel crash when unregistering thermal zone
References: <b6a2209c-1343-cbda-c6c2-ae5eb93148d3@kernel.dk>
        <20170121125917.2E08F609D0@smtp.codeaurora.org>
        <1e6ae9d2-fef7-1ce0-53fc-4948f81ae27d@kernel.dk>
Date: Fri, 27 Jan 2017 21:54:04 +0200
In-Reply-To: <1e6ae9d2-fef7-1ce0-53fc-4948f81ae27d@kernel.dk> (Jens Axboe's
        message of "Fri, 27 Jan 2017 12:48:11 -0700")
Message-ID: <874m0k46ub.fsf@kamboji.qca.qualcomm.com> (sfid-20170127_214042_139634_73A0B97B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jens Axboe <axboe@kernel.dk> writes:

> On 01/21/2017 05:59 AM, Kalle Valo wrote:
>> Jens Axboe <axboe@kernel.dk> wrote:
>>> A recent firmware change seems to have enabled thermal zones on the
>>> iwlwifi driver. Unfortunately, my device fails when registering the
>>> thermal zone. This doesn't stop the driver from attempting to unregister
>>> the thermal zone at unload time, triggering a NULL pointer deference in
>>> strlen() off the thermal_zone_device_unregister() path.
>>>
>>> Don't unregister if name is NULL, for that case we failed registering.
>>> Do the same for the cooling zone.
>>>
>>> Signed-off-by: Jens Axboe <axboe@fb.com>
>> 
>> Patch applied to wireless-drivers.git, thanks.
>> 
>> 92549cdc288f iwlwifi: fix kernel crash when unregistering thermal zone
>
> When is this going out?

Trying to send a pull request to Dave tomorrow.

-- 
Kalle Valo
