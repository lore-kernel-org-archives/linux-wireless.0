Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54424 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab3LDVlA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 16:41:00 -0500
Received: by mail-wg0-f44.google.com with SMTP id a1so13927881wgh.35
        for <linux-wireless@vger.kernel.org>; Wed, 04 Dec 2013 13:40:58 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 4 Dec 2013 22:40:58 +0100
Message-ID: <CA+OxbLhpRV2GhHbYD_VpoWgdYfR1uV4g38OO=gT4WPEt=F8_Og@mail.gmail.com> (sfid-20131204_224104_474135_3272203B)
Subject: Weak Signal and slow tx Rate with RTL8723AE
From: =?ISO-8859-1?Q?David_Pinilla_Caparr=F3s?= <dpini@caliu.cat>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have mailed with Larry Finger asking for a problem and he has
pointed me to this list.

I am an Arch Linux User with a Clevo based laptop.

It ships with the RTL8723AE. I have been reading posts around the net
and found that some people are having problems and talking about the
driver and something about the RX or TX Power.


With the 2 APs wich I usually use I can only reach 18Mb/s of Bit rate
whatever the signal level or link quality is. Both of them are 802.11
G and not N I think.

The connection is very unstable. Sometimes powering the wifi off and
on increases the performance a bit when it's impossible to do anything
(pings to gateway don't reply)

If they are related to the driver, I would be proud to help with
anything that I am able to. Testing for example.

I have a recent version of the stable Kernel but I dont know if the
firmware files are up to date.



Some data:

03:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8723AE
PCIe Wireless Network Adapter
    Subsystem: Realtek Semiconductor Co., Ltd. Device 0726
    Flags: bus master, fast devsel, latency 0, IRQ 18
    I/O ports at d000 [size=256]
    Memory at f7900000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [40] Power Management version 3
    Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
    Capabilities: [70] Express Endpoint, MSI 00
    Capabilities: [100] Advanced Error Reporting
    Capabilities: [140] Virtual Channel
    Capabilities: [160] Device Serial Number 01-23-87-fe-ff-4c-e0-00
    Kernel driver in use: rtl8723ae
    Kernel modules: rtl8723ae

 root  ~  dmesg | grep rtl
[    2.734124] rtl8723ae 0000:03:00.0: enabling device (0000 -> 0003)
[    2.749732] rtl8723ae: Using firmware rtlwifi/rtl8723fw_B.bin
[    2.752940] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[    2.753057] rtlwifi: wireless switch is on
[ 8838.570486] rtlwifi: wireless switch is o


 root  ~  uname -a
Linux DPini-Laptop 3.12.2-1-ARCH #1 SMP PREEMPT Fri Nov 29 21:14:15
CET 2013 x86_64 GNU/Linux


Iwconfig:

wlp3s0    IEEE 802.11bgn  ESSID:"Pinis_AP"
          Mode:Managed  Frequency:2.462 GHz  Access Point: 00:1A:2B:12:34:56
          Bit Rate=18 Mb/s   Tx-Power=20 dBm
          Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=50/70  Signal level=-60 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:9   Missed beacon:0

 root  ~  rfkill list
0: phy0: Wireless LAN
    Soft blocked: no
    Hard blocked: no
1: hci0: Bluetooth
    Soft blocked: no
    Hard blocked: no

 root  ⋯  lib  firmware  rtlwifi  md5sum rtl8723fw*
ce50dfe07dbb1bfe9e14bdb315a4b28a  rtl8723fw_B.bin
69ccaffbe94cc0ef1b89c25290e19b2e  rtl8723fw.bin



Thank you for all, and sorry for my English.

Best regards,
David
