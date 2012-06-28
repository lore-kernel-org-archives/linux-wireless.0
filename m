Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:41342 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab2F1W7F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 18:59:05 -0400
Message-ID: <4FECE1BD.80906@ti.com> (sfid-20120629_005911_453755_0854210A)
Date: Thu, 28 Jun 2012 17:59:09 -0500
From: Jon Hunter <jon-hunter@ti.com>
MIME-Version: 1.0
To: Franky Lin <frankyl@broadcom.com>
CC: Kevin Hilman <khilman@ti.com>, <b-cousson@ti.com>,
	<tony@atomide.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	<grant.likely@secretlab.ca>, <santosh.shilimkar@ti.com>,
	<linux-omap@vger.kernel.org>, <tarun.kanti@ti.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Panda ES board hang when using GPIO as interrupt
References: <4FE8CF77.5080400@broadcom.com> <87txxxs9we.fsf@ti.com> <4FEBA854.5010508@broadcom.com> <4FEC7B48.8040402@ti.com> <4FECCB91.7090609@broadcom.com> <4FECD2E5.1060603@ti.com> <4FECE067.7000809@broadcom.com>
In-Reply-To: <4FECE067.7000809@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 06/28/2012 05:53 PM, Franky Lin wrote:
> On 06/28/2012 02:55 PM, Jon Hunter wrote:
>> Ok. Any way to manually reset the wlan module to deactivate the gpio
>> when it is hung? I am wondering if the gpio is deactivated if the board
>> comes back to life, indicating it is stuck in the interrupt somewhere.
> 
> The only way I can think of is removing the module manually. But it
> didn't bring the board back to live.
> 
>> Well, at least that is consistent with what I see, but also perplexing
>> that it takes sometime to fail. Can you try the following as a debug
>> patch to see if it is in the context restore that is the problem. From
>> your testing and bisect, the only possible difference in the current
>> kernel is that it could perform the context restore when acquiring the
>> gpio.
>>
>> diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
>> index c4ed172..a2401bd 100644
>> --- a/drivers/gpio/gpio-omap.c
>> +++ b/drivers/gpio/gpio-omap.c
>> @@ -1341,6 +1341,8 @@ void omap2_gpio_resume_after_idle(void)
>>   #if defined(CONFIG_PM_RUNTIME)
>>   static void omap_gpio_restore_context(struct gpio_bank *bank)
>>   {
>> +       return;
>> +
>>          __raw_writel(bank->context.wake_en,
>>                                  bank->base + bank->regs->wkup_en);
>>          __raw_writel(bank->context.ctrl, bank->base + bank->regs->ctrl);
>>
> 
> This one works! It can run more than 20 mins.

Great! I need to dig into the context restore some more.

> I found one interesting thing. When I added the print info to see when
> runtime_suspend/resume get called, it seems like the suspend/resume is
> unbalance during boot. Resume got called more than suspend. So I hack
> the code to make sure suspend and resume are called in pair. A resume
> without suspend will do nothing and return immediately. This also makes
> the hang vanish.

I am not 100% sure I follow. On boot I would expect to see a
resume/suspend due to the probe on the irq bank and then I would expect
to see another resume from the acquisition of the gpio, however, I would
not expect a suspend until the gpio is freed, which I don't believe you
are doing.

Can you share your hack? Just paste the diff? This may help me
understand more.

Thanks
Jon
