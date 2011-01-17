Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:55322 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752007Ab1AQMd2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 07:33:28 -0500
Received: by qyk27 with SMTP id 27so5270035qyk.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jan 2011 04:33:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295263943-32110-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1295263943-32110-1-git-send-email-juuso.oikarinen@nokia.com>
Date: Mon, 17 Jan 2011 14:33:26 +0200
Message-ID: <AANLkTikYPCqQy7ra7RHSA8fE_NR9LgoPhaKori2xhbYa@mail.gmail.com>
Subject: Re: [PATCH] wl12xx: Increase scan channel dwell time for passive scans
From: "Kahn, Gery" <geryk@ti.com>
To: juuso.oikarinen@nokia.com
Cc: coelho@ti.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Does it worth to have different value for 5GHz?

On Mon, Jan 17, 2011 at 13:32,  <juuso.oikarinen@nokia.com> wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
>
> The passive scan channel dwell time currently used is 30ms-60ms. A typical
> beacon interval for AP's is 100ms. This leads to a ~30% worst-case probability
> of finding an AP via passive scanning.
>
> For 5GHz bands for DFS frequencies passive scanning is the only scanning
> option. Hence for these, the probability of finding an AP is very low.
>
> To fix this, increase the passive channel scan dwell times (also the early
> leave value, as 5GHz channels are still typically very silent.) Use a value
> of 100ms, because that covers most typical AP configurations.
>
> Based on testing the probability of finding an AP (102.4ms beacon interval) on
> a single scan round are as follows (based on 100 iterations):
>
> dwell min/max (ms)   | probability
> ---------------------+------------
> 30/60                | 35%
> 60/60                | 56%
> 80/80                | 77%
> 100/100              | 100%
>
> Total scan times now and after the change:
>
> Region | Before (s) | After (s)
> -------+------------+----------
> 00     | 0.77       | 1.48
> FI     | 0.95       | 2.01
> US     | 0.91       | 1.76
>
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---
>  drivers/net/wireless/wl12xx/conf.h |   16 ++++++++--------
>  drivers/net/wireless/wl12xx/main.c |    4 ++--
>  2 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
> index f5c048c..21b72a5 100644
> --- a/drivers/net/wireless/wl12xx/conf.h
> +++ b/drivers/net/wireless/wl12xx/conf.h
> @@ -1084,30 +1084,30 @@ struct conf_scan_settings {
>        /*
>         * The minimum time to wait on each channel for active scans
>         *
> -        * Range: 0 - 65536 tu
> +        * Range: u32 tu/1000
>         */
> -       u16 min_dwell_time_active;
> +       u32 min_dwell_time_active;
>
>        /*
>         * The maximum time to wait on each channel for active scans
>         *
> -        * Range: 0 - 65536 tu
> +        * Range: u32 tu/1000
>         */
> -       u16 max_dwell_time_active;
> +       u32 max_dwell_time_active;
>
>        /*
>         * The maximum time to wait on each channel for passive scans
>         *
> -        * Range: 0 - 65536 tu
> +        * Range: u32 tu/1000
>         */
> -       u16 min_dwell_time_passive;
> +       u32 min_dwell_time_passive;
>
>        /*
>         * The maximum time to wait on each channel for passive scans
>         *
> -        * Range: 0 - 65536 tu
> +        * Range: u32 tu/1000
>         */
> -       u16 max_dwell_time_passive;
> +       u32 max_dwell_time_passive;
>
>        /*
>         * Number of probe requests to transmit on each active scan channel
> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index 863e660..c1814f2 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -279,8 +279,8 @@ static struct conf_drv_settings default_conf = {
>        .scan = {
>                .min_dwell_time_active        = 7500,
>                .max_dwell_time_active        = 30000,
> -               .min_dwell_time_passive       = 30000,
> -               .max_dwell_time_passive       = 60000,
> +               .min_dwell_time_passive       = 100000,
> +               .max_dwell_time_passive       = 100000,
>                .num_probe_reqs               = 2,
>        },
>        .rf = {
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
