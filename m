Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50210 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750881AbdBBJKi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Feb 2017 04:10:38 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] ath9k: fix race condition in enabling/disabling IRQs
References: <20170125163654.66431-1-nbd@nbd.name>
        <20170125163654.66431-4-nbd@nbd.name>
        <ca32601f-81f1-aec0-9ab4-02631b226900@nbd.name>
Date: Thu, 02 Feb 2017 11:10:34 +0200
In-Reply-To: <ca32601f-81f1-aec0-9ab4-02631b226900@nbd.name> (Felix Fietkau's
        message of "Fri, 27 Jan 2017 13:47:06 +0100")
Message-ID: <871svhez5h.fsf@purkki.adurom.net> (sfid-20170202_101210_387013_F09D5B34)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> On 2017-01-25 17:36, Felix Fietkau wrote:
>> The code currently relies on refcounting to disable IRQs from within the
>> IRQ handler and re-enabling them again after the tasklet has run.
>> 
>> However, due to race conditions sometimes the IRQ handler might be
>> called twice, or the tasklet may not run at all (if interrupted in the
>> middle of a reset).
>> 
>> This can cause nasty imbalances in the irq-disable refcount which will
>> get the driver permanently stuck until the entire radio has been stopped
>> and started again (ath_reset will not recover from this).
>> 
>> Instead of using this fragile logic, change the code to ensure that
>> running the irq handler during tasklet processing is safe, and leave the
>> refcount untouched.
>> 
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>
> Please don't apply this yet, it looks like it might cause some
> regressions on other devices. I will investigate.

Ok, as patch 3 also had some changes I'll drop these now. So please
resend the whole patch series once you know more.

-- 
Kalle Valo
