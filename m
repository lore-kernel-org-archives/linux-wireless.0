Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:14481 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbbEHJab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 05:30:31 -0400
Message-ID: <554C8234.4010402@broadcom.com> (sfid-20150508_113036_796953_B9CDFE7E)
Date: Fri, 8 May 2015 11:30:28 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	<linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	<brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCH] brcmfmac: check result of USB firmware request
References: <1431000783-17411-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1431000783-17411-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/07/15 14:13, Rafał Miłecki wrote:
> This prevents silence failures with driver waiting (infinitely) for a
> callback.

Looks like proper thing to do :-p

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---
> I don't really have any opinion if this should go for next or as a fix.
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/usb.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
> index 5df6aa7..daba86d 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
> @@ -1270,8 +1270,13 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo)
>   	bus->chiprev = bus_pub->chiprev;
>
>   	/* request firmware here */
> -	brcmf_fw_get_firmwares(dev, 0, brcmf_usb_get_fwname(devinfo), NULL,
> -			       brcmf_usb_probe_phase2);
> +	ret = brcmf_fw_get_firmwares(dev, 0, brcmf_usb_get_fwname(devinfo),
> +				     NULL, brcmf_usb_probe_phase2);
> +	if (ret) {
> +		brcmf_err("firmware request failed: %d\n", ret);
> +		goto fail;
> +	}
> +
>   	return 0;
>
>   fail:

