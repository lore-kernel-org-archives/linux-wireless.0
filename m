Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:33075 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933979AbdDGR2U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Apr 2017 13:28:20 -0400
Received: by mail-pg0-f51.google.com with SMTP id x125so72591943pgb.0
        for <linux-wireless@vger.kernel.org>; Fri, 07 Apr 2017 10:28:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1491562285-29818-2-git-send-email-huxinming820@gmail.com>
References: <1491562285-29818-1-git-send-email-huxinming820@gmail.com> <1491562285-29818-2-git-send-email-huxinming820@gmail.com>
From: Dmitry Torokhov <dtor@google.com>
Date: Fri, 7 Apr 2017 10:28:18 -0700
Message-ID: <CAE_wzQ9WzgNfgRAPR8Anhmq_bHZR1==Pb_9u6395kFvc49jZxg@mail.gmail.com> (sfid-20170407_192825_137382_2F8D93E8)
Subject: Re: [PATCH v2 2/4] mwifiex: fall back mwifiex_dbg to pr_info when
 adapter->dev not set
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

Hi Xinming,

On Fri, Apr 7, 2017 at 3:51 AM, Xinming Hu <huxinming820@gmail.com> wrote:
> From: Xinming Hu <huxm@marvell.com>
>
> mwifiex_dbg will do nothing before adapter->dev get assigned. several logs
> lost in this case. it can be avoided by fall back to pr_info.
>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> ---
> v2: enhance adapter->dev null case.(Brain)
> ---
>  drivers/net/wireless/marvell/mwifiex/main.c | 17 ++++++++++++-----
>  drivers/net/wireless/marvell/mwifiex/main.h |  2 ++
>  2 files changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
> index 98fd491..f3e772f 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.c
> +++ b/drivers/net/wireless/marvell/mwifiex/main.c
> @@ -1749,18 +1749,25 @@ void _mwifiex_dbg(const struct mwifiex_adapter *adapter, int mask,
>  {
>         struct va_format vaf;
>         va_list args;
> +       char msg[MWIFIEX_LOG_LEN];
>
> -       if (!adapter->dev || !(adapter->debug_mask & mask))
> +       if (!(adapter->debug_mask & mask))
>                 return;
>
>         va_start(args, fmt);
>
> -       vaf.fmt = fmt;
> -       vaf.va = &args;
> -
> -       dev_info(adapter->dev, "%pV", &vaf);
> +       if (!adapter->dev) {
> +               vsnprintf(msg, MWIFIEX_LOG_LEN, fmt, args);
> +       } else {
> +               vaf.fmt = fmt;
> +               vaf.va = &args;
> +               dev_info(adapter->dev, "%pV", &vaf);
> +       }
>
>         va_end(args);
> +
> +       if (!adapter->dev)
> +               pr_info("%s", msg);

Why not:

vaf.fmt = fmt;
vaf.va = &args;

if (adapter->dev)
        dev_info(adapter->dev, "%pV", &vaf);
else
        pr_info("mwifiex: %pV", &vaf);

va_end(args);

Also, instead of static "mwifiex" prefix maybe make sure you have
pr_fmt() set properly (I am not sure if it is set or not).

Thanks.

-- 
Dmitry
