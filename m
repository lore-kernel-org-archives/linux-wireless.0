Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:39639 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751072AbeA2SEv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Jan 2018 13:04:51 -0500
Received: by mail-oi0-f51.google.com with SMTP id j188so4344490oib.6
        for <linux-wireless@vger.kernel.org>; Mon, 29 Jan 2018 10:04:50 -0800 (PST)
Subject: Re: r8822be driver
To: Glenn <troubleshooting@epilitimus.com>,
        linux-wireless@vger.kernel.org
References: <5A6EBA1B.3080802@epilitimus.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <61788aff-30d2-d1b4-d35a-182f58c2d3d4@lwfinger.net> (sfid-20180129_190454_378173_5975E324)
Date: Mon, 29 Jan 2018 12:04:47 -0600
MIME-Version: 1.0
In-Reply-To: <5A6EBA1B.3080802@epilitimus.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/29/2018 12:07 AM, Glenn wrote:
> Hello,
> My new laptop apparently has a  Real Tek R8822BE as the wifi device. The
> module loads but I can not bring up the interface or do anything with
> it. I think the problem is that the firmware load fails, see below. I
> can not find any source for the listed firmware file or any make rules
> to build it.  Possibly connected, the machine also has an R8822B as the
> Bluetooth device (possibly a secondary port on the same device?) which
> shows the same error. The problem is not higher up in the networking
> stack as eth0 works fine.
> 
> Any help will be appreciated.
> 
> Relevant (I think) info:
> 
> uname -a:
> Linux IceFalcon 4.14.13-tuned #1 SMP Tue Jan 16 20:35:41 PST 2018 x86_64
> Intel(R) Core(TM) i7-7700HQ CPU @ 2.80GHz GenuineIntel GNU/Linux
> 
> ifconfig wlan0:
> wlan0: flags=4098<BROADCAST,MULTICAST>  mtu 1500
>          ether d4:6a:6a:55:89:39  txqueuelen 1000  (Ethernet)
>          RX packets 0  bytes 0 (0.0 B)
>          RX errors 0  dropped 0  overruns 0  frame 0
>          TX packets 0  bytes 0 (0.0 B)
>          TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
> 
> ifconfig wlan0 up:
> SIOCSIFFLAGS: Operation not permitted
> 
> lspci -v:
> 3c:00.0 Network controller: Realtek Semiconductor Co., Ltd. Device b822
>      Subsystem: Hewlett-Packard Company Device 831b
>      Flags: bus master, fast devsel, latency 0, IRQ 131
>      I/O ports at c000 [size=256]
>      Memory at dc200000 (64-bit, non-prefetchable) [size=64K]
>      Capabilities: [40] Power Management version 3
>      Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
>      Capabilities: [70] Express Endpoint, MSI 00
>      Capabilities: [100] Advanced Error Reporting
>      Capabilities: [148] Device Serial Number 00-e0-4c-ff-fe-b8-22-01
>      Capabilities: [158] Latency Tolerance Reporting
>      Capabilities: [160] L1 PM Substates
>      Kernel driver in use: r8822be
>      Kernel modules: r8822be
> 
> dmesg:
> [    0.259212] pci 0000:3c:00.0: reg 0x10: [io  0xc000-0xc0ff]
> [    0.259235] pci 0000:3c:00.0: reg 0x18: [mem 0xdc200000-0xdc20ffff 64bit]
> [    0.259352] pci 0000:3c:00.0: supports D1 D2
> [    0.259353] pci 0000:3c:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> 
> [    0.337550] pci_bus 0000:3c: resource 0 [io  0xc000-0xcfff]
> [    0.337551] pci_bus 0000:3c: resource 1 [mem 0xdc200000-0xdc2fffff]
> 
> [    2.148955] r8822be: module is from the staging directory, the
> quality is unknown, you have been warned.
> 
> [    2.173850] r8822be 0000:3c:00.0: enabling device (0000 -> 0003)
> [    2.191530] r8822be: Using firmware rtlwifi/rtl8822befw.bin
> [    2.193717] r8822be 0000:3c:00.0: Direct firmware load for
> rtlwifi/rtl8822befw.bin failed with error -2
> [    2.194503] r8822be: Selected firmware is not available

As the log clearly states, you have not installed the firmware. It seems that 
your distro is not up to date. You could obtain it from the linux-firmware 
repository, or get it from my GitHub repo named rtlwifi_new. I will send it to 
you privately in the next E-mail.

Larry
