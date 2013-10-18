Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44702 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755551Ab3JROtK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 10:49:10 -0400
Date: Fri, 18 Oct 2013 10:49:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: =?UTF-8?B?WWFubmlrIFbDtmxrZXI=?= <yannikv@yahoo.de>
cc: Pontus Fuchs <pontus.fuchs@gmail.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: ar5523 Gigaset USB Adapter 108 issue
In-Reply-To: <526020B6.7080601@yahoo.de>
Message-ID: <Pine.LNX.4.44L0.1310181041080.1164-100000@iolanthe.rowland.org> (sfid-20131018_164914_078212_9D92501F)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yannik, you should always use Reply-To-All so that your messages get 
sent to the mailing list and not just to me.

On Thu, 17 Oct 2013, Yannik Völker wrote:

> Am 07.08.2013 19:34, schrieb Alan Stern:
> > Please post two usbmon traces, one showing the failure on your
> > current system and the other showing the adapter running correctly
> > under a 32-bit kernel.  Instructions for usbmon are in the kernel
> > source file Documentation/usb/usbmon.txt.
> I never got it to work under a 32-bit kernel, i was just able to utilize
> a windows32 driver using ndiswrapper.
> 
> Now i got it to "work". I randomly found out that the ar5523 driver
> actually works when you load it after you unload ndiswrapper so the
> following steps make it work:
> 1. modprobe ndiswrapper
> 2. plug in device
> 3. connect to wlan using ndiswrapper and disconnect again (might be
> optional)
> 4. modprobe -r ndiswrapper
> 5. modprobe ar5523
> 6. connect to wlan
> log for that is attatched as wlanthennative2.log
> 
> This works but is unreliable and sometimes the connection breaks down with
> 
> Oct 17 19:26:46 yannik-desktop wpa_supplicant[2153]: wlan0:
> CTRL-EVENT-DISCONNECTED bssid=01:23:45:67:89:ab reason=3
> Oct 17 19:26:46 yannik-desktop kernel: [  633.005591] usb 3-14:
> ar5523_data_rx_cb: USB err: -71
> Oct 17 19:26:46 yannik-desktop kernel: [  633.005703] usb 3-14: RX USB
> error -71.
> Oct 17 19:26:46 yannik-desktop kernel: [  633.005718] usb 3-14:
> ar5523_data_rx_cb: USB err: -71
> Oct 17 19:26:46 yannik-desktop kernel: [  633.005779] usb 3-14: RX USB
> error -71.
> Oct 17 19:26:46 yannik-desktop kernel: [  633.005788] usb 3-14:
> ar5523_data_rx_cb: USB err: -71
> Oct 17 19:26:46 yannik-desktop kernel: [  633.005846] usb 3-14: USB
> disconnect, device number 7
> Oct 17 19:26:46 yannik-desktop kernel: [  633.006080] wlan0:
> deauthenticating from 01:23:45:67:89:ab by local choice (reason=3)
> 
> unloading ar5523 and then refollowing the steps beginning with step 3
> usually makes it work again
> 
> 
> directload.log contains what happens when you just load ar5523 after
> the device was plugged in.
> 
> plug_ndis.log contains what sometimes happens when i have loaded and
> unloaded the modules some times and then try to load ndiswrapper.
> 
> pluginout.log contains syslog for plugging the device in and out.
> 
> Do you still need the usbmon traces?

In fact, I'm not the best person to work on this, since I know nothing
about the ar5523.  Problems with a particular driver should be brought
to the attention of the driver's maintainer (CC'ed).  Maybe he can
help.

It might be a good idea to post two usbmon traces: One showing what 
happens during steps 1-3, and another showing what happens if you 
modprobe ar5523 without loading ndiswrapper first.

Alan Stern

