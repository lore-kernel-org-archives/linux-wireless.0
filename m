Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.179]:55424 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbYGIP2G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 11:28:06 -0400
Received: by el-out-1112.google.com with SMTP id z25so457442ele.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 08:28:05 -0700 (PDT)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh beacons
Date: Wed, 9 Jul 2008 17:36:54 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200807091511.14288.IvDoorn@gmail.com> <200807091708.04870.IvDoorn@gmail.com> <200807091715.24710.mb@bu3sch.de>
In-Reply-To: <200807091715.24710.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807091736.55061.IvDoorn@gmail.com> (sfid-20080709_172813_076385_F2521469)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 July 2008, Michael Buesch wrote:
> On Wednesday 09 July 2008 17:08:04 Ivo van Doorn wrote:
> > On Wednesday 09 July 2008, Johannes Berg wrote:
> > > 
> > > > If rt2x00 would use a global lock to block all TX and beacons, then yes.
> > > > But rt2x00 uses per-queue locking. When a beacon is being updated rt2x00
> > > > will still allow regular frames to be queued.
> > > 
> > > That just widens the window. And if you have multiple queues then you
> > > can't do sw sequence numbers anyway because the hardware might reorder
> > > the frames.
> > 
> > That doesn't seem to be a problem in the legacy drivers, so I guess the hardware
> > does *something* to prevent problems.
> 
> Well, legacy drivers don't use mac80211. Sequence counting can trivially be fixed
> by doing it _right_ before queueing the packet to the hardware in the driver,
> with the TX queue lock held, that must already be there.

True, I have to double check it, but the legacy drivers use per-queue locking as well.
And it would still be possible for the driver to send out frames with a higher
sequence number before one with a lower number.

But I'll put out a request on the rt2400-devel list to see if anybody is interested
in looking into this issue for rt2400pci and rt2500pci. In if there is nobody, I'll
disable adhoc and master mode for those drivers to prevent problems.

Ivo
