Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:33756 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbaIOIQA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 04:16:00 -0400
Message-ID: <5416A03D.1040701@broadcom.com> (sfid-20140915_101606_732551_82A23B17)
Date: Mon, 15 Sep 2014 10:15:57 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Karen Vincent <KarMaVin@aol.com>
CC: <brcm80211-dev-list@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: Re: BCM4313 14e4:4727 was working fine, now failing - Ubuntu Linux
References: <5415A808.8090302@aol.com>
In-Reply-To: <5415A808.8090302@aol.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-wireless, Seth

On 14-09-14 16:36, Karen Vincent wrote:
> Hello,
> 
> I am trying to fix a wireless connectivity problem on a Lenovo G585 which has 
> BCM4313 14e4:4727 (rev 01) running on Ubuntu 14.04
> 
> This was working fine, then following a Linux headers upgrade last week it 
> started to play up (connection failing or repeatedly dropping)

Hi Karen,

I assume the upgrade involved a kernel upgrade and not just the headers.
It would be very interesting to know the package versions before and
after this particular upgrade. I added Seth as he may know whether the
packaging software in Ubuntu keeps any log with that info.

> As a LTS Ubuntu upgrade was due anyway I decided to complete this first and then 
> see if this resolved the wireless issues. Ubuntu 14.04 successfully installed 
> (using ethernet wired connection) but the wireless problem remains

Would you happen to know the kernel version before the upgrade as this
surely looks like a regression.

> Having checked the various online forums I have
> * run the various updates including -pciids
> * purged bcmwl-kernel-source

Are you aware that this was actually used?

> * installed linux-firmware-nonfree

Uhm, what is this package?

> * blacklisted the b43 and wl modules (the latter giving "modprobe: FATAL: Module 
> wl not found" although given I was trying to blacklist it anyway I figured this 
> did not matter)
> * checked the module requirement for BCM4313 14e4:4727 = bcma, which is showing 
> on the module list
> 
> As bcma is the recognised and non-blacklisted module I am puzzled to know why 
> the wireless card still will not connect. And yes, I did reboot after each step!

Could you send me a kernel log from system start, ie. run 'dmesg' on the
terminal.

> A check on the forums and your website suggests 3 possibilities:
> * there is a missing dependency for bcma, perhaps something that is present in 
> brcms? One of the forum 'solutions' suggests this
> * there is a firmware update that I need to ensure is on my system, although a 
> look at the lists on your website has nothing for :4727
> * BCM4313 14e4:4727 is simply not going to work on the updated Linux headers - 
> mine is currently 3.13.0 - 35 - generic, on a 32-bit system - your page 
> http://wireless.kernel.org/en/users/Drivers/brcm80211#Supported_Chips hints that 
> not all 4313 chips will function
> 
> I do not know if this 'bug' - for which there seems to be much evidence on the 
> forums as a dependency conflict - is still live, is going to be fixed or is a 
> 'wait and see' issue, but any assistance in pointing me in the right direction 
> would be useful.
> 
> I am a private user trying to keep the family laptops going rather than a 
> professional technician but I can work through logical processes and have no 
> problems using terminal commands etc

We will make an effort. The bcm4313 keeps nagging as there are many
variations of that card being used and brcmsmac may be missing some
essential piece for it.

Regards,
Arend

> Even if it is just a 'sorry, unlucky to have this combo, cannot help' it would 
> save me a lot of time trying to get it sorted!

