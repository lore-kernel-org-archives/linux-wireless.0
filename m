Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42457 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab0KFKnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Nov 2010 06:43:22 -0400
Received: by bwz11 with SMTP id 11so3433225bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 06 Nov 2010 03:43:21 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: working usb wifi card, that is still possible to buy
Date: Sat, 6 Nov 2010 11:43:11 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Josh Lehan <krellan@krellan.com>, Pavel Machek <pma@sysgo.com>
References: <20101103092431.GA21138@pma.sysgo.com> <ff5cf9bdd23aa256b379521d4c4263d8@localhost> <4CD46524.5010100@lwfinger.net>
In-Reply-To: <4CD46524.5010100@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201011061143.12038.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 05 November 2010 21:12:20 Larry Finger wrote:
> On 11/05/2010 12:54 PM, Johannes Berg wrote:
> > 
> > On Fri, 05 Nov 2010 08:15:26 -0500, Larry Finger
> >> The Realtek RTL8712 (aka RTL8192U) and found in the D-Link DWA 130, has
> > a
> >> driver
> >> in 2.6.37 (r8712u). Although not based on mac80211, thus found in
> > staging,
> >> the
> >> driver is extremely stable - my connection never drops out. With an
> > 802.11n
> >> router, I get transmission throughput of up to 70 Mb/s.
> > 
> > That definitely requires USB 2 though, and I suspect that
> > nobody actually ever tests their devices on a 1.1 only
> > controller like Pavel was asking for.
> 
> I have tested on 1.1 and it works. The rate mechanism of that non-mac80211
> driver ends up at 54M with a maximum transmission rate of 7.1 Mb/s. That must be
> the maximum that USB 1.1 can handle.

heh, be careful with what you're saying. He has problems
with not just one, but two completely different devices.
So r8712u might work perfectly well for you and your 1.1
USB hcd. But from the logs he posted I think it's not
just a wacky driver or firmware "problem".

usb 1-1: restart device (4)
usb 1-1: firmware upload failed (-110).
usb 1-1: Failed to restart device  (-110).
ieee80211 phy0: writing reg 0x1c36f0 (val 0x5000) failed (-5)

usb 1-1: no command feedback received (-110).
carl9170 cmd: 08 01 00 00 04 01 1d 00 03 00 00 00 ............
usb 1-1: restart device (6)
writing reg 0x1d0104 (val 0x3) failed (-110)

usb 1-3: no command feedback received (-110).
carl9170 cmd: 08 01 00 00 f0 36 1c 00 00 24 00 00 .....6...$..
usb 1-3: restart device (6)
writing reg 0x1c36f0 (val 0x2400) failed (-110)
lost 3 command responses/traps! w:13 g:0

>From the logs he posted, It's obvious that 
command and data frames are dropped along the way.
Now, this is fatal for carl9170 and *maybe* for rt2800usb too.

Best regards,
	Chr
