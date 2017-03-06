Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:33065 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753156AbdCFNHe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 08:07:34 -0500
Received: by mail-qk0-f180.google.com with SMTP id y76so20861617qkb.0
        for <linux-wireless@vger.kernel.org>; Mon, 06 Mar 2017 05:07:33 -0800 (PST)
Subject: Re: [PATCH] 4.9.13 brcmfmac: fix use-after-free on resume
To: Daniel J Blueman <daniel@quora.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>
References: <CAMVG2stHA9qSUiRFBW=-4jhSMk-o7Frext+Qf9JK3Fo822XHhw@mail.gmail.com>
Cc: Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <3626494c-8482-d003-1c83-e6171f6990a8@broadcom.com> (sfid-20170306_140751_768773_07C1F718)
Date: Mon, 6 Mar 2017 14:00:09 +0100
MIME-Version: 1.0
In-Reply-To: <CAMVG2stHA9qSUiRFBW=-4jhSMk-o7Frext+Qf9JK3Fo822XHhw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-wireless

On 6-3-2017 8:14, Daniel J Blueman wrote:
> KASAN reported 'struct wireless_dev wdev' was read after being freed.
> Fix by freeing after the access.

I would rather like to see the KASAN report, because something is off
here. This function is called with wdev as a parameter so how can it be
accessed after free here? brcmf_remove_interface() does not free the
wdev nor the brcmf_cfg80211_vif instance which contains the wdev.

Regards,
Arend

> Signed-off-by: Daniel J Blueman <daniel@quora.org>
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> index de19c7c..aa0f470 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> @@ -2288,12 +2288,13 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy,
> struct wireless_dev *wdev)
>                 else
>                         err = 0;
>         }
> -       brcmf_remove_interface(vif->ifp, true);
> 
> -       brcmf_cfg80211_arm_vif_event(cfg, NULL);
>         if (vif->wdev.iftype != NL80211_IFTYPE_P2P_DEVICE)
>                 p2p->bss_idx[P2PAPI_BSSCFG_CONNECTION].vif = NULL;
> 
> +       brcmf_remove_interface(vif->ifp, true);
> +       brcmf_cfg80211_arm_vif_event(cfg, NULL);
> +
>         return err;
>  }
> 
