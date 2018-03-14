Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34264 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbeCNVn2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 17:43:28 -0400
Received: by mail-oi0-f67.google.com with SMTP id e79so44278oih.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Mar 2018 14:43:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1521054179-4030-1-git-send-email-stefan.wahren@i2se.com>
References: <1521054179-4030-1-git-send-email-stefan.wahren@i2se.com>
From: Franky Lin <franky.lin@broadcom.com>
Date: Wed, 14 Mar 2018 14:43:06 -0700
Message-ID: <CA+8PC_eb1hDyWKGh1HEYqoqookT6wuRTcGPm00srtFLxhUktYg@mail.gmail.com> (sfid-20180314_224331_921252_791AC33E)
Subject: Re: [PATCH] wireless: brcmfmac: cfg80211: Fix check for ISO3166 code
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list@cypress.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 14, 2018 at 12:02 PM, Stefan Wahren <stefan.wahren@i2se.com> wrote:
> The commit "regulatory: add NUL to request alpha2" increases the length of
> alpha2 to 3. This causes a regression on brcmfmac, because
> brcmf_cfg80211_reg_notifier() expect valid ISO3166 codes in the complete
> array. So fix this accordingly.
>
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Acked-by: Franky Lin <franky.lin@broadcom.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 74a8302..5ed718d 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -6805,7 +6805,7 @@ static void brcmf_cfg80211_reg_notifier(struct wiphy *wiphy,
>                 return;
>
>         /* ignore non-ISO3166 country codes */
> -       for (i = 0; i < sizeof(req->alpha2); i++)
> +       for (i = 0; i < 2; i++)
>                 if (req->alpha2[i] < 'A' || req->alpha2[i] > 'Z') {
>                         brcmf_err("not an ISO3166 code (0x%02x 0x%02x)\n",
>                                   req->alpha2[0], req->alpha2[1]);
> --
> 2.7.4
>
