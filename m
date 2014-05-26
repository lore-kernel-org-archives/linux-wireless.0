Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:3322 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaEZJU6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 05:20:58 -0400
Message-ID: <53830776.1030308@broadcom.com> (sfid-20140526_112113_785937_78909087)
Date: Mon, 26 May 2014 11:20:54 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
	Chris Ball <chris@printf.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-mmc@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	devicetree <devicetree@vger.kernel.org>,
	<linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 09/11] brcmfmac: Fix OOB interrupt not working for BCM43362
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com> <1401090486-4414-10-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1401090486-4414-10-git-send-email-hdegoede@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/26/14 09:48, Hans de Goede wrote:
> It has taken me a long long time to get the OOB interrupt working on the
> AP6210 sdio wifi/bt module found on various Allwinner A20 boards. In the
> end I found these magic register pokes in the cubietruck kernel tree:
> https://github.com/cubieboard2/linux-sunxi/commit/7f08ba395617d17e7a711507503d89a50406fe7a
>
> I'm not entirely sure if this specific to the AP6210 module, or if this
> should be done for all BCM43362 sdio devices.

This magic is not in our host drivers so my guess is that it is board 
specific. This means the nvram file provided to the firmware should have 
this specified. Can you send me yours?

Regards,
Arend

> Signed-off-by: Hans de Goede<hdegoede@redhat.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> index 0fc707c..2369a0f 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> @@ -39,7 +39,9 @@
>   #include<brcm_hw_ids.h>
>   #include<brcmu_utils.h>
>   #include<brcmu_wifi.h>
> +#include<chipcommon.h>
>   #include<soc.h>
> +#include "chip.h"
>   #include "dhd_bus.h"
>   #include "dhd_dbg.h"
>   #include "sdio_host.h"
> @@ -119,6 +121,7 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
>   {
>   	int ret = 0;
>   	u8 data;
> +	u32 addr, gpiocontrol;
>   	unsigned long flags;
>
>   	if ((sdiodev->pdata)&&  (sdiodev->pdata->oob_irq_supported)) {
> @@ -148,6 +151,21 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
>
>   		sdio_claim_host(sdiodev->func[1]);
>
> +		if (sdiodev->bus_if->chip == BCM43362_CHIP_ID) {
> +			addr = CORE_CC_REG(SI_ENUM_BASE, gpiocontrol);
> +			gpiocontrol = brcmf_sdiod_regrl(sdiodev, addr,&ret);
> +			gpiocontrol |= 0x2;
> +			brcmf_sdiod_regwl(sdiodev, addr, gpiocontrol,&ret);
> +
> +			/* SPROM_ADDR_HIGH ? perhaps the defines name is off */
> +			brcmf_sdiod_regwb(sdiodev, SBSDIO_SPROM_ADDR_HIGH, 0xf,
> +					&ret);
> +			brcmf_sdiod_regwb(sdiodev, SBSDIO_CHIP_CTRL_DATA, 0,
> +					&ret);
> +			brcmf_sdiod_regwb(sdiodev, SBSDIO_CHIP_CTRL_EN, 0x2,
> +					&ret);
> +		}
> +
>   		/* must configure SDIO_CCCR_IENx to enable irq */
>   		data = brcmf_sdiod_regrb(sdiodev, SDIO_CCCR_IENx,&ret);
>   		data |= 1<<  SDIO_FUNC_1 | 1<<  SDIO_FUNC_2 | 1;

