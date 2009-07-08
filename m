Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:49406 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbZGHST2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2009 14:19:28 -0400
Received: by yxe26 with SMTP id 26so8218042yxe.33
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jul 2009 11:19:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <dcc24d260907032143h38165b8as9f18da70b16ed2a@mail.gmail.com>
References: <dcc24d260907032143h38165b8as9f18da70b16ed2a@mail.gmail.com>
Date: Wed, 8 Jul 2009 13:19:27 -0500
Message-ID: <dcc24d260907081119j778ba587ob82bd953ed95eb8c@mail.gmail.com>
Subject: Re: Slow wired network when wireless card is also active
From: David Webber <dwebber@illinois.edu>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 3, 2009 at 11:43 PM, David Webber <dwebber@illinois.edu> wrote:
>
> I'm trying to use Jaunty on my Centrino laptop as a wireless access
> point / NAT. My cable modem is plugged in to the ethernet port.
> Strangely, when I enable the wireless card (via hostapd or simply
> 'ifconfig wlan1 192.168.0.1 up'), my WIRED network slows down. On a
> terminal on the laptop, I see transfer speeds drop from over about 200
> K/s to about 40 K/s. As far as I can tell, the problem is not affected
> by iptables rules, ip_forward on/off, or ipv6. Just having the
> wireless card present and active seems to affect the wired interface.
> The problem may have something to do with having hostapd active, but
> I'm not sure.
>
> Aside: I have an intel wireless card built-in but since it can't do
> hostap-mode, I purchased the ath9k cardbus card. The intel card is
> disabled by function-key and is not active on boot. I have recent
> versions of the kernel and hostapd from the subversion repositories
> discussed on linuxwireless.org.
>
> Linux version 2.6.30-custom-wl (root@whitebook) (gcc version 4.3.3
> (Ubuntu 4.3.3-5ubuntu4) ) #1 SMP Thu Jun 18 19:22:02 CDT 2009
>
> 00:00.0 Host bridge: Intel Corporation 82852/82855 GM/GME/PM/GMV
> Processor to I/O Controller (rev 02)
> 00:00.1 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV
> Processor to I/O Controller (rev 02)
> 00:00.3 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV
> Processor to I/O Controller (rev 02)
> 00:02.0 VGA compatible controller: Intel Corporation 82852/855GM
> Integrated Graphics Device (rev 02)
> 00:02.1 Display controller: Intel Corporation 82852/855GM Integrated
> Graphics Device (rev 02)
> 00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM
> (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 03)
> 00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM
> (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 03)
> 00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM
> (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 03)
> 00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M)
> USB2 EHCI Controller (rev 03)
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 83)
> 00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface
> Bridge (rev 03)
> 00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE
> Controller (rev 03)
> 00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M)
> SMBus Controller (rev 03)
> 00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM
> (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 03)
> 00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M)
> AC'97 Modem Controller (rev 03)
> 01:01.0 Network controller: Intel Corporation PRO/Wireless 2200BG
> [Calexico2] Network Connection (rev 05)
> 01:02.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL-8139/8139C/8139C+ (rev 10)
> 01:04.0 CardBus bridge: Texas Instruments PCI1410 PC card Cardbus
> Controller (rev 02)
> 01:05.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306 Fire II
> IEEE 1394 OHCI Link Layer Controller (rev 80)
> 02:00.0 Network controller: Atheros Communications Inc. AR5008
> Wireless Network Adapter (rev 01)
>
> Speed test:
> (start with everything active. NAT works, other computers can reach
> the internet through the laptop, but the speed is just slow. For this
> test, no other machines were connected so they're not consuming the
> bandwidth)
> $ wget http://cosmos.cites.uiuc.edu/pub/ubuntu-iso/9.04/ubuntu-9.04-desktop-amd64.iso
> [snip] 47.6K/s eta 4h 56m
> $ sudo ifdown wlan1
> [snip] 44.5K/s eta 5h 54m
> $ sudo ifconfig mon.wlan1 down
> [snip] 245K/s eta 45m 7s
>
> As you can see, I lose about a factor of 5 when the wireless card is active.
>
> I also posted this question to
> https://answers.launchpad.net/ubuntu/+question/76037
>
> Thanks in advance,
> David

I tracked this down to the Realtek ethernet.  When I plugged my cable
modem over USB rather than over ethernet, the speed improved to
normal.  I've seen on other forums a problem with slowness using
reatek ethernet.  Strange that it would only show up when two network
interfaces are active though.

David
