Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50976 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab2F0XnZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 19:43:25 -0400
Message-ID: <4FEB9A9D.4080406@ti.com> (sfid-20120628_014334_944477_0EF90521)
Date: Wed, 27 Jun 2012 18:43:25 -0500
From: Jon Hunter <jon-hunter@ti.com>
MIME-Version: 1.0
To: Franky Lin <frankyl@broadcom.com>
CC: <khilman@ti.com>, <tarun.kanti@ti.com>, <b-cousson@ti.com>,
	<tony@atomide.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	<grant.likely@secretlab.ca>, <santosh.shilimkar@ti.com>,
	<linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Panda ES board hang when using GPIO as interrupt
References: <4FE8CF77.5080400@broadcom.com>
In-Reply-To: <4FE8CF77.5080400@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Franky,

On 06/25/2012 03:52 PM, Franky Lin wrote:
> Hi Kevin, Tarun,
> 
> We are using the expansion connector A on Panda board to mount a SDIO
> WiFi dongle on MMC2 with a level triggered interrupt signal connected to
> GPIO 138. It's been working fine until 3.5 rc1. The board hang randomly
> within 5 mins during a network traffic test. After bisecting we found
> the culprit is "[PATCH 8/8] gpio/omap: fix missing check in
> *_runtime_suspend()" [1].

I have been looking into this today to see if I can replicate the
problem that you have reported. However, so far I have not had any luck.
Please note that my test setup is not exactly the same as yours as I
don't have your wlan module. However, I have been using a 2nd board to
generate gpio events to a panda-es to see I can make it lock up. I have
tried mainline kernel 3.5-rc1 and 3.5-rc3 but I have not seen any
problems after sending 100k gpio events (over many minutes). My setup is
as follows ...

- OMAP4460 panda-es with gpio-138 connected to OMAP3430 beagle gpio-11.
- Mainline kernel 3.5-rc1/3 using omap2plus_defconfig (no changes)
- Created a simple kernel module that acquires gpio-138 and sets up a
  IRQ with flag IRQF_TRIGGER_HIGH (for active high level interrupt).
- GPIO events are triggered roughly every 1ms

Can you confirm ...
1. You are just using omap2plus_defconfig with no changes?
2. Rough frequency of gpio events?
3. Is the gpio configured for active low or high?
4. When the hang occurs, what is the state of the gpio? Active or
   inactive? Can you probe it with a scope? If it was always active I
   could see that this would lock the device up, but I am not sure how
   that would relate to the results from your bisect???

> I noticed Kevin raised some similar cases on other platforms and also
> provided two patches in the patch mail thread. But unfortunately those
> two patches doesn't help in our case. I tested the driver with 3.5-rc3
> mainline kernel and the issue is still there. I can only "fix" the hang
> by either reverting the commit or disabling CONFIG_PM_RUNTIME. Also, the
> hang only happens on Panda ES board. Old Panda with 4430 works good.

It does not make sense to me yet why this would only impact 4460, but I
will keep this in mind.

In your wlan driver are you acquiring and freeing the gpio often? Or are
you only acquiring the gpio on boot?

The reason I ask is because for omap4, it seems that we are not
currently calling omap2_gpio_prepare_for_idle() during idle and so the
only time I see us call the runtime_suspend/resume handlers for omap4 is
during probe and when we acquire and free the gpio.

So if you were not acquiring and freeing the gpio and are using the
stock kernel, then as far as I can tell, the runtime pm code is not
being exercised much. My test is not acquiring and releasing the gpio
and so I am wondering if that is the secret to reproducing this problem :-)

Cheers
Jon

