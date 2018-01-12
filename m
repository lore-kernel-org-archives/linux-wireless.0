Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:40956 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754745AbeALKzj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Jan 2018 05:55:39 -0500
Received: by mail-qt0-f193.google.com with SMTP id u42so5509165qte.7
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jan 2018 02:55:38 -0800 (PST)
Subject: Re: [PATCH v2] brcmfmac: fix CLM load error for legacy chips when
 user helper is enabled
To: Wright Feng <wright.feng@cypress.com>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org,
        chi-hsien.lin@cypress.com
References: <1515743056-8109-1-git-send-email-wright.feng@cypress.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A589428.7020502@broadcom.com> (sfid-20180112_115544_229112_5B57937E)
Date: Fri, 12 Jan 2018 11:55:36 +0100
MIME-Version: 1.0
In-Reply-To: <1515743056-8109-1-git-send-email-wright.feng@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/12/2018 8:44 AM, Wright Feng wrote:
> For legacy chips without CLM blob files, kernel with user helper function
> returns -EAGAIN when we request_firmware() for blob file. In this case,
> brcmf_bus_started gets error and failed to bring up legacy chips.
> Because of that, we should continue with CLM data currently present in
> firmware if getting -EAGAIN when doing request_firmware().
>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> ---
> v2: remove retry from patch v1
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> index 6a59d06..0baab4c 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> @@ -182,7 +182,7 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
>
>   	err = request_firmware(&clm, clm_name, dev);
>   	if (err) {
> -		if (err == -ENOENT) {
> +		if (err == -ENOENT || err == -EAGAIN) {
>   			brcmf_dbg(INFO, "continue with CLM data currently present in firmware\n");
>   			return 0;
>   		}

Hi Wright,

Why don't we just fall-back to "CLM in firmware" regardless of the error 
code? Also it might be better to use brcmf_info() instead of 
brcmf_dbg(INFO, ..).

Regards,
Arend
