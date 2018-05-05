Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:43318 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751230AbeEEVLQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 May 2018 17:11:16 -0400
Received: by mail-oi0-f47.google.com with SMTP id p62-v6so22062283oie.10
        for <linux-wireless@vger.kernel.org>; Sat, 05 May 2018 14:11:16 -0700 (PDT)
Subject: Re: rtl8188eu: link is not ready error on lm816
To: =?UTF-8?Q?Myl=c3=a8ne_Josserand?= <mylene.josserand@bootlin.com>,
        linux-wireless@vger.kernel.org
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20180504212057.2edaa658@dell-desktop.home>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <f40ea748-d53f-9cd5-18f9-e713c86865bb@lwfinger.net> (sfid-20180505_231123_109787_7AC71AA0)
Date: Sat, 5 May 2018 16:11:13 -0500
MIME-Version: 1.0
In-Reply-To: <20180504212057.2edaa658@dell-desktop.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/04/2018 02:20 PM, Mylène Josserand wrote:
> Hello everyone,
> 
> I am currently testing a USB Wifi dongle LM816 [1] on a custom platform
> based on an IMX6.
> 
> My configuration:
> 	kernel from mainline: v4.14
> 	driver: staging R8188EU
> 	firmware: rtl8188eu from linux-firmware, last commit
> 	a3a26af24e29c818ef9b5661856018e21a5c49fb
> 
> When I tried to set the wlan interface up, it says that "link is not
> ready" and that's all. Because of that, it fails to scan available
> networks.
> 
> Here are commands used and their output:
> 
> # dmesg
> [...]
> [   14.690152] r8188eu: module is from the staging directory, the
> quality is unknown, you have been warned.
> [   14.703105] Chip Version
> Info: CHIP_8188E_Normal_Chip_TSMC_D_CUT_1T1R_RomVer(0)
> [...]
> 
> # lsusb
> Bus 002 Device 004: ID 0bda:8179  <-- LM816
> Bus 002 Device 003: ID 0424:9e00
> Bus 002 Device 002: ID 0424:2517
> Bus 002 Device 001: ID 1d6b:0002
> Bus 001 Device 001: ID 1d6b:0002
> 
> # lsmod
> Module                  Size  Used by    Tainted: G
> dw_hdmi_ahb_audio      16384  0
> r8188eu               401408  0
> coda                   61440  0
> imx_vdoa               16384  1 coda
> v4l2_mem2mem           24576  1 coda
> videobuf2_vmalloc      16384  1 coda
> evbug                  16384  0
> 
> # ifconfig wlan0 up
> [  447.639524] MAC Address = 5c:f3:70:3d:5c:71
> [  447.653636] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> #
> #
> # iw wlan0 scan
> command failed: No such device (-19)
> 
> 
> Does anyone already have this issue with this dongle?
> If it is not the case, what is your setup? Which firmware? Which driver?
> Any help will be very appreciated.
> 
> Thanks in advance,
> Best regards,
> 
> [1]:
> https://www.lm-technologies.com/product/wifi-usb-nano-adapter-150mbps-lm816/

I am running kernel 4.17.0-rc3 under openSUSE Tumbleweed KDE on a Toshiba 
laptop, and controlling networks with NetworkManager. When I plug my dongle in, 
the device connects automatically. The firmware I am using has the following md5sum:

aaef52a47852e599cbff63a3e7f96a94  /lib/firmware/rtlwifi/rtl8188eufw.bin

My dongle shows the following with lsusb:
ID 0bda:8179 Realtek Semiconductor Corp. RTL8188EUS 802.11n Wireless Network Adapter

Mine shows as an A-cut:
Chip Version Info: CHIP_8188E_Normal_Chip_TSMC_A_CUT_1T1R_RomVer(0)

Yours is a D-cut, but I would not expect any difference from that. The only 
place that information is used is in the log entry shown above.

If you want to try a different driver, there is one at
http://github.com/lwfinger/rtl8188eu.git

Larry
