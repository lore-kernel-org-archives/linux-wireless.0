Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38556 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbcB1M1y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2016 07:27:54 -0500
Received: by mail-wm0-f44.google.com with SMTP id l68so26283603wml.1
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2016 04:27:54 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: alexander nekrasov <i.sinister@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: carl1970: stops working at random periods on Ubuntu 15.05
Date: Sun, 28 Feb 2016 13:27:50 +0100
Message-ID: <42847572.gSex6kjQ2f@debian64> (sfid-20160228_132801_680580_C40EB283)
In-Reply-To: <CAG4k0fCqB1KNLyHV5--pi1nSoDPnV3qM-yTB0T2jmgbnjmqvww@mail.gmail.com>
References: <CAG4k0fCqB1KNLyHV5--pi1nSoDPnV3qM-yTB0T2jmgbnjmqvww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Sunday, February 28, 2016 03:06:35 AM alexander nekrasov wrote:
> I'm using TP-LINK TL-WN821N and encountering very annoying behaviour -
> adapter 'hangs' at random period of time - sometimes it is 1 hour,
> sometimes 2. After it hangs Network manager does not see any wireless
> networks and the only way to make it work is to reboot system (also
> tried unplugging/plugging adapter and removing/adding module but it
> did not work)
Did it get hot? Or Have you tried unloading/reloading the ohci/ehci/xhci?
The used USB-PHY FUSB200 (in the AR9170) is known to misbehave. If you
want to read more about the implications and possible solution, you can
visit the ath9k_htc firmware community. They have written a wiki entry
which describes the issues in detail [0].
 
> Heres lsusb -v:
> Bus 004 Device 004: ID 0cf3:1002 Atheros Communications, Inc. TP-Link
> TL-WN821N v2 / TL-WN822N v1 802.11n [Atheros AR9170]
> 
> And here what i have in syslog right before the hang:
> Following messages are also relevant to adapter failure but i guess it
> will be to long to post it here.
> 
> Feb 28 01:46:53 evren kernel: [ 4978.753087] usb 4-1.4: no command
> feedback received (-90).
> Feb 28 01:46:53 evren kernel: [ 4978.753098] usb 4-1.4: restart device (6)
> Feb 28 01:46:54 evren kernel: [ 4979.891093] usb 4-1.4: device
> restarted successfully.
> Feb 28 01:46:54 evren kernel: [ 4979.899273] ieee80211 phy1: Hardware
> restart was requested
Commands are issued on the devices end point #4.... And the response the
driver is waiting for doesn't get through. If you want to debug this, 
you'll need to look at the usb data stream and check which party (host
controller (ehci/ohci), device (AR9170) or cable?) is at fault. 

Regards,
Christian

[0] <https://github.com/qca/open-ath9k-htc-firmware/wiki/usb-related-issues>
