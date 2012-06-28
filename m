Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:55883 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630Ab2F1Vzq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 17:55:46 -0400
Message-ID: <4FECD2E5.1060603@ti.com> (sfid-20120628_235550_814819_C6FB9FDB)
Date: Thu, 28 Jun 2012 16:55:49 -0500
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
References: <4FE8CF77.5080400@broadcom.com> <87txxxs9we.fsf@ti.com> <4FEBA854.5010508@broadcom.com> <4FEC7B48.8040402@ti.com> <4FECCB91.7090609@broadcom.com>
In-Reply-To: <4FECCB91.7090609@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 06/28/2012 04:24 PM, Franky Lin wrote:
> On 06/28/2012 08:42 AM, Jon Hunter wrote:
>>
>> On 06/27/2012 07:41 PM, Franky Lin wrote:
>>> On 06/26/2012 08:37 PM, Kevin Hilman wrote:
>>>> "Franky Lin" <frankyl@broadcom.com> writes:
>>>>> I noticed Kevin raised some similar cases on other platforms and also
>>>>> provided two patches in the patch mail thread. But unfortunately those
>>>>> two patches doesn't help in our case. I tested the driver with 3.5-rc3
>>>>> mainline kernel and the issue is still there. I can only "fix" the
>>>>> hang by either reverting the commit or disabling
>>>>> CONFIG_PM_RUNTIME. Also, the hang only happens on Panda ES board. Old
>>>>> Panda with 4430 works good.
>>>>>
>>>>> Any thoughts and suggestions?
>>>>
>>>> If reverting the patch fixes your problem, can you isolate down to
>>>> which
>>>> part of that patch causes the problem?  IOW, can you fix your
>>>> problem if
>>>> you undo just the hunk added in runtime_suspend or undo just the moved
>>>> hunk runtime_resume?  Or is reverting both required?
>>>>
>>>> I suspect the added runtime_suspend hunk is causing the problems, so
>>>> can
>>>> you see if just undoing that part works[1].  If that works, I will give
>>>> a bit more of a thinking on it tomorrow.
>>>
>>> runtime_suspend hunk is fine. The hang still exist after reverting it.
>>> The culprit is the moved hunk in runtime_resume. Reverting it makes the
>>> hang disappear.
>>
>> Thanks. From reviewing the code the only thing that appears suspect based
>> upon your findings is the return if we find the context has not been
>> lost.
>> We are not checking if "workaround_enabled" is set before we return.
>>
>> Could you try the following change on top of v3.5-rc3?
>>
> 
> The patch doesn't help. And I also managed to probe the signal. It's
> active when it hung.

Ok. Any way to manually reset the wlan module to deactivate the gpio
when it is hung? I am wondering if the gpio is deactivated if the board
comes back to life, indicating it is stuck in the interrupt somewhere.

>> Also, could you add a print in the runtime_suspend/resume() functions so
>> we can see how often these are being called. In my case, I really
>> don't see
>> these being exercised and I am wondering how often you see suspend/resume
>> being called in your setup.
> 
> Well, the runtime_suspend/resume never get called during the test.

Well, at least that is consistent with what I see, but also perplexing
that it takes sometime to fail. Can you try the following as a debug
patch to see if it is in the context restore that is the problem. From
your testing and bisect, the only possible difference in the current
kernel is that it could perform the context restore when acquiring the gpio.

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index c4ed172..a2401bd 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -1341,6 +1341,8 @@ void omap2_gpio_resume_after_idle(void)
 #if defined(CONFIG_PM_RUNTIME)
 static void omap_gpio_restore_context(struct gpio_bank *bank)
 {
+       return;
+
        __raw_writel(bank->context.wake_en,
                                bank->base + bank->regs->wkup_en);
        __raw_writel(bank->context.ctrl, bank->base + bank->regs->ctrl);

Cheers
Jon
