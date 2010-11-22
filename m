Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65173 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab0KVJFV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 04:05:21 -0500
Received: by qwc9 with SMTP id 9so546948qwc.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 01:05:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CE997E3.9080706@lwfinger.net>
References: <AANLkTi=gzBDd6AZAzUKpLyTxtOgkwUkB5STeaU45=OFB@mail.gmail.com> <4CE997E3.9080706@lwfinger.net>
From: Klaas De Craemer <klaasdc@gmail.com>
Date: Mon, 22 Nov 2010 09:59:28 +0100
Message-ID: <AANLkTi=kF956KYU393jmZhMagX=mz6dZcf1xwMaqPJ3Q@mail.gmail.com>
Subject: Re: RTL8187L: Can only "enable" hw radio switch after Windows boot
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 21, 2010 at 23:06, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 11/21/2010 01:05 PM, Klaas De Craemer wrote:
>> Hello all,
>>
>> I'm using an Alfa AWUS036H adapter for a long range outdoor wireless
>> link (+5km) connected to an Intel Atom board running kernel
>> 2.6.32-5-amd64. Since a few weeks, the system cannot connect to the
>> remote AP anymore after booting: trying to bring up the interface
>> wlan0 gives an SCIO error and rfkill reports a hw block is present on
>> the device... Repeatedly inserting and removing the device does not
>> change this.
>>
>> The only way to make the card work is to plug it into a Windows
>> computer in which it then connects immediately to the AP. Then I can
>> plug it back into the linux box and the connection works (hw block
>> gone, yes, magic...). The connection is then stable (it is usually up
>> for about 8 hours). In the evening the hardware is turned off so in
>> the morning the same problem arises again.
>>
>> Below is some dmesg output. If I can add some more specific debug
>> output, please let me know.
>>
>> Klaas De Craemer
>>
>> ----------------
>> dmesg output after initially plugging the device in is:
>>
>> [  617.720045] usb 1-8: new high speed USB device using ehci_hcd and address 4
>> [  617.852402] usb 1-8: New USB device found, idVendor=0409, idProduct=005a
>> [  617.852511] usb 1-8: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>> [  617.853147] usb 1-8: configuration #1 chosen from 1 choice
>> [  617.853730] hub 1-8:1.0: USB hub found
>> [  617.854023] hub 1-8:1.0: 4 ports detected
>> [  618.140174] usb 1-8.1: new high speed USB device using ehci_hcd and address 5
>> [  618.254772] usb 1-8.1: New USB device found, idVendor=0bda, idProduct=8187
>> [  618.254882] usb 1-8.1: New USB device strings: Mfr=1, Product=2,
>> SerialNumber=3
>> [  618.255016] usb 1-8.1: Product: RTL8187_Wireless
>> [  618.255105] usb 1-8.1: Manufacturer: Manufacturer_Realtek_RTL8187_
>> [  618.255202] usb 1-8.1: SerialNumber: 00C0CA3F9517
>> [  618.257166] usb 1-8.1: configuration #1 chosen from 1 choice
>> [  618.505617] phy6: Selected rate control algorithm 'minstrel'
>> [  618.508755] phy6: hwaddr 00:c0:ca:3f:95:17, RTL8187vB (default) V1
>> + rtl8225z2, rfkill mask 2
>> [  618.525401] rtl8187: Customer ID is 0xFF
>> [  618.526749] Registered led device: rtl8187-phy6::tx
>> [  618.528126] Registered led device: rtl8187-phy6::rx
>> [  618.529030] rtl8187: wireless switch is on
>> [  618.529364] usbcore: registered new interface driver rtl8187
>> [  623.780644] rtl8187: wireless radio switch turned off
>
> Interesting. I do not have a data sheet for the RTL8187L, but I do for the
> RTL8187B, which is very similar. On the chip, there is a GPIO0 line that has the
> state of the radio. For an external device like yours, I would not expect a
> switch connected to this line, thus it should be wired high.
>
> Note that when the device is not yet brought up at 618 seconds, the radio enable
> bit is high, yet at 623 seconds, it is low. One thing that happened is that the
> radio was actually turned on, and the device is now drawing a lot more power.
> Either that power is low, or the read of GPIO0 is failing and returning 0.
>
>> After having it connected in Windows this will be added:
>>
>> [  762.904044] usb 1-8: new high speed USB device using ehci_hcd and address 6
>> [  763.036384] usb 1-8: New USB device found, idVendor=0409, idProduct=005a
>> [  763.036491] usb 1-8: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>> [  763.037793] usb 1-8: configuration #1 chosen from 1 choice
>> [  763.038501] hub 1-8:1.0: USB hub found
>> [  763.038759] hub 1-8:1.0: 4 ports detected
>> [  763.324155] usb 1-8.1: new high speed USB device using ehci_hcd and address 7
>> [  763.438628] usb 1-8.1: New USB device found, idVendor=0bda, idProduct=8187
>> [  763.438737] usb 1-8.1: New USB device strings: Mfr=1, Product=2,
>> SerialNumber=3
>> [  763.438872] usb 1-8.1: Product: RTL8187_Wireless
>> [  763.438961] usb 1-8.1: Manufacturer: Manufacturer_Realtek_RTL8187_
>> [  763.439057] usb 1-8.1: SerialNumber: 00C0CA3F9517
>> [  763.439707] usb 1-8.1: configuration #1 chosen from 1 choice
>> [  763.672336] phy7: Selected rate control algorithm 'minstrel'
>> [  763.675556] phy7: hwaddr 00:c0:ca:3f:95:17, RTL8187vB (default) V1
>> + rtl8225z2, rfkill mask 2
>> [  763.692505] rtl8187: Customer ID is 0xFF
>> [  763.692885] Registered led device: rtl8187-phy7::tx
>> [  763.693125] Registered led device: rtl8187-phy7::rx
>> [  763.693752] rtl8187: wireless switch is on
>
> Any idea what is inside your box besides the RTL8187L chip and the radio
> transceiver? Does lsusb show a hub? Run the command with the device unplugged
> and again with it plugged in.

The box consists of a Gigabyte GA-D510UD motherboard with an Intel
Atom D510. The antenna and usb-transceiver equipment is a few meters
away and connected using an active USB extender cable. I believe this
is where the "usb hub found" messages come from.
I'll run the lsusb command this evening when I'm back.

Not sure if it's useful, but the AWUS036H transceiver is the 1W
version (I run it at much lower power though). The pcb is shown on the
right in http://4.bp.blogspot.com/_yKAih5N2U8Y/S1MSczALYRI/AAAAAAAAACg/IhiVakqDhWE/s400/pcbalfa.jpg

Also, I believe the problem has come up since the outside temperature
has dropped to about 4-5 °C, so I don't exclude a hardware problem.
Even so, the fact that it then would still work in Windows is strange.

> What does the acronym SCIO mean? I'm not familiar with that one? Where does the
> SCIO read failure message get logged?

Sorry, I meant I get a few errors in the form of "SIOCSIFFLAGS:
Unknown error 132" on the stdout when trying to bring up the blocked
interface.

Klaas

> Larry
>
