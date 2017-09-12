Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:38641 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751054AbdILQfn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Sep 2017 12:35:43 -0400
Received: by mail-it0-f48.google.com with SMTP id c195so30792610itb.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 Sep 2017 09:35:43 -0700 (PDT)
Subject: Re: iwlwifi firmware load broken in current -git
To: "Coelho, Luciano" <luciano.coelho@intel.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>
Cc: linuxwifi <linuxwifi@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <04c9b578-693c-1dc6-9f0f-904580231b21@kernel.dk>
 <1505232673.5400.243.camel@intel.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d8c38f27-cdc3-bc91-8900-907744cd1ebf@kernel.dk> (sfid-20170912_183547_026569_83FA9A87)
Date: Tue, 12 Sep 2017 10:35:33 -0600
MIME-Version: 1.0
In-Reply-To: <1505232673.5400.243.camel@intel.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/12/2017 10:11 AM, Coelho, Luciano wrote:
> Hi Jens,
> 
> On Tue, 2017-09-12 at 09:48 -0600, Jens Axboe wrote:
>> Hi,
>>
>> I have no wifi in current git (8fac2f96ab8), it simply fails with:
>>
>> [    4.363481] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-34.ucode failed with error -2
>> [    4.363733] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-33.ucode failed with error -2
>> [    4.363744] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-32.ucode failed with error -2
>> [    4.368077] iwlwifi 0000:04:00.0: loaded firmware version 31.532993.0 op_mode iwlmvm
>> [    4.461753] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless AC 8260, REV=0x208
>> [ ... ]
>> [    9.510570] iwlwifi 0000:04:00.0: Failed to load firmware chunk!             
>> [    9.513903] iwlwifi 0000:04:00.0: Could not load the [0] uCode section       
>> [    9.516201] iwlwifi 0000:04:00.0: Failed to start INIT ucode: -110           
>> [    9.530842] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -110             
>>
>> I get the same thing with -27 of the firmware:
>>
>> [   60.990831] Intel(R) Wireless WiFi driver for Linux                          
>> [   60.990833] Copyright(c) 2003- 2015 Intel Corporation                        
>> [   60.991936] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-34.ucode failed with error -2
>> [   60.991941] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-33.ucode failed with error -2
>> [   60.991946] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-32.ucode failed with error -2
>> [   60.991957] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-31.ucode failed with error -2
>> [   60.991964] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-30.ucode failed with error -2
>> [   60.991969] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-29.ucode failed with error -2
>> [   60.991975] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-28.ucode failed with error -2
>> [   61.029852] iwlwifi 0000:04:00.0: loaded firmware version 27.541033.0 op_mode iwlmvm
>> [   61.043660] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless AC 8260, REV=0x208
>> [   66.070135] iwlwifi 0000:04:00.0: Failed to load firmware chunk!             
>> [   66.070149] iwlwifi 0000:04:00.0: Could not load the [0] uCode section       
>> [   66.070165] iwlwifi 0000:04:00.0: Failed to start INIT ucode: -110           
>> [   66.083462] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -110             
>>
>> Things work fine in 4.13-rc7+, which was the last kernel I ran on my laptop.
> 
> This is strange, Linus has been running this same combination with -31
> (with -27 we had a regression, but it was fixed recently and the fix is
> in the current master).  I have also tried this combination with both
> -27 and -31 after my fix and it works fine.

It's 100% reproducible, I booted in and out of current -git and 4.13-rc7+
a few times and the latter never works while the former works fine. I
haven't seen this issue before on previous kernels.

> There are only a couple of other patches that may affect iwlwifi since
> the previous net-next.git pull request...
> 
> I'll try this combination on my machine and see if I can reproduce the
> problem.

Let me know if you have something I can try.

-- 
Jens Axboe
