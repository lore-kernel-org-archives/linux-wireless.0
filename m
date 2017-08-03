Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39398 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751258AbdHCJeN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 05:34:13 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [BUG] rtlwifi: rtl_pci_probe: Fix fail path of
 _rtl_pci_find_adapter
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170730080219.5925-1-tvboxspy@gmail.com>
References: <20170730080219.5925-1-tvboxspy@gmail.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Malcolm Priestley <tvboxspy@gmail.com>, stable@vger.kernel.org
Message-Id: <20170803093412.AE5BB60224@smtp.codeaurora.org> (sfid-20170803_113416_628024_7B06CD67)
Date: Thu,  3 Aug 2017 09:34:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Malcolm Priestley <tvboxspy@gmail.com> wrote:

> _rtl_pci_find_adapter fail path will jump to label fail3 for
> unsupported adapter types.
> 
> However, on course for fail3 there will be call rtl_deinit_core
> before rtl_init_core.
> 
> For the inclusion of checking pci_iounmap this fail can be moved to
> fail2.
> 
> Fixes
> [    4.492963] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [    4.493067] IP: rtl_deinit_core+0x31/0x90 [rtlwifi]
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> Cc: <stable@vger.kernel.org>

Patch applied to wireless-drivers-next.git, thanks.

fc81bab5eeb1 rtlwifi: rtl_pci_probe: Fix fail path of _rtl_pci_find_adapter

-- 
https://patchwork.kernel.org/patch/9870227/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
