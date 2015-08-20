Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:33383 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbbHTQQi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 12:16:38 -0400
Received: by iods203 with SMTP id s203so51844085iod.0
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2015 09:16:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1439708139-7527-4-git-send-email-arend@broadcom.com>
References: <1439708139-7527-1-git-send-email-arend@broadcom.com>
	<1439708139-7527-4-git-send-email-arend@broadcom.com>
Date: Thu, 20 Aug 2015 18:16:37 +0200
Message-ID: <CACna6rzrfGwpNS1nm1wDhGvu5voKMGH4BE1w5ZS0WeQUbgZUAQ@mail.gmail.com> (sfid-20150820_181641_112045_4498F3F8)
Subject: Re: [PATCH V2 3/7] brcmfmac: Increase nr of supported flowrings.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 August 2015 at 08:55, Arend van Spriel <arend@broadcom.com> wrote:
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/flowring.h b/drivers/net/wireless/brcm80211/brcmfmac/flowring.h
> index 5551861..3a7d9c2 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/flowring.h
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/flowring.h
> @@ -16,7 +16,7 @@
>  #define BRCMFMAC_FLOWRING_H
>
>
> -#define BRCMF_FLOWRING_HASHSIZE                256
> +#define BRCMF_FLOWRING_HASHSIZE                512             /* has to be 2^x */
>  #define BRCMF_FLOWRING_INVALID_ID      0xFFFFFFFF

Applying patch *and* switching back to 256 let brcmfmac work again
with my BCM43602. Not sure if it helps to understand the problem much.
