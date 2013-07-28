Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from erley.org ([97.107.129.9]:58822 "EHLO remote.erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab3G1TGA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Jul 2013 15:06:00 -0400
Message-ID: <51F569A6.5090800@erley.org> (sfid-20130728_210625_587837_E6EAF2AE)
Date: Sun, 28 Jul 2013 14:57:42 -0400
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: Tomas Pospisek <tpo2@sourcepole.ch>
CC: linux-wireless@vger.kernel.org
Subject: Re: unable to unblock Bluetooth
References: <51F3CEF7.4030200@sourcepole.ch>
In-Reply-To: <51F3CEF7.4030200@sourcepole.ch>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/27/2013 09:45 AM, Tomas Pospisek wrote:
> Hello
>
> I am not able to unblock Bluetooth:
>
> # rfkill unblock all
> # rfkill list 4
> 4: hp-bluetooth: Bluetooth
>           Soft blocked: yes
>           Hard blocked: no
>
> The Bluetooth layer remains "Soft blocked".
>
> My system looks like this:
>
> - Linux: 3.11-rc1
> - Userspace: Debian wheezy
> - rfkill: 0.5
> - HW: HP dv7 6130ez
> - Bluetooth probably provided by:
>    # lspci
>    ...
>    0d:00.0 Network controller: Ralink corp. RT5390
>   [802.11 b/g/n 1T1R G-band PCI Express Single Chip]
>
> Kernel logs show no trace of a problem:
>
>    Bluetooth: Core ver 2.16
>    Bluetooth: HCI device and connection manager initialized
>    Bluetooth: HCI socket layer initialized
>    Bluetooth: L2CAP socket layer initialized
>    Bluetooth: SCO socket layer initialized
>    Bluetooth: RFCOMM TTY layer initialized
>    Bluetooth: RFCOMM socket layer initialized
>    Bluetooth: RFCOMM ver 1.11
>    Bluetooth: BNEP (Ethernet Emulation) ver 1.3
>    Bluetooth: BNEP filters: protocol multicast
>    Bluetooth: BNEP socket layer initialized
>
> I had to provide some firware in order for the Bluetooth device to show
> up in rfkill. I copied those firmware blobs over from Debian's
> "firmware-ralink" package. It must be one of these:
>
> rt2661.bin
> rtl_nic
> rtl_nic/rtl8168f-1.fw
> rtl_nic/rtl8168e-1.fw
> rtl_nic/rtl8168f-2.fw
> rtl_nic/rtl8168e-3.fw
> rtl_nic/rtl8168d-2.fw
> rtl_nic/rtl8168e-2.fw
> rtl_nic/rtl8105e-1.fw
> rtl_nic/rtl8168d-1.fw
> RTL8192SU
> RTL8192SU/rtl8192sfw.bin
> rt2561.bin
> rt2870.bin
> rt2860.bin
> rt73.bin
> rt3070.bin
> rtlwifi
> rtlwifi/rtl8192cufw.bin
> rtlwifi/rtl8192cfwU.bin
> rtlwifi/rtl8192cfw.bin
> rtlwifi/rtl8192cfwU_B.bin
> rtlwifi/rtl8192sefw.bin
> rtlwifi/rtl8192defw.bin
> rtlwifi/rtl8712u.bin
> rt3071.bin
> rt3090.bin
> rt2561s.bin
> RTL8192E
> RTL8192E/main.img
> RTL8192E/boot.img
> RTL8192E/data.img
>
> Additional possibly useful info:
>
>    # lsmod |grep blue
>    bluetooth             169854  10 bnep,rfcomm
>    rfkill                 19242  6 cfg80211,hp_wmi,bluetooth
>    crc16                  12343  2 ext4,bluetooth
>
> What can I do to unblock the Bluetooth?
>
> Thank you,
> *t

lsusb might be useful here too.  hp_wmi hooked into rfkill might mean 
that hp-wmi is setting that soft block.  Perhaps you have a keyboard 
combo to unblock it?

Pat Erley

