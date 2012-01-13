Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57588 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab2AMD2i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 22:28:38 -0500
Received: by yenq4 with SMTP id q4so58033yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jan 2012 19:28:37 -0800 (PST)
Message-ID: <4F0FA4DD.5020601@lwfinger.net> (sfid-20120113_042841_693024_F6A73644)
Date: Thu, 12 Jan 2012 21:28:29 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Markus_K=F6nigshaus?= <m.koenigshaus@wut.de>
CC: linux-wireless@vger.kernel.org, georgia@realtek.com
Subject: Re: Problem with the rtl8192cu - kernelmodule after ifdown, ifup
References: <4F0EEA1B.3040501@wut.de>
In-Reply-To: <4F0EEA1B.3040501@wut.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/12/2012 08:11 AM, Markus Königshaus wrote:
> Hello,
>
> I am using a USB WLAN - Stick with Realtek 8192 kernel driver. After plugging it
> works fine, connecting to a WPA - network works. After ifdown wlan0, ifup wlan0
> the stick no longer works , it stucks on scanning. Only a modprobe -r rtl8192cu;
> modprobe rtl8192cu fixes the problem. The problem only appear if more than one
> wireless - network is in range.The problem appear only in connection with the
> rtl8192cu driver, other USB - sticks (with different Chipset) and other PCIE -
> boards operate properly.
> In order to reproduce the behavior repeat the sequenceifdown wlan0, ifup wlan0 a
> few times.
>
> wpa_cli status->
> Selected interface 'wlan0'
> wpa_state=SCANNING
> < no change after 10 minutes>
>
> dmesg ->
> rtl8192cu: MAC auto ON okay!
> rtl8192cu: Tx queue select: 0x05
> rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin
> wlan0: authenticate with 00:08:54:9a:b2:5f (try 1)
> wlan0: authenticated
> wlan0: associate with 00:08:54:9a:b2:5f (try 1)
> wlan0: RX AssocResp from 00:08:54:9a:b2:5f (capab=0x411 status=0 aid=1)
> wlan0: associated
> < ifdown wlan0 >
> wlan0: disassociated from 00:08:54:9a:b2:5f (Reason: 14)
> wlan0: deauthenticating from 00:08:54:9a:b2:5f by local choice (reason=3)
> cfg80211: Calling CRDA for country: US
> rtl8192cu: MAC auto ON okay!
> rtl8192cu: Tx queue select: 0x05
> rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin
> < ifup wlan0 >
> rtl8192cu: MAC auto ON okay!
> rtl8192cu: Tx queue select: 0x05
> rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin
>
>
> cat /sys/class/net/wlan0/carrier -> 0
> cat /sys/class/net/wlan0/operstate -> down
>
> Kernelversion: 3.1.8
>
> modinfo rtl8192cu->
> filename: kernel/drivers/net/wireless/rtlwifi/rtl8192cu/rtl8192cu.ko
> description: Realtek 8192C/8188C 802.11n USB wireless
> author: Larry Finger <Larry.Finger@lwfinger.net>
> author: Georgia <georgia@realtek.com>
> license: GPL
> vermagic: 3.1.8-WuT preempt mod_unload ARMv5
> firmware: rtlwifi/rtl8192cufw.bin
> depends: rtlwifi,rtl8192c-common
>
> lsusb ->
> Bus 001 Device 001: ID 1d6b:0002
> Bus 001 Device 003: ID 0bda:8176

I will try to duplicate your results; however,there are two things I would like 
you to try. First is to get a copy of the bleeding-edge compat-wireless code, 
build and install the package, and test to see if it still fails. If it does, I 
want you to load the driver with a 'debug=4' option. In other words, use

modprobe -v rtl8192cu debug=4

Then, after a failure occurs, send me the output of a dmesg command.

Larry
