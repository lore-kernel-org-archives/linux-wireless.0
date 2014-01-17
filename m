Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 0.mx.nanl.de ([217.115.11.12]:45977 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbaAQJL6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 04:11:58 -0500
Received: from mail-qc0-f175.google.com (mail-qc0-f175.google.com [209.85.216.175])
	by mail.nanl.de (Postfix) with ESMTPSA id 0C2AD460B3
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 08:59:54 +0000 (UTC)
Received: by mail-qc0-f175.google.com with SMTP id x13so3290462qcv.6
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 01:01:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140116123336.24551.2629.stgit@potku.adurom.net>
References: <20140116123336.24551.2629.stgit@potku.adurom.net>
From: Jonas Gorski <jogo@openwrt.org>
Date: Fri, 17 Jan 2014 10:01:06 +0100
Message-ID: <CAOiHx=n77=CiFYfB3Y=jxOjVtmr06zvFhUe5R96Kq0HUgSLv5Q@mail.gmail.com> (sfid-20140117_101207_480049_9C940B24)
Subject: Re: [PATCH] ath10k: enable firmware STA quick kickout
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 16, 2014 at 1:33 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Firmware has a feature to track if the associated STA is not acking the frames.
> When that happens, the firmware sends WMI_PEER_STA_KICKOUT_EVENTID event to the
> host. Enable that to faster detect when a STA has left BSS without sending a
> deauth frame.
>
> Also set huge keepalive timeouts to avoid using the keepalive functionality in
> the firmware.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.h |   12 +++++++
>  drivers/net/wireless/ath/ath10k/mac.c  |   55 ++++++++++++++++++++++++++++----
>  drivers/net/wireless/ath/ath10k/wmi.c  |   22 ++++++++++++-
>  drivers/net/wireless/ath/ath10k/wmi.h  |    4 ++
>  4 files changed, 85 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index ade1781..e6308f4 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -46,6 +46,18 @@
>
>  #define ATH10K_MAX_NUM_MGMT_PENDING 128
>
> +/* number of failed packets */
> +#define ATH10K_KICKOUT_THRESHOLD 50
> +
> +/*
> + * Use insanely high numbers to make sure that the firmware implementation
> + * won't start, we have the same functionality already in hostapd. Unit
> + * is seconds.
> + */
> +#define ATH10K_KEEPALIVE_MIN_IDLE 3747
> +#define ATH10K_KEEPALIVE_MAX_IDLE 3895
> +#define ATH10K_KEEPALIVE_MAX_UNRESPONSIVE 3900
> +
>  struct ath10k;
>
>  struct ath10k_skb_cb {
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 7aa6c4d..f5f7c6a 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -339,6 +339,47 @@ static int ath10k_peer_create(struct ath10k *ar, u32 vdev_id, const u8 *addr)
>         return 0;
>  }
>
> +static int ath10k_mac_set_kickout(struct ath10k_vif *arvif)
> +{
> +       struct ath10k *ar = arvif->ar;
> +       u32 param;
> +       int ret;
> +
> +       param = ar->wmi.pdev_param->sta_kickout_th;
> +       ret = ath10k_wmi_pdev_set_param(ar, param,
> +                                       ATH10K_KICKOUT_THRESHOLD);
> +       if (ret) {
> +               ath10k_warn("Failed to enable sta kickout: %d\n", ret);
> +               return ret;
> +       }
> +
> +       param = ar->wmi.vdev_param->ap_keepalive_min_idle_inactive_time_secs;
> +       ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, param,
> +                                       ATH10K_KEEPALIVE_MIN_IDLE);
> +       if (ret) {
> +               ath10k_warn("Failed to enable sta kickout: %d\n", ret);
> +               return ret;
> +       }
> +
> +       param = ar->wmi.vdev_param->ap_keepalive_max_idle_inactive_time_secs;
> +       ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, param,
> +                                       ATH10K_KEEPALIVE_MAX_IDLE);
> +       if (ret) {
> +               ath10k_warn("Failed to enable sta kickout: %d\n", ret);
> +               return ret;
> +       }
> +
> +       param = ar->wmi.vdev_param->ap_keepalive_max_unresponsive_time_secs;
> +       ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, param,
> +                                       ATH10K_KEEPALIVE_MAX_UNRESPONSIVE);
> +       if (ret) {
> +               ath10k_warn("Failed to enable sta kickout: %d\n", ret);
> +               return ret;
> +       }

Did you intend to have differing warnings here? Currently it will be
hard to tell which of these calls have failed based on the warning
(assuming ath10k_warn does not print the source code line it was
invoked from).


Jonas
