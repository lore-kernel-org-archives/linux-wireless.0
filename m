Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39792 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751989AbdJ0IBu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 04:01:50 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V2] bcma: Use bcma_debug and not pr_cont in MIPS driver
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <d0155fd60408cebf8e32c523582d71e1240e40ec.1508391860.git.joe@perches.com>
References: <d0155fd60408cebf8e32c523582d71e1240e40ec.1508391860.git.joe@perches.com>
To: Joe Perches <joe@perches.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20171027080150.60B1C6034E@smtp.codeaurora.org> (sfid-20171027_100205_284954_1593AEEB)
Date: Fri, 27 Oct 2017 08:01:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> wrote:

> Commit 66cc04424960 ("bcma: use bcma_debug and pr_cont in MIPS driver")
> converted a printk(KERN_DEBUG to bcma_debug.
> 
> bcma_debug is guarded by a #define DEBUG via pr_debug.
> 
> This means that the bcma_debug will generally not be emitted
> but any pr_cont following the bcma_debug will be emitted.
> 
> Correct this by removing the uses of pr_cont by using a temporary.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Patch applied to wireless-drivers-next.git, thanks.

758f7e06063a bcma: Use bcma_debug and not pr_cont in MIPS driver

-- 
https://patchwork.kernel.org/patch/10016013/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
