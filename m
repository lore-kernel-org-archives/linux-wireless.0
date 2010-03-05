Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay02.digicable.hu ([92.249.128.188]:38930 "EHLO
	relay02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab0CEGtk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Mar 2010 01:49:40 -0500
Message-ID: <4B90A97C.5050703@freemail.hu>
Date: Fri, 05 Mar 2010 07:49:32 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: Luis Correia <luis.f.correia@gmail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
Subject: Re: Linux 2.6.33 + Edimax EW-7318Ug?
References: <4B8F5228.4080001@freemail.hu> <efe7343f1003032339x32bd512et9eebe0518546cfee@mail.gmail.com> <4B901811.2030708@gmail.com>
In-Reply-To: <4B901811.2030708@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gertjan van Wingerde wrote:
> On 03/04/10 08:39, Luis Correia wrote:
>> Hi!
>>
>> 2010/3/4 Németh Márton <nm127@freemail.hu>:
>>> Hi,
>>>
>>> I'm new to the Edimax EW-7318Ug ( http://www.edimax.com/en/produce_detail.php?pd_id=3&pl1_id=1&pl2_id=44 )
>>> device. I could find out so far that there are different drivers for Linux
>>> which can be used with this device. I think this device have the RT73 chip.
>>>
>>> I tried Linux kernel 2.6.33, compiled with CONFIG_RT2X00=m and CONFIG_RT2X00_DEBUG=y
>>> (the full kernel config is attached). I copied the rt73.bin from
>>> http://www.edimax.com/images/Image/driver/Linux%20driver/Wireless/USB%20adaptor/2008_0506_RT73_Linux_STA_Drv1.1.0.1.tar.zip
>>> to /lib/firmware/rt73.bin .
>> While I'm not 100% sure, this may be one of those devices thas has
>> it's ID in both rt2500usb and rt73usb.
>>
>> Besides prying it open to see which is the actual chip used, there is
>> little we can do, software side, to be sure of which exact driver
>> should be used.
>>
>> But to be honest, I can't really recall which exact driver ID conflict.
>>
> 
> By the looks of it (at the Edimax website) this is a true rt73 device. And that seems
> to be supported by the dmesg output posted by Németh, where the loading of the rt2500usb
> driver fails.
> 
> Németh, can you blacklist the auto-loading of the rt2500usb device (see
> http://www.cyberciti.biz/tips/avoid-linux-kernel-module-driver-autoloading.html for how
> to do this)?

After I blacklisted the rt2500usb in /etc/modprobe.d/blacklist.conf, I rebooted the system
and I get the following messages in dmesg when I plug the device:

[   31.500242] usb 1-4: new high speed USB device using ehci_hcd and address 5
[   31.772166] usb 1-4: New USB device found, idVendor=148f, idProduct=2573
[   31.772188] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   31.772204] usb 1-4: Product: 802.11 bg WLAN
[   31.772216] usb 1-4: Manufacturer: Ralink
[   31.972449] cfg80211: Using static regulatory domain info
[   31.972462] cfg80211: Regulatory domain: 00
[   31.972472]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   31.972483]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[   31.972494]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
[   31.972505]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
[   31.972516]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[   31.972527]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[   31.973352] cfg80211: Calling CRDA to update world regulatory domain
[   32.594920] phy0 -> rt73usb_validate_eeprom: EEPROM recovery - NIC: 0xffef
[   32.594939] phy0 -> rt73usb_validate_eeprom: EEPROM recovery - Led: 0xe000
[   32.594955] phy0 -> rt73usb_validate_eeprom: EEPROM recovery - RSSI OFFSET A: 0x0000
[   32.597348] phy0 -> rt2x00_print_chip: Info - Chipset detected - rt: 1300, rf: 0002, rev: 0002573a.
[   32.661727] phy0: Selected rate control algorithm 'minstrel'
[   32.678361] Registered led device: rt73usb-phy0::radio
[   32.684644] Registered led device: rt73usb-phy0::assoc
[   32.686278] Registered led device: rt73usb-phy0::quality
[   32.687991] usbcore: registered new interface driver rt73usb

Then I try to bring up the device before searching wireless networks:

# ifconfig wlan0 up
SIOCSIFFLAGS: Unknown error 132

I tried to run "strace ifconfig wlan0 up":

ioctl(4, SIOCGIFFLAGS, {ifr_name="wlan0", ifr_flags=IFF_BROADCAST|IFF_MULTICAST}) = 0
ioctl(4, SIOCSIFFLAGS, {ifr_name="wlan0", ???}) = -1 ERFKILL (Unknown error 132)

So I recognised that the radio LED was switched off on the Eee PC 901 which I could
turn on with Fn+F2. At this point both the internal and the Edimax EW-7318Ug started
to work. I could disable the internal wlan driver with the command "rmmod rt2860sta"
temporary to see if everything works fine.

Thank you for your help!

Regards,

	Márton Németh
