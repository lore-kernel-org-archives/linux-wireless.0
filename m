Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55442 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758244Ab1FJXLZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 19:11:25 -0400
Subject: Re: iwlagn module ignores parameter "led_mode=1" under certain
 conditions
From: wwguy <wey-yi.w.guy@intel.com>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <201106110025.06740.toralf.foerster@gmx.de>
References: <201106100937.23295.toralf.foerster@gmx.de>
	 <1307719540.5115.25.camel@wwguy-ubuntu>
	 <201106110025.06740.toralf.foerster@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jun 2011 16:07:48 -0700
Message-ID: <1307747268.26537.5.camel@wwguy-ubuntu> (sfid-20110611_011129_245757_48E4FD87)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-06-10 at 15:25 -0700, Toralf Förster wrote:
> wwguy wrote at 17:25:40
> > On Fri, 2011-06-10 at 00:37 -0700, Toralf Förster wrote:
> > > Hello,
> > > 
> > > Since years this worked at my Gentoo system :
> > > 
> > > $ cat /etc/modprobe.d/iwlagn.conf
> > > options iwlcore led_mode=1
> > > 
> > > However nowadays this doesn't work when I do the following :
> > > 
> > > 1. dock the ThinkPad T400 (no WLAN, only DSL)
> > > 2. boot it
> > > 3. s2ram it
> > > 4. undock iow
> > > 5. go into the office
> > > 6. resume the undocked notebook (WLAN, no DSL)
> > > 
> > > The led  blinking ...
> > > 
> > > Putting however this line into the config file :
> > > $ options iwlagn  led_mode=1
> > > 
> > > works alwasys.
> > 
> > what kernel version you are using?
> 2.6.39.1 and I'm just curious b/c if I boot the system within the office than 
> the old line works fine.
> 
> 
Now you make me really confuse, so you use the same system, but work in
the office but not home? 2.6.39.1 already has split driver, so
"iwlcore.ko" not exist anymore, and it will not affect the led behavior.

what module parameters you have in the system, could you do the
following:
$modinfo iwlagn
$modinfo iwlcore

you should see the list of supported module parameters in iwlagn, but
not iwlcore.

Thanks
Wey

