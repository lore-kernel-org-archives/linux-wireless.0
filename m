Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44722 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752194AbcKPP71 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 10:59:27 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Matthias Schiffer <mschiffer@universe-factory.net>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath9k-devel@lists.ath9k.org, miaoqing@codeaurora.org
Subject: Re: [PATCH] ath9k: fix ath9k_hw_gpio_get() to return 0 or 1 on success
References: <44116a7bca8524a187083916bdea535145e7a23a.1479232041.git.mschiffer@universe-factory.net>
        <8760nno6th.fsf@kamboji.qca.qualcomm.com>
        <6d1da72b-33b5-b99e-69ac-8b8307ce60f0@universe-factory.net>
Date: Wed, 16 Nov 2016 17:59:21 +0200
In-Reply-To: <6d1da72b-33b5-b99e-69ac-8b8307ce60f0@universe-factory.net>
        (Matthias Schiffer's message of "Wed, 16 Nov 2016 15:40:02 +0100")
Message-ID: <871sybo1pi.fsf@kamboji.qca.qualcomm.com> (sfid-20161116_165931_340027_739C6AEB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthias Schiffer <mschiffer@universe-factory.net> writes:

> On 11/16/2016 03:08 PM, Kalle Valo wrote:
>> Matthias Schiffer <mschiffer@universe-factory.net> writes:
>> 
>>> Commit b2d70d4944c1 ("ath9k: make GPIO API to support both of WMAC and
>>> SOC") refactored ath9k_hw_gpio_get() to support both WMAC and SOC GPIOs,
>>> changing the return on success from 1 to BIT(gpio). This broke some callers
>>> like ath_is_rfkill_set().
>>>
>>> Instead of fixing all callers, change ath9k_hw_gpio_get() back to only
>>> return 0 or 1.
>>>
>>> Fixes: b2d70d4944c1 ("ath9k: make GPIO API to support both of WMAC and SOC")
>>> Cc: <stable@vger.kernel.org> # v4.7+
>>> Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
>> 
>> Can you describe more about the symptoms, how did this break from user's
>> point of view? I can add that to the commit log.
>> 
>
> I did actually not experience an issue myself with a mainline kernel.
>
> Looking at the functions ath_is_rfkill_set() and ath9k_rfkill_poll_state()
> in gpio.c, this issue causes wiphy_rfkill_set_hw_state() always to be
> passed false when ah->rfkill_polarity==1, breaking rfkill. I don't know how
> common devices with ah->rfkill_polarity==1 are.
>
> I became aware of this issue when rebasing an out-of-tree patch in LEDE
> which uses the WMAC GPIOs to configure some kind of bandpass filter found
> in Ubiquiti hardware. (I hope to find time to get this patch upsteam at
> some point...)

Thanks, this kind of information is good to have in the commit log. That
way maintainers, like me or stable tree folks, can prioritise the fix to
various releases. And I guess Linux distros also like to know this as
well as some of the normal users when trying to solve problems.

I'll mention in the commit log that this doesn't fix any known bug. And
I'll push this to 4.10, I don't think this is important enough for 4.9.

-- 
Kalle Valo
