Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:42365 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbYGLIPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2008 04:15:07 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1271538nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jul 2008 01:15:06 -0700 (PDT)
To: Pavel Roskin <proski@gnu.org>
Subject: Re: rt2x00 is still experimental?
Date: Sat, 12 Jul 2008 10:25:43 +0200
Cc: linux-wireless@vger.kernel.org
References: <1215811139.30975.10.camel@dv>
In-Reply-To: <1215811139.30975.10.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807121025.43801.IvDoorn@gmail.com> (sfid-20080712_101520_447574_534AF3FF)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Can we please have rt2x00 drivers considered stable in Linux 2.6.27? 

No.

> My experience running rt73 day by day with WPA on a very crowded network
> shows that it's a pretty reliable driver already.

Perhaps managed mode, but not adhoc mode, beaconing is still broken.
In addition the leds are broken as well, and hardware encryption isn't in either.

But to make a very important nore:

rt2400pci: unknown status
rt2500pci: TX rate problems, LED problems
rt2500usb: Completely broken, segfault on unplug, no HW crypto
rt61pci: TX rate problems, LED problems, no HW crypto
rt73usb: TX rate problems, LED problems. no HW crypto

I have 4 open Fedora bugreports, and 3 open Kernel bugreports

When I finally have my testsystem capable of running a >=2.6.26 kernel
then I can test rt2400pci, and _perhaps_ I can mark that one as stable since
it seems to work quite well on 2.6.25.

But marking the drivers as stable with be a per-rt2x00-driver decision, so what
I can do is moving the CONFIG_EXPERIMENTAL dependency to the drivers instead
of globally on CONFIG_RT2X00

> I realize that distros would enable whatever they want, and most people
> here have CONFIG_EXPERIMENTAL on anyway, but still, it could help direct
> users towards better supported hardware and make CONFIG_EXPERIMENTAL
> more relevant.
> 
> The latest commits to the drivers/net/wireless/rt2x00 directory seem to
> confirm that the major issues have been addressed already.

Not sure what you saw in the latest commits, but they are not confirming anything
about stability. ;)

Ivo
