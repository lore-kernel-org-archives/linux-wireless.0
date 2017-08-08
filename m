Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:40542 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752273AbdHHLHU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 07:07:20 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath10k: fix memory leak in rx ring buffer allocation
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1501670017-12862-1-git-send-email-pillair@codeaurora.org>
References: <1501670017-12862-1-git-send-email-pillair@codeaurora.org>
To: Rakesh Pillai <pillair@codeaurora.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Rakesh Pillai" <pillair@qti.qualcomm.com>
Message-ID: <20c41b712302461f8667c8bf5fc7cebe@euamsexm01a.eu.qualcomm.com> (sfid-20170808_130725_576806_120481F4)
Date: Tue, 8 Aug 2017 13:07:13 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rakesh Pillai <pillair@codeaurora.org> wrote:

> The rx ring buffers are added to a hash table if
> firmware support full rx reorder. If the full rx
> reorder support flag is not set before allocating
> the rx ring buffers, none of the buffers are added
> to the hash table.
> 
> There is a race condition between rx ring refill and
> rx buffer replenish from napi poll. The interrupts are
> enabled in hif start, before the rx ring is refilled during init.
> We replenish buffers from napi poll due to the interrupts which
> get enabled after hif start. Hence before the entire rx ring is
> refilled during the init, the napi poll replenishes a few buffers
> in steps of 100 buffers per attempt. During this rx ring replenish
> from napi poll, the rx reorder flag has not been set due to which
> the replenished buffers are not added to the hash table
> 
> Set the rx full reorder support flag before we allocate
> the rx ring buffer to avoid the memory leak.
> 
> Signed-off-by: Rakesh Pillai <pillair@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

f35a7f91f66a ath10k: fix memory leak in rx ring buffer allocation

-- 
https://patchwork.kernel.org/patch/9876599/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
