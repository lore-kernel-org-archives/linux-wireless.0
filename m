Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39892 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753850AbdDZGKV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 02:10:21 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: Andi Kleen <andi@firstfloor.org>, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org
Subject: Re: 4.11-rc* iwlwifi instable
References: <20170424005400.GK22592@two.firstfloor.org>
        <1493016631.31741.139.camel@coelho.fi>
        <20170424124017.GL22592@two.firstfloor.org>
        <1493059948.31741.161.camel@coelho.fi>
Date: Wed, 26 Apr 2017 09:10:16 +0300
In-Reply-To: <1493059948.31741.161.camel@coelho.fi> (Luca Coelho's message of
        "Mon, 24 Apr 2017 21:52:28 +0300")
Message-ID: <87zif3aed3.fsf@purkki.adurom.net> (sfid-20170426_081025_523186_192A3586)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

>> > https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/iwlwifi-7265D-27.ucode
>> > 
>> > We have loads of fixes and improvements in this new version.  And
>> > hopefully it will make your problems go away. ;)
>> > 
>> > Please try it and let me know how it goes.
>> 
>> This is -27, but the driver looks for -28
>> 
>> [12382.760671] iwlwifi 0000:03:00.0: Direct firmware load for
>> iwlwifi-7265D-28.ucode failed with error -2
>> 
>> Where is version -28?
>
> TL;DR: this error message is harmless and the driver tries to load -27
> if -28 is not available.
>
> Long story: We upstream driver patches from our internal tree constantly
> and, at that point, we don't know which FW version will pass all the
> quality gates to be released officially.  The driver in 4.11 supports up
> to version -28.  We haven't release -28 yet, though (and maybe won't),
> so you get this error message when we try to load it.  But if it fails
> to load, we try to load the one immediately below it and so on, until we
> reach the minimum API version we support.
>
> These errors are definitely annoying and confusing, but I don't know how
> to work around them.  Luckily Luis is working on the firmware class[1]
> and part of his work will make these messages go away.

FWIW, we got frustrated with the same problem in ath10k and switched to
request_firmware_direct() to get rid of the warning:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9f5bcfe93315d75da4cc46bd30b536966559359a

-- 
Kalle Valo
