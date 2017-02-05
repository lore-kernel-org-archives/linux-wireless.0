Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36737 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751956AbdBETtl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Feb 2017 14:49:41 -0500
Received: by mail-wm0-f48.google.com with SMTP id c85so97627887wmi.1
        for <linux-wireless@vger.kernel.org>; Sun, 05 Feb 2017 11:49:41 -0800 (PST)
Subject: Re: [PATCH V3 5/9] brcmfmac: pcie: store private pointer to struct
 brcmf_pub
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170202213321.11591-1-zajec5@gmail.com>
 <20170202213321.11591-5-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <701140c2-0d9b-7496-c8e8-db2e6064e742@broadcom.com> (sfid-20170205_205004_287230_6D74AE41)
Date: Sun, 5 Feb 2017 20:49:37 +0100
MIME-Version: 1.0
In-Reply-To: <20170202213321.11591-5-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2-2-2017 22:33, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Getting this pointer in PCIe code is not trivial and requires using
> dev_get_drvdata helper which adds extra line of code. Having access to
> this struct is useful for using generic stuff and e.g. improving logging
> messages.

It is actually by design that getting the pointer is not trivial. We
have made an effort to use struct device pointer as handle between
common and bus-specific code. So I have some reservations about the
approach in this patch series. I had a few days off so I want to look at
it in more detail tomorrow and probably give it a spin.

Regards,
Arend

> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index 6fae4cf3f6ab..8a3c6e2e4b38 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -265,6 +265,7 @@ struct brcmf_pciedev_info {
>  	void (*write_ptr)(struct brcmf_pciedev_info *devinfo, u32 mem_offset,
>  			  u16 value);
>  	struct brcmf_mp_device *settings;
> +	struct brcmf_pub *pub;
>  };
>  
>  struct brcmf_pcie_ringbuf {
> @@ -1564,14 +1565,18 @@ static void brcmf_pcie_release_resource(struct brcmf_pciedev_info *devinfo)
>  
>  static int brcmf_pcie_attach_bus(struct brcmf_pciedev_info *devinfo)
>  {
> +	struct device *dev = &devinfo->pdev->dev;
> +	struct brcmf_bus *bus = dev_get_drvdata(dev);
>  	int ret;
>  
>  	/* Attach to the common driver interface */
> -	ret = brcmf_attach(&devinfo->pdev->dev, devinfo->settings);
> +	ret = brcmf_attach(dev, devinfo->settings);
>  	if (ret) {
>  		brcmf_err("brcmf_attach failed\n");
>  	} else {
> -		ret = brcmf_bus_started(&devinfo->pdev->dev);
> +		devinfo->pub = bus->drvr;
> +
> +		ret = brcmf_bus_started(dev);
>  		if (ret)
>  			brcmf_err("dongle is not responding\n");
>  	}
> 
