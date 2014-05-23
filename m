Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kraftzwerg.no-carrier.info ([87.98.242.129]:54309 "EHLO
	mail.no-carrier.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbaEWPdf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 11:33:35 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.no-carrier.info (Postfix) with ESMTP id 143BD2037F9
	for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 17:33:34 +0200 (CEST)
Received: from mail.no-carrier.info ([127.0.0.1])
	by localhost (mail.no-carrier.info [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 4JqwH-l2WQlF for <linux-wireless@vger.kernel.org>;
	Fri, 23 May 2014 17:33:23 +0200 (CEST)
Received: from [192.168.1.130] (p5DD56887.dip0.t-ipconnect.de [93.213.104.135])
	(Authenticated sender: mail@marc-stuermer.de)
	by mail.no-carrier.info (Postfix) with ESMTPA id 8439F200A47
	for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 17:33:23 +0200 (CEST)
Message-ID: <537F6A1B.6060905@marc-stuermer.de> (sfid-20140523_173339_278880_915B1BE4)
Date: Fri, 23 May 2014 17:32:43 +0200
From: =?ISO-8859-15?Q?Marc_St=FCrmer?= <mail@marc-stuermer.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: Rtl8192CU: regular disconnect in managed mode after a short while
References: <537F0A21.5070102@marc-stuermer.de> <537F606E.6030808@lwfinger.net>
In-Reply-To: <537F606E.6030808@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 23.05.2014 16:51, schrieb Larry Finger:

 > Looking at your kernel log, the first thing I see is
 >
 > [  295.926536] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
 > [  295.926578] usbcore: registered new interface driver rtl8192cu
 > [  295.949364] usb 3-9: Direct firmware load failed with error -2
 > [  295.949366] usb 3-9: Falling back to user helper
 > [  295.955563] rtlwifi: Loading alternative firmware
 > rtlwifi/rtl8192cufw.bin
 >
 > You should try the newest firmware. If you have updated your code base
 > recently, then your distro apparently does not supply it. You should get
 > the latest copy of firmware with

Thanks for the response and information, I just did that like told.

I'm on Gentoo stable here and used the linux-firmware-ebuild out of 
portage, which still had not that BLOB in it. So I just copied it over.

Kernel is:
Linux dreadnought 3.14.4 #6 SMP Fri May 23 17:00:34 CEST 2014 x86_64 
Intel(R) Core(TM) i5-4670K CPU @ 3.40GHz GenuineIntel GNU/Linux

/proc/config.gz is: http://pastebin.com/CZ7VmuWt

 > Load the driver with 'modprobe -v rtl8192cu debug=3' and post the from
 > when the driver is loaded until it fails.

modprobe -v rtl8192cu debug=3
insmod 
/lib/modules/3.14.4/kernel/drivers/net/wireless/rtlwifi/rtl8192c/rtl8192c-common.ko
insmod /lib/modules/3.14.4/kernel/drivers/net/wireless/rtlwifi/rtlwifi.ko
insmod /lib/modules/3.14.4/kernel/drivers/net/wireless/rtlwifi/rtl_usb.ko
insmod 
/lib/modules/3.14.4/kernel/drivers/net/wireless/rtlwifi/rtl8192cu/rtl8192cu.ko 
debug=3

Logfile: http://pastebin.com/1RsGKsZi

After it got stuck I unloaded the driver module and fired up the other 
WLAN then, I guess that's where those URB errors originate from.

IMHO the typical loop it has been stuck in goes like this, all after 
Line 2107 happened because I unloaded the module:

May 23 17:21:43 dreadnought kernel: [ 1164.047574] 
rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=08
May 23 17:21:44 dreadnought kernel: [ 1165.043107] 
rtl8192c_common:rtl92c_dm_write_dig():<0-0> dig values 0x1e 0x1e 0x0 0xc 
0x3e 0x1e 0x0 0x1e
May 23 17:21:44 dreadnought kernel: [ 1165.284384] 
rtl8192cu:_rtl8192cu_mq_to_descq():<600-1> BE queue, set qsel = 0x0
May 23 17:21:45 dreadnought kernel: [ 1165.576186] 
rtl8192cu:_rtl8192cu_mq_to_descq():<500-1> BE queue, set qsel = 0x0
May 23 17:21:45 dreadnought kernel: [ 1166.286179] 
rtl8192cu:_rtl8192cu_mq_to_descq():<300-1> BE queue, set qsel = 0x0
May 23 17:21:46 dreadnought kernel: [ 1166.599659] 
rtl8192cu:_rtl8192cu_mq_to_descq():<500-1> BE queue, set qsel = 0x0
May 23 17:21:46 dreadnought kernel: [ 1167.045766] 
rtl8192c_common:rtl92c_dm_write_dig():<0-0> dig values 0x1e 0x1e 0x0 0xc 
0x3e 0x1e 0x0 0x1e
May 23 17:21:46 dreadnought kernel: [ 1167.287601] 
rtl8192cu:_rtl8192cu_mq_to_descq():<300-1> BE queue, set qsel = 0x0
May 23 17:21:47 dreadnought kernel: [ 1167.622982] 
rtl8192cu:_rtl8192cu_mq_to_descq():<500-1> BE queue, set qsel = 0x0
May 23 17:21:48 dreadnought kernel: [ 1169.036675] 
rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=08
May 23 17:21:48 dreadnought kernel: [ 1169.048732] 
rtl8192c_common:rtl92c_dm_write_dig():<0-0> dig values 0x1f 0x1f 0x0 0xc 
0x3e 0x1e 0x0 0x1e

Thanks in advance and please give me a shoot if I can do anything else 
to assist you in tracking down this nasty bug once and for all.

Greetings,

Marc

