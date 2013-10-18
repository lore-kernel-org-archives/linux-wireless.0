Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:63790 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756434Ab3JRRQE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 13:16:04 -0400
Received: from [192.168.0.103] ([93.218.112.150]) by mail.gmx.com (mrgmx003)
 with ESMTPSA (Nemesis) id 0LzcIM-1Vl1Nr1mgE-014jkH for
 <linux-wireless@vger.kernel.org>; Fri, 18 Oct 2013 19:16:02 +0200
Message-ID: <52616CD0.2000203@rempel-privat.de> (sfid-20131018_191608_559078_77978886)
Date: Fri, 18 Oct 2013 19:16:00 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: =?UTF-8?B?WWFubmlrIFbDtmxrZXI=?= <yannikv@yahoo.de>
CC: Pontus Fuchs <pontus.fuchs@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ar5523 Gigaset USB Adapter 108 issue
References: <Pine.LNX.4.44L0.1310181041080.1164-100000@iolanthe.rowland.org> <52614E9B.6040400@rempel-privat.de> <526155ED.1090007@yahoo.de> <52615EFA.80902@rempel-privat.de> <526162ED.8030901@yahoo.de>
In-Reply-To: <526162ED.8030901@yahoo.de>
Content-Type: multipart/mixed;
 boundary="------------030202040502030900070109"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030202040502030900070109
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Am 18.10.2013 18:33, schrieb Yannik Völker:
> Am 18.10.2013 18:16, schrieb Oleksij Rempel:
>> Am 18.10.2013 17:38, schrieb Yannik Völker:
>>> Am 18.10.2013 17:07, schrieb Oleksij Rempel:
>>>> Am 18.10.2013 16:49, schrieb Alan Stern:
>>>>> Yannik, you should always use Reply-To-All so that your
>>>>> messages get sent to the mailing list and not just to me.
>>>>>
>>>>> On Thu, 17 Oct 2013, Yannik Völker wrote:
>>>>>
>>>>>> Am 07.08.2013 19:34, schrieb Alan Stern:
>>>>>>> Please post two usbmon traces, one showing the failure
>>>>>>> on your current system and the other showing the adapter
>>>>>>> running correctly under a 32-bit kernel.  Instructions
>>>>>>> for usbmon are in the kernel source file
>>>>>>> Documentation/usb/usbmon.txt.
>>>>>> I never got it to work under a 32-bit kernel, i was just
>>>>>> able to utilize a windows32 driver using ndiswrapper.
>>>>>>
>>>>>> Now i got it to "work". I randomly found out that the
>>>>>> ar5523 driver actually works when you load it after you
>>>>>> unload ndiswrapper so the following steps make it work: 1.
>>>>>> modprobe ndiswrapper 2. plug in device 3. connect to wlan
>>>>>> using ndiswrapper and disconnect again (might be optional)
>>>>>> 4. modprobe -r ndiswrapper 5. modprobe ar5523 6. connect to
>>>>>> wlan log for that is attatched as wlanthennative2.log
>>>
>>>
>>>> It sounds like linux driver didn't recognised usb id and
>>>> didn't uploaded firmware, or there was no firmware to upload.
>>> there is firmware (/lib/firmware/ar5523.bin exists) but it does
>>> not even get touched (i renamed the file and the error did not
>>> change at all)
> 
>> find first usbid of your adapter (it will be changed after
>> firmware upload). And try to force driver to use this id: modprobe
>> -v ar5523 echo 07d1 3a0d > /sys/bus/usb/drivers/ar5523/new_id
> 
>> instead of "07d1 3a0d" use your id.
> 
> 
> # lsusb
> …
> Bus 003 Device 011: ID 129b:160c CyberTAN Technology Siemens
> S30853-S1038-R351 802.11g Wireless Adapter [Atheros AR5523]
> …
> 
> # modprobe ar5523
> # echo 129b 160c > /sys/bus/usb/drivers/ar5523/new_id
> <plugging device in>
> syslog:
> Oct 18 18:27:47 yannik-desktop kernel: [ 8751.447784] usbcore:
> registered new interface driver ar5523
> Oct 18 18:28:25 yannik-desktop kernel: [ 8789.036912] usb 3-14: new
> high-speed USB device number 12 using xhci_hcd
> Oct 18 18:28:25 yannik-desktop kernel: [ 8789.053995] usb 3-14: New
> USB device found, idVendor=129b, idProduct=160c
> Oct 18 18:28:25 yannik-desktop kernel: [ 8789.054005] usb 3-14: New
> USB device strings: Mfr=1, Product=2, SerialNumber=3
> Oct 18 18:28:25 yannik-desktop kernel: [ 8789.054010] usb 3-14:
> Product: AR5523
> Oct 18 18:28:25 yannik-desktop kernel: [ 8789.054015] usb 3-14:
> Manufacturer: Atheros Communications Inc
> Oct 18 18:28:25 yannik-desktop kernel: [ 8789.054019] usb 3-14:
> SerialNumber: 1.0
> Oct 18 18:28:27 yannik-desktop kernel: [ 8791.052313] usb 3-14:
> timeout waiting for command 01 reply
> Oct 18 18:28:27 yannik-desktop kernel: [ 8791.052323] usb 3-14: could
> not initialize adapter
> Oct 18 18:28:27 yannik-desktop kernel: [ 8791.052359] usb 3-14: RX USB
> error -2.
> Oct 18 18:28:27 yannik-desktop kernel: [ 8791.052378] usb 3-14: error
> -1 when submitting rx urb
> Oct 18 18:28:27 yannik-desktop kernel: [ 8791.052504] ar5523: probe of
> 3-14:1.0 failed with error -110
> 
>> Besidy, what kernel version are you using? May be it is too old..
> 
> 3.11.0-12-generic
> it is my understanding that the ar5523 driver was included from 3.8 on.

please test attached patch.

-- 
Regards,
Oleksij

--------------030202040502030900070109
Content-Type: text/x-patch;
 name="ar5523.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ar5523.diff"

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 17d7fec..57fc06e 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1764,7 +1764,7 @@ static struct usb_device_id ar5523_id_table[] = {
 	AR5523_DEVICE_UX(0x2001, 0x3a04),	/* Dlink / DWLAG122 */
 	AR5523_DEVICE_UG(0x1690, 0x0712),	/* Gigaset / AR5523 */
 	AR5523_DEVICE_UG(0x1690, 0x0710),	/* Gigaset / SMCWUSBTG */
-	AR5523_DEVICE_UG(0x129b, 0x160c),	/* Gigaset / USB stick 108
+	AR5523_DEVICE_UG(0x129b, 0x160b),	/* Gigaset / USB stick 108
 						   (CyberTAN Technology) */
 	AR5523_DEVICE_UG(0x16ab, 0x7801),	/* Globalsun / AR5523_1 */
 	AR5523_DEVICE_UX(0x16ab, 0x7811),	/* Globalsun / AR5523_2 */

--------------030202040502030900070109--
