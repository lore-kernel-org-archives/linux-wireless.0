Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab0C3Qry (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 12:47:54 -0400
Subject: Re: b43 'hardware blocked' but only keyboard/led touch button
From: Dan Williams <dcbw@redhat.com>
To: Philippe De Muyter <phdm@macqel.be>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
In-Reply-To: <20100330073401.GA13675@frolo.macqel>
References: <20100329201236.GA9587@frolo.macqel>
	 <4BB1335F.7030306@lwfinger.net>  <20100330073401.GA13675@frolo.macqel>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 09:47:37 -0700
Message-ID: <1269967657.3019.16.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-03-30 at 09:34 +0200, Philippe De Muyter wrote:
> Hello Larry,

Adding Matthew Garrett to the CC list, since he knows about such
things...

It could be that hp-wmi doesn't have support for these models yet, or
that the dv6-1300sb is simply completely different.  But for example, on
my Elitebook 2530p, there's a softswitch that pokes BIOS, and when BIOS
is softkilled, the onboard wifi becomes hardkilled.  To unkill, I need
to unblock BIOS, which then either unblocks wifi, or turns the wifi
hardkill into a softkill.  Convoluted.

Dan

> On Mon, Mar 29, 2010 at 06:10:23PM -0500, Larry Finger wrote:
> > On 03/29/2010 03:12 PM, Philippe De Muyter wrote:
> > > Hello wireless-linux experts,
> > > 
> > > I have installed yesterday the last opensuse 11.3 rc4 on a
> > > hp pavilion dv6-1300sb laptop which is has a
> > > 
> > > 02:00.0 Network controller [0280]: Broadcom Corporation BCM4312 802.11b/g LP-PHY [14e4:4315] (rev 01)
> > > 
> > > as wireless chip.
> > > 
> > > I needed to install such a bleeding edge distro because opensuse 11.2 does
> > > not have the lp_phy driver yet.
> > > 
> > > with dmesg, I see :
> > > 
> > > [   21.818415] b43 ssb0:0: firmware: requesting b43/ucode15.fw
> > > [   21.820519] b43 ssb0:0: firmware: requesting b43/lp0initvals15.fw
> > > [   21.823084] b43 ssb0:0: firmware: requesting b43/lp0bsinitvals15.fw
> > > [   21.975380] b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
> > > [   22.076456] b43-phy0: Radio hardware status changed to DISABLED
> > > [   22.077743] b43-phy0: Radio turned on by software
> > > [   22.077747] b43-phy0: The hardware RF-kill button still turns the radio physically off. Press the button to turn it on.
> > > [   22.078413] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> > > 
> > > this is confirmed by rfkill :
> > > 
> > > 0: phy0: Wireless LAN
> > >         Soft blocked: no
> > >         Hard blocked: yes
> > > 
> > > BUT, I DON'T SEE A HARDWARE RF-KILL button;  I only see a red-lighted wireless
> > > symbol, which is also a touch-key; in console mode, when I touch this
> > > touch-key I get a message asking me to
> > > 
> > > 	'setkey e014 <keycode>'
> > > 
> > > I have already seen this symbol being blue-lighted in the first seconds of
> > > linux booting, but I don't know what changes this color or if this has
> > > an effect on the 'hardware' RF-kill button.  In the BIOS there is no option
> > > to enable or disable the wireless interface.
> > > 
> > > Any hint ?
> > > 
> > > Thanks already for the good work so far
> > 
> > Is the module hp-wmi loaded? That module is designed to implement all of the
> > special keys for HP laptops.
> > 
> > Larry
> 
> No, thanks for the suggestion.  Here is the log of my attempt :
> 
> $ modprobe hp-wmi
> FATAL: Error inserting hp_wmi (/lib/modules/2.6.33-6-desktop/kernel/drivers/platform/x86/hp-wmi.ko): No such device
> 
> and there is nothing in dmesg.
> 
> If that can help, here is the output of lspci :
> 
> 00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
> 00:01.0 PCI bridge: Intel Corporation Mobile 4 Series Chipset PCI Express Graphics Port (rev 07)
> 00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03)
> 00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03)
> 00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03)
> 00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
> 00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03)
> 00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 03)
> 00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 (rev 03)
> 00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 5 (rev 03)
> 00:1c.5 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 6 (rev 03)
> 00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03)
> 00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03)
> 00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03)
> 00:1d.3 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03)
> 00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03)
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
> 00:1f.0 ISA bridge: Intel Corporation ICH9M LPC Interface Controller (rev 03)
> 00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03)
> 00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
> 00:1f.6 Signal processing controller: Intel Corporation 82801I (ICH9 Family) Thermal Subsystem (rev 03)
> 01:00.0 VGA compatible controller: ATI Technologies Inc M96 [Mobility Radeon HD 4650]
> 01:00.1 Audio device: ATI Technologies Inc RV710/730
> 02:00.0 Network controller: Broadcom Corporation BCM4312 802.11b/g LP-PHY (rev 01)
> 03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
> 06:00.0 FireWire (IEEE 1394): JMicron Technology Corp. IEEE 1394 Host Controller
> 06:00.1 System peripheral: JMicron Technology Corp. SD/MMC Host Controller
> 06:00.2 SD Host controller: JMicron Technology Corp. Standard SD Host Controller
> 06:00.3 System peripheral: JMicron Technology Corp. MS Host Controller
> 06:00.4 System peripheral: JMicron Technology Corp. xD Host Controller
> 
> Philippe
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


