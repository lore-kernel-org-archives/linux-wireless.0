Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:46996 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750790AbeAPIzF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 03:55:05 -0500
Received: by mail-qt0-f194.google.com with SMTP id o35so7200362qtj.13
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jan 2018 00:55:05 -0800 (PST)
Subject: Re: [PATCH v3] brcmfmac: fix CLM load error for legacy chips when
 user helper is enabled
To: Wright Feng <wright.feng@cypress.com>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org,
        chi-hsien.lin@cypress.com
References: <1516083246-16013-1-git-send-email-wright.feng@cypress.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A5DBDE6.2080403@broadcom.com> (sfid-20180116_095509_474156_C4F9FD15)
Date: Tue, 16 Jan 2018 09:55:02 +0100
MIME-Version: 1.0
In-Reply-To: <1516083246-16013-1-git-send-email-wright.feng@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/16/2018 7:14 AM, Wright Feng wrote:
> For legacy chips without CLM blob files, kernel with user helper function
> returns -EAGAIN when we request_firmware(), and then driver got failed
> when bringing up legacy chips. We expect the CLM blob file for legacy chip
> is not existence in firmware path, but the -ENOENT error is transferred to
> -EAGAIN in firmware_class.c with user helper.
> Because of that, we continue with CLM data currently present in firmware
> if getting error from doing request_firmware().

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> ---
> v2: remove retry from patch v1
> v3: remove redundant log print
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 9 +++------
>   1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> index 6a59d06..b0ef0e7 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> @@ -182,12 +182,9 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
>
>   	err = request_firmware(&clm, clm_name, dev);
>   	if (err) {
> -		if (err == -ENOENT) {
> -			brcmf_dbg(INFO, "continue with CLM data currently present in firmware\n");
> -			return 0;
> -		}
> -		brcmf_err("request CLM blob file failed (%d)\n", err);
> -		return err;
> +		brcmf_info("no clm_blob available(%d), device may have limited channels available\n",
> +			   err);
> +		return 0;

Looking good. However, let's nitpick (my bad). Please make it 
"..available (err=%d), ...".

Regards,
Arend
