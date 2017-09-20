Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50728 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbdITMrO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 08:47:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: remove unnecessary call to memset
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1505133964-376-1-git-send-email-himanshujha199640@gmail.com>
References: <1505133964-376-1-git-send-email-himanshujha199640@gmail.com>
To: Himanshu Jha <himanshujha199640@gmail.com>
Cc: amitkarwar@gmail.com, nishants@marvell.com, gbhat@marvell.com,
        huxm@marvell.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Himanshu Jha <himanshujha199640@gmail.com>
Message-Id: <20170920124713.5A68B60725@smtp.codeaurora.org> (sfid-20170920_144720_546629_2D50059D)
Date: Wed, 20 Sep 2017 12:47:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Himanshu Jha <himanshujha199640@gmail.com> wrote:

> call to memset to assign 0 value immediately after allocating
> memory with kzalloc is unnecesaary as kzalloc allocates the memory
> filled with 0 value.
> 
> Semantic patch used to resolve this issue:
> 
> @@
> expression e,e2; constant c;
> statement S;
> @@
> 
>   e = kzalloc(e2, c);
>   if(e == NULL) S
> - memset(e, 0, e2);
> 
> Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

85dafc129196 mwifiex: remove unnecessary call to memset

-- 
https://patchwork.kernel.org/patch/9947331/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
