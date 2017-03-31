Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:35966 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751263AbdCaWhE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 18:37:04 -0400
Received: by mail-pg0-f53.google.com with SMTP id g2so82094181pge.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Mar 2017 15:37:03 -0700 (PDT)
Received: from mail-pg0-f47.google.com (mail-pg0-f47.google.com. [74.125.83.47])
        by smtp.gmail.com with ESMTPSA id 73sm12381143pfj.31.2017.03.31.15.37.01
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Mar 2017 15:37:02 -0700 (PDT)
Received: by mail-pg0-f47.google.com with SMTP id 81so83207164pgh.2
        for <linux-wireless@vger.kernel.org>; Fri, 31 Mar 2017 15:37:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1490865547-10208-1-git-send-email-huxinming820@gmail.com>
References: <1490865547-10208-1-git-send-email-huxinming820@gmail.com>
From: Dmitry Torokhov <dtor@chromium.org>
Date: Fri, 31 Mar 2017 15:37:01 -0700
Message-ID: <CAE_wzQ9x8-dNCEbJw9+XnSK6fPaUa-K29jc0hjB91xUaFvRFhQ@mail.gmail.com> (sfid-20170401_003710_769782_E6F7A90D)
Subject: Re: [PATCH 1/3] mwifiex: remove unnecessary wakeup interrupt number
 sanity check
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Rajat Jain <rajatja@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 30, 2017 at 2:19 AM, Xinming Hu <huxinming820@gmail.com> wrote:
> From: Xinming Hu <huxm@marvell.com>
>
> Sanity check of interrupt number in interrupt handler is unnecessary and
> confusion, remove it.

I'd reworded the explanation a bit: "If wakeup interrupt handler is
called, we know that the wakeup interrupt number is valid, there is no
need to check it."

Otherwise:

Reviewed-by: Dmitry Torokhov <dtor@chromium.org>

>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/main.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
> index 30f4994..5e82602 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.c
> +++ b/drivers/net/wireless/marvell/mwifiex/main.c
> @@ -1503,11 +1503,9 @@ static irqreturn_t mwifiex_irq_wakeup_handler(int irq, void *priv)
>  {
>         struct mwifiex_adapter *adapter = priv;
>
> -       if (adapter->irq_wakeup >= 0) {
> -               dev_dbg(adapter->dev, "%s: wake by wifi", __func__);
> -               adapter->wake_by_wifi = true;
> -               disable_irq_nosync(irq);
> -       }
> +       dev_dbg(adapter->dev, "%s: wake by wifi", __func__);
> +       adapter->wake_by_wifi = true;
> +       disable_irq_nosync(irq);
>
>         /* Notify PM core we are wakeup source */
>         pm_wakeup_event(adapter->dev, 0);
> --
> 1.8.1.4
>
