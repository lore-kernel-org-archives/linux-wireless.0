Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.231]:59704 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbYGIO7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 10:59:16 -0400
Received: by wr-out-0506.google.com with SMTP id 69so2164852wri.5
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 07:59:15 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh beacons
Date: Wed, 9 Jul 2008 17:08:04 +0200
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200807091511.14288.IvDoorn@gmail.com> <200807091637.02090.IvDoorn@gmail.com> <1215614895.3246.17.camel@johannes.berg>
In-Reply-To: <1215614895.3246.17.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807091708.04870.IvDoorn@gmail.com> (sfid-20080709_165919_690389_57EF815B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 July 2008, Johannes Berg wrote:
> 
> > If rt2x00 would use a global lock to block all TX and beacons, then yes.
> > But rt2x00 uses per-queue locking. When a beacon is being updated rt2x00
> > will still allow regular frames to be queued.
> 
> That just widens the window. And if you have multiple queues then you
> can't do sw sequence numbers anyway because the hardware might reorder
> the frames.

That doesn't seem to be a problem in the legacy drivers, so I guess the hardware
does *something* to prevent problems.

> > As far as rt2x00 is concerned, all hardware that supports multi-bss also
> > support HW sequence counters. rt2400pci and rt2500pci are the only ones
> > requiring SW sequence counters, and they can't do multi-bss.
> 
> Do they keep per-BSS counters?

Not sure what you mean, but rt2400pci and rt2500pci don't support multi-bss,
so they wouldn't have per-BSS counters.
rt61pci and rt73usb do support multi-bss and keep the sequence counting
completely in firmware/hardware and I am not sure how they can be read
by the driver. So I don't know how those are stored either.


Ivo
