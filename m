Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:41230 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907Ab1CYDyI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 23:54:08 -0400
Received: from mail.lockie.ca (dyn-dsl-lh-98-124-36-5.nexicom.net [98.124.36.5])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p2P3s6U1027747
	for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2011 23:54:07 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 55B2D1E03D8
	for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2011 23:54:05 -0400 (EDT)
Message-ID: <4D8C11DD.7000003@lockie.ca>
Date: Thu, 24 Mar 2011 23:54:05 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: kernel-2.6.36.2 works, later doesn't
References: <4D866BD1.9060904@lockie.ca>	<4D86B222.4070708@lockie.ca> <AANLkTik+AjhMBwRy9ESaidnuW+1YCSZiEzeWdFnmZnqS@mail.gmail.com>
In-Reply-To: <AANLkTik+AjhMBwRy9ESaidnuW+1YCSZiEzeWdFnmZnqS@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/24/11 12:51, Sedat Dilek wrote:
> On Mon, Mar 21, 2011 at 3:04 AM, James <bjlockie@lockie.ca> wrote:
>> On 03/20/11 17:04, James wrote:
>>> $ dmesg | grep phy
>>> BIOS-provided physical RAM map:
>>> modified physical RAM map:
>>> phy0: Selected rate control algorithm 'ath9k_rate_control'
>>> Registered led device: ath9k-phy0::radio
>>> Registered led device: ath9k-phy0::assoc
>>> Registered led device: ath9k-phy0::tx
>>> Registered led device: ath9k-phy0::rx
>>> phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81
>>> mem=0xffffc90001900000, irq=17
>>>
>>> This is kernel-2.6.36.2.
>>> The wireless doesn't work on any later kernel that I have tried.
>>> It is very interesting the IRQ is 17 on this kernel but 18 on 2.6.37.3.
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> I tried
>> http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.36/compat-wireless-2.6.36-4.tar.bz2
>> but it doesn't work in the 2.6.36.2 kernel or the 2.6.38 kernel.
>>
>> Where can I get the compat-wireless that is the exact code that is in
>> the 2.6.36.2 kernel and then I can try it in the 2.6.38 kernel?
>>
> The idea of compat-wireless is to make new wifi drivers & features
> accessible for older host-kernel, not the other way around.
> It also makes no sense to have same versions of host kernel and c-w
> version (both 2.6.36 for example, it is the same codebase).
If the old c-w works on the new kernel then I know it is a kernel problem.
> Did you try one of the bleeding-edge compat-wireless [1] tarball (it
> is updated daily, but can be broken)?
> Furthermore, [2] has informations about stable releases and detailed
> build instructions.
I last tried 2011-03-19
> Please provide full dmesg and lspci/lsusb output - not truncated one.
> Which user-space do you use? Network-Manager, wpasupplicant, etc.?
No user space utilities are automatically started but I use wicd
manually to get an IP from my wired connection.
The AP is open so I don't use wpasupplicant.

$ dmesg
http://lockie.ca/test/dmesg.txt.bz2

$ sudo lspci
00:00.0 RAM memory: nVidia Corporation MCP65 Memory Controller (rev a1)
00:01.0 ISA bridge: nVidia Corporation MCP65 LPC Bridge (rev a2)
00:01.1 SMBus: nVidia Corporation MCP65 SMBus (rev a1)
00:01.2 RAM memory: nVidia Corporation MCP65 Memory Controller (rev a1)
00:02.0 USB Controller: nVidia Corporation MCP65 USB Controller (rev a1)
00:02.1 USB Controller: nVidia Corporation MCP65 USB Controller (rev a1)
00:07.0 Audio device: nVidia Corporation MCP65 High Definition Audio
(rev a1)
00:08.0 PCI bridge: nVidia Corporation MCP65 PCI bridge (rev a1)
00:09.0 IDE interface: nVidia Corporation MCP65 IDE (rev a1)
00:0a.0 IDE interface: nVidia Corporation MCP65 SATA Controller (rev a1)
00:0b.0 PCI bridge: nVidia Corporation Device 045b (rev a1)
00:0c.0 PCI bridge: nVidia Corporation MCP65 PCI Express bridge (rev a1)
00:0d.0 PCI bridge: nVidia Corporation MCP65 PCI Express bridge (rev a1)
00:0e.0 PCI bridge: nVidia Corporation MCP65 PCI Express bridge (rev a1)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
Miscellaneous Control
01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
02:07.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A
IEEE-1394a-2000 Controller (PHY/Link)
02:08.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 11)
02:08.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture
(rev 11)
02:09.0 Network controller: Atheros Communications Inc. AR5008 Wireless
Network Adapter (rev 01)
04:00.0 VGA compatible controller: nVidia Corporation G92 [GeForce 8800
GT] (rev a2)

