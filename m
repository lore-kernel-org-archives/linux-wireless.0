Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:55716 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaIWMxK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 08:53:10 -0400
Message-ID: <54216D33.1000404@broadcom.com> (sfid-20140923_145314_012384_7FE216A7)
Date: Tue, 23 Sep 2014 14:53:07 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Marc & Karen Vincent <karmavin@aol.com>
CC: <seth.forshee@canonical.com>, <linux-wireless@vger.kernel.org>,
	<brcm80211-dev-list@broadcom.com>
Subject: Re: BCM4313 14e4:4727 was working fine, now failing - Ubuntu Linux
References: <8D19F0C0D277DCC-10DC-23F3@webmail-vm064.sysops.aol.com>
In-Reply-To: <8D19F0C0D277DCC-10DC-23F3@webmail-vm064.sysops.aol.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/14 16:54, Marc & Karen Vincent wrote:
> HelloSeth and Arend,
>
> Thanks for getting back to me so quickly.
>
> I hope that this gives some pointers -
>
>     * dmesg output attached as requested. The lines 30.649061 and
>       30.649285 (ref brcms) appear as error messages on the screen
>       during the boot process. The line 23.809659 seems to confirm the
>       presence of the brcms and bcma modules
>     *  From a check back through the system logs Linux updated on Friday
>       12th after which the wireless failed, it was with the same
>       3.13.0.xx that the Ubuntu 14.04 LTS upgrade installed on Saturday 13th
>     *  From the logs of the Saturday 13th upgrade the previous version
>       of Linux appears to have been 3.2.0.68.81 and wireless had
>       definitely worked without modifications prior to this. Also, no
>       attempt was made to fix the wireless BEFORE the LTS Ubuntu upgrade
>       (wired), which incidentally was from 12.04 LTS and was problem free
>     * Purging of bcmwl-kernel-source package was recommended on the
>       majority of the Ubuntu forum solutions to ensure unwanted modules
>       were not present and conflicting. I am not aware of it being active
>     * This is the link for the contents of the package linux firmware
>       nonfree which should provide the information re the drivers that
>       are being installed through it
>       http://packages.ubuntu.com/trusty/kernel/linux-firmware-nonfree
>     * This is the link to the 'module to use/blacklist' answer which
>       seemed to summarise what everyone was saying
>       https://help.ubuntu.com/community/WifiDocs/Driver/bcm43xx#Known_Issues
>
> I have taken copies of the log files for the system updates completed in
> the week prior to, and including, the LTS Ubuntu upgrade. As you can
> imagine these are big so if you need any details from them perhaps you
> would like to give me a filter so you only get the bits you need.
>
> Many thanks for looking into this. Hopefully it will be obvious to you
> what changed!

 From your dotted list above I can only conclude that is worked with 
3.2.x and started failing with 3.13.x. I think I also asked for debugfs 
information. Can you run the following command and provide output to me:

$ cat /sys/kernel/debug/brcmsmac/*/hardware

Regards,
Arend

> Karen
>
>
> -----Original Message-----
> From: Seth Forshee <seth.forshee@canonical.com>
> To: Arend van Spriel <arend@broadcom.com>; Karen Vincent <KarMaVin@aol.com>
> CC: brcm80211-dev-list <brcm80211-dev-list@broadcom.com>; linux-wireless
> <linux-wireless@vger.kernel.org>
> Sent: Mon, 15 Sep 2014 12:41
> Subject: Re: BCM4313 14e4:4727 was working fine, now failing - Ubuntu Linux
>
> On Mon, Sep 15, 2014 at 10:15:57AM+0200, Arend van Spriel wrote:
>>  +  linux-wireless, Seth
>>
>>  On 14-09-14 16:36, Karen Vincent wrote:
>>  >  Hello,
>>  >
>>  >  I am trying to fix a wireless connectivity problem on a Lenovo G585 which
> has
>>  >  BCM4313 14e4:4727 (rev 01) running on Ubuntu 14.04
>>  >
>>  >  This was working fine, then following a Linux headers upgrade last week it
>>  >  started to play up (connection failing or repeatedly dropping)
>>
>>  Hi Karen,
>>
>>  I assume the upgrade involved a kernel upgrade and not just the headers.
>>  It would be very interesting to know the package versions before and
>>  after this particular upgrade. I added Seth as he may know whether the
>>  packaging software in Ubuntu keeps any log with that info.
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
>>  >  As a LTS Ubuntu upgrade was due anyway I decided to complete this first and
> then
>>  >  see if this resolved the wireless issues. Ubuntu 14.04 successfully
> installed
>>  >  (using ethernet wired connection) but the wireless problem remains
>>
>>  Would you happen to know the kernel version before the upgrade as this
>>  surely looks like a regression.
>>
>>  >  Having checked the various online forums I have
>>  >  * run the various updates including -pciids
>>  >  * purged bcmwl-kernel-source
>>
>>  Are you aware that this was actually used?
>>
>>  >  * installed linux-firmware-nonfree
>>
>>  Uhm, what is this package?
>
> I don't know the exact details, but I think it basically includes device
> firmware which are distributible in some fashion but also have some
> limitations on distribution/redistribution. The firmware which brcmsmac
> uses is included in the linux-firmware package though and not that one.
>
>>  >  * blacklisted the b43 and wl modules (the latter giving"modprobe: FATAL:
> Module
>>  >  wl not found"  although given I was trying to blacklist it anyway I figured
> this
>>  >  did not matter)
>>  >  * checked the module requirement for BCM4313 14e4:4727 = bcma, which is
> showing
>>  >  on the module list
>>  >
>>  >  As bcma is the recognised and non-blacklisted module I am puzzled to know
> why
>>  >  the wireless card still will not connect. And yes, I did reboot after each
> step!
>>
>>  Could you send me a kernel log from system start, ie. run 'dmesg' on the
>>  terminal.
>>
>>  >  A check on the forums and your website suggests 3 possibilities:
>>  >  * there is a missing dependency for bcma, perhaps something that is present
> in
>>  >  brcms? One of the forum 'solutions' suggests this
>>  >  * there is a firmware update that I need to ensure is on my system, although
> a
>>  >  look at the lists on your website has nothing for :4727
>>  >  * BCM4313 14e4:4727 is simply not going to work on the updated Linux headers
> -
>>  >  mine is currently 3.13.0 - 35 - generic, on a 32-bit system - your page
>>  >  http://wireless.kernel.org/en/users/Drivers/brcm80211#Supported_Chips  hints
> that
>>  >  not all 4313 chips will function
>>  >
>>  >  I do not know if this 'bug' - for which there seems to be much evidence on
> the
>>  >  forums as a dependency conflict - is still live, is going to be fixed or is
> a
>>  >  'wait and see' issue, but any assistance in pointing me in the right
> direction
>>  >  would be useful.
>>  >
>>  >  I am a private user trying to keep the family laptops going rather than a
>>  >  professional technician but I can work through logical processes and have no
>
>>  >  problems using terminal commands etc
>>
>>  We will make an effort. The bcm4313 keeps nagging as there are many
>>  variations of that card being used and brcmsmac may be missing some
>>  essential piece for it.
>>
>>  Regards,
>>  Arend
>>
>>  >  Even if it is just a 'sorry, unlucky to have this combo, cannot help' it
> would
>>  >  save me a lot of time trying to get it sorted!
>>
>

