Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:44132 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbeAOTyn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 14:54:43 -0500
Received: by mail-qt0-f173.google.com with SMTP id m59so15568080qte.11
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jan 2018 11:54:43 -0800 (PST)
Subject: Re: [PATCH v2] brcmfmac: fix CLM load error for legacy chips when
 user helper is enabled
To: Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <1515743056-8109-1-git-send-email-wright.feng@cypress.com>
 <5A589428.7020502@broadcom.com> <87a7xjs4xa.fsf@kamboji.qca.qualcomm.com>
 <713a8666-8b72-9198-03a3-a3656c5cb84d@cypress.com>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A5D06FF.2060909@broadcom.com> (sfid-20180115_205448_037331_195E5CCD)
Date: Mon, 15 Jan 2018 20:54:39 +0100
MIME-Version: 1.0
In-Reply-To: <713a8666-8b72-9198-03a3-a3656c5cb84d@cypress.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/15/2018 11:09 AM, Wright Feng wrote:
>

[...]

> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 12
> ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> index 6a59d06..aaab0e6 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> @@ -182,12 +182,12 @@ static int brcmf_c_process_clm_blob(struct
> brcmf_if *ifp)
>
>       err = request_firmware(&clm, clm_name, dev);
>       if (err) {
> -        if (err == -ENOENT) {
> -            brcmf_dbg(INFO, "continue with CLM data currently present
> in firmware\n");
> -            return 0;
> -        }
> -        brcmf_err("request CLM blob file failed (%d)\n", err);
> -        return err;
> +        if (err == -ENOENT || err == -EAGAIN)
> +            brcmf_info("continue with CLM data in FW\n");
> +        else
> +            brcmf_err("request clm_blob failed(%d) continue with CLM
> data in FW\n",
> +                  err);

Don't see much value in doing it this way. Either way we need to inform 
the user about the consequence of this, ie.:

	brcmf_info("no clm_blob available (%d). device may have limited 
channels available\n", err);
> +        return 0;
>       }

Regards,
Arend
