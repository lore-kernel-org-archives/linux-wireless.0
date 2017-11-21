Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43240 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751418AbdKUKmy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 05:42:54 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: sedat.dilek@gmail.com, linux-wireless@vger.kernel.org,
        linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi 2017-11-19
References: <1511175768.4011.261.camel@coelho.fi>
        <CA+icZUVqhmH3dyMXkHKsHus5qyfMqQfcOctvHRDf4x=6+ndfPw@mail.gmail.com>
        <1511259055.4011.268.camel@coelho.fi>
Date: Tue, 21 Nov 2017 12:42:48 +0200
In-Reply-To: <1511259055.4011.268.camel@coelho.fi> (Luca Coelho's message of
        "Tue, 21 Nov 2017 12:10:55 +0200")
Message-ID: <871skrdiaf.fsf@kamboji.qca.qualcomm.com> (sfid-20171121_114257_603881_BC97E4B4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

>> [   10.630285] iwlwifi 0000:04:00.0: firmware: failed to load
>> iwlwifi-8265-34.ucode (-2)
>> [   10.630331] iwlwifi 0000:04:00.0: Direct firmware load for
>> iwlwifi-8265-34.ucode failed with error -2
>> [   10.630454] iwlwifi 0000:04:00.0: firmware: failed to load
>> iwlwifi-8265-33.ucode (-2)
>> [   10.630479] iwlwifi 0000:04:00.0: Direct firmware load for
>> iwlwifi-8265-33.ucode failed with error -2
>> [   10.630486] iwlwifi 0000:04:00.0: firmware: failed to load
>> iwlwifi-8265-32.ucode (-2)
>> [   10.630510] iwlwifi 0000:04:00.0: Direct firmware load for
>> iwlwifi-8265-32.ucode failed with error -2
>> [   10.636423] iwlwifi 0000:04:00.0: firmware: direct-loading
>> firmware
>> iwlwifi-8265-31.ucode
>> [   10.637463] iwlwifi 0000:04:00.0: loaded firmware version
>> 31.532993.0 op_mode iwlmvm
>
> This is an unfortunate side-effect of the way firmwares are loaded. 
> There is currently no way to prevent these error messages by making
> some files optional... But you can ignore them.  Or, even better,
> upgrade your firmware to the latest version the driver supports. :)

Or even better that we improve request_firmware()&co to make it possible
not to print an error message :)

In ath10k we are also (again) suffering about the same problem due to:

ath10k: activate user space firmware loading again

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c0cc00f250e19c717fc9cdbdb7f55aaa569c7498

-- 
Kalle Valo
