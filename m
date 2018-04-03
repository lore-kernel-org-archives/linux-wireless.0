Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48262 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754813AbeDCJ6k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 05:58:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Daniel Mack <daniel@zonque.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        rfried@codeaurora.org, bjorn.andersson@linaro.org
Subject: Re: [PATCH] wcn36xx: allocate skbs with GFP_KERNEL during init
References: <20180319063002.24665-1-daniel@zonque.org>
        <0dafe1f7-6f79-faa7-aff9-3eca532d237e@zonque.org>
Date: Tue, 03 Apr 2018 12:58:35 +0300
In-Reply-To: <0dafe1f7-6f79-faa7-aff9-3eca532d237e@zonque.org> (Daniel Mack's
        message of "Thu, 29 Mar 2018 20:04:10 +0200")
Message-ID: <87sh8cipbo.fsf@kamboji.qca.qualcomm.com> (sfid-20180403_115847_831076_C7390194)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Mack <daniel@zonque.org> writes:

> On Monday, March 19, 2018 07:30 AM, Daniel Mack wrote:
>> GFP_ATOMIC should only be used when the allocation is done from atomic
>> context. Introduce a new flag to wcn36xx_dxe_fill_skb() and use GFP_KERNEL
>> when pre-allocating buffers during init.
>> 
>> This doesn't fix an issue that was observed in the wild, but it reduces
>> the chance of failed allocations under memory pressure.
>> 
>> Signed-off-by: Daniel Mack <daniel@zonque.org>
>
> Any opinion about this one?

It's better that you check the state from patchwork, less mail to the
maintainers:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#checking_state_of_patches_from_patchwork

-- 
Kalle Valo
