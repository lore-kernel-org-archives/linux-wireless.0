Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:38654 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbZIQMfg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 08:35:36 -0400
Received: by fxm17 with SMTP id 17so2939256fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2009 05:35:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AB1FAAB.1050103@canonical.com>
References: <4AA9B46E.8020100@canonical.com> <69e28c910909102318u465f6c75w46a2404a8e8d9f08@mail.gmail.com>
	<4AB0EDEB.9010803@canonical.com> <69e28c910909160813h2a91ff32hb5fa836f1f7a4963@mail.gmail.com>
	<4AB1AE43.6000602@canonical.com> <4AB1FAAB.1050103@canonical.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 17 Sep 2009 14:35:17 +0200
Message-ID: <69e28c910909170535r26aabb14mfbd3e31223f56618@mail.gmail.com>
Subject: Re: [b43] About supporting of BCM4312 [14e4:4315] with Low Power PHY
To: Bryan Wu <bryan.wu@canonical.com>
Cc: mb@bu3sch.de, stefano.brivio@polimi.it,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 17, 2009 at 11:00 AM, Bryan Wu <bryan.wu@canonical.com> wrote:
> Bryan Wu wrote:
>> Gábor Stefanik wrote:
>>> 2009/9/16 Bryan Wu <bryan.wu@canonical.com>:
>>>> Hi Gabor,
>>>>
>>>> I tried the latest cmpat-wireless 09-16 snapshot on my machine which runs on 2.6.31
>>>> Ubuntu Karmic latest kernel. The hardware probing passes and wlan1 interface shows up.
>>>> But the iwlist scanning got no data from wlan1 interface,
>>>>
>>>> dmesg:
>>>> ---
>>>> [  364.371703] b43-pci-bridge 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
>>>> [  364.371761] b43-pci-bridge 0000:07:00.0: setting latency timer to 64
>>>> [  364.437779] ssb: Sonics Silicon Backplane found on PCI device 0000:07:00.0
>>>> [  364.491488] b43-phy0: Broadcom 4312 WLAN found (core revision 15)
>>>> [  364.533562] b43-phy0 debug: Found PHY: Analog 6, Type 5, Revision 1
>>>> [  364.533604] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2062, Revision 2
>>>> [  364.693040] phy0: Selected rate control algorithm 'minstrel'
>>>> [  364.701666] Broadcom 43xx driver loaded [ Features: PML, Firmware-ID: FW13 ]
>>>> [  364.748486] udev: renamed network interface wlan0 to wlan1
>>>> [  364.824296] b43 ssb0:0: firmware: requesting b43/ucode15.fw
>>>> [  364.901848] b43 ssb0:0: firmware: requesting b43/lp0initvals15.fw
>>>> [  364.931482] b43 ssb0:0: firmware: requesting b43/lp0bsinitvals15.fw
>>>> [  365.140212] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
>>> Please test with v478 or newer.
>>
>> OK, do you know where can I find this firmware? I just followed the wiki page to get the firmware, but it seems the same version as I am using.
>> http://linuxwireless.org/en/users/Drivers/b43#device_firmware
>>
>
> I tried the one from here: http://downloads.openwrt.org/sources/broadcom-wl-4.178.10.4.tar.bz2
> Still got the same result,
> [   95.360263] b43-pci-bridge 0000:07:00.0: PCI INT A disabled
> [  122.214822] b43-pci-bridge 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [  122.214880] b43-pci-bridge 0000:07:00.0: setting latency timer to 64
> [  122.285420] ssb: Sonics Silicon Backplane found on PCI device 0000:07:00.0
> [  122.354411] b43-phy0: Broadcom 4312 WLAN found (core revision 15)
> [  122.397222] b43-phy0 debug: Found PHY: Analog 6, Type 5, Revision 1
> [  122.397260] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2062, Revision 2
> [  122.544617] phy0: Selected rate control algorithm 'minstrel'
> [  122.549401] Broadcom 43xx driver loaded [ Features: PML, Firmware-ID: FW13 ]
> [  122.675356] udev: renamed network interface wlan0 to wlan1
> [  122.769147] b43 ssb0:0: firmware: requesting b43/ucode15.fw
> [  122.847433] b43 ssb0:0: firmware: requesting b43/lp0initvals15.fw
> [  122.883806] b43 ssb0:0: firmware: requesting b43/lp0bsinitvals15.fw
> [  123.113178] b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
> [  123.117334] b43-phy0 debug: b2062: Using crystal tab entry 19200 kHz.
> [  123.385222] b43-phy0 debug: Chip initialized
> [  123.385794] b43-phy0 debug: 64-bit DMA initialized
> [  123.385850] b43-phy0 debug: QoS disabled
> [  123.406615] Registered led device: b43-phy0::tx
> [  123.406745] Registered led device: b43-phy0::rx
> [  123.406874] Registered led device: b43-phy0::radio
> [  123.407281] b43-phy0 debug: Wireless interface started
> [  123.407374] b43-phy0 debug: Adding Interface type 2
> [  123.421273] ADDRCONF(NETDEV_UP): wlan1: link is not ready
>
> Thanks,
> -Bryan
>
>

Try to enable mac80211/cfg80211 debug messages. Also enable SSB
debugging. (If mac80211 debugging is on, then you are hitting a
{mac|cfg|nl|lib}80211 bug, as your dmesg should contain entries like
"device is no longer idle".)

To Larry: Software RFKILL is not yet implemented for LP-PHY - it is
part of my calibration patch, which had other errors (software RFKILL
is a prereq for calibration). Feel free to split it out into a
separate patch if anyone needs it - I can't do it right now; no
working Linux system (due to the vmware problem).

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
