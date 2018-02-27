Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54526 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750997AbeB0QTk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 11:19:40 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/4] qtnfmac: fix releasing Tx/Rx data buffers
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180210140420.17013-2-sergey.matyukevich.os@quantenna.com>
References: <20180210140420.17013-2-sergey.matyukevich.os@quantenna.com>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Message-Id: <20180227161940.4271460849@smtp.codeaurora.org> (sfid-20180227_171944_267940_32621788)
Date: Tue, 27 Feb 2018 16:19:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:

> Add missing PCI unmap for Tx buffers and release all buffers explicitly.
> Managed release using devm_add_action is not suitable for qtnfmac Tx/Rx
> data buffers. The reason is in ordering and dependencies: buffers
> should be released after transmission is stopped but before PCI
> device resources and DMA allocations are released.
> 
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

3 patches applied to wireless-drivers-next.git, thanks.

1d5e3b90ab01 qtnfmac: fix releasing Tx/Rx data buffers
a34d7bcb73f5 qtnfmac: enable reloading of qtnfmac kernel modules
c3b2f7ca4186 qtnfmac: implement asynchronous firmware loading

-- 
https://patchwork.kernel.org/patch/10210499/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
