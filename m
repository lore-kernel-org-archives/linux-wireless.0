Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33156 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750717AbdAULWK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 21 Jan 2017 06:22:10 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: "Coelho\, Luciano" <luciano.coelho@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Berg\, Johannes" <johannes.berg@intel.com>,
        "axboe\@kernel.dk" <axboe@kernel.dk>
Subject: Re: iwlwifi: fix kernel crash when unregistering thermal zone
References: <1484996068.2774.23.camel@intel.com>
Date: Sat, 21 Jan 2017 13:22:04 +0200
In-Reply-To: <1484996068.2774.23.camel@intel.com> (Luciano Coelho's message of
        "Sat, 21 Jan 2017 10:54:30 +0000")
Message-ID: <87wpdolktf.fsf@kamboji.qca.qualcomm.com> (sfid-20170121_122240_108472_F0125994)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Coelho, Luciano" <luciano.coelho@intel.com> writes:

> On Jan 21, 2017 09:56, Kalle Valo <kvalo@codeaurora.org> wrote:
> Jens Axboe <axboe@kernel.dk> writes: 
>> > A recent firmware change seems to have enabled thermal zones on the 
>> > iwlwifi driver. Unfortunately, my device fails when registering the 
>> > thermal zone. This doesn't stop the driver from attempting to unregister 
>> > the thermal zone at unload time, triggering a NULL pointer deference in 
>> > strlen() off the thermal_zone_device_unregister() path. 
>> > 
>> > Don't unregister if name is NULL, for that case we failed registering. 
>> > Do the same for the cooling zone. 
>> > 
>> > Signed-off-by: Jens Axboe <axboe@fb.com> 
>> > 
>> > --- 
>> > 
>> > Would be great if this could go into the current series, as sometimes I 
>> > have to reload the driver. Right now I can't, since it crashes... 
>> 
>> Luca, can I take this directly to wireless-drivers? This is an important 
>> fix and we should get it to Linus' tree ASAP.
>
> Yes, please go ahead and take it directly.
>
> Acked-by: Luca Coelho <luciano.coelho@intel.com>

Thanks, I'll apply it soon.

-- 
Kalle Valo
