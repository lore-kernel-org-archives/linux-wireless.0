Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43590 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752885AbdBMPbJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Feb 2017 10:31:09 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Rajat Jain <rajatja@google.com>
Subject: Re: [PATCH - REGRESSION] mwifiex: don't enable/disable IRQ 0 during suspend/resume
References: <20170210215525.139701-1-briannorris@chromium.org>
Date: Mon, 13 Feb 2017 17:30:57 +0200
In-Reply-To: <20170210215525.139701-1-briannorris@chromium.org> (Brian
        Norris's message of "Fri, 10 Feb 2017 13:55:25 -0800")
Message-ID: <87zihqrtu6.fsf@kamboji.qca.qualcomm.com> (sfid-20170213_163250_353238_D14BBA6D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> writes:

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
> ---
> This is a 4.10 regression. Not sure if it's critical to push quickly, or if it
> should just be tagged -stable and pushed in 4.11.

It's really late for 4.10, so I would rather push it to 4.11.

-- 
Kalle Valo
