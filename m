Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:47741 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbcABIua (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2016 03:50:30 -0500
Message-ID: <56878F52.5070308@broadcom.com> (sfid-20160102_095140_806033_2A7DDCA4)
Date: Sat, 2 Jan 2016 09:50:26 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: SF Markus Elfring <elfring@users.sourceforge.net>,
	<brcm80211-dev-list@broadcom.com>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>
CC: LKML <linux-kernel@vger.kernel.org>,
	<kernel-janitors@vger.kernel.org>,
	Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] net-brcmfmac: Delete an unnecessary variable initialisation
 in brcmf_sdio_download_firmware()
References: <566ABCD9.1060404@users.sourceforge.net> <5686D2E0.2010309@users.sourceforge.net>
In-Reply-To: <5686D2E0.2010309@users.sourceforge.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/01/2016 08:26 PM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 1 Jan 2016 20:20:15 +0100

I think it has been said over and over, but please use driver name only 
as prefix. I don't see value to prepend it with 'net-'.

> Omit explicit initialisation at the beginning for one local variable
> that is redefined before its first use.
>

That being said here is my....

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index ceb2a75..c21eeb1 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -3260,7 +3260,7 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
>   					const struct firmware *fw,
>   					void *nvram, u32 nvlen)
>   {
> -	int bcmerror = -EFAULT;
> +	int bcmerror;
>   	u32 rstvec;
>
>   	sdio_claim_host(bus->sdiodev->func[1]);
>

