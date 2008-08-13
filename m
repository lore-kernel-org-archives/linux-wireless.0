Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:38104 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbYHMSaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2008 14:30:25 -0400
From: Chr <chunkeey@web.de>
To: d i <navilein@hotmail.com>
Subject: Re: p54usb not working on DWL-G120 Spinnaker wireless card
Date: Wed, 13 Aug 2008 20:33:15 +0200
Cc: linux-wireless@vger.kernel.org
References: <BLU144-W261CF289A7CDEA2BABB0B4D1730@phx.gbl>
In-Reply-To: <BLU144-W261CF289A7CDEA2BABB0B4D1730@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808132033.16673.chunkeey@web.de> (sfid-20080813_203031_439905_89450118)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

On Wednesday 13 August 2008 16:02:09 Daniel wrote:
> I now have kernel 2.6.25-r7, but I kept trying to use the p54usb module
> with my card unsuccessfully since it appeared in the kernel tree (around
> February this year) -- it never worked. I use firmware version 2.5.6.0 from
> the prism54.org website. I tried with other versions of firmware as well,
> but most of them did not even load up (error -22 and error -110).
hmm, there are about 5 different types of firmwares... 
- TWO for minipci cards 
	- fullmac are exclusively for prism54
	- softmac are only for p54
- one for isl3886 chips with a net2280 pci-usb-bridge (your card/stick)
- one for isl3887 chips (they have a native USB-Interface)
- one for conextant's cx3110x (spi interface) (found on some Nokia N800/N770 I think
	Johannes did some work here, but that was long ago)

so stick with prism54.org recommendation 2.5.6.0 ...
>
> With firmware 2.5.6.0 the module loads up, but scanning for APs reveals no
> answer, ever. If I set an ESSID of a network I KNOW is around and not
> crypted it does not set the AP address and the "Link Quality" is always 0 
> and  it never connects. The card can not be set in monitor mode.
> I can set the card in ad-hoc mode ONLY if the interface is down.
(Ad-hoc isn't supported... there was a patch but no review!)

And you always have to bring the interface down to change the mode
it's more a mac80211 thing than p54's fault...

> If afterwards I try to bring the interface up (with ifconfig), I get an error,
> and the interface does not come up.
Ad-hoc isn't supported and monitor-mode will filter out anything
except beacons...

> After a while (never fixed) the kernel Oops.
>
> Both the failure to work and the final unpredictable kernel Oops are always
> reproducible, although the time it takes the kernel to Oops varies every
> time.
Hmm, I found 2 problems and I guess there are some more...
(Will post them later today or tomorrow, my timezone is CEST)

but you'll need:
- wireless-dev git-tree (which can be found here:
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git )
- the "patch" - utility
- time to test & report...

> I've tried this with 3 desktop computers and 1 laptop and all have the same
> behavior. The wireless card works well in windows or in linux under
> ndiswrapper.
hmm, do you have usbmon enabled in your kernel? Or is there any other facility
to "monitor" what ndiswrapper or p54 is doing? because this logs are very handy!

> Did anyone manage to have this wireless card (DWL-G120) working with this
> module (p54usb) ?
hmm, I haven't heard of anyone with success... 

Regards,
	Chr
