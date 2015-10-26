Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:54590 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbbJZJND (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2015 05:13:03 -0400
Message-ID: <562DEF4C.1070103@atmel.com> (sfid-20151026_101307_458318_7249C71C)
Date: Mon, 26 Oct 2015 18:15:56 +0900
From: glen lee <glen.lee@atmel.com>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <austin.shin@atmel.com>,
	<linux-wireless@vger.kernel.org>, <Nicolas.FERRE@atmel.com>,
	<adel.noureldin@atmel.com>, <tony.cho@atmel.com>,
	<leo.kim@atmel.com>, <adham.abozaeid@atmel.com>
Subject: Re: [PATCH 02/28] staging: wicl1000: isr_uh_routine: use netdev private
 wilc
References: <1445578124-31486-1-git-send-email-glen.lee@atmel.com> <1445578124-31486-2-git-send-email-glen.lee@atmel.com> <20151025012944.GA22184@kroah.com> <562D8B2B.2000308@atmel.com> <20151026082340.GA4643@kroah.com>
In-Reply-To: <20151026082340.GA4643@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 10월 26일 17:23, Greg KH wrote:
> On Mon, Oct 26, 2015 at 11:08:43AM +0900, glen lee wrote:
>>
>> On 2015년 10월 25일 10:29, Greg KH wrote:
>>> On Fri, Oct 23, 2015 at 02:28:18PM +0900, Glen Lee wrote:
>>>> Use netdev private member wilc instead of g_linux_wlan and Change argument wilc
>>>> with dev in the function request_threaded_irq to pass back to handler
>>>> the function isr_uh_routine.
>>>>
>>>> Signed-off-by: Glen Lee <glen.lee@atmel.com>
>>>> ---
>>>>   drivers/staging/wilc1000/linux_wlan.c | 9 +++++++--
>>>>   1 file changed, 7 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
>>>> index b036b96..7b0614d 100644
>>>> --- a/drivers/staging/wilc1000/linux_wlan.c
>>>> +++ b/drivers/staging/wilc1000/linux_wlan.c
>>>> @@ -229,10 +229,15 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
>>>>   #if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
>>>>   static irqreturn_t isr_uh_routine(int irq, void *user_data)
>>>>   {
>>>> +	perInterface_wlan_t *nic;
>>>> +	struct wilc *wl;
>>>> +
>>>> +	nic = netdev_priv(usedata);
>>> This patch breaks the build, which means you didn't even test build the
>>> series :(
>> Hi greg,
>>
>> I built every patches I'v posted and also there is no build error for this patch.
> I don't believe you, just look at the lines, it's obviously incorrect.
>
>> Would you please reconsider this patch again?
> Why would I ever accept a patch that is obviously wrong?  I would be a
> horrible subsystem maintainer, and you would not want me to merge an
> obviously broken patch from someone else into this driver, breaking it,
> right?

True. Sorry for wasting your time. I didn't look at the code carefully but just built on SDIO not SPI as usual.
I should have been more careful about this.
Again, sorry for the noise. I'll do this patches again.

>
> I have no idea why you would expect me to ever accept this patch as-is.
>
> greg k-h

