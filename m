Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:59718 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbZJBKqh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 06:46:37 -0400
Received: by fxm27 with SMTP id 27so882410fxm.17
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2009 03:46:40 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Malte Gell <malte.gell@gmx.de>
Subject: Re: [PATCH] ar9170usb: LEDs are confused
Date: Fri, 2 Oct 2009 12:46:34 +0200
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, linville@tuxdriver.com,
	"Hin-Tak Leung" <hintak.leung@gmail.com>
References: <200910011654.10963.chunkeey@googlemail.com> <200910020852.36427.malte.gell@gmx.de>
In-Reply-To: <200910020852.36427.malte.gell@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200910021246.34699.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 02 October 2009 08:52:36 Malte Gell wrote:
> Christian Lamparter <chunkeey@googlemail.com> wrote
> > On 2009-10-01 06:32 AM, Malte Gell wrote:
> > For example: The Netgear uses a single bi-color LED for their WNDA3100
> >  stick. It glows blue or/and orange depending on the selected band and
> >  current operation mode and state...
> 
> The Netgear (WN?) 111 even only has one blue LED as far as I know.
the question is if it's the only device with this deficit, or not?

> > FYI: you can assign the LEDs under "/sys/class/leds/" with a different
> >  tigger without messing with the kernel source... An up-to-date README can
> >  be found in the kernel's documentation directory:
> >  Documentation/leds-class.txt , or you can look it up online as well:
> > http://www.mjmwired.net/kernel/Documentation/leds-class.txt (from 2.6.31)
> 
> Very good to know. This needs a udev rule, right?
yes, should be possible one way or another...

If you do find an easy ACTION== rule, then let us know!
It would make a nice addition to the wiki @ wireless.kernel.org .
 
> But, what about a USB ID based decission in the driver how to handle the LED? 
> I have a Fritz WLAN N, USB ID:  057c:8401
The first post had a patch attached:
http://patchwork.kernel.org/patch/50977/

(raw patch)
=> http://patchwork.kernel.org/patch/50977/raw/

it should do exactly what you want.
just make sure, you reverted any previous LED related patch,
or it will not apply cleanly.

Regards,
	Chr
