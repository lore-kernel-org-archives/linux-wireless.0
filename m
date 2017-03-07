Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35548 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754639AbdCGKD0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 05:03:26 -0500
Received: by mail-wm0-f47.google.com with SMTP id v186so85166835wmd.0
        for <linux-wireless@vger.kernel.org>; Tue, 07 Mar 2017 02:03:21 -0800 (PST)
Subject: Re: [PATCH v2 2/4] brcmfmac: p2p and normal ap access are not always
 possible at the same time
To: Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170227214539.16422-1-hdegoede@redhat.com>
 <20170227214539.16422-2-hdegoede@redhat.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <33689f32-1bf8-98f8-df65-278de097e435@broadcom.com> (sfid-20170307_110625_123738_93CF800D)
Date: Tue, 7 Mar 2017 11:03:18 +0100
MIME-Version: 1.0
In-Reply-To: <20170227214539.16422-2-hdegoede@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 27-2-2017 22:45, Hans de Goede wrote:
> The firmware responding with -EBUSY when trying to add an extra virtual-if
> is a normal thing, do not print an error for this.

This may be something we need to look into. It seems to me the interface
combinations needs to be fixed so we do not try to provision firmware.
Can you explain the scenario here?

Regards,
Arend

> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 14 ++++++++++----
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c     |  5 ++++-
>  2 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 7ffc4ab..c54e8b4 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -688,11 +688,17 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
>  		return ERR_PTR(-EINVAL);
>  	}
>  
> -	if (IS_ERR(wdev))
> -		brcmf_err("add iface %s type %d failed: err=%d\n",
> -			  name, type, (int)PTR_ERR(wdev));
> -	else
> +	if (IS_ERR(wdev)) {
> +		err = PTR_ERR(wdev);
> +		if (err != -EBUSY)
> +			brcmf_err("add iface %s type %d failed: err=%d\n",
> +				  name, type, err);
> +		else
> +			brcmf_dbg(INFO, "add iface %s type %d failed: err=%d\n",
> +				  name, type, err);
> +	} else {
>  		brcmf_cfg80211_update_proto_addr_mode(wdev);
> +	}
>  
>  	return wdev;
>  }
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> index de19c7c..b5df0a0 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> @@ -2090,7 +2090,10 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
>  	/* Initialize P2P Discovery in the firmware */
>  	err = brcmf_fil_iovar_int_set(pri_ifp, "p2p_disc", 1);
>  	if (err < 0) {
> -		brcmf_err("set p2p_disc error\n");
> +		if (err != -EBUSY)
> +			brcmf_err("set p2p_disc error\n");
> +		else
> +			brcmf_dbg(INFO, "set p2p_disc error\n");
>  		brcmf_fweh_p2pdev_setup(pri_ifp, false);
>  		brcmf_cfg80211_arm_vif_event(p2p->cfg, NULL);
>  		goto fail;
> 
