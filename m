Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:34983 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752186AbdARMsG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 07:48:06 -0500
Received: by mail-lf0-f52.google.com with SMTP id n124so10485620lfd.2
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jan 2017 04:48:05 -0800 (PST)
Subject: Re: [PATCH V2 4/4] brcmfmac: rename brcmf_bus_start function to
 brcmf_bus_started
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170118104854.32231-1-zajec5@gmail.com>
 <20170118104854.32231-4-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <df3919be-b1f2-a1ac-a31a-df20d6d33cf7@broadcom.com> (sfid-20170118_134809_961070_557A5DF5)
Date: Wed, 18 Jan 2017 13:40:01 +0100
MIME-Version: 1.0
In-Reply-To: <20170118104854.32231-4-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18-1-2017 11:48, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This intends to make init/attach process slightly easier to follow.
> 
> What driver was doing in brcmf_bus_start wasn't bus specific at all and
> function brcmf_bus_stop wasn't undoing things done there. This function
> is supposed to be called by bus specific code when the bus is ready.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> V2: Use "brcmf_bus_started" name instead of "brcmf_attach_phase2", don't rename
>     brcmf_attach.
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h    | 2 +-
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 2 +-
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c   | 2 +-
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c   | 2 +-
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   | 2 +-
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c    | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
> index b5bb971..76693df 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
> @@ -238,7 +238,7 @@ void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success);
>  /* Configure the "global" bus state used by upper layers */
>  void brcmf_bus_change_state(struct brcmf_bus *bus, enum brcmf_bus_state state);
>  
> -int brcmf_bus_start(struct device *dev);
> +int brcmf_bus_started(struct device *dev);
>  s32 brcmf_iovar_data_set(struct device *dev, char *name, void *data, u32 len);
>  void brcmf_bus_add_txhdrlen(struct device *dev, uint len);
>  
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> index 3e15d64..5fb4a14 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> @@ -74,7 +74,7 @@ module_param_named(roamoff, brcmf_roamoff, int, S_IRUSR);
>  MODULE_PARM_DESC(roamoff, "Do not use internal roaming engine");
>  
>  #ifdef DEBUG
> -/* always succeed brcmf_bus_start() */
> +/* always succeed brcmf_bus_started() */
>  static int brcmf_ignore_probe_fail;
>  module_param_named(ignore_probe_fail, brcmf_ignore_probe_fail, int, 0);
>  MODULE_PARM_DESC(ignore_probe_fail, "always succeed probe for debugging");
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> index 372d2c4..b73a55b 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> @@ -966,7 +966,7 @@ static int brcmf_revinfo_read(struct seq_file *s, void *data)
>  	return 0;
>  }
>  
> -int brcmf_bus_start(struct device *dev)
> +int brcmf_bus_started(struct device *dev)
>  {
>  	int ret = -1;
>  	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index 048027f..19db8f2 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -1572,7 +1572,7 @@ static int brcmf_pcie_attach_bus(struct brcmf_pciedev_info *devinfo)
>  	if (ret) {
>  		brcmf_err("brcmf_attach failed\n");
>  	} else {
> -		ret = brcmf_bus_start(&devinfo->pdev->dev);
> +		ret = brcmf_bus_started(&devinfo->pdev->dev);
>  		if (ret)
>  			brcmf_err("dongle is not responding\n");
>  	}
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index dfb0658..5298582 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -4065,7 +4065,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev,
>  
>  	sdio_release_host(sdiodev->func[1]);
>  
> -	err = brcmf_bus_start(dev);
> +	err = brcmf_bus_started(dev);
>  	if (err != 0) {
>  		brcmf_err("dongle is not responding\n");
>  		goto fail;
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
> index 2f978a3..d93ebbd 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
> @@ -1148,7 +1148,7 @@ static int brcmf_usb_bus_setup(struct brcmf_usbdev_info *devinfo)
>  	if (ret)
>  		goto fail;
>  
> -	ret = brcmf_bus_start(devinfo->dev);
> +	ret = brcmf_bus_started(devinfo->dev);
>  	if (ret)
>  		goto fail;
>  
> 
