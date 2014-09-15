Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:42378 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaIOPt0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 11:49:26 -0400
Received: by mail-oi0-f45.google.com with SMTP id v63so2392967oia.18
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2014 08:49:26 -0700 (PDT)
Date: Mon, 15 Sep 2014 10:49:22 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Marc & Karen Vincent <karmavin@aol.com>
Cc: arend@broadcom.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: Re: BCM4313 14e4:4727 was working fine, now failing - Ubuntu Linux
Message-ID: <20140915154922.GA12981@ubuntu-hedt> (sfid-20140915_174931_246938_2D4020A9)
References: <8D19F0C0D277DCC-10DC-23F3@webmail-vm064.sysops.aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8D19F0C0D277DCC-10DC-23F3@webmail-vm064.sysops.aol.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 15, 2014 at 10:54:14AM -0400, Marc & Karen Vincent wrote:
> Hello Seth and Arend,
> 
> Thanks for getting back to me so quickly.
> 
> I hope that this gives some pointers - 
> 
> 
> dmesg output attached as requested. The lines 30.649061 and 30.649285 (ref brcms) appear as error messages on the screen during the boot process. The line 23.809659 seems to confirm the presence of the brcms and bcma modules
> From a check back through the system logs Linux updated on Friday 12th after which the wireless failed, it was with the same 3.13.0.xx that the Ubuntu 14.04 LTS upgrade installed on Saturday 13th
> From the logs of the Saturday 13th upgrade the previous version of Linux appears to have been 3.2.0.68.81 and wireless had definitely worked without modifications prior to this. Also, no attempt was made to fix the wireless BEFORE the LTS Ubuntu upgrade (wired), which incidentally was from 12.04 LTS and was problem free

Oh, in that case it sounds like we're talking about an upgrade from a
3.2.x kernel to a 3.13.x kernel. But I'm a bit confused - from the
original message I got the impression that you started seeing problems
before you did the LTS upgrade, but from this statement I get the
impression that the problems didn't start until after the upgrade. Can
you clarify?

Those error messages you pointed out aren't really errors in the sense
that something went wrong, they're just notifications of features which
haven't been implemented in brcmsmac. They aren't related to the
problems you're seeing.

I didn't notice anything in the dmesg which provides any clues as to
what's going on. Maybe Arend will notice something I missed.

> Purging of bcmwl-kernel-source package was recommended on the majority of the Ubuntu forum solutions to ensure unwanted modules were not present and conflicting. I am not aware of it being active

If you hadn't installed the bcmwl-kernel-source package then all of
those instructions probably had no practical effect on your machine.

> This is the link for the contents of the package linux firmware nonfree which should provide the information re the drivers that are being installed through it http://packages.ubuntu.com/trusty/kernel/linux-firmware-nonfree
> 
> This is the link to the 'module to use/blacklist' answer which seemed to summarise what everyone was saying https://help.ubuntu.com/community/WifiDocs/Driver/bcm43xx#Known_Issues
> 
> I have taken copies of the log files for the system updates completed in the week prior to, and including, the LTS Ubuntu upgrade. As you can imagine these are big so if you need any details from them perhaps you would like to give me a filter so you only get the bits you need.

You'll need to look for entries matching the date and approximate time
when you did the update. In those logs dates are in the format
yyyy-mm-dd and times are hh:mm:ss in 24-hour time. Then we're interested
in installation or updates to packages which started with "linux-".
Though if the problems only started happening after the upgrade to 14.04
I doubt that this information is going to tell us much more.

> Many thanks for looking into this. Hopefully it will be obvious to you what changed!
> 
> 
> Karen
> 
> 
> 
> 
> 
> -----Original Message-----
> From: Seth Forshee <seth.forshee@canonical.com>
> To: Arend van Spriel <arend@broadcom.com>; Karen Vincent <KarMaVin@aol.com>
> CC: brcm80211-dev-list <brcm80211-dev-list@broadcom.com>; linux-wireless <linux-wireless@vger.kernel.org>
> Sent: Mon, 15 Sep 2014 12:41
> Subject: Re: BCM4313 14e4:4727 was working fine, now failing - Ubuntu Linux
> 
> 
> On Mon, Sep 15, 2014 at 10:15:57AM +0200, Arend van Spriel wrote:
> > + linux-wireless, Seth
> > 
> > On 14-09-14 16:36, Karen Vincent wrote:
> > > Hello,
> > > 
> > > I am trying to fix a wireless connectivity problem on a Lenovo G585 which 
> has 
> > > BCM4313 14e4:4727 (rev 01) running on Ubuntu 14.04
> > > 
> > > This was working fine, then following a Linux headers upgrade last week it 
> > > started to play up (connection failing or repeatedly dropping)
> > 
> > Hi Karen,
> > 
> > I assume the upgrade involved a kernel upgrade and not just the headers.
> > It would be very interesting to know the package versions before and
> > after this particular upgrade. I added Seth as he may know whether the
> > packaging software in Ubuntu keeps any log with that info.
> 
> There's both /var/log/dpkg.log* and /var/log/apt/* which contain some
> history of what packages were upgraded and when. I know that
> /var/log/apt/* shows both the old and new package versions for any given
> upgrade, so you might start there.
> 
> The subsequent upgrade to a newer release will probably make it harder
> to find, but everything there should include dates and times when the
> packages were upgraded which ought to help. Hopefully the relevant data
> hasn't rotated out of the logs yet.
> 
> > > As a LTS Ubuntu upgrade was due anyway I decided to complete this first and 
> then 
> > > see if this resolved the wireless issues. Ubuntu 14.04 successfully 
> installed 
> > > (using ethernet wired connection) but the wireless problem remains
> > 
> > Would you happen to know the kernel version before the upgrade as this
> > surely looks like a regression.
> > 
> > > Having checked the various online forums I have
> > > * run the various updates including -pciids
> > > * purged bcmwl-kernel-source
> > 
> > Are you aware that this was actually used?
> > 
> > > * installed linux-firmware-nonfree
> > 
> > Uhm, what is this package?
> 
> I don't know the exact details, but I think it basically includes device
> firmware which are distributible in some fashion but also have some
> limitations on distribution/redistribution. The firmware which brcmsmac
> uses is included in the linux-firmware package though and not that one.
> 
> > > * blacklisted the b43 and wl modules (the latter giving "modprobe: FATAL: 
> Module 
> > > wl not found" although given I was trying to blacklist it anyway I figured 
> this 
> > > did not matter)
> > > * checked the module requirement for BCM4313 14e4:4727 = bcma, which is 
> showing 
> > > on the module list
> > > 
> > > As bcma is the recognised and non-blacklisted module I am puzzled to know 
> why 
> > > the wireless card still will not connect. And yes, I did reboot after each 
> step!
> > 
> > Could you send me a kernel log from system start, ie. run 'dmesg' on the
> > terminal.
> > 
> > > A check on the forums and your website suggests 3 possibilities:
> > > * there is a missing dependency for bcma, perhaps something that is present 
> in 
> > > brcms? One of the forum 'solutions' suggests this
> > > * there is a firmware update that I need to ensure is on my system, although 
> a 
> > > look at the lists on your website has nothing for :4727
> > > * BCM4313 14e4:4727 is simply not going to work on the updated Linux headers 
> - 
> > > mine is currently 3.13.0 - 35 - generic, on a 32-bit system - your page 
> > > http://wireless.kernel.org/en/users/Drivers/brcm80211#Supported_Chips hints 
> that 
> > > not all 4313 chips will function
> > > 
> > > I do not know if this 'bug' - for which there seems to be much evidence on 
> the 
> > > forums as a dependency conflict - is still live, is going to be fixed or is 
> a 
> > > 'wait and see' issue, but any assistance in pointing me in the right 
> direction 
> > > would be useful.
> > > 
> > > I am a private user trying to keep the family laptops going rather than a 
> > > professional technician but I can work through logical processes and have no 
> 
> > > problems using terminal commands etc
> > 
> > We will make an effort. The bcm4313 keeps nagging as there are many
> > variations of that card being used and brcmsmac may be missing some
> > essential piece for it.
> > 
> > Regards,
> > Arend
> > 
> > > Even if it is just a 'sorry, unlucky to have this combo, cannot help' it 
> would 
> > > save me a lot of time trying to get it sorted!
> > 
> 
>  


