Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:50073 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393Ab3JVSpW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Oct 2013 14:45:22 -0400
Received: from [192.168.0.100] ([93.218.117.40]) by mail.gmx.com (mrgmx101)
 with ESMTPSA (Nemesis) id 0Ld4xA-1VyzEO1kC8-00iF9K for
 <linux-wireless@vger.kernel.org>; Tue, 22 Oct 2013 20:45:20 +0200
Message-ID: <5266C7BF.20503@rempel-privat.de> (sfid-20131022_204527_918685_C66178F9)
Date: Tue, 22 Oct 2013 20:45:19 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: =?UTF-8?B?WWFubmlrIFbDtmxrZXI=?= <yannikv@yahoo.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	pontus.fuchs@gmail.com
Subject: Re: ar5523 Gigaset USB Adapter 108 issue
References: <Pine.LNX.4.44L0.1310181041080.1164-100000@iolanthe.rowland.org> <52614E9B.6040400@rempel-privat.de> <526155ED.1090007@yahoo.de> <52615EFA.80902@rempel-privat.de> <526162ED.8030901@yahoo.de> <52616CD0.2000203@rempel-privat.de> <5262789D.8030704@yahoo.de> <5262BA7A.2050803@rempel-privat.de> <5266C4C1.80408@yahoo.de>
In-Reply-To: <5266C4C1.80408@yahoo.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 22.10.2013 20:32, schrieb Yannik Völker:
> Am 19.10.2013 18:59, schrieb Oleksij Rempel:
>> Am 19.10.2013 14:18, schrieb Yannik Völker:
>>> Am 18.10.2013 19:16, schrieb Oleksij Rempel:
>>>> Am 18.10.2013 18:33, schrieb Yannik Völker:
>>>>> Am 18.10.2013 18:16, schrieb Oleksij Rempel:
>>>>>> Am 18.10.2013 17:38, schrieb Yannik Völker:
>>>>>>> Am 18.10.2013 17:07, schrieb Oleksij Rempel:
>>>>>>>> Am 18.10.2013 16:49, schrieb Alan Stern:
>>>>>>>>> Yannik, you should always use Reply-To-All so that 
>>>>>>>>> your messages get sent to the mailing list and not 
>>>>>>>>> just to me.
>>>>>>>>> 
>>>>>>>>> On Thu, 17 Oct 2013, Yannik Völker wrote:
>>>>>>>>> 
>>>>>>>>>> Am 07.08.2013 19:34, schrieb Alan Stern:
>>>>>>>>>>> Please post two usbmon traces, one showing the
>>>>>>>>>>>  failure on your current system and the other 
>>>>>>>>>>> showing the adapter running correctly under a 
>>>>>>>>>>> 32-bit kernel. Instructions for usbmon are in
>>>>>>>>>>> the kernel source file
>>>>>>>>>>> Documentation/usb/usbmon.txt.
>>>>>>>>>> I never got it to work under a 32-bit kernel, i 
>>>>>>>>>> was just able to utilize a windows32 driver using
>>>>>>>>>>  ndiswrapper.
>>>>>>>>>> 
>>>>>>>>>> Now i got it to "work". I randomly found out
>>>>>>>>>> that the ar5523 driver actually works when you
>>>>>>>>>> load it after you unload ndiswrapper so the
>>>>>>>>>> following steps make it work: 1. modprobe
>>>>>>>>>> ndiswrapper 2. plug in device 3. connect to wlan
>>>>>>>>>> using ndiswrapper and disconnect again (might be
>>>>>>>>>> optional) 4. modprobe -r ndiswrapper 5. modprobe
>>>>>>>>>> ar5523 6. connect to wlan log for that is
>>>>>>>>>> attatched as wlanthennative2.log
>>>>>>> 
>>>>>>> 
>>>>>>>> It sounds like linux driver didn't recognised usb id 
>>>>>>>> and didn't uploaded firmware, or there was no
>>>>>>>> firmware to upload.
>>>>>>> there is firmware (/lib/firmware/ar5523.bin exists)
>>>>>>> but it does not even get touched (i renamed the file
>>>>>>> and the error did not change at all)
>>>>> 
>>>>>> find first usbid of your adapter (it will be changed
>>>>>> after firmware upload). And try to force driver to use
>>>>>> this id: modprobe -v ar5523 echo 07d1 3a0d > 
>>>>>> /sys/bus/usb/drivers/ar5523/new_id
>>>>> 
>>>>>> instead of "07d1 3a0d" use your id.
>>>>> 
>>>>> 
>>>>> # lsusb … Bus 003 Device 011: ID 129b:160c CyberTAN 
>>>>> Technology Siemens S30853-S1038-R351 802.11g Wireless
>>>>> Adapter [Atheros AR5523] …
>>>>> 
>>>>> # modprobe ar5523 # echo 129b 160c > 
>>>>> /sys/bus/usb/drivers/ar5523/new_id <plugging device in> 
>>>>> syslog: Oct 18 18:27:47 yannik-desktop kernel: [
>>>>> 8751.447784] usbcore: registered new interface driver
>>>>> ar5523 Oct 18 18:28:25 yannik-desktop kernel: [
>>>>> 8789.036912] usb 3-14: new high-speed USB device number 12
>>>>> using xhci_hcd Oct 18 18:28:25 yannik-desktop kernel: [
>>>>> 8789.053995] usb 3-14: New USB device found, idVendor=129b,
>>>>> idProduct=160c Oct 18 18:28:25 yannik-desktop kernel: [
>>>>> 8789.054005] usb 3-14: New USB device strings: Mfr=1,
>>>>> Product=2, SerialNumber=3 Oct 18 18:28:25 yannik-desktop
>>>>> kernel: [ 8789.054010] usb 3-14: Product: AR5523 Oct 18
>>>>> 18:28:25 yannik-desktop kernel: [ 8789.054015] usb 3-14:
>>>>> Manufacturer: Atheros Communications Inc Oct 18 18:28:25
>>>>> yannik-desktop kernel: [ 8789.054019] usb 3-14:
>>>>> SerialNumber: 1.0 Oct 18 18:28:27 yannik-desktop kernel: [
>>>>> 8791.052313] usb 3-14: timeout waiting for command 01 reply
>>>>> Oct 18 18:28:27 yannik-desktop kernel: [ 8791.052323] usb
>>>>> 3-14: could not initialize adapter Oct 18 18:28:27
>>>>> yannik-desktop kernel: [ 8791.052359] usb 3-14: RX USB
>>>>> error -2. Oct 18 18:28:27 yannik-desktop kernel: [ 
>>>>> 8791.052378] usb 3-14: error -1 when submitting rx urb Oct
>>>>> 18 18:28:27 yannik-desktop kernel: [ 8791.052504] ar5523:
>>>>> probe of 3-14:1.0 failed with error -110
>>>>> 
>>>>>> Besidy, what kernel version are you using? May be it is 
>>>>>> too old..
>>>>> 
>>>>> 3.11.0-12-generic it is my understanding that the ar5523 
>>>>> driver was included from 3.8 on.
>>> 
>>>> please test attached patch.
>>> Stopped the error from appearing but it looks like it would
>>> not even try to upload the firmware to me:
> 
>> Hi Yannik,
> 
>> please use this patch instead of previous. It will provide some 
>> more info. And send me complete dmesg.
> 
> I have to correct myself: I got the sources via apt-get source (as
> opposed to git) this time. applied patch, worked.


Thank you for update. Can you please send us dmesg with working result.


-- 
Regards,
Oleksij
