Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:65257 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbZBORUH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 12:20:07 -0500
Received: by an-out-0708.google.com with SMTP id c2so912768anc.1
        for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2009 09:20:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <da94abde0902070320g6a98320dhfdb05de8867d5fa7@mail.gmail.com>
References: <20090207071701.21485.18763.stgit@tikku>
	 <da94abde0902070320g6a98320dhfdb05de8867d5fa7@mail.gmail.com>
Date: Sun, 15 Feb 2009 12:20:05 -0500
Message-ID: <c4d76b3b0902150920v23db7ad3qf6e69752eade6643@mail.gmail.com> (sfid-20090215_182019_335193_17A2C570)
Subject: Re: [PATCH] at76c50x-usb: mac80211 port of at76_usb
From: Jason Andryuk <jandryuk@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 7, 2009 at 6:20 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> On Sat, Feb 7, 2009 at 9:27 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
>> John, please consider this driver as inclusion to the linux-testing tree. I
>> don't consider this ready for mainline yet, I want to test this more first in
>> case there are critical bugs.
>
> I have been testing this for few hours now on ubuntu 8.10 with
> networkmanager. With iperf I got this warning in some cases:
>
> phy0: at76_mac80211_tx called while tx urb is pending
>
> Also sometimes first association attempt failed and a second attempt
> was needed, but otherwise the driver seems to be usable, at least for
> me. The device I used for testing:
>
> Bus 002 Device 006: ID 050d:0050 Belkin Components F5D6050 802.11b
> Wireless Adapter

After applying the patch to wireless-testing master-2009-02-11, I
tried it out to poor results.

Attaching my Linksys WUSB11 results in an Oops.  Unfortunately,
2.6.29-rc4 has problems with my e1000e, so I cannot set up a
netconsole.  I will continue to investigate, but all I have for now is
the below logs.

Jason

Feb 13 13:11:16 rainbow kernel: [  371.980119] usb 3-2: new full speed
USB device using uhci_hcd and address 2
Feb 13 13:11:16 rainbow kernel: [  372.129492] usb 3-2: configuration
#1 chosen from 1 choice
Feb 13 13:11:16 rainbow kernel: [  372.196265] at76c50x_usb:
`0xb002c001' invalid for parameter `debug'
Feb 13 13:14:42 rainbow kernel: [  578.488148] usb 3-2: USB
disconnect, address 2
Feb 13 13:14:46 rainbow kernel: [  582.232074] usb 3-2: new full speed
USB device using uhci_hcd and address 3
Feb 13 13:14:46 rainbow kernel: [  582.381458] usb 3-2: configuration
#1 chosen from 1 choice
Feb 13 13:14:46 rainbow kernel: [  582.441646] Atmel at76x USB
Wireless LAN Driver 0.17 loading
Feb 13 13:14:46 rainbow kernel: [  582.441711] usb 3-2: firmware:
requesting atmel_at76c503-i3861.bin
Feb 13 13:14:46 rainbow kernel: [  582.500287] usb 3-2: using firmware
atmel_at76c503-i3861.bin (version 0.90.0-44)
Feb 13 13:14:46 rainbow kernel: [  582.515108] phy2: Selected rate
control algorithm 'minstrel'
Feb 13 13:14:46 rainbow kernel: [  582.517798] phy2: USB 3-2:1.0, MAC
00:06:25:00:6a:7a, firmware 0.90.0-2
Feb 13 13:14:46 rainbow kernel: [  582.517804] phy2: regulatory domain
0x10: FCC (USA)
Feb 13 13:14:46 rainbow kernel: [  582.517858] usbcore: registered new
interface driver at76c50x-usb
Feb 13 13:14:46 rainbow kernel: [  582.530931] udev: renamed network
interface wlan0 to wlan3
