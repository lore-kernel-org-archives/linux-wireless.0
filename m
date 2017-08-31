Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:22843 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751009AbdHaMOB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 08:14:01 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix napi_poll budget overflow
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1503438242-5657-1-git-send-email-ryanhsu@qti.qualcomm.com>
References: <1503438242-5657-1-git-send-email-ryanhsu@qti.qualcomm.com>
To: <ryanhsu@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <ryanhsu@qti.qualcomm.com>
Message-ID: <b71aea953f7243498dbe97b0bd5473f7@euamsexm01a.eu.qualcomm.com> (sfid-20170831_141404_762169_CC7105E8)
Date: Thu, 31 Aug 2017 14:13:54 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ryanhsu@qti.qualcomm.com wrote:

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
> Link: https://lkml.kernel.org/r/26670dce-4dd2-f8e4-0e14-90d74257e739@virtuozzo.com
> Signed-off-by: Ryan Hsu <ryanhsu@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

c9353bf483d3 ath10k: fix napi_poll budget overflow

-- 
https://patchwork.kernel.org/patch/9916207/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
