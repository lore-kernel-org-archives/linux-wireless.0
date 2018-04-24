Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56170 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbeDXRYs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 13:24:48 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] rsi: remove unecessary PTR_ALIGN()s
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180406083717.GA21857@mwanda>
References: <20180406083717.GA21857@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <20180424172447.D1A0360131@smtp.codeaurora.org> (sfid-20180424_192451_900767_47516143)
Date: Tue, 24 Apr 2018 17:24:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> The issue here is that we allocate "data" and then set
> "data = PTR_ALIGN(data, 8);" and then we free the aligned pointer
> instead of the original pointer.
> 
> kmalloc() pointers are already ARCH_SLAB_MINALIGN aligned which is 8 or
> more on everything except certain Xtensa variants.  We decided that if
> the Xtensa people ever notice a bug here then we'll tell them the bug is
> on their side.  ;)
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Patch applied to wireless-drivers-next.git, thanks.

350fcdb83457 rsi: remove unecessary PTR_ALIGN()s

-- 
https://patchwork.kernel.org/patch/10325781/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
