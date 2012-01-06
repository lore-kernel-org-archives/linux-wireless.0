Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60167 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030358Ab2AFPvN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jan 2012 10:51:13 -0500
Received: by iaeh11 with SMTP id h11so2788842iae.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jan 2012 07:51:12 -0800 (PST)
Message-ID: <4F07186D.7020708@lwfinger.net> (sfid-20120106_165118_228746_C95B855A)
Date: Fri, 06 Jan 2012 09:51:09 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: lina <lina.lastname@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Fwd: how to uninstall the b43 and reinstall
References: <4F070CF4.5030708@gmail.com>
In-Reply-To: <4F070CF4.5030708@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/06/2012 09:02 AM, lina wrote:
> Hi,
>
> a quick question, how to clear the b43?
>
>
> a detailed background stories as following:
>
>
> I installed the b43 following the advice given by list,
> mainly from
> http://linuxwireless.org/en/users/Drivers/b43
>
> it WORKED.
>
> but yesterday I removed the old kernel 3.2-rc6, which is the one b43 worked,
> and installed the 3.2 from kernel.org. I guess it's latest, than 3.2-rc6 ?
>
> I don't know how to remove the b43 since the trial of
> make uninstall in pathTo/b43-fwcutter-015 not work.
>
> so I just did something like make install again, and then
> 1
> <http://linuxwireless.org/en/users/Drivers/b43#CA-d6bf7044c28bbe20619873aa0dd5f8faa0864c61_1>
> export FIRMWARE_INSTALL_DIR="/lib/firmware"
> 2
> <http://linuxwireless.org/en/users/Drivers/b43#CA-d6bf7044c28bbe20619873aa0dd5f8faa0864c61_2>
> wget http://www.lwfinger.com/b43-firmware/broadcom-wl-5.100.138.tar.bz2
> 3
> <http://linuxwireless.org/en/users/Drivers/b43#CA-d6bf7044c28bbe20619873aa0dd5f8faa0864c61_3>
> tar xjf broadcom-wl-5.100.138.tar.bz2
> 4 sudo b43-fwcutter -w "$FIRMWARE_INSTALL_DIR"
> broadcom-wl-5.100.138/linux/wl_apsta.o
>
> dmesg showed me:
> [ 127.434017] cfg80211: Calling CRDA to update world regulatory domain
> [ 127.704793] b43-phy0: Broadcom 4331 WLAN found (core revision 29)
> [ 127.704821] bcma: Switched to core: 0x812
> [ 127.705237] b43-phy0 ERROR: FOUND UNSUPPORTED PHY (Analog 9, Type 7, Revision 1)
> [ 127.705244] b43: probe of bcma0:0 failed with error -95
> [ 127.705260] Broadcom 43xx driver loaded [ Features: PMNLS ]
> [ 431.367724] applesmc: FS! : read arg fail

You are very confused. The only thing you can "uninstall" is the firmware 
cutter. The driver b43 is part of the kernel. Installing a new kernel gets you a 
new version.

Your problem with the 4331 is that you are getting your kernel from the wrong 
source. If you want to run that device with 4331, you need code that will not be 
in a mainline kernel until 3.3-rc1, which will not be available for about 2 
weeks. The kernel you need is the one found in the git tree of wireless-testing, 
or you need to build a recent compat-wireless package. I suspect that is what 
you did with 3.2-rc6.

Larry


