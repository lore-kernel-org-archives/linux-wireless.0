Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:33883 "EHLO
        mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752854AbdBMTz3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Feb 2017 14:55:29 -0500
Received: by mail-yw0-f171.google.com with SMTP id w75so55684755ywg.1
        for <linux-wireless@vger.kernel.org>; Mon, 13 Feb 2017 11:55:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170210215525.139701-1-briannorris@chromium.org>
References: <20170210215525.139701-1-briannorris@chromium.org>
From: Rajat Jain <rajatja@google.com>
Date: Mon, 13 Feb 2017 11:54:47 -0800
Message-ID: <CACK8Z6G7xgMf5yzmo+4suxWqcPx7WB2u_niO26mJt7csajjc=g@mail.gmail.com> (sfid-20170213_205533_995747_EDE09E34)
Subject: Re: [PATCH - REGRESSION] mwifiex: don't enable/disable IRQ 0 during suspend/resume
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 10, 2017 at 1:55 PM, Brian Norris <briannorris@chromium.org> wrote:
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

Acked-by: Rajat Jain <rajatja@google.com>

> ---
> This is a 4.10 regression. Not sure if it's critical to push quickly, or if it
> should just be tagged -stable and pushed in 4.11.
>
>  drivers/net/wireless/marvell/mwifiex/main.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
> index e5c3a8aa3929..c246d8efb6fc 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.c
> +++ b/drivers/net/wireless/marvell/mwifiex/main.c
> @@ -1569,13 +1569,13 @@ static void mwifiex_probe_of(struct mwifiex_adapter *adapter)
>         struct device *dev = adapter->dev;
>
>         if (!dev->of_node)
> -               return;
> +               goto err_exit;
>
>         adapter->dt_node = dev->of_node;
>         adapter->irq_wakeup = irq_of_parse_and_map(adapter->dt_node, 0);
>         if (!adapter->irq_wakeup) {
> -               dev_info(dev, "fail to parse irq_wakeup from device tree\n");
> -               return;
> +               dev_dbg(dev, "fail to parse irq_wakeup from device tree\n");
> +               goto err_exit;
>         }
>
>         ret = devm_request_irq(dev, adapter->irq_wakeup,
> @@ -1595,7 +1595,7 @@ static void mwifiex_probe_of(struct mwifiex_adapter *adapter)
>         return;
>
>  err_exit:
> -       adapter->irq_wakeup = 0;
> +       adapter->irq_wakeup = -1;
>  }
>
>  /*
> --
> 2.11.0.483.g087da7b7c-goog
>
