Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58358 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab3JRPHK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 11:07:10 -0400
Received: from [192.168.0.103] ([93.218.112.150]) by mail.gmx.com (mrgmx003)
 with ESMTPSA (Nemesis) id 0MgtWa-1VJw6u2Prc-00M7KG for
 <linux-wireless@vger.kernel.org>; Fri, 18 Oct 2013 17:07:08 +0200
Message-ID: <52614E9B.6040400@rempel-privat.de> (sfid-20131018_170715_891026_4DB02EBF)
Date: Fri, 18 Oct 2013 17:07:07 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>,
	=?UTF-8?B?WWFubmlrIFbDtmxrZXI=?= <yannikv@yahoo.de>
CC: Pontus Fuchs <pontus.fuchs@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ar5523 Gigaset USB Adapter 108 issue
References: <Pine.LNX.4.44L0.1310181041080.1164-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1310181041080.1164-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 18.10.2013 16:49, schrieb Alan Stern:
> Yannik, you should always use Reply-To-All so that your messages get 
> sent to the mailing list and not just to me.
> 
> On Thu, 17 Oct 2013, Yannik Völker wrote:
> 
>> Am 07.08.2013 19:34, schrieb Alan Stern:
>>> Please post two usbmon traces, one showing the failure on your
>>> current system and the other showing the adapter running correctly
>>> under a 32-bit kernel.  Instructions for usbmon are in the kernel
>>> source file Documentation/usb/usbmon.txt.
>> I never got it to work under a 32-bit kernel, i was just able to utilize
>> a windows32 driver using ndiswrapper.
>>
>> Now i got it to "work". I randomly found out that the ar5523 driver
>> actually works when you load it after you unload ndiswrapper so the
>> following steps make it work:
>> 1. modprobe ndiswrapper
>> 2. plug in device
>> 3. connect to wlan using ndiswrapper and disconnect again (might be
>> optional)
>> 4. modprobe -r ndiswrapper
>> 5. modprobe ar5523
>> 6. connect to wlan
>> log for that is attatched as wlanthennative2.log


It sounds like linux driver didn't recognised usb id and didn't uploaded
firmware, or there was no firmware to upload.


>>
>> This works but is unreliable and sometimes the connection breaks down with
>>
>> Oct 17 19:26:46 yannik-desktop wpa_supplicant[2153]: wlan0:
>> CTRL-EVENT-DISCONNECTED bssid=01:23:45:67:89:ab reason=3
>> Oct 17 19:26:46 yannik-desktop kernel: [  633.005591] usb 3-14:
>> ar5523_data_rx_cb: USB err: -71
>> Oct 17 19:26:46 yannik-desktop kernel: [  633.005703] usb 3-14: RX USB
>> error -71.
>> Oct 17 19:26:46 yannik-desktop kernel: [  633.005718] usb 3-14:
>> ar5523_data_rx_cb: USB err: -71
>> Oct 17 19:26:46 yannik-desktop kernel: [  633.005779] usb 3-14: RX USB
>> error -71.
>> Oct 17 19:26:46 yannik-desktop kernel: [  633.005788] usb 3-14:
>> ar5523_data_rx_cb: USB err: -71
>> Oct 17 19:26:46 yannik-desktop kernel: [  633.005846] usb 3-14: USB
>> disconnect, device number 7
>> Oct 17 19:26:46 yannik-desktop kernel: [  633.006080] wlan0:
>> deauthenticating from 01:23:45:67:89:ab by local choice (reason=3)
>>
>> unloading ar5523 and then refollowing the steps beginning with step 3
>> usually makes it work again
>>

thas is probably other issue.  Let's start with thirst issue.

>> directload.log contains what happens when you just load ar5523 after
>> the device was plugged in.
>>
>> plug_ndis.log contains what sometimes happens when i have loaded and
>> unloaded the modules some times and then try to load ndiswrapper.
>>
>> pluginout.log contains syslog for plugging the device in and out.
>>
>> Do you still need the usbmon traces?
> 
> In fact, I'm not the best person to work on this, since I know nothing
> about the ar5523.  Problems with a particular driver should be brought
> to the attention of the driver's maintainer (CC'ed).  Maybe he can
> help.
> 
> It might be a good idea to post two usbmon traces: One showing what 
> happens during steps 1-3, and another showing what happens if you 
> modprobe ar5523 without loading ndiswrapper first.
> 



-- 
Regards,
Oleksij
