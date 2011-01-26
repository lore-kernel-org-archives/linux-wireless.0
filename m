Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:41354 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753703Ab1AZXfV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 18:35:21 -0500
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	"Ohad Ben-Cohen" <ohad@wizery.com>,
	linux-pm@lists.linux-foundation.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Ido Yariv <ido@wizery.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
References: <Pine.LNX.4.44L0.1012212032590.11252-100000@netrider.rowland.org>
	<201012221329.40251.rjw@sisk.pl>
Date: Wed, 26 Jan 2011 15:28:20 -0800
In-Reply-To: <201012221329.40251.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Wed, 22 Dec 2010 13:29:40 +0100")
Message-ID: <87k4hrtfcb.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Wednesday, December 22, 2010, Alan Stern wrote:
>> On Tue, 21 Dec 2010, Rafael J. Wysocki wrote:
>> 
>> > It basically goes like this.  There's device A that is only resumed when it's
>> > needed to carry out an operation and is suspended immediately after that.
>> > There's another device B that needs A to do something during its suspend.
>> > So, when the suspend of B is started, A is woken up, does its work and is
>> > suspended again (using pm_runtime_suspend()).  Then B is suspended.
>> > 
>> > We currently require that ->suspend() and ->resume() callbacks be defined
>> > for A (presumably pointing to the same code as its runtime callbacks) so that
>> > things work correctly, but perhaps we can just relax this requirement a bit?
>> > I'm not 100% sure that's a good idea, just considering it.
>> 
>> I still don't know.  It would require a lot of special conditions: no
>> child devices, not runtime-PM-disabled, not runtime-PM-forbidden...  
>> Also, A's parent would have to be coded carefully; otherwise A's
>> runtime resume would prevent the parent from suspending.
>> 
>> This just doesn't fit very well with the runtime PM model, or at least, 
>> not in the form you described.
>> 
>> Consider this instead:  Since A is required to be functional before B
>> can be used, A must be registered before B and hence B gets suspended
>> before A.  Therefore during the prepare phase we can runtime-resume A
>> and leave it powered up; when B needs to suspend, it won't matter that
>> the runtime-PM calls are ineffective.
>
> We don't really need to do that, because the runtime resume _is_ functional
> during system suspend.  The only thing missing is a ->suspend() callback for A
> (and a corresponding ->resume() callback to make sure A will be available to
> B during system resume).
>

OK, I'm finally back to debugging this problem and looking for a final
solution.

I agree that what is needed is ->suspend() and ->resume() callbacks for
A, but the question remains how to implement them.

In my case, A doesn't need runtime callbacks, but *does* require that
the subsystem callbacks are called because the subsystem actually does
all the real PM work.  On OMAP, the device PM code (clock mgmt, device
low-power states, etc.) is common for all on-chip devices, so is handled
in common code at the subsystem level (in this case, platform_bus.)

Therefore, what is ideally needed is the ability for A's suspend to
simply call pm_runtime_suspend() so the subsystem can do the work.
However, since runtime transitions are locked out by this time, that
doesn't work.  IOW, what is needed is a way for a system suspend to say
"please finish the runtime suspend that was already requested."

What I've done to work around this in driver A is to manually check
pm_runtime_suspended() and directly call the subsystem's runtime
suspend/resume (patch below[1].  NOTE, I've used the _noirq methods to
ensure device A is available when device B needs it.)

While this works, I'm not crazy about it since it requires the driver
know about the subsystem (in this case the bus) where the real PM work
is done.  IMO, it would be much more intuitive (and readable) if the
driver's suspend hooks could simply trigger a runtime suspend (either a
new one, or one already requested.)

FWIW, another hack that I've experimented with is just to just re-enable
runtime transitions by doing a pm_runtime_put_sync() in the
suspend_noirq method and a pm_runtime_get_noresume() in the resume_noirq
method.  This allows driver A to suspend since it has already requested
runtime, but I don't expect this second approach to be popluar. :) This
second approach also doen't address system suspend/resume when the user
has disabled runtime PM via /sys/devices/.../power/control.

Kevin

[1]
diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index b605ff3..a4bc15a 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -1137,12 +1137,40 @@ omap_i2c_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_SUSPEND
+static int omap_i2c_suspend(struct device *dev)
+{
+	if (!pm_runtime_suspended(dev))
+		if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_suspend)
+			dev->bus->pm->runtime_suspend(dev);
+
+	return 0;
+}
+
+static int omap_i2c_resume(struct device *dev)
+{
+	if (!pm_runtime_suspended(dev))
+		if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_resume)
+			dev->bus->pm->runtime_resume(dev);
+
+	return 0;
+}
+
+static struct dev_pm_ops omap_i2c_pm_ops = {
+	.suspend_noirq = omap_i2c_suspend,
+	.resume_noirq = omap_i2c_resume,
+};
+#else
+#define omap_i2c_pm_ops NULL
+#endif
+
 static struct platform_driver omap_i2c_driver = {
 	.probe		= omap_i2c_probe,
 	.remove		= omap_i2c_remove,
 	.driver		= {
 		.name	= "omap_i2c",
 		.owner	= THIS_MODULE,
+		.pm     = &omap_i2c_pm_ops,
 	},
 };
 
