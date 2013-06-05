Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:51041 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab3FEMI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 08:08:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Solomon Peachy <pizza@shaftnet.org>
Subject: Re: [PATCH] cw1200: fix some obvious mistakes
Date: Wed, 5 Jun 2013 14:08:03 +0200
Cc: linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
	Ajitpal Singh <ajitpal.singh@stericsson.com>,
	linux-wireless@vger.kernel.org
References: <1370126241-2528420-1-git-send-email-arnd@arndb.de> <2014948.bdhzSga56L@wuerfel> <20130605040802.GA22735@shaftnet.org>
In-Reply-To: <20130605040802.GA22735@shaftnet.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201306051408.03931.arnd@arndb.de> (sfid-20130605_140846_259872_A92B42E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 05 June 2013, Solomon Peachy wrote:
> > Regarding a long-term solution, I think what we should do here is to
> > move the reset logic into the SDIO framework itself: We have similar
> > requirements even for eMMC and SD cards, where you need to provide
> > the correct voltage to a device on the MMC port in order for it to
> > work. Today this is supported to a varying degree on the MMC controller
> > level, where we hook into various frameworks (clk, reset-controller,
> > regulator, gpio, pinctrl, power domain) based on platformm data or
> > device tree information on the controller node.
> 
> If I understand you correctly, the "traditional" platform data -- power 
> supply, clock source, and gpio (ie POWERUP, RESET) lines would be 
> brought up using this mechanism, in order to get the device to attach to 
> the SDIO bus.  One wrinkle here is that the cw1200 has some minimum 
> timing requirements between when each of those signals are brought up; I 
> don't know if there's a way to encode that into the devicetree.

If there is a way to know the timings by the SDIO device ID, we should
not need device tree data. However, if the timings need to be set up
right in order to find out the device ID, I think they should go into
the device tree.

> But that's only half the equation.
> 
> Once the device has identified it to the SDIO bus and the driver's 
> probe() function is called, the other half of the platform data is 
> needed to successfully probe the hardware.  Namely, the 'ref_clk' field. 
> This would need to be made available to the probe() call (eg via 
> func->dev.platform_data) but from what I can tell there's currently no 
> mechanism to make that connection.

I may not following right what you say here, but I think we need two
separate platform_data structures, one for the SDIO pins, used by the
SDIO layer to set up the clocks and regulators, and a separate
platform_data structure specific to the actual SDIO device, which is
used by the cw1200 driver and attached to the sdio_func.

I think mmc_attach_sdio would be the right place to pass down the
platform_data from the host to the func, if set by the platform.
I notice that this function already sets up the voltage and the
power domain for the card, so adding any further clock/reset/...
code could also be done there, or you model the reset line through
a power domain.
In case of DT booting, we would do the respective thing and
add the device_node pointer for the children of the mmc host to
the sdio devices. We don't currently do that, but it would be
straightforward to add as well.

	Arnd
