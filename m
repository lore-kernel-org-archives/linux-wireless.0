Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:10892 "EHLO
        alexa-out-lv-02.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932578AbdIYHO0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 03:14:26 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath9k: remove cast to void pointer
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1504248214-3805-1-git-send-email-himanshujha199640@gmail.com>
References: <1504248214-3805-1-git-send-email-himanshujha199640@gmail.com>
To: Himanshu Jha <himanshujha199640@gmail.com>
CC: <kvalo@codeaurora.org>, <ath9k-devel@qca.qualcomm.com>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joe@perches.com>, Himanshu Jha <himanshujha199640@gmail.com>
Message-ID: <10d2e93c64404c87816c3575c3b94c38@euamsexm01a.eu.qualcomm.com> (sfid-20170925_095440_960320_7EE8E2F9)
Date: Mon, 25 Sep 2017 09:14:18 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Himanshu Jha <himanshujha199640@gmail.com> wrote:

> casting to void pointer from any pointer type and vice-versa is done
> implicitly and therefore casting is not needed in such a case.
> 
> Done using Coccinellle.
> Semantic Patch used :
> 
> @r@
> expression x;
> void* e;
> type T;
> identifier f;
> @@
> 
> (
>   *((T *)e)
> |
>   ((T *)x)[...]
> |
>   ((T *)x)->f
> |
> - (T *)
>   e
> )
> 
> 
> Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

50c8cd44ed5f ath9k: remove cast to void pointer

-- 
https://patchwork.kernel.org/patch/9933585/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
