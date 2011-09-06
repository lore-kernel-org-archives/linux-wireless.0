Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:41611
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754204Ab1IFMJA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 08:09:00 -0400
Message-ID: <4E660D52.30600@compulab.co.il> (sfid-20110906_140908_172697_B0FAFF78)
Date: Tue, 06 Sep 2011 15:08:50 +0300
From: Ilya Ledvich <ilya@compulab.co.il>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	linux-wireless@vger.kernel.org,
	Igor Grinberg <grinberg@compulab.co.il>,
	Ido Yariv <ido@wizery.com>
Subject: Re: Problem with wl1271
References: <4E5B9B44.6080508@compulab.co.il>	 <1314627555.2296.353.camel@cumari>  <4E5CF23F.2060806@compulab.co.il> <1314786703.2296.566.camel@cumari> <4E648383.10505@compulab.co.il>
In-Reply-To: <4E648383.10505@compulab.co.il>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/05/2011 11:08 AM, Ilya Ledvich wrote:
> On 08/31/2011 01:31 PM, Luciano Coelho wrote:
>> Hi Ilya,
>>
>> On Tue, 2011-08-30 at 17:22 +0300, Ilya Ledvich wrote:
>>> On 08/29/2011 05:19 PM, Luciano Coelho wrote:
>>>> On Mon, 2011-08-29 at 16:59 +0300, Ilya Ledvich wrote:
>>>>> I load the wl12xx_sdio module and then set the interface up; no
>>>>> obvious
>>>>> error
>>>>> is seen. When I run any other command (e.g. interface down/up,
>>>>> iwlist scan).
>>>>> I have "/wl1271: ERROR ELP wakeup timeout!/" error. Then the driver
>>>>> tries to
>>>>> recover the chip; this eventually leads to the
>>>>> "/wl1271: ERROR sdio read failed (-110)/" error. The log file for
>>>>> ifconfig wlan0 up - down - up sequence is attached.
>>>> This looks like an SDIO power management problem. Do you have
>>>> CONFIG_PM_RUNTIME enabled in your kernel?
>>>>
>>>> Can you send us your .config and the patch where you modified the
>>>> board-cm-t35.c file?
>>>>
>>> Hi Luciano,
>>> Sorry, my mailer converted the previous e-mail to html...
>>> I thank you for fast response.
>>> The required files are are attached. The CONFIG_PM_RUNTIME is enabled
>>> indeed.
>>
>> This seems to be a problem in your board file. You have probably not
>> configured the interrupt line correctly. Are you sure all the MUXing is
>> correct? Also, please check the regulator settings for your card.
>>
>> I have attached the patch I use to add this stuff to my beagleboard.
>> Take a look at it and see if you find some more information about what
>> you need to change in your board file.
>>
>> I hope this helps.
>>
> Hi,
>
> First, thank you all for the help.
> I moved the evaluation kit from the mmc[0] (OMAP MMC 1 controller) to
> the mmc[1] (OMAP MMC 2 controller) because I had some problem with the
> VMMC1 regulator registration that I didn't manage to fix.
> Additionally, I connected the WLAN_EN pin to the GPIO170. The WLAN_IRQ
> pin is still not connected. Is it possible to use the SDIO IRQ instead?
> (The comment line in the struct wl12xx_platform_data defined in the
> include/linux/wl12xx.h: /* SDIO only: IRQ number if WLAN_IRQ line is
> used, 0 for SDIO IRQs */ states it's possible). Otherwise we have to
> make hardware changes (wire up) on the evalkit that is not desired
> because we have no schematics of the evaluation board.
> I added the missing code for the fixed regulator including the GPIO170
> in the board file. The patch is attached.
> I checked the MUXing as well. Everything excepting the GPIO170 is done
> in the omap_hsmmc_mux() function. The GPIO170 mux configuration is added
> in the patch.
> However I still having the same error and the module behaviour is still
> the same.
> Do you think connecting the WLAN_IRQ pin to a GPIO most probably fixes
> the problem?
> Thank you in advance.
> Best regards,
> Ilya.
>
>
>
Hi,

We managed to found and connect the WLAN_IRQ line to a OMAP GPIO pin.
As a result the problem is fixed, and the module appears to be
working!
Thank you all. Special thanks for Luciano and Ido. Your assistance is
keenly appreciated!

Best regards,
Ilya.
