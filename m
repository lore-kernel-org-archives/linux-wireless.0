Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40376 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754040AbeEaIov (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 May 2018 04:44:51 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: Alexander Wetzel <alexander.wetzel@web.de>,
        linux-wireless@vger.kernel.org,
        Golan Ben Ami <golan.ben.ami@intel.com>
Subject: Re: iwlwifi: regression due to: allow different csr flags for different device families
References: <20180422082745.9743-1-luca@coelho.fi>
        <20180422082745.9743-2-luca@coelho.fi>
        <8ac31eb3-17cd-c4ee-fdf6-49aea171a667@web.de>
        <3a0d36e025325f873f6db2651c6d576b3b14c36d.camel@coelho.fi>
Date: Thu, 31 May 2018 11:44:46 +0300
In-Reply-To: <3a0d36e025325f873f6db2651c6d576b3b14c36d.camel@coelho.fi> (Luca
        Coelho's message of "Thu, 31 May 2018 09:30:48 +0300")
Message-ID: <87k1rk1af5.fsf@kamboji.qca.qualcomm.com> (sfid-20180531_104457_411245_2B844214)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> On Sun, 2018-05-27 at 14:08 +0200, Alexander Wetzel wrote:
>> > From: Golan Ben Ami <golan.ben.ami@intel.com>
>> > 
>> > Different device families may have different flag values
>> > for passing a message to the fw (i.e. SW_RESET).
>> > In order to keep the code readable, and avoid conditioning
>> > upon the family, store a value for each flag, which indicates
>> > the bit that needs to be enabled.
>> > 
>> > Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
>> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
>> 
>> This patch generates a Null pointer exception for my Ultimate-N 6300
>> card when loading the driver, making the card unusable.
>> (Bisecting linked it to commit
>> a8cbb46f831d2c101feccdd0e0daf3627b8c1dca.)
>> 
>> Sine the commit could not be simply reverted I applied this commit to
>> my
>> distribution kernel - basically 4.16.12 - and can confirm it is
>> indeed
>> causing the issue.
>
> It seems that I forgot to reply to this, even though we looked into it
> and provided a fix[1].  This fix will hopefully be included in 4.17
> final.
>
> Thanks a lot for reporting and bisecting!
>
> [1] https://patchwork.kernel.org/patch/10437773/

Something is not right, commit 0513c083d1f4 is in wireless-drivers-next
so it will be in 4.18. Are we mixing commits or releases or did I pull
it to wrong tree?

0513c083d1f4 iwlwifi: add csr configuration for 6300 devices

-- 
Kalle Valo
