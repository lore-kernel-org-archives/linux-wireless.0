Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:37219 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab2F1Pl5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 11:41:57 -0400
Message-ID: <4FEC7B48.8040402@ti.com> (sfid-20120628_174202_575984_34A9E2FF)
Date: Thu, 28 Jun 2012 10:42:00 -0500
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
References: <4FE8CF77.5080400@broadcom.com> <87txxxs9we.fsf@ti.com> <4FEBA854.5010508@broadcom.com>
In-Reply-To: <4FEBA854.5010508@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 06/27/2012 07:41 PM, Franky Lin wrote:
> On 06/26/2012 08:37 PM, Kevin Hilman wrote:
>> "Franky Lin" <frankyl@broadcom.com> writes:
>>> I noticed Kevin raised some similar cases on other platforms and also
>>> provided two patches in the patch mail thread. But unfortunately those
>>> two patches doesn't help in our case. I tested the driver with 3.5-rc3
>>> mainline kernel and the issue is still there. I can only "fix" the
>>> hang by either reverting the commit or disabling
>>> CONFIG_PM_RUNTIME. Also, the hang only happens on Panda ES board. Old
>>> Panda with 4430 works good.
>>>
>>> Any thoughts and suggestions?
>>
>> If reverting the patch fixes your problem, can you isolate down to which
>> part of that patch causes the problem?  IOW, can you fix your problem if
>> you undo just the hunk added in runtime_suspend or undo just the moved
>> hunk runtime_resume?  Or is reverting both required?
>>
>> I suspect the added runtime_suspend hunk is causing the problems, so can
>> you see if just undoing that part works[1].  If that works, I will give
>> a bit more of a thinking on it tomorrow.
> 
> runtime_suspend hunk is fine. The hang still exist after reverting it.
> The culprit is the moved hunk in runtime_resume. Reverting it makes the
> hang disappear.

Thanks. From reviewing the code the only thing that appears suspect based
upon your findings is the return if we find the context has not been lost.
We are not checking if "workaround_enabled" is set before we return. 

Could you try the following change on top of v3.5-rc3?

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index c4ed172..3b89e85 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -1238,12 +1238,8 @@ static int omap_gpio_runtime_resume(struct device *dev)
        if (bank->get_context_loss_count) {
                context_lost_cnt_after =
                        bank->get_context_loss_count(bank->dev);
-               if (context_lost_cnt_after != bank->context_loss_count) {
+               if (context_lost_cnt_after != bank->context_loss_count)
                        omap_gpio_restore_context(bank);
-               } else {
-                       spin_unlock_irqrestore(&bank->lock, flags);
-                       return 0;
-               }
        }

Also, could you add a print in the runtime_suspend/resume() functions so
we can see how often these are being called. In my case, I really don't see
these being exercised and I am wondering how often you see suspend/resume
being called in your setup.

Cheers
Jon
