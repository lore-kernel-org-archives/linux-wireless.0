Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50806 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933294AbdIYIap (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 04:30:45 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: b43: make const arrays static, reduces object code size
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170922153902.15372-1-colin.king@canonical.com>
References: <20170922153902.15372-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20170925083044.D348A6025D@smtp.codeaurora.org> (sfid-20170925_110028_047117_6AC704D5)
Date: Mon, 25 Sep 2017 08:30:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate const arrays on the stack, instead make them static.
> Makes the object code smaller by over 60 bytes:
> 
> Before:
>    text	   data	    bss	    dec	    hex	filename
>   14816	   1296	      0	  16112	   3ef0	b43/phy_ht.o
> 
> After:
>    text	   data	    bss	    dec	    hex	filename
>   14551	   1496	      0	  16047	   3eaf	b43/phy_ht.o
> 
> (gcc 6.3.0, x86-64)
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

96cbe3d638e4 b43: make const arrays static, reduces object code size

-- 
https://patchwork.kernel.org/patch/9966415/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
