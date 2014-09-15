Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:40922 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbaIOLl0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 07:41:26 -0400
Received: by mail-ob0-f177.google.com with SMTP id wp4so2327945obc.36
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2014 04:41:26 -0700 (PDT)
Date: Mon, 15 Sep 2014 06:41:24 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	Karen Vincent <KarMaVin@aol.com>
Cc: brcm80211-dev-list@broadcom.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: BCM4313 14e4:4727 was working fine, now failing - Ubuntu Linux
Message-ID: <20140915114124.GA4041@ubuntu-hedt> (sfid-20140915_134130_347718_9807EFB6)
References: <5415A808.8090302@aol.com>
 <5416A03D.1040701@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5416A03D.1040701@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 15, 2014 at 10:15:57AM +0200, Arend van Spriel wrote:
> + linux-wireless, Seth
> 
> On 14-09-14 16:36, Karen Vincent wrote:
> > Hello,
> > 
> > I am trying to fix a wireless connectivity problem on a Lenovo G585 which has 
> > BCM4313 14e4:4727 (rev 01) running on Ubuntu 14.04
> > 
> > This was working fine, then following a Linux headers upgrade last week it 
> > started to play up (connection failing or repeatedly dropping)
> 
> Hi Karen,
> 
> I assume the upgrade involved a kernel upgrade and not just the headers.
> It would be very interesting to know the package versions before and
> after this particular upgrade. I added Seth as he may know whether the
> packaging software in Ubuntu keeps any log with that info.

There's both /var/log/dpkg.log* and /var/log/apt/* which contain some
history of what packages were upgraded and when. I know that
/var/log/apt/* shows both the old and new package versions for any given
upgrade, so you might start there.

The subsequent upgrade to a newer release will probably make it harder
to find, but everything there should include dates and times when the
packages were upgraded which ought to help. Hopefully the relevant data
hasn't rotated out of the logs yet.

> > As a LTS Ubuntu upgrade was due anyway I decided to complete this first and then 
> > see if this resolved the wireless issues. Ubuntu 14.04 successfully installed 
> > (using ethernet wired connection) but the wireless problem remains
> 
> Would you happen to know the kernel version before the upgrade as this
> surely looks like a regression.
> 
> > Having checked the various online forums I have
> > * run the various updates including -pciids
> > * purged bcmwl-kernel-source
> 
> Are you aware that this was actually used?
> 
> > * installed linux-firmware-nonfree
> 
> Uhm, what is this package?

I don't know the exact details, but I think it basically includes device
firmware which are distributible in some fashion but also have some
limitations on distribution/redistribution. The firmware which brcmsmac
uses is included in the linux-firmware package though and not that one.

> > * blacklisted the b43 and wl modules (the latter giving "modprobe: FATAL: Module 
> > wl not found" although given I was trying to blacklist it anyway I figured this 
> > did not matter)
> > * checked the module requirement for BCM4313 14e4:4727 = bcma, which is showing 
> > on the module list
> > 
> > As bcma is the recognised and non-blacklisted module I am puzzled to know why 
> > the wireless card still will not connect. And yes, I did reboot after each step!
> 
> Could you send me a kernel log from system start, ie. run 'dmesg' on the
> terminal.
> 
> > A check on the forums and your website suggests 3 possibilities:
> > * there is a missing dependency for bcma, perhaps something that is present in 
> > brcms? One of the forum 'solutions' suggests this
> > * there is a firmware update that I need to ensure is on my system, although a 
> > look at the lists on your website has nothing for :4727
> > * BCM4313 14e4:4727 is simply not going to work on the updated Linux headers - 
> > mine is currently 3.13.0 - 35 - generic, on a 32-bit system - your page 
> > http://wireless.kernel.org/en/users/Drivers/brcm80211#Supported_Chips hints that 
> > not all 4313 chips will function
> > 
> > I do not know if this 'bug' - for which there seems to be much evidence on the 
> > forums as a dependency conflict - is still live, is going to be fixed or is a 
> > 'wait and see' issue, but any assistance in pointing me in the right direction 
> > would be useful.
> > 
> > I am a private user trying to keep the family laptops going rather than a 
> > professional technician but I can work through logical processes and have no 
> > problems using terminal commands etc
> 
> We will make an effort. The bcm4313 keeps nagging as there are many
> variations of that card being used and brcmsmac may be missing some
> essential piece for it.
> 
> Regards,
> Arend
> 
> > Even if it is just a 'sorry, unlucky to have this combo, cannot help' it would 
> > save me a lot of time trying to get it sorted!
> 
