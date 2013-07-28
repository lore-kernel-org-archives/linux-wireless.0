Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from brisi.sourcepole.ch ([5.9.57.43]:42919 "EHLO
	brisi.sourcepole.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3G1VBn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Jul 2013 17:01:43 -0400
Received: from cable-dynamic-87-245-83-117.shinternet.ch ([87.245.83.117] helo=[192.168.2.35])
	by vilan-mail with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <tpo2@sourcepole.ch>)
	id 1V3Y62-0008PR-2T
	for linux-wireless@vger.kernel.org; Sun, 28 Jul 2013 23:01:42 +0200
Message-ID: <51F58698.7030508@sourcepole.ch> (sfid-20130728_230204_999004_DD1509B3)
Date: Sun, 28 Jul 2013 23:01:12 +0200
From: Tomas Pospisek <tpo2@sourcepole.ch>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: unable to unblock Bluetooth
References: <51F3CEF7.4030200@sourcepole.ch> <51F569A6.5090800@erley.org>
In-Reply-To: <51F569A6.5090800@erley.org>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 28.07.2013 20:57, schrieb Pat Erley:
> On 07/27/2013 09:45 AM, Tomas Pospisek wrote:
>> Hello
>>
>> I am not able to unblock Bluetooth:
>>
>> # rfkill unblock all
>> # rfkill list 4
>> 4: hp-bluetooth: Bluetooth
>>           Soft blocked: yes
>>           Hard blocked: no
>>
>> The Bluetooth layer remains "Soft blocked".
>>
>> My system looks like this:
>>
>> - Linux: 3.11-rc1
>> - Userspace: Debian wheezy
>> - rfkill: 0.5
>> - HW: HP dv7 6130ez
>> - Bluetooth probably provided by:
>>    # lspci
>>    ...
>>    0d:00.0 Network controller: Ralink corp. RT5390
>>   [802.11 b/g/n 1T1R G-band PCI Express Single Chip]
>>
>> Kernel logs show no trace of a problem:
>>
>>    Bluetooth: Core ver 2.16
>>    Bluetooth: HCI device and connection manager initialized
>>    Bluetooth: HCI socket layer initialized
>>    Bluetooth: L2CAP socket layer initialized
>>    Bluetooth: SCO socket layer initialized
>>    Bluetooth: RFCOMM TTY layer initialized
>>    Bluetooth: RFCOMM socket layer initialized
>>    Bluetooth: RFCOMM ver 1.11
>>    Bluetooth: BNEP (Ethernet Emulation) ver 1.3
>>    Bluetooth: BNEP filters: protocol multicast
>>    Bluetooth: BNEP socket layer initialized
>>
>> I had to provide some firware in order for the Bluetooth device to show
>> up in rfkill. I copied those firmware blobs over from Debian's
>> "firmware-ralink" package. It must be one of these:
>>
>> rt2661.bin
>> rtl_nic
>> rtl_nic/rtl8168f-1.fw
>> rtl_nic/rtl8168e-1.fw
>> rtl_nic/rtl8168f-2.fw
>> rtl_nic/rtl8168e-3.fw
>> rtl_nic/rtl8168d-2.fw
>> rtl_nic/rtl8168e-2.fw
>> rtl_nic/rtl8105e-1.fw
>> rtl_nic/rtl8168d-1.fw
>> RTL8192SU
>> RTL8192SU/rtl8192sfw.bin
>> rt2561.bin
>> rt2870.bin
>> rt2860.bin
>> rt73.bin
>> rt3070.bin
>> rtlwifi
>> rtlwifi/rtl8192cufw.bin
>> rtlwifi/rtl8192cfwU.bin
>> rtlwifi/rtl8192cfw.bin
>> rtlwifi/rtl8192cfwU_B.bin
>> rtlwifi/rtl8192sefw.bin
>> rtlwifi/rtl8192defw.bin
>> rtlwifi/rtl8712u.bin
>> rt3071.bin
>> rt3090.bin
>> rt2561s.bin
>> RTL8192E
>> RTL8192E/main.img
>> RTL8192E/boot.img
>> RTL8192E/data.img
>>
>> Additional possibly useful info:
>>
>>    # lsmod |grep blue
>>    bluetooth             169854  10 bnep,rfcomm
>>    rfkill                 19242  6 cfg80211,hp_wmi,bluetooth
>>    crc16                  12343  2 ext4,bluetooth
>>
>> What can I do to unblock the Bluetooth?
> 
> lsusb might be useful here too.  hp_wmi hooked into rfkill might mean
> that hp-wmi is setting that soft block.  Perhaps you have a keyboard
> combo to unblock it?

Thanks Pat, there's only the "lighthouse" button, that I'm interpreting
as wifi on/off button. Other than that there doesn't seem to be any
"bluetooth" or related button.

As for:
# lsusb
Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 004 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 003: ID 138a:0018 Validity Sensors, Inc.
Bus 001 Device 004: ID 064e:e258 Suyin Corp.

"Validity Sensors" seems to be the fingerprint reader and "Suyin Corp."
seems to be the laptop camera.

I wrote Matthew Garrett the hp_wmi author, but haven heard back. I'm not
sure, maybe I shouldn't contact him directly or maybe he's just busy or
on holidays currently.

If anybody can point out to me what direction to take from here I'd be
very glad.

Thanks,
*t
*t

