Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm16-vm0.bullet.mail.ird.yahoo.com ([77.238.189.192]:21825 "HELO
	nm16-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753034Ab1GWUHY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 16:07:24 -0400
Message-ID: <1311451643.25625.YahooMailClassic@web29501.mail.ird.yahoo.com> (sfid-20110723_220729_356357_0CBC64FF)
Date: Sat, 23 Jul 2011 21:07:23 +0100 (BST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: rfkill bit and override - Re: Issues with rtl8187
To: Larry.Finger@lwfinger.net, herton@mandriva.com.br,
	andreamrl@tiscali.it, flamingice@sourmilk.net,
	Nikolaos Pavlidis <nikolaos.pavlidis@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAEA=Lw18SJW4h4u-yDGe1aXbHP0n69Uq=h+MtG6x-Ut7wyD9Og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Please always CC: one of the relevant mailing list, as well as use a more appropriate/specific subject than 'issues with rtl8187')

--- On Sat, 23/7/11, Nikolaos Pavlidis <nikolaos.pavlidis@gmail.com> wrote:

> Hello all,
> 
> First of all my apologies for being so direct on contacting
> you, but I
> have reached my limit with this issue. we have been going
> at it at
> #backtrack-linux for a while now and no permanent solution
> is in
> sight.
> Second I would like to thank you for providing the driver
> to begin
> with! Now moving on to the issue.
> 
> The system: Backtrack-5 VMware Workstation
> The device: Netgear WG111v3
> 
> The issue:
> Jul 23 12:16:39 bt kernel: [  640.033748] rtl8187:
> wireless radio
> switch turned off
> 
> The result of "ifconfig wlan0 up":
> SIOCSIFFLAGS: Unknown error 132
> 
> "udevadm monitor" output:
> KERNEL[1311437799.765141] change
> /devices/pci0000:00/0000:00:11.0/0000:02:03.0/usb1/1-1/1-1:1.0/ieee80211/phy0/rfkill0
> (rfkill)
> UDEV  [1311437799.765889] change
> /devices/pci0000:00/0000:00:11.0/0000:02:03.0/usb1/1-1/1-1:1.0/ieee80211/phy0/rfkill0
> (rfkill)
> 
> "rfkill list all" output:
> 0: phy0: Wireless LAN
>     Soft blocked: no
>     Hard blocked: yes
> 
> "modinfo rtl8187" output (cut-down version):
> filename:
> /lib/modules/2.6.38/kernel/drivers/net/wireless/rtl818x/rtl8187/rtl8187.ko
> license:        GPL
> description:    RTL8187/RTL8187B USB wireless
> driver
> srcversion: 
>    60EF29201888665B0214271
> depends:       
> mac80211,eeprom_93cx6,cfg80211
> vermagic:       2.6.38 SMP
> mod_unload ELAN
> 
> The question:
> Can a solution be engineered on this issue? I understand
> that the
> module works fine when on true hardware and not on a vm,
> but couldn't
> you engineer something like an "rfkill=0" option for it so
> it does not
> get turned off?
> 
> Many thanks in advance.

That "unknown" error from ifconfig seems wrong/broken. 

I seem to remember a while ago we had a report of somebody with some strange hardware for which the hardware rfkill switch works the other way round (i.e. on<->off position/detection was the other way round compared to other devices) - you might want to look at the kernel changes, and/or try compat-wireless.

I am surprised about your outcry of 'reached ...limit'. If the worst comes to the worst, you can always hack the kernel source to disable the rfkill functionality out completely within the driver. (I suppose you already have vm-related patches which aren't in the mainline kernel nor acceptable/accepted in mainline, so another patch isn't out of the question). There are also patches around which makes some of the rtl8187 behavior controllable via /sysfs or /proc (at least I know of one: to force the driver to bind to a usb device with an unknown vid/pid) so it is certainly possible to override rfkill behavior via such means. But of course, the whole point of rfkill is regulatory compliance as well as least user-surprise, so adding some kind of backdoor override isn't acceptable, at least in the mainline kernel.

Back to your problem - perhaps the most important question is, why is the driver mis-detecting/mis-interpreting the rfkill switch state, if there is any? AFAIK devices without rfkill switches are detected as always on.


