Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:57324 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753278AbeENGzd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 02:55:33 -0400
Date: Mon, 14 May 2018 08:55:21 +0200
From: =?UTF-8?B?TXlsw6huZQ==?= Josserand <mylene.josserand@bootlin.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: rtl8188eu: link is not ready error on lm816
Message-ID: <20180514085521.1529d00b@dell-desktop.home> (sfid-20180514_092805_911653_BB194676)
In-Reply-To: <f40ea748-d53f-9cd5-18f9-e713c86865bb@lwfinger.net>
References: <20180504212057.2edaa658@dell-desktop.home>
        <f40ea748-d53f-9cd5-18f9-e713c86865bb@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Larry,

Sorry about the delay, I was on holiday last week.

On Sat, 5 May 2018 16:11:13 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> On 05/04/2018 02:20 PM, Mylène Josserand wrote:
> > Hello everyone,
> > 
> > I am currently testing a USB Wifi dongle LM816 [1] on a custom platform
> > based on an IMX6.
> > 
> > My configuration:
> > 	kernel from mainline: v4.14
> > 	driver: staging R8188EU
> > 	firmware: rtl8188eu from linux-firmware, last commit
> > 	a3a26af24e29c818ef9b5661856018e21a5c49fb
> > 
> > When I tried to set the wlan interface up, it says that "link is not
> > ready" and that's all. Because of that, it fails to scan available
> > networks.
> > 
> > Here are commands used and their output:
> > 
> > # dmesg
> > [...]
> > [   14.690152] r8188eu: module is from the staging directory, the
> > quality is unknown, you have been warned.
> > [   14.703105] Chip Version
> > Info: CHIP_8188E_Normal_Chip_TSMC_D_CUT_1T1R_RomVer(0)
> > [...]
> > 
> > # lsusb
> > Bus 002 Device 004: ID 0bda:8179  <-- LM816
> > Bus 002 Device 003: ID 0424:9e00
> > Bus 002 Device 002: ID 0424:2517
> > Bus 002 Device 001: ID 1d6b:0002
> > Bus 001 Device 001: ID 1d6b:0002
> > 
> > # lsmod
> > Module                  Size  Used by    Tainted: G
> > dw_hdmi_ahb_audio      16384  0
> > r8188eu               401408  0
> > coda                   61440  0
> > imx_vdoa               16384  1 coda
> > v4l2_mem2mem           24576  1 coda
> > videobuf2_vmalloc      16384  1 coda
> > evbug                  16384  0
> > 
> > # ifconfig wlan0 up
> > [  447.639524] MAC Address = 5c:f3:70:3d:5c:71
> > [  447.653636] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> > #
> > #
> > # iw wlan0 scan
> > command failed: No such device (-19)
> > 
> > 
> > Does anyone already have this issue with this dongle?
> > If it is not the case, what is your setup? Which firmware? Which driver?
> > Any help will be very appreciated.
> > 
> > Thanks in advance,
> > Best regards,
> > 
> > [1]:
> > https://www.lm-technologies.com/product/wifi-usb-nano-adapter-150mbps-lm816/  
> 
> I am running kernel 4.17.0-rc3 under openSUSE Tumbleweed KDE on a Toshiba 
> laptop, and controlling networks with NetworkManager. 

I am running a kernel v4.14.0. The last commit I have for this driver
is:
b24413180f56 'License cleanup: add SPDX GPL-2.0 license identifier to
files with no license'.

There is many new commits on top of it. I will try to update the driver
or my kernel to have the last version.

> When I plug my dongle in, 
> the device connects automatically. The firmware I am using has the following md5sum:
> 
> aaef52a47852e599cbff63a3e7f96a94  /lib/firmware/rtlwifi/rtl8188eufw.bin

Okay, I have the same md5sum so we are using the same firmware:
aaef52a47852e599cbff63a3e7f96a94  /lib/firmware/rtlwifi/rtl8188eufw.bin

> 
> My dongle shows the following with lsusb:
> ID 0bda:8179 Realtek Semiconductor Corp. RTL8188EUS 802.11n Wireless Network Adapter

Same here:
ID 0bda:8179 Realtek Semiconductor Corp. RTL8188EUS 802.11n Wireless
Network Adapter

> 
> Mine shows as an A-cut:
> Chip Version Info: CHIP_8188E_Normal_Chip_TSMC_A_CUT_1T1R_RomVer(0)
> 
> Yours is a D-cut, but I would not expect any difference from that. The only 
> place that information is used is in the log entry shown above.
> 
> If you want to try a different driver, there is one at
> http://github.com/lwfinger/rtl8188eu.git
> 
> Larry
> 
> 

I will try to update my kernel and I will let you know if it is now
working (or not).

Anyway, thanks for your help!

Best regards,

-- 
Mylène Josserand, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
http://bootlin.com
