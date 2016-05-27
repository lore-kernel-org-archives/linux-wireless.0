Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35234 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973AbcE0JNa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2016 05:13:30 -0400
Received: by mail-oi0-f49.google.com with SMTP id w184so157992554oiw.2
        for <linux-wireless@vger.kernel.org>; Fri, 27 May 2016 02:13:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1464338991-8284-1-git-send-email-arend@broadcom.com>
References: <1464338991-8284-1-git-send-email-arend@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 27 May 2016 19:13:10 +1000
Message-ID: <CAGRGNgWi+q=771XzQHz5dO4af0ySWc+fLWGM32HjWTXe8wMs2w@mail.gmail.com> (sfid-20160527_111335_419213_3557CD4E)
Subject: Re: [PATCH V5] brcmfmac: print errors if creating interface fails
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Fri, May 27, 2016 at 6:49 PM, Arend van Spriel <arend@broadcom.com> wrote:
> From: Rafał Miłecki <zajec5@gmail.com>
>
> This is helpful for debugging. Without this all I was getting from "iw"
> command on failed creating of P2P interface was:
>> command failed: Too many open files in system (-23)
>
> Signed-off-by: Rafal Milecki <zajec5@gmail.com>
> [arend@broadcom.com: reduce error prints upon iface creation]
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> V2: s/in/if/ in commit message
> V3: Add one more error message as suggested by Arend
> V4: Also update brcmf_cfg80211_add_iface & print error for AP
> V5: remove error prints from p2p.c
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 12 ++++++++++--
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c      |  2 --
>  2 files changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index d0631b6..64ed003 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -671,18 +671,26 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
>                 wdev = brcmf_ap_add_vif(wiphy, name, flags, params);
>                 if (!IS_ERR(wdev))
>                         brcmf_cfg80211_update_proto_addr_mode(wdev);
> -               return wdev;
> +               break;
>         case NL80211_IFTYPE_P2P_CLIENT:
>         case NL80211_IFTYPE_P2P_GO:
>         case NL80211_IFTYPE_P2P_DEVICE:
>                 wdev = brcmf_p2p_add_vif(wiphy, name, name_assign_type, type, flags, params);
>                 if (!IS_ERR(wdev))
>                         brcmf_cfg80211_update_proto_addr_mode(wdev);
> -               return wdev;
> +               break;
>         case NL80211_IFTYPE_UNSPECIFIED:
>         default:
>                 return ERR_PTR(-EINVAL);
>         }
> +
> +       if (IS_ERR(wdev))
> +               brcmf_err("add iface %s type %d failed: err=%d\n",
> +                         name, type, PTR_ERR(wdev));
> +       else
> +               brcmf_cfg80211_update_proto_addr_mode(wdev);

Doesn't this now get called twice?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
