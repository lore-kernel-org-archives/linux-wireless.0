Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62330 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab0KWT1H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:27:07 -0500
Received: by pva4 with SMTP id 4so550103pva.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 11:27:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CEAC868.9040402@lwfinger.net>
References: <4CEA9903.6070604@lwfinger.net> <370521.43644.qm@web29514.mail.ird.yahoo.com>
 <AANLkTimd0EDGtZFcrhknyacoCQQZNMEKe-kvYNA9z_Bo@mail.gmail.com> <4CEAC868.9040402@lwfinger.net>
From: Klaas De Craemer <klaasdc@gmail.com>
Date: Tue, 23 Nov 2010 20:26:45 +0100
Message-ID: <AANLkTim_O8SJ5xA4TWfOa2q7NXDG95-PDoXCqosiaGz3@mail.gmail.com>
Subject: Re: RTL8187L: Can only "enable" hw radio switch after Windows boot
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: htl10@users.sourceforge.net, linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 22, 2010 at 20:45, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 11/22/2010 01:13 PM, Klaas De Craemer wrote:
>> Not sure if you meant this, but the box itself is inside (warm), only
>> the transceiver is outside.
>> Just to be sure, I skipped trying it in Linux first today and
>> immediately plugged it in my Windows laptop: instant connection. Next
>> I plugged it in Linux and it works fine. This way the device had no
>> time to "warm up" because of first being powered in Linux.
>>
>> I cannot easily take it inside without unscrewing the antenna (a dish
>> with biquad feeder). So I'll try it without antenna tomorrow.
>
> If it is not too much trouble, please try it with the transceiver box warm. In
> the meantime, I will do a USB dump of rtl8187 and the Windows driver using an XP
> system that I have as a VM. Please check in the device manager on your Windows
> box and get the driver version.
>
> Thanks,
>
> Larry
>

This morning I put the transceiver inside. I just connected it to the
Atom box without antenna and it reported no wireless block:

[  382.312044] usb 1-3: new high speed USB device using ehci_hcd and address 2
[  382.450722] usb 1-3: New USB device found, idVendor=0bda, idProduct=8187
[  382.450835] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  382.450939] usb 1-3: Product: RTL8187_Wireless
[  382.451027] usb 1-3: Manufacturer: Manufacturer_Realtek_RTL8187_
[  382.451122] usb 1-3: SerialNumber: 00C0CA3F9517
[  382.451822] usb 1-3: configuration #1 chosen from 1 choice
[  382.743060] phy1: Selected rate control algorithm 'minstrel'
[  382.746490] phy1: hwaddr 00:c0:ca:3f:95:17, RTL8187vB (default) V1
+ rtl8225z2, rfkill mask 2
[  382.764106] rtl8187: Customer ID is 0xFF
[  382.764344] Registered led device: rtl8187-phy1::tx
[  382.764554] Registered led device: rtl8187-phy1::rx
[  382.765254] rtl8187: wireless switch is on
[  382.765594] usbcore: registered new interface driver rtl8187

Then I put it back onto the antenna outside and it connected just fine.

I'm really confused now. Does this mean that it might be both a hard-
& software problem? I guess I should also check if it works fine
"warm" + immediately connecting it to the antenna. If temperature is
such a problem I might put a heating resistor inside the transceiver
housing...

The Windows driver is 6.1316.1209.2009 for Windows 7 64bit. It comes
with a GUI from Alfa Networks that says version 700.1604.108.201.

Klaas
