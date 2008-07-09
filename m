Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:42085 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbYGIPPs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 11:15:48 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh beacons
Date: Wed, 9 Jul 2008 17:15:24 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200807091511.14288.IvDoorn@gmail.com> <1215614895.3246.17.camel@johannes.berg> <200807091708.04870.IvDoorn@gmail.com>
In-Reply-To: <200807091708.04870.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807091715.24710.mb@bu3sch.de> (sfid-20080709_171600_600517_AF9400C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 July 2008 17:08:04 Ivo van Doorn wrote:
> On Wednesday 09 July 2008, Johannes Berg wrote:
> > 
> > > If rt2x00 would use a global lock to block all TX and beacons, then yes.
> > > But rt2x00 uses per-queue locking. When a beacon is being updated rt2x00
> > > will still allow regular frames to be queued.
> > 
> > That just widens the window. And if you have multiple queues then you
> > can't do sw sequence numbers anyway because the hardware might reorder
> > the frames.
> 
> That doesn't seem to be a problem in the legacy drivers, so I guess the hardware
> does *something* to prevent problems.

Well, legacy drivers don't use mac80211. Sequence counting can trivially be fixed
by doing it _right_ before queueing the packet to the hardware in the driver,
with the TX queue lock held, that must already be there.

-- 
Greetings Michael.
