Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:41408 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752021AbeDFLuk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Apr 2018 07:50:40 -0400
Received: by mail-wr0-f177.google.com with SMTP id s12so1495256wrc.8
        for <linux-wireless@vger.kernel.org>; Fri, 06 Apr 2018 04:50:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1523014902-23232-1-git-send-email-siva8118@gmail.com>
References: <1523014902-23232-1-git-send-email-siva8118@gmail.com>
From: Siva Rebbagondla <siva8118@gmail.com>
Date: Fri, 6 Apr 2018 17:20:38 +0530
Message-ID: <CANGSkXTx7TQkjSTdgkbH8FEUac5opzYj_wr-TogUmGXB6Urgtw@mail.gmail.com> (sfid-20180406_135043_872948_BF66DE76)
Subject: Re: [PATCH] Added wait event for power save request till confirm form
 firmware is received
To: linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Mishra <sushant.mishra@redpinesignals.com>,
        Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 6, 2018 at 5:11 PM, Siva Rebbagondla <siva8118@gmail.com> wrote:
> From: Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>
>
> Signed-off-by: Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>
> ---
>  ubuntu/rsi/rsi_91x_main.c | 1 +
>  ubuntu/rsi/rsi_91x_mgmt.c | 5 +++++
>  ubuntu/rsi/rsi_main.h     | 1 +
>  3 files changed, 7 insertions(+)
>
> diff --git a/ubuntu/rsi/rsi_91x_main.c b/ubuntu/rsi/rsi_91x_main.c
> index 2350dbb..49b98cd 100644
> --- a/ubuntu/rsi/rsi_91x_main.c
> +++ b/ubuntu/rsi/rsi_91x_main.c
> @@ -382,6 +382,7 @@ struct rsi_hw *ven_rsi_91x_init(void)
>  #ifdef CONFIG_HW_SCAN_OFFLOAD
>         rsi_init_event(&common->chan_set_event);
>         rsi_init_event(&common->probe_cfm_event);
> +       rsi_init_event(&common->mgmt_cfm_event);
>         rsi_init_event(&common->chan_change_event);
>         rsi_init_event(&common->cancel_hw_scan_event);
>         common->scan_workqueue =
> diff --git a/ubuntu/rsi/rsi_91x_mgmt.c b/ubuntu/rsi/rsi_91x_mgmt.c
> index 11b2046..58a9b69 100644
> --- a/ubuntu/rsi/rsi_91x_mgmt.c
> +++ b/ubuntu/rsi/rsi_91x_mgmt.c
> @@ -2407,6 +2407,8 @@ void rsi_scan_start(struct work_struct *work)
>
>         common->scan_in_prog = true;
>         rsi_disable_ps(common->priv);
> +       rsi_reset_event(&common->mgmt_cfm_event);
> +       rsi_wait_event(&common->mgmt_cfm_event, msecs_to_jiffies(2000));
>
>         for (ii =0; ii < scan_req->n_channels ; ii++) {
>                 if (common->iface_down)
> @@ -2470,6 +2472,8 @@ void rsi_scan_start(struct work_struct *work)
>         del_timer(&common->scan_timer);
>         common->scan_in_prog = false;
>         rsi_enable_ps(common->priv);
> +       rsi_reset_event(&common->mgmt_cfm_event);
> +       rsi_wait_event(&common->mgmt_cfm_event, msecs_to_jiffies(2000));
>  #if (LINUX_VERSION_CODE >= KERNEL_VERSION(4, 9, 0))
>         info.aborted = false;
>         ieee80211_scan_completed(common->priv->hw, &info);
> @@ -2693,6 +2697,7 @@ static int rsi_handle_ta_confirm(struct rsi_common *common, u8 *msg)
>
>         case WAKEUP_SLEEP_REQUEST:
>                 ven_rsi_dbg(INFO_ZONE, "Wakeup/Sleep confirmation.\n");
> +               rsi_set_event(&common->mgmt_cfm_event);
>                 return rsi_handle_ps_confirm(adapter, msg);
>
>         case BG_SCAN_PROBE_REQ:
> diff --git a/ubuntu/rsi/rsi_main.h b/ubuntu/rsi/rsi_main.h
> index 2aad124..027e9d9 100644
> --- a/ubuntu/rsi/rsi_main.h
> +++ b/ubuntu/rsi/rsi_main.h
> @@ -376,6 +376,7 @@ struct rsi_common {
>         struct work_struct scan_work;
>         struct rsi_event chan_set_event;
>         struct rsi_event probe_cfm_event;
> +       struct rsi_event mgmt_cfm_event;
>         struct rsi_event chan_change_event;
>         struct rsi_event cancel_hw_scan_event;
>         struct timer_list scan_timer;
> --
> 2.7.4
>

Please ignore this. It got sent by mistake.

Thanks,
Siva Rebbagondla
