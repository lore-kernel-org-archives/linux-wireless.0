Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbaFTO3U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2014 10:29:20 -0400
Message-ID: <53A44517.4070001@redhat.com> (sfid-20140620_162931_692399_63BA5C05)
Date: Fri, 20 Jun 2014 16:28:39 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: Chen-Yu Tsai <wens@csie.org>, linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 4/4] brcmfmac: Fix OOB interrupt not working for BCM43362
References: <1402941407-8210-1-git-send-email-hdegoede@redhat.com> <1402941407-8210-5-git-send-email-hdegoede@redhat.com> <53A1F8D1.1050204@broadcom.com>
In-Reply-To: <53A1F8D1.1050204@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 06/18/2014 10:38 PM, Arend van Spriel wrote:
> On 16-06-14 19:56, Hans de Goede wrote:
>> It has taken me a long long time to get the OOB interrupt working on the
>> AP6210 sdio wifi/bt module found on various Allwinner A20 boards. In the
>> end I found these magic register pokes in the cubietruck kernel tree:
>> https://github.com/cubieboard2/linux-sunxi/commit/7f08ba395617d17e7a711507503d89a50406fe7a
>>
>> I'm not entirely sure if this specific to the AP6210 module, or if this
>> should be done for all BCM43362 sdio devices.
> 
> Bit late response but it took some digging. It turns out this is done for all bcm43362 in internal/proprietary driver.
> 
> +Reviewed-by: Arend van Spriel <arend@broadcom.com>

Thanks, I've updated the commit msg with this info and added
your Reviewed-by for v3 of this patch-set.

>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>   drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c | 16 ++++++++++++++++
>>   1 file changed, 16 insertions(+)
>>
>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
>> index 0fc707c..58e86a5 100644
>> --- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
>> +++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
>> @@ -39,7 +39,9 @@
>>   #include <brcm_hw_ids.h>
>>   #include <brcmu_utils.h>
>>   #include <brcmu_wifi.h>
>> +#include <chipcommon.h>
>>   #include <soc.h>
>> +#include "chip.h"
> 
> Not sure why chip.h is needed here.

For the CORE_CC_REG macro used below.

> 
>>   #include "dhd_bus.h"
>>   #include "dhd_dbg.h"
>>   #include "sdio_host.h"
>> @@ -119,6 +121,7 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
>>   {
>>       int ret = 0;
>>       u8 data;
>> +    u32 addr, gpiocontrol;
>>       unsigned long flags;
>>
>>       if ((sdiodev->pdata) && (sdiodev->pdata->oob_irq_supported)) {
>> @@ -148,6 +151,19 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
>>
>>           sdio_claim_host(sdiodev->func[1]);
>>
>> +        if (sdiodev->bus_if->chip == BCM43362_CHIP_ID) {
>> +            /* assign GPIO to SDIO core */
>> +            addr = CORE_CC_REG(SI_ENUM_BASE, gpiocontrol);
> 
> I don't like the assumption that chipcommon core register space is always at SI_ENUM_BASE although it is for BCM43362. Let's keep it for now.

Ok.

> 
>> +            gpiocontrol = brcmf_sdiod_regrl(sdiodev, addr, &ret);
>> +            gpiocontrol |= 0x2;
>> +            brcmf_sdiod_regwl(sdiodev, addr, gpiocontrol, &ret);
>> +
>> +            brcmf_sdiod_regwb(sdiodev, SBSDIO_GPIO_SELECT, 0xf,
>> +                      &ret);
>> +            brcmf_sdiod_regwb(sdiodev, SBSDIO_GPIO_OUT, 0, &ret);
>> +            brcmf_sdiod_regwb(sdiodev, SBSDIO_GPIO_EN, 0x2, &ret);
>> +        }
>> +
>>           /* must configure SDIO_CCCR_IENx to enable irq */
>>           data = brcmf_sdiod_regrb(sdiodev, SDIO_CCCR_IENx, &ret);
>>           data |= 1 << SDIO_FUNC_1 | 1 << SDIO_FUNC_2 | 1;
>>
> 
> Regards,
> Arend

Regards,

Hans
