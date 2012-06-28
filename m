Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:42864 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab2F1XfM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 19:35:12 -0400
Message-ID: <4FECEA30.5060107@ti.com> (sfid-20120629_013520_793846_F4F09C77)
Date: Thu, 28 Jun 2012 18:35:12 -0500
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
References: <4FE8CF77.5080400@broadcom.com> <87txxxs9we.fsf@ti.com> <4FEBA854.5010508@broadcom.com> <4FEC7B48.8040402@ti.com> <4FECCB91.7090609@broadcom.com> <4FECD2E5.1060603@ti.com> <4FECE067.7000809@broadcom.com> <4FECE1BD.80906@ti.com> <4FECE45E.6040506@broadcom.com>
In-Reply-To: <4FECE45E.6040506@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 06/28/2012 06:10 PM, Franky Lin wrote:
> On 06/28/2012 03:59 PM, Jon Hunter wrote:
>>
>> On 06/28/2012 05:53 PM, Franky Lin wrote:
>>> I found one interesting thing. When I added the print info to see when
>>> runtime_suspend/resume get called, it seems like the suspend/resume is
>>> unbalance during boot. Resume got called more than suspend. So I hack
>>> the code to make sure suspend and resume are called in pair. A resume
>>> without suspend will do nothing and return immediately. This also makes
>>> the hang vanish.
>>
>> I am not 100% sure I follow. On boot I would expect to see a
>> resume/suspend due to the probe on the irq bank and then I would expect
>> to see another resume from the acquisition of the gpio, however, I would
>> not expect a suspend until the gpio is freed, which I don't believe you
>> are doing.
>>
>> Can you share your hack? Just paste the diff? This may help me
>> understand more.
>>
> 
> OK.
> This is what I saw in the log:
> [    0.171844] dummy:
> [    0.172912] NET: Registered protocol family 16
> [    0.173431] GPMC revision 6.0
> [    0.173492] gpmc: irq-52 could not claim: err -22
> [    0.177551] ??????omap_gpio_runtime_resume
> [    0.178619] OMAP GPIO hardware version 0.1
> [    0.178649] !!!!!omap_gpio_runtime_suspend
> [    0.178771] ??????omap_gpio_runtime_resume
> [    0.179351] !!!!!omap_gpio_runtime_suspend
> [    0.179504] ??????omap_gpio_runtime_resume
> [    0.180023] !!!!!omap_gpio_runtime_suspend
> [    0.180145] ??????omap_gpio_runtime_resume
> [    0.180694] !!!!!omap_gpio_runtime_suspend
> [    0.180847] ??????omap_gpio_runtime_resume
> [    0.181365] !!!!!omap_gpio_runtime_suspend
> [    0.181518] ??????omap_gpio_runtime_resume
> [    0.182037] !!!!!omap_gpio_runtime_suspend
> [    0.185089] omap_mux_init: Add partition: #1: core, flags: 2
> [    0.186462] omap_mux_init: Add partition: #2: wkup, flags: 2
> [    0.186584] error setting wl12xx data: -38
> [    0.189788] _omap_mux_get_by_name: Could not find signal
> uart1_rx.uart1_rx
> [    0.189788] _omap_mux_get_by_name: Could not find signal
> uart1_rx.uart1_rx
> [    0.239501] ??????omap_gpio_runtime_resume
> [    0.239532] ??????omap_gpio_runtime_resume
> [    0.241058]  usbhs_omap: alias fck already exists
> [    0.244781] ??????omap_gpio_runtime_resume

Sorry, can you do one more test? :-)

Add the following and send me the output?

Thanks!
Jon

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index c4ed172..3aa0f96 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -1155,6 +1155,7 @@ static int omap_gpio_runtime_suspend(struct device
*dev)
        unsigned long flags;
        u32 wake_low, wake_hi;

+       pr_info("%s: bank @ 0x%x\n", __func__, (u32)bank->base);
        spin_lock_irqsave(&bank->lock, flags);

        /*
@@ -1221,6 +1222,7 @@ static int omap_gpio_runtime_resume(struct device
*dev)
        u32 l = 0, gen, gen0, gen1;
        unsigned long flags;

+       pr_info("%s: bank @ 0x%x\n", __func__, (u32)bank->base);
        spin_lock_irqsave(&bank->lock, flags);
        _gpio_dbck_enable(bank);

@@ -1239,6 +1241,7 @@ static int omap_gpio_runtime_resume(struct device
*dev)
                context_lost_cnt_after =
                        bank->get_context_loss_count(bank->dev);
                if (context_lost_cnt_after != bank->context_loss_count) {
+                       pr_info("%s: count %d, now %d", __func__,
bank->context_loss_count, context_lost_cnt_after);
                        omap_gpio_restore_context(bank);
                } else {
                        spin_unlock_irqrestore(&bank->lock, flags);
@@ -1341,6 +1344,7 @@ void omap2_gpio_resume_after_idle(void)
 #if defined(CONFIG_PM_RUNTIME)
 static void omap_gpio_restore_context(struct gpio_bank *bank)
 {
+       pr_info("%s: bank @ 0x%x\n", __func__, (u32)bank->base);
        __raw_writel(bank->context.wake_en,
                                bank->base + bank->regs->wkup_en);
        __raw_writel(bank->context.ctrl, bank->base + bank->regs->ctrl);

