Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:25689 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab0GGUAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jul 2010 16:00:17 -0400
Message-ID: <4C34DC92.80908@nokia.com>
Date: Wed, 07 Jul 2010 22:59:14 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
MIME-Version: 1.0
To: Nicolas Pitre <nico@fluxnic.net>
CC: "Quadros Roger (Nokia-MS/Helsinki)" <roger.quadros@nokia.com>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>
Subject: Re: [PATCH 11/15] wireless: wl1271: introduce platform device support
References: <1278376666-3509-1-git-send-email-ohad@wizery.com> <1278376666-3509-12-git-send-email-ohad@wizery.com> <4C32EF19.1000604@nokia.com> <AANLkTintIz-N7MwwtqhVq2LR3Ln5JTNYSbJUBSSClcA-@mail.gmail.com> <4C3306F4.8060907@nokia.com> <AANLkTin5W52fPzWToRrAzm56SLZI-taSuI16rCEhLWqH@mail.gmail.com> <4C333E0D.2070601@nokia.com> <alpine.LFD.2.00.1007061316010.6020@xanadu.home> <4C338927.5020400@nokia.com> <4C34347F.8030000@nokia.com> <alpine.LFD.2.00.1007070954010.6020@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.1007070954010.6020@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nicolas Pitre wrote:
> On Wed, 7 Jul 2010, Roger Quadros wrote:
> 
>> On 07/06/2010 10:51 PM, Hunter Adrian (Nokia-MS/Helsinki) wrote:
>>> For eMMC in omap_hsmmc, this is all done via claim_host / release_host
>>> which call ->enable() / ->disable() methods.  omap_hsmmc makes use of
>>> mmc_power_restore_host() which calls host->bus_ops->power_restore()
>>> which is not implemented for SDIO, but for MMC and SD it reinitializes
>>> the card.
> 
> This is IMHO a really bad design.  The power control decision has to 
> come from the top, not from the bottom.  And certainly not with a 
> U-turn dependency the omap_hsmmc is using.

The power control decision does come from the top via mmc_claim_host /
mmc_release_host.

> 
> I regret to say this, but the omap_hsmmc driver is becoming a total 
> mess.  The host controller driver has to be a dumb interface serving 
> requests from the hardware used by the upper layer stack, not the place 
> where decisions such as power handling should be made.  Think of it like 
> an ethernet driver.  No ethernet driver in Linux is telling the IP stack 
> when to shut down.

The omap_hsmmc driver does not tell the core to shut down the upper layers.
Instead the core tells the omap_hsmmc driver that it is "disabled" i.e.
not currently being used so it can start taking steps to save power.
That is sensible because not even the upper layers know when the next
activity will be.

> 
>> Shouldn't the power control intelligence (i.e. when to turn power ON/OFF) lie
>> with the bus drivers?
> 
> Absolutely!  And in the SDIO case that should lie with each function 
> drivers.  Please let's stop this omap_hsmmc madness.

You are dealing with a trivial case - turn off the power when not in use.
We have 3 power saving actions: enable DPS, put the card to sleep,
and finally power it off.  Each increases the latency to start up
again and so must be staggered.  With DPS-enabled the host controller can
be powered off at any time.  In that case the controller registers must be
restored.  There are numerous entry points to the driver.  Checking whether
to restore registers at every entry point is error prone and messy.
Instead we require that the core tells the driver when to enable and
disable.

> 
> 
> Nicolas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

