Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34886 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274Ab2BIXTx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 18:19:53 -0500
Received: by iacb35 with SMTP id b35so3173964iac.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 15:19:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1327581689-22090-2-git-send-email-victorg@ti.com>
References: <1327581689-22090-1-git-send-email-victorg@ti.com> <1327581689-22090-2-git-send-email-victorg@ti.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 9 Feb 2012 15:19:33 -0800
Message-ID: <CAB=NE6Vz0GX=XpcycGyGbsLYDt556BrW11P0RHEnCCOD9HB7XA@mail.gmail.com> (sfid-20120210_001957_414425_9CC98290)
Subject: Re: [RFC 1/7] hostapd: implement dfs drv ops functions
To: Victor Goldenshtein <victorg@ti.com>
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, johannes@sipsolutions.net,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 26, 2012 at 4:41 AM, Victor Goldenshtein <victorg@ti.com> wrote:
> Add nl80211 driver operation functions:
> hostapd_enable_tx – to enable tx on DFS channel after
> channel availability check.
> hostapd_channel_switch – to handle channel switch request.
> hostapd_start_radar_detection – to enable radar detection
> on DFS channel.
>
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> ---
>  src/ap/ap_config.h   |    3 +++
>  src/ap/ap_drv_ops.c  |   34 ++++++++++++++++++++++++++++++++++
>  src/ap/ap_drv_ops.h  |    4 ++++
>  src/drivers/driver.h |   34 ++++++++++++++++++++++++++++++++++
>  4 files changed, 75 insertions(+), 0 deletions(-)
>
> diff --git a/src/ap/ap_config.h b/src/ap/ap_config.h
> index 485092d..eddc9b7 100644
> --- a/src/ap/ap_config.h
> +++ b/src/ap/ap_config.h
> @@ -410,6 +410,9 @@ struct hostapd_config {
>
>        int ieee80211d;
>
> +       /* DFS */
> +       int channel_switch_count;
> +
>        struct hostapd_tx_queue_params tx_queue[NUM_TX_QUEUES];
>
>        /*
> diff --git a/src/ap/ap_drv_ops.c b/src/ap/ap_drv_ops.c
> index 429c187..628f90e 100644
> --- a/src/ap/ap_drv_ops.c
> +++ b/src/ap/ap_drv_ops.c
> @@ -590,3 +590,37 @@ int hostapd_drv_sta_disassoc(struct hostapd_data *hapd,
>        return hapd->driver->sta_disassoc(hapd->drv_priv, hapd->own_addr, addr,
>                                          reason);
>  }
> +
> +
> +int hostapd_enable_tx(struct hostapd_data *hapd)
> +{
> +       if (!hapd->driver || !hapd->driver->enable_tx)
> +               return 0;
> +       return hapd->driver->enable_tx(hapd->drv_priv);

No checks on if the channel is DFS, if we started DFS, etc?

  Luis
