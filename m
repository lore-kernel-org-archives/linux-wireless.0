Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46140 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751614AbdBOJOw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 04:14:52 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [-,
 REGRESSION] mwifiex: don't enable/disable IRQ 0 during suspend/resume
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170210215525.139701-1-briannorris@chromium.org>
References: <20170210215525.139701-1-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Rajat Jain <rajatja@google.com>,
        Brian Norris <briannorris@chromium.org>
Message-Id: <20170215091436.24D3560C51@smtp.codeaurora.org> (sfid-20170215_101533_788417_25E6B2D7)
Date: Wed, 15 Feb 2017 09:14:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:
> If we don't have an out-of-band wakeup IRQ configured through DT (as
> most platforms don't), then we fall out of this function with
> 'irq_wakeup == 0'. Other code (e.g., mwifiex_disable_wake() and
> mwifiex_enable_wake()) treats 'irq_wakeup >= 0' as a valid IRQ, and so
> we end up calling {enable,disable}_irq() on IRQ 0.
> 
> That seems bad, so let's not do that.
> 
> Same problem as fixed in this patch:
> 
> https://patchwork.kernel.org/patch/9531693/
> [PATCH v2 2/3] btmrvl: set irq_bt to -1 when failed to parse it
> 
> with the difference that:
> (a) this one is actually a regression and
> (b) this affects both device tree and non-device-tree systems
> 
> While fixing the regression, also drop the verbosity on the parse
> failure, so we don't see this when a DT node is present but doesn't have
> an interrupt property (this is perfectly legal):
> 
> [   21.999000] mwifiex_pcie 0000:01:00.0: fail to parse irq_wakeup from device tree
> 
> Fixes: 853402a00823 ("mwifiex: Enable WoWLAN for both sdio and pcie")
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Acked-by: Rajat Jain <rajatja@google.com>

Patch applied to wireless-drivers-next.git, thanks.

2447e2cad752 mwifiex: don't enable/disable IRQ 0 during suspend/resume

-- 
https://patchwork.kernel.org/patch/9567543/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
