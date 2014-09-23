Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36459 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaIWIxn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 04:53:43 -0400
Received: by mail-wi0-f174.google.com with SMTP id fb4so4391154wid.7
        for <linux-wireless@vger.kernel.org>; Tue, 23 Sep 2014 01:53:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1411419245-25799-2-git-send-email-greearb@candelatech.com>
References: <1411419245-25799-1-git-send-email-greearb@candelatech.com>
	<1411419245-25799-2-git-send-email-greearb@candelatech.com>
Date: Tue, 23 Sep 2014 10:53:42 +0200
Message-ID: <CA+BoTQ=NtS3hOD+gVZ2whx+K2xsKrZUWBPUa=gfKxaNFcoTHEw@mail.gmail.com> (sfid-20140923_105348_336995_3FBB3B9A)
Subject: Re: [PATCH 2/2] ath10k: apply chainmask settings to vdev on creation.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 September 2014 22:54,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> It appears it takes more than just setting the
> hardware's chainmask to make things work well.  Without
> this patch, a vdev would only use 1x1 rates when chainmask
> was set to 0x3.
>
> Setting the 'nss' (number of spatial streams) on the vdev
> helps the firmware's rate-control algorithm work properly.
>
> Tested on CT firmware, but probably this works (and
> is required) on normal firmware.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 4dc5a40..855c71c 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -2767,6 +2767,17 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
>         return ret;
>  }
>
> +static u32 get_nss_from_chainmask(u16 chain_mask)
> +{
> +       if ((chain_mask & 0x15) == 0x15)
> +               return 4;
> +       else if ((chain_mask & 0x7) == 0x7)
> +               return 3;
> +       else if ((chain_mask & 0x3) == 0x3)
> +               return 2;
> +       return 1;
> +}

So a chainmask of `BIT(0) | BIT(2) = 0x5` is nss=1?

Why not just use `hweight16()` kernel macro? Or do we want to forbid
odd chainmasks (in which case additional checks need to be added as
well)?


> +
>  /*
>   * TODO:
>   * Figure out how to handle WMI_VDEV_SUBTYPE_P2P_DEVICE,
> @@ -2868,6 +2879,19 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
>                 goto err_vdev_delete;
>         }
>
> +       if (ar->cfg_tx_chainmask) {
> +               u16 nss = get_nss_from_chainmask(ar->cfg_tx_chainmask);
> +               vdev_param = ar->wmi.vdev_param->nss;
> +               ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
> +                                               nss);
> +               if (ret) {
> +                       ath10k_warn(ar, "failed to set vdev %i chainmask 0x%x, nss %i: %d\n",
> +                                   arvif->vdev_id, ar->cfg_tx_chainmask, nss,
> +                                   ret);
> +                       goto err_vdev_delete;
> +               }
> +       }
> +

If this is required won't setting up peer nss (after association) be
necessary as well?

Shouldn't the vdev nss param be set in __ath10k_set_antenna() as well?
What about peer nss (assuming it's necessary to update it) in that
case?


Michał
