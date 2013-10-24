Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm24-vm6.bullet.mail.ird.yahoo.com ([212.82.109.197]:43041 "EHLO
	nm24-vm6.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754544Ab3JXMwm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Oct 2013 08:52:42 -0400
Message-ID: <526916A9.2050002@yahoo.de> (sfid-20131024_145246_608005_8F6561A8)
Date: Thu, 24 Oct 2013 14:46:33 +0200
From: =?UTF-8?B?WWFubmlrIFbDtmxrZXI=?= <yannikv@yahoo.de>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	pontus.fuchs@gmail.com
Subject: Re: ar5523 Gigaset USB Adapter 108 issue
References: <Pine.LNX.4.44L0.1310181041080.1164-100000@iolanthe.rowland.org> <52614E9B.6040400@rempel-privat.de> <526155ED.1090007@yahoo.de> <52615EFA.80902@rempel-privat.de> <526162ED.8030901@yahoo.de> <52616CD0.2000203@rempel-privat.de> <5262789D.8030704@yahoo.de> <5262BA7A.2050803@rempel-privat.de> <5266C4C1.80408@yahoo.de> <5266C7BF.20503@rempel-privat.de>
In-Reply-To: <5266C7BF.20503@rempel-privat.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am 22.10.2013 20:45, schrieb Oleksij Rempel:> Am 22.10.2013 20:32,
schrieb Yannik Völker:
>> Am 19.10.2013 18:59, schrieb Oleksij Rempel:
>>> Am 19.10.2013 14:18, schrieb Yannik Völker:
>>>> Am 18.10.2013 19:16, schrieb Oleksij Rempel:
>>>>> Am 18.10.2013 18:33, schrieb Yannik Völker:
>>>>>> Am 18.10.2013 18:16, schrieb Oleksij Rempel:
>>>>>>> Am 18.10.2013 17:38, schrieb Yannik Völker:
>>>>>>>> Am 18.10.2013 17:07, schrieb Oleksij Rempel:
>>>>>>>>> Am 18.10.2013 16:49, schrieb Alan Stern:
>>>>>>>>>> Yannik, you should always use Reply-To-All so
>>>>>>>>>> that your messages get sent to the mailing list
>>>>>>>>>> and not just to me.
>>>>>>>>>> 
>>>>>>>>>> On Thu, 17 Oct 2013, Yannik Völker wrote:
>>>>>>>>>> 
>>>>>>>>>>> Am 07.08.2013 19:34, schrieb Alan Stern:
>>>>>>>>>>>> Please post two usbmon traces, one showing
>>>>>>>>>>>> the failure on your current system and the
>>>>>>>>>>>> other showing the adapter running correctly
>>>>>>>>>>>> under a 32-bit kernel. Instructions for
>>>>>>>>>>>> usbmon are in the kernel source file 
>>>>>>>>>>>> Documentation/usb/usbmon.txt.
>>>>>>>>>>> I never got it to work under a 32-bit kernel,
>>>>>>>>>>> i was just able to utilize a windows32 driver
>>>>>>>>>>> using ndiswrapper.
>>>>>>>>>>> 
>>>>>>>>>>> Now i got it to "work". I randomly found out 
>>>>>>>>>>> that the ar5523 driver actually works when you 
>>>>>>>>>>> load it after you unload ndiswrapper so the 
>>>>>>>>>>> following steps make it work: 1. modprobe 
>>>>>>>>>>> ndiswrapper 2. plug in device 3. connect to
>>>>>>>>>>> wlan using ndiswrapper and disconnect again
>>>>>>>>>>> (might be optional) 4. modprobe -r ndiswrapper
>>>>>>>>>>> 5. modprobe ar5523 6. connect to wlan log for
>>>>>>>>>>> that is attatched as wlanthennative2.log
>>>>>>>> 
>>>>>>>> 
>>>>>>>>> It sounds like linux driver didn't recognised usb
>>>>>>>>> id and didn't uploaded firmware, or there was no 
>>>>>>>>> firmware to upload.
>>>>>>>> there is firmware (/lib/firmware/ar5523.bin exists) 
>>>>>>>> but it does not even get touched (i renamed the file 
>>>>>>>> and the error did not change at all)
>>>>>> 
>>>>>>> find first usbid of your adapter (it will be changed 
>>>>>>> after firmware upload). And try to force driver to use 
>>>>>>> this id: modprobe -v ar5523 echo 07d1 3a0d > 
>>>>>>> /sys/bus/usb/drivers/ar5523/new_id
>>>>>> 
>>>>>>> instead of "07d1 3a0d" use your id.
>>>>>> 
>>>>>> 
>>>>>> # lsusb … Bus 003 Device 011: ID 129b:160c CyberTAN 
>>>>>> Technology Siemens S30853-S1038-R351 802.11g Wireless 
>>>>>> Adapter [Atheros AR5523] …
>>>>>> 
>>>>>> # modprobe ar5523 # echo 129b 160c > 
>>>>>> /sys/bus/usb/drivers/ar5523/new_id <plugging device in> 
>>>>>> syslog: Oct 18 18:27:47 yannik-desktop kernel: [ 
>>>>>> 8751.447784] usbcore: registered new interface driver 
>>>>>> ar5523 Oct 18 18:28:25 yannik-desktop kernel: [ 
>>>>>> 8789.036912] usb 3-14: new high-speed USB device number
>>>>>> 12 using xhci_hcd Oct 18 18:28:25 yannik-desktop kernel:
>>>>>> [ 8789.053995] usb 3-14: New USB device found,
>>>>>> idVendor=129b, idProduct=160c Oct 18 18:28:25
>>>>>> yannik-desktop kernel: [ 8789.054005] usb 3-14: New USB
>>>>>> device strings: Mfr=1, Product=2, SerialNumber=3 Oct 18
>>>>>> 18:28:25 yannik-desktop kernel: [ 8789.054010] usb 3-14:
>>>>>> Product: AR5523 Oct 18 18:28:25 yannik-desktop kernel: [
>>>>>> 8789.054015] usb 3-14: Manufacturer: Atheros
>>>>>> Communications Inc Oct 18 18:28:25 yannik-desktop kernel:
>>>>>> [ 8789.054019] usb 3-14: SerialNumber: 1.0 Oct 18
>>>>>> 18:28:27 yannik-desktop kernel: [ 8791.052313] usb 3-14:
>>>>>> timeout waiting for command 01 reply Oct 18 18:28:27
>>>>>> yannik-desktop kernel: [ 8791.052323] usb 3-14: could not
>>>>>> initialize adapter Oct 18 18:28:27 yannik-desktop kernel:
>>>>>> [ 8791.052359] usb 3-14: RX USB error -2. Oct 18 18:28:27
>>>>>> yannik-desktop kernel: [ 8791.052378] usb 3-14: error -1
>>>>>> when submitting rx urb Oct 18 18:28:27 yannik-desktop
>>>>>> kernel: [ 8791.052504] ar5523: probe of 3-14:1.0 failed
>>>>>> with error -110
>>>>>> 
>>>>>>> Besidy, what kernel version are you using? May be it
>>>>>>> is too old..
>>>>>> 
>>>>>> 3.11.0-12-generic it is my understanding that the ar5523 
>>>>>> driver was included from 3.8 on.
>>>> 
>>>>> please test attached patch.
>>>> Stopped the error from appearing but it looks like it would 
>>>> not even try to upload the firmware to me:
>> 
>>> Hi Yannik,
>> 
>>> please use this patch instead of previous. It will provide
>>> some more info. And send me complete dmesg.
>> 
>> I have to correct myself: I got the sources via apt-get source
>> (as opposed to git) this time. applied patch, worked.
> 
> 
> Thank you for update. Can you please send us dmesg with working
> result.
sure:
[ 9594.050560] usb 3-14: USB disconnect, device number 31
[ 9594.158932] wlan0: deauthenticating from 00:04:0e:d8:dd:56 by local
choice (reason=3)
[ 9594.254929] cfg80211: Calling CRDA to update world regulatory domain
[ 9594.261826] cfg80211: World regulatory domain updated:
[ 9594.261828] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[ 9594.261830] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[ 9594.261831] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[ 9594.261832] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[ 9594.261833] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[ 9594.261834] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[ 9596.032401] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[ 9596.136438] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[ 9596.136603] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[ 9596.616166] usb 3-14: new high-speed USB device number 32 using
xhci_hcd
[ 9596.633336] usb 3-14: New USB device found, idVendor=129b,
idProduct=160c
[ 9596.633345] usb 3-14: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[ 9596.633351] usb 3-14: Product: AR5523
[ 9596.633355] usb 3-14: Manufacturer: Atheros Communications Inc
[ 9596.633360] usb 3-14: SerialNumber: 1.0
[ 9596.634037] ar5523: start probe
[ 9596.729806] ar5523: firmware uploaded
[ 9596.877982] usb 3-14: USB disconnect, device number 32
[ 9597.148034] usb 3-14: new high-speed USB device number 33 using
xhci_hcd
[ 9597.165114] usb 3-14: New USB device found, idVendor=129b,
idProduct=160b
[ 9597.165123] usb 3-14: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[ 9597.165129] usb 3-14: Product: AR5523
[ 9597.165134] usb 3-14: Manufacturer: Atheros Communications Inc
[ 9597.165138] usb 3-14: SerialNumber: 1.0
[ 9597.165785] ar5523: start probe
[ 9597.212580] usb 3-14: Cap: CAP_TARGET_VERSION=0x00000006
[ 9597.212865] usb 3-14: Cap: CAP_TARGET_REVISION=0x00000001
[ 9597.213155] usb 3-14: Cap: CAP_MAC_VERSION=0x00000008
[ 9597.213420] usb 3-14: Cap: CAP_MAC_REVISION=0x00000001
[ 9597.213669] usb 3-14: Cap: CAP_PHY_REVISION=0x00000046
[ 9597.213939] usb 3-14: Cap: CAP_ANALOG_5GHz_REVISION=0x00000046
[ 9597.214188] usb 3-14: Cap: CAP_ANALOG_2GHz_REVISION=0x00000000
[ 9597.214459] usb 3-14: Cap: CAP_REG_DOMAIN=0x00000030
[ 9597.214699] usb 3-14: Cap: CAP_REG_CAP_BITS=0x00000000
[ 9597.214925] usb 3-14: Cap: CAP_WIRELESS_MODES=0x00000000
[ 9597.215238] usb 3-14: Cap: CAP_CHAN_SPREAD_SUPPORT=0x0000001c
[ 9597.215482] usb 3-14: Cap: CAP_COMPRESS_SUPPORT=0x00000001
[ 9597.215754] usb 3-14: Cap: CAP_BURST_SUPPORT=0x00000001
[ 9597.216025] usb 3-14: Cap: CAP_FAST_FRAMES_SUPPORT=0x00000001
[ 9597.216316] usb 3-14: Cap: CAP_CHAP_TUNING_SUPPORT=0x00000001
[ 9597.216563] usb 3-14: Cap: CAP_TURBOG_SUPPORT=0x00000001
[ 9597.216814] usb 3-14: Cap: CAP_TURBO_PRIME_SUPPORT=0x00000001
[ 9597.217084] usb 3-14: Cap: CAP_DEVICE_TYPE=0x00000001
[ 9597.217333] usb 3-14: Cap: CAP_WME_SUPPORT=0x00000001
[ 9597.217593] usb 3-14: Cap: CAP_TOTAL_QUEUES=0x00000001
[ 9597.217844] usb 3-14: Cap: CAP_CONNECTION_ID_MAX=0x0000000a
[ 9597.218112] usb 3-14: Cap: CAP_LOW_5GHZ_CHAN=0x00000004
[ 9597.218362] usb 3-14: Cap: CAP_HIGH_5GHZ_CHAN=0x00001338
[ 9597.218611] usb 3-14: Cap: CAP_LOW_2GHZ_CHAN=0x000017d4
[ 9597.218862] usb 3-14: Cap: CAP_HIGH_2GHZ_CHAN=0x00000908
[ 9597.219111] usb 3-14: Cap: CAP_TWICE_ANTENNAGAIN_5G=0x00000001
[ 9597.219376] usb 3-14: Cap: CAP_TWICE_ANTENNAGAIN_2G=0x00000004
[ 9597.219605] usb 3-14: Cap: CAP_CIPHER_AES_CCM=0x00000001
[ 9597.219861] usb 3-14: Cap: CAP_CIPHER_TKIP=0x00000000
[ 9597.220158] usb 3-14: Cap: CAP_MIC_TKIP=0x00000000
[ 9597.220732] usb 3-14: MAC/BBP AR5523, RF AR2112
[ 9597.221376] usb 3-14: Found and initialized AR5523 device
[ 9597.332462] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 9599.371152] wlan0: authenticate with 00:04:0e:d8:dd:56
[ 9599.380705] wlan0: send auth to 00:04:0e:d8:dd:56 (try 1/3)
[ 9599.382768] wlan0: authenticated
[ 9599.386282] wlan0: associate with 00:04:0e:d8:dd:56 (try 1/3)
[ 9599.395019] wlan0: RX AssocResp from 00:04:0e:d8:dd:56 (capab=0x411
status=0 aid=1)
[ 9599.395786] wlan0: associated
[ 9599.395820] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready

as reported the connection sometimes breakes down, when that happens
the dmesg contains multiple repetitions of the line
[ 9577.930431] usb 3-14: ar5523_data_rx_cb: USB err: -2


- -- 
Yannik Völker
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSaRapAAoJEDqk81AiCyXKvxkQAJPrAEx7E/YPEJEMVzIPsBQw
e9YyGkMJPfHRLJghtVAofKxmprohoq+NDNN5LHjMbm60q/TgKYlbQyHW4dDBc5yG
sV8L2A6/uDECi+5nq1ONUIsBIroWRIyXbfmcfDICCiGeO/z0Y/HraIsJtxNVu4Bx
gNMOgpKWV61nu/HeKQLLT52ShXnLfTOi+sqZape5PVm2YxHVS7DypfQ4q+qXdgEa
Rr5UxuItzYuIl0FrjxuVcMzgOwbMvP02tZZu+jnDU9XlQLf69C/TDjVDlGbvN9V3
nJh9bdeLqfz3IwLq1ojmEuqyF2rDTbHY/ccvw9ZbO7GfoWfo21EN23BXU/Codqnk
kr+GgMWX3Or8nQnJs0xZE7Rvaso2Xg6EEsbtlNyTz9BH85m0md+jCrtY6kYq93UT
U4S3CvtO+6gr2RYbR7WEIl+T67SQAZP0CPHQ6/VOhD5zkUIY5RGNoPTpekaKYKVG
m//6WXU50EZIcqHbIjpWQ3wGvYQ+GcZDmNA7b64Suc9G2HKJTyJhwZtjm4ql1FBL
k6zAcyF2TRG8bAm0+FudhhsTjJCmgcDVjWuJjrmWA46HgRj9ISLvbg8P0Pqo9792
PUEZbRXy9oWu77py9KmBwueomGIK2gM/14t/arXa82VXfryIv+Y2RxpNUlY3cXgB
3RoqQbe2+hh9nPM2fg65
=YL+I
-----END PGP SIGNATURE-----
