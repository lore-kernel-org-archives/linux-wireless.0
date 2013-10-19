Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm11.bullet.mail.ird.yahoo.com ([77.238.189.64]:38157 "HELO
	nm11.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752309Ab3JSMSk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Oct 2013 08:18:40 -0400
Message-ID: <5262789D.8030704@yahoo.de> (sfid-20131019_141844_266304_2424B7B5)
Date: Sat, 19 Oct 2013 14:18:37 +0200
From: =?UTF-8?B?WWFubmlrIFbDtmxrZXI=?= <yannikv@yahoo.de>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>
CC: Pontus Fuchs <pontus.fuchs@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ar5523 Gigaset USB Adapter 108 issue
References: <Pine.LNX.4.44L0.1310181041080.1164-100000@iolanthe.rowland.org> <52614E9B.6040400@rempel-privat.de> <526155ED.1090007@yahoo.de> <52615EFA.80902@rempel-privat.de> <526162ED.8030901@yahoo.de> <52616CD0.2000203@rempel-privat.de>
In-Reply-To: <52616CD0.2000203@rempel-privat.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am 18.10.2013 19:16, schrieb Oleksij Rempel:
> Am 18.10.2013 18:33, schrieb Yannik Völker:
>> Am 18.10.2013 18:16, schrieb Oleksij Rempel:
>>> Am 18.10.2013 17:38, schrieb Yannik Völker:
>>>> Am 18.10.2013 17:07, schrieb Oleksij Rempel:
>>>>> Am 18.10.2013 16:49, schrieb Alan Stern:
>>>>>> Yannik, you should always use Reply-To-All so that your 
>>>>>> messages get sent to the mailing list and not just to
>>>>>> me.
>>>>>> 
>>>>>> On Thu, 17 Oct 2013, Yannik Völker wrote:
>>>>>> 
>>>>>>> Am 07.08.2013 19:34, schrieb Alan Stern:
>>>>>>>> Please post two usbmon traces, one showing the
>>>>>>>> failure on your current system and the other showing
>>>>>>>> the adapter running correctly under a 32-bit kernel.
>>>>>>>> Instructions for usbmon are in the kernel source
>>>>>>>> file Documentation/usb/usbmon.txt.
>>>>>>> I never got it to work under a 32-bit kernel, i was
>>>>>>> just able to utilize a windows32 driver using
>>>>>>> ndiswrapper.
>>>>>>> 
>>>>>>> Now i got it to "work". I randomly found out that the 
>>>>>>> ar5523 driver actually works when you load it after
>>>>>>> you unload ndiswrapper so the following steps make it
>>>>>>> work: 1. modprobe ndiswrapper 2. plug in device 3.
>>>>>>> connect to wlan using ndiswrapper and disconnect again
>>>>>>> (might be optional) 4. modprobe -r ndiswrapper 5.
>>>>>>> modprobe ar5523 6. connect to wlan log for that is
>>>>>>> attatched as wlanthennative2.log
>>>> 
>>>> 
>>>>> It sounds like linux driver didn't recognised usb id and 
>>>>> didn't uploaded firmware, or there was no firmware to
>>>>> upload.
>>>> there is firmware (/lib/firmware/ar5523.bin exists) but it
>>>> does not even get touched (i renamed the file and the error
>>>> did not change at all)
>> 
>>> find first usbid of your adapter (it will be changed after 
>>> firmware upload). And try to force driver to use this id:
>>> modprobe -v ar5523 echo 07d1 3a0d >
>>> /sys/bus/usb/drivers/ar5523/new_id
>> 
>>> instead of "07d1 3a0d" use your id.
>> 
>> 
>> # lsusb … Bus 003 Device 011: ID 129b:160c CyberTAN Technology
>> Siemens S30853-S1038-R351 802.11g Wireless Adapter [Atheros
>> AR5523] …
>> 
>> # modprobe ar5523 # echo 129b 160c >
>> /sys/bus/usb/drivers/ar5523/new_id <plugging device in> syslog: 
>> Oct 18 18:27:47 yannik-desktop kernel: [ 8751.447784] usbcore: 
>> registered new interface driver ar5523 Oct 18 18:28:25
>> yannik-desktop kernel: [ 8789.036912] usb 3-14: new high-speed
>> USB device number 12 using xhci_hcd Oct 18 18:28:25
>> yannik-desktop kernel: [ 8789.053995] usb 3-14: New USB device
>> found, idVendor=129b, idProduct=160c Oct 18 18:28:25
>> yannik-desktop kernel: [ 8789.054005] usb 3-14: New USB device
>> strings: Mfr=1, Product=2, SerialNumber=3 Oct 18 18:28:25
>> yannik-desktop kernel: [ 8789.054010] usb 3-14: Product: AR5523 
>> Oct 18 18:28:25 yannik-desktop kernel: [ 8789.054015] usb 3-14: 
>> Manufacturer: Atheros Communications Inc Oct 18 18:28:25
>> yannik-desktop kernel: [ 8789.054019] usb 3-14: SerialNumber:
>> 1.0 Oct 18 18:28:27 yannik-desktop kernel: [ 8791.052313] usb
>> 3-14: timeout waiting for command 01 reply Oct 18 18:28:27
>> yannik-desktop kernel: [ 8791.052323] usb 3-14: could not
>> initialize adapter Oct 18 18:28:27 yannik-desktop kernel: [
>> 8791.052359] usb 3-14: RX USB error -2. Oct 18 18:28:27
>> yannik-desktop kernel: [ 8791.052378] usb 3-14: error -1 when
>> submitting rx urb Oct 18 18:28:27 yannik-desktop kernel: [
>> 8791.052504] ar5523: probe of 3-14:1.0 failed with error -110
>> 
>>> Besidy, what kernel version are you using? May be it is too
>>> old..
>> 
>> 3.11.0-12-generic it is my understanding that the ar5523 driver
>> was included from 3.8 on.
> 
> please test attached patch.
Stopped the error from appearing but it looks like it would not even try
to upload the firmware to me:

[  708.193488] cfg80211: Calling CRDA to update world regulatory domain


[  708.492120] usbcore: registered new interface driver ar5523


[  708.509819] cfg80211: World regulatory domain updated:


[  708.509822] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)

[  708.509823] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[  708.509824] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[  708.509825] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[  708.509826] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[  708.509827] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[  720.232697] usb 3-14: USB disconnect, device number 8
[  721.721980] usb 3-14: new high-speed USB device number 9 using xhci_hcd
[  721.739153] usb 3-14: New USB device found, idVendor=129b,
idProduct=160c
[  721.739163] usb 3-14: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[  721.739168] usb 3-14: Product: AR5523
[  721.739174] usb 3-14: Manufacturer: Atheros Communications Inc
[  721.739178] usb 3-14: SerialNumber: 1.0
mtp-probe: checking bus 3, device 9:
"/sys/devices/pci0000:00/0000:00:14.0/usb3/3-14"
mtp-probe: bus: 3, device: 9 was not an MTP device

also it did not load the module on plugging in.

- -- 
Yannik Völker
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSYnidAAoJEDqk81AiCyXKT1cP/3U/UvcXmhIHrxioZsM+WDcA
eEbC6zyEdGeLR10kkD9bnsTa0pwk4Bvj7ciuNKYYRn1kDpt+KIgmJoam0ljbF0Gb
jE/hG6ZzVdZEHWbEy2yz1+ns8hyQ7hCcc96zHI+5LQsPvqajRFgiclIOK9J1TbR4
Vc6xV0mJAAhLpokUZ+lD7cPlmBcpmMVkJrWRkyZW7W/jp4myitxmnROJrEVhZM51
sdglrDWq0tsEWgL8T5M10ZVwbBRZo94qYGWr3CVcDqEdAzx+vujtST7XWzmv1p85
6C9P+CmcEIS8GiCeZrQmPu74L2nXl5fT8xkrI9XrYd71q9HArl9Arr6w268nYw4N
urheXF88bg/Os4L/npm5yy9SGl+Iz/LJcsayrDP3MrwgNGZ8WGQ82mlxkk25X+l1
igu6A2OhB7fGfGoAuWpfRl1WBG33A1IuYyA1GWr5OrVShD831g8PLv8cFOBBHeFC
SLfh4hKPtctQk5NOlhe623wtOGI4lN2wXnRJIKABCdnIlzIkem7ZK1rmT4oXzNj3
cKzMf1mFOt5G1ow4iE0JDuH0RyUbkOa0CweyrXaJnyh1mQ6j3Y9XI6QMjk+dbt1f
E4RYKpL8IhTL2aWTDjSkyrbRNDpvtGa8h3yDvpZ3MartwOokUE6TTirxz3WfvLC0
8Poh/Wb6C2znRN/kfY6Q
=+njK
-----END PGP SIGNATURE-----
