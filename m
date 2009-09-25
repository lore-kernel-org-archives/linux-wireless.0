Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51820 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751411AbZIYUQE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 16:16:04 -0400
Message-ID: <4ABD2504.9010202@gmx.de>
Date: Fri, 25 Sep 2009 22:16:04 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Malte Gell <malte.gell@gmx.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: ar9170 makes machine hang when shut down
References: <200909242155.19485.malte.gell@gmx.de> <4ABBE5DB.5070201@gmx.de> <200909251132.18546.malte.gell@gmx.de>
In-Reply-To: <200909251132.18546.malte.gell@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/25/2009 11:32 AM, Malte Gell wrote:
> My system loads ar9170:
> 
> lsmod | grep ar91*
> 
> ar9170                 32632  0
> mac80211              237208  1 ar9170
> led_class               4028  1 ar9170
> usbcore               183280  15 
> usbserial,ar9170,usbhid,uvcvideo,snd_usb_audio,snd_usb_lib,usblp,ehci_hcd,uhci_hcd,ohci_hcd,usb_storage

You are right. I had a look into the source rpm for the packets your url pointed to. The ar9170 driver inside
compat-wireless dates back to end of February 2009, at that time the driver was called ar9170, it got the "usb" prefix later.

You might try arusb_lnx (the vendor driver) from the other package (no idea how OpenSuSE handles two drivers
for the same hardware), but the best way to get support from this list would be to compile a decent
compat-wireless by your own and report bugs etc. to the list. A lot of stuff changed since February.

Regards,
Jörg.
