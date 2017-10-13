Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46474 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757829AbdJMJmn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 05:42:43 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] mwifiex: Use put_unaligned_le32
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1507302279-3875-1-git-send-email-himanshujha199640@gmail.com>
References: <1507302279-3875-1-git-send-email-himanshujha199640@gmail.com>
To: Himanshu Jha <himanshujha199640@gmail.com>
Cc: amitkarwar@gmail.com, nishants@marvell.com, gbhat@marvell.com,
        huxm@marvell.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Himanshu Jha <himanshujha199640@gmail.com>
Message-Id: <20171013094243.4C87C6070A@smtp.codeaurora.org> (sfid-20171013_114301_772507_84E2628A)
Date: Fri, 13 Oct 2017 09:42:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Himanshu Jha <himanshujha199640@gmail.com> wrote:

> Use put_unaligned_le32 rather than using byte ordering function and
> memcpy which makes code clear.
> Also, add the header file where it is declared.
> 
> Done using Coccinelle and semantic patch used is :
> 
> @ rule1 @
> identifier tmp; expression ptr,x; type T;
> @@
> 
> - tmp = cpu_to_le32(x);
> 
>   <+... when != tmp
> - memcpy(ptr, (T)&tmp, ...);
> + put_unaligned_le32(x,ptr);
>   ...+>
> 
> @ depends on rule1 @
> type j; identifier tmp;
> @@
> 
> - j tmp;
>   ...when != tmp
> 
> Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

317049204cd3 mwifiex: Use put_unaligned_le32

-- 
https://patchwork.kernel.org/patch/9989655/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
