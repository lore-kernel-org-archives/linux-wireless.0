Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:34681 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750797AbdFPUSD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 16:18:03 -0400
Received: by mail-wm0-f51.google.com with SMTP id d64so6091881wmf.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jun 2017 13:18:02 -0700 (PDT)
Subject: Re: [PATCH 1/2] brcmfmac: Log chip id and revision
To: Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Jelle van der Waa <jelle@vdwaa.nl>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
References: <20170616131449.12108-1-hdegoede@redhat.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <25322f02-1e26-16b4-21b5-3e55a5a9f5ff@broadcom.com> (sfid-20170616_221807_103046_F0AD8388)
Date: Fri, 16 Jun 2017 22:18:00 +0200
MIME-Version: 1.0
In-Reply-To: <20170616131449.12108-1-hdegoede@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16-06-17 15:14, Hans de Goede wrote:
> For debugging some problems, it is useful to know the chip revision
> add a brcmf_info message logging this.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index e03450059b06..4ed40c94bda9 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -4214,6 +4214,8 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
>  	if (ret)
>  		goto fail;
>  
> +	brcmf_info("Loading firmware %s for chip %08x rev %08x\n",
> +		   sdiodev->fw_name, bus->ci->chip, bus->ci->chiprev);

I would prefer to have this in brcmf_fw_map_chip_to_name() in
firmware.c, ie.:

brcmf_info("mapping chip %x(%d) rev %d\n", chip, chip, chiprev);

That way it will be done for all host-interfaces.

Regards,
Arend
