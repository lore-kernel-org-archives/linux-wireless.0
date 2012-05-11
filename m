Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59931 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab2EKHq1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 03:46:27 -0400
Received: by bkcji2 with SMTP id ji2so1991501bkc.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 May 2012 00:46:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1336474934-22069-3-git-send-email-yoni.divinsky@ti.com>
References: <1336474934-22069-1-git-send-email-yoni.divinsky@ti.com> <1336474934-22069-3-git-send-email-yoni.divinsky@ti.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Fri, 11 May 2012 10:46:10 +0300
Message-ID: <CA+XVXfcD3nh-ucNHiJRX8ypKE+Ln4Ejz5m3Woe+-LCzntV=wjg@mail.gmail.com> (sfid-20120511_094631_636982_350E0FB8)
Subject: Re: [PATCH 3/4] wlcore: do not send stop fwlog cmd if fw is hanged
To: Yoni Divinsky <yoni.divinsky@ti.com>
Cc: linux-wireless@vger.kernel.org, coelho@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 8, 2012 at 2:02 PM, Yoni Divinsky <yoni.divinsky@ti.com> wrote:
> If the driver received a watchdog interrupt then the
> assumption is that the fw is hanged. Avoid sending
> the stop fwlog command in case of a watchdog recovey
> to avoid waiting for the 2 seconds timeout of the command.
>
> Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
> ---
>  drivers/net/wireless/ti/wlcore/main.c   |    9 +++++++--
>  drivers/net/wireless/ti/wlcore/wlcore.h |    1 +
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index 45fe911..b8dcef3 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -582,6 +582,7 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
>                if (unlikely(intr & WL1271_ACX_INTR_WATCHDOG)) {
>                        wl1271_error("watchdog interrupt received! "
>                                     "starting recovery.");
> +                       wl->watchdog_recovery = true;
>                        wl12xx_queue_recovery_work(wl);
>
>                        /* restarting the chip. ignore any other interrupt. */
> @@ -820,10 +821,12 @@ static void wl12xx_read_fwlog_panic(struct wl1271 *wl)
>
>        /*
>         * Make sure the chip is awake and the logger isn't active.
> -        * This might fail if the firmware hanged.
> +        * Do not send a stop fwlog command if the fw is hanged.
>         */
> -       if (!wl1271_ps_elp_wakeup(wl))
> +       if (!wl1271_ps_elp_wakeup(wl) && !wl->watchdog_recovery)
>                wl12xx_cmd_stop_fwlog(wl);
> +       else
> +               goto out;
>
>        /* Read the first memory block address */
>        wl12xx_fw_status(wl, wl->fw_status);
> @@ -926,6 +929,7 @@ static void wl1271_recovery_work(struct work_struct *work)
>         * to restart the HW.
>         */
>        ieee80211_wake_queues(wl->hw);
> +       wl->watchdog_recovery = false;
>        return;

Please change watchdog_recovery only inside the wl->mutex.

>  out_unlock:
>        mutex_unlock(&wl->mutex);

Please change watchdog_recovery to false here as well.

> @@ -1049,6 +1053,7 @@ int wl1271_plt_start(struct wl1271 *wl)
>
>                wl->plt = true;
>                wl->state = WL1271_STATE_ON;
> +               wl->watchdog_recovery = false;
>                wl1271_notice("firmware booted in PLT mode (%s)",
>                              wl->chip.fw_ver_str);

This is not needed here once watchdog_recovery is always set to false
indie recovery_work().

Arik
