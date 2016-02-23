Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:61756 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbcBWKbw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 05:31:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thierry Reding <thierry.reding@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
	Alexandre Courbot <gnurou@gmail.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Marc Dietrich <marvin24@gmx.de>
Subject: Re: [PATCHv2 3/4] ARM: tegra: use build-in device properties with rfkill_gpio
Date: Tue, 23 Feb 2016 11:31:40 +0100
Message-ID: <3086257.esvHq8Yk9N@wuerfel> (sfid-20160223_113644_262886_0C3C6790)
In-Reply-To: <5438459.Mb6Ga2Xhyq@wuerfel>
References: <1453712629-143317-1-git-send-email-heikki.krogerus@linux.intel.com> <1455825889.2084.16.camel@sipsolutions.net> <5438459.Mb6Ga2Xhyq@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 23 February 2016 11:15:31 Arnd Bergmann wrote:
> On Thursday 18 February 2016 21:04:49 Johannes Berg wrote:
> > On Tue, 2016-01-26 at 09:42 +0100, Johannes Berg wrote:

> Just for my curiosity: what is the difference between a rfkill-gpio
> device and a gpio-keys device with a KEY_RFKILL code?
> 
> arch/arm/boot/dts/bcm4708-netgear-r6250.dts and others seem to
> do the second approach in DT so they don't need to create the
> platform device.

I found the answer now (after discussing on IRC): just
for reference: KEY_RFKILL is for sending the event to the kernel
when a user presses the gpio butting, this rfkill-gpio turns
the devices on or off when after an RFKILL event is received.

	Arnd
