Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34943 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192AbcE3FpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2016 01:45:17 -0400
Received: by mail-oi0-f68.google.com with SMTP id h125so23556411oib.2
        for <linux-wireless@vger.kernel.org>; Sun, 29 May 2016 22:45:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1464339268-27916-1-git-send-email-arend@broadcom.com>
References: <1464339268-27916-1-git-send-email-arend@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 30 May 2016 15:44:56 +1000
Message-ID: <CAGRGNgUWSLNFoDnfLsA_Rr6DG_6c0Xr0dx3-ZuqZBcC=ZbbKFA@mail.gmail.com> (sfid-20160530_074523_678651_8D2E9309)
Subject: Re: [PATCH V6] brcmfmac: print errors if creating interface fails
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Fri, May 27, 2016 at 6:54 PM, Arend van Spriel <arend@broadcom.com> wrote:
> From: Rafał Miłecki <zajec5@gmail.com>
>
> This is helpful for debugging. Without this all I was getting from "iw"
> command on failed creating of P2P interface was:
>> command failed: Too many open files in system (-23)
>
> Signed-off-by: Rafal Milecki <zajec5@gmail.com>
> [arend@broadcom.com: reduce error prints upon iface creation]
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

FWIW, this is:

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

Julian Calaby


> ---
> V2: s/in/if/ in commit message
> V3: Add one more error message as suggested by Arend
> V4: Also update brcmf_cfg80211_add_iface & print error for AP
> V5: remove error prints from p2p.c
> V6: fix compiler warning and remove duplicate calls
> ---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c  | 16 ++++++++++------
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c   |  2 --
>  2 files changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index d0631b6..2248e8e 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -669,20 +669,24 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
>                 return ERR_PTR(-EOPNOTSUPP);
>         case NL80211_IFTYPE_AP:
>                 wdev = brcmf_ap_add_vif(wiphy, name, flags, params);
> -               if (!IS_ERR(wdev))
> -                       brcmf_cfg80211_update_proto_addr_mode(wdev);
> -               return wdev;
> +               break;
>         case NL80211_IFTYPE_P2P_CLIENT:
>         case NL80211_IFTYPE_P2P_GO:
>         case NL80211_IFTYPE_P2P_DEVICE:
>                 wdev = brcmf_p2p_add_vif(wiphy, name, name_assign_type, type, flags, params);
> -               if (!IS_ERR(wdev))
> -                       brcmf_cfg80211_update_proto_addr_mode(wdev);
> -               return wdev;
> +               break;
>         case NL80211_IFTYPE_UNSPECIFIED:
>         default:
>                 return ERR_PTR(-EINVAL);
>         }
> +
> +       if (IS_ERR(wdev))
> +               brcmf_err("add iface %s type %d failed: err=%d\n",
> +                         name, type, (int)PTR_ERR(wdev));
> +       else
> +               brcmf_cfg80211_update_proto_addr_mode(wdev);
> +
> +       return wdev;
>  }
>
>  static void brcmf_scan_config_mpc(struct brcmf_if *ifp, int mpc)
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> index a70cda6..a812381 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> @@ -2030,8 +2030,6 @@ static int brcmf_p2p_request_p2p_if(struct brcmf_p2p_info *p2p,
>
>         err = brcmf_fil_iovar_data_set(ifp, "p2p_ifadd", &if_request,
>                                        sizeof(if_request));
> -       if (err)
> -               return err;
>
>         return err;
>  }
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
