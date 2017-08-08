Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41436 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751927AbdHHLrV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 07:47:21 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: replace netif_carrier_on/off by
 netif_device_attach/dettach
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1501704286-3908-1-git-send-email-gbhat@marvell.com>
References: <1501704286-3908-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20170808114721.50D3360250@smtp.codeaurora.org> (sfid-20170808_134725_070400_ED1E3AF7)
Date: Tue,  8 Aug 2017 11:47:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:

> Driver is doing netif_carrier_off during suspend, which will set
> the IFF_LOWER_UP flag to 0. As a result certain applications
> will think this as a real carrier down and behave accordingly.
> This will cause issues like loss of IP address, for example. To
> fix this use netif_device_dettach during suspend.
> 
> Fixes: 0026b32d723e ('mwifiex: fix Tx timeout issue during suspend test')
> 
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

bd69cddcdf47 mwifiex: replace netif_carrier_on/off by netif_device_attach/dettach

-- 
https://patchwork.kernel.org/patch/9877467/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
