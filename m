Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:63608 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751276AbdHXJHm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 05:07:42 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix napi_poll budget overflow
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1503438242-5657-1-git-send-email-ryanhsu@qti.qualcomm.com>
References: <1503438242-5657-1-git-send-email-ryanhsu@qti.qualcomm.com>
To: <ryanhsu@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <ryanhsu@qti.qualcomm.com>
Message-ID: <2cd00da66a6847c1829ed9edf7ad7009@euamsexm01a.eu.qualcomm.com> (sfid-20170824_110750_441983_1E250D01)
Date: Thu, 24 Aug 2017 11:07:35 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ryanhsu@qti.qualcomm.com wrote:

> From: Ryan Hsu <ryanhsu@qti.qualcomm.com>
> 
> In napi_poll, the budget number is used to control the amount of packets
> we should handle per poll to balance the resource in the system.
> 
> In the list of the amsdu packets reception, we check if there is budget
> count left and handle the complete list of the packets, that it will have
> chances the very last list will over the budget leftover.
> 
> So adding one more parameter - budget_left, this would help while
> traversing the list to avoid handling more than the budget given.
> 
> Reported-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Fix-suggested-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> 
> Signed-off-by: Ryan Hsu <ryanhsu@qti.qualcomm.com>

Was there a bug report about this? I can add a link to that and maybe also
include the warning.

-- 
https://patchwork.kernel.org/patch/9916207/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
