Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14917 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167Ab1FJP3R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 11:29:17 -0400
Subject: Re: iwlagn module ignores parameter "led_mode=1" under certain
 conditions
From: wwguy <wey-yi.w.guy@intel.com>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <201106100937.23295.toralf.foerster@gmx.de>
References: <201106100937.23295.toralf.foerster@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jun 2011 08:25:40 -0700
Message-ID: <1307719540.5115.25.camel@wwguy-ubuntu> (sfid-20110610_172920_786395_9BBC4048)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-06-10 at 00:37 -0700, Toralf Förster wrote:
> Hello,
> 
> Since years this worked at my Gentoo system :
> 
> $ cat /etc/modprobe.d/iwlagn.conf 
> options iwlcore led_mode=1
> 
> However nowadays this doesn't work when I do the following :
> 
> 1. dock the ThinkPad T400 (no WLAN, only DSL)
> 2. boot it
> 3. s2ram it
> 4. undock it
> 5. go into the office
> 6. resume the undocked notebook (WLAN, no DSL)
> 
> The led is blinking ...
> 
> Putting however this line into the config file :
> $ options iwlagn  led_mode=1
> 
> works always.

what kernel version you are using?
the newer kernel (after .38), the iwlwifi driver split into 2 separate
driver (iwlagn and iwlegacy). so there is no longer using iwlcore.ko

putting options "iwlagn led_mode=1" in config file should do the job.

Thanks
Wey


