Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41215 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573AbYGIPNG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 11:13:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh beacons
Date: Wed, 9 Jul 2008 17:12:31 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200807091511.14288.IvDoorn@gmail.com> <1215612322.3246.12.camel@johannes.berg> <200807091637.02090.IvDoorn@gmail.com>
In-Reply-To: <200807091637.02090.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807091712.31862.mb@bu3sch.de> (sfid-20080709_171330_435072_FE304245)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 July 2008 16:37:01 Ivo van Doorn wrote:
> On Wednesday 09 July 2008, Johannes Berg wrote:
> > On Wed, 2008-07-09 at 16:00 +0200, Michael Buesch wrote:
> > > On Wednesday 09 July 2008 16:04:50 Ivo van Doorn wrote:
> > > > On Wednesday 09 July 2008, Michael Buesch wrote:
> > > > > On Wednesday 09 July 2008 15:11:45 Ivo van Doorn wrote:
> > > > > > Currently only beacons generated in AP mode have the software
> > > > > > sequence number inserted. This means IBSS and Mesh mode are broken
> > > > > > for all hardware that require software sequence numbers.
> > > > > 
> > > > > Does software seq numbering even work at all?
> > > > > What about packets that get sent between the driver requested the
> > > > > beacon and the driver does actually queue it?
> > > > 
> > > > For rt2x00 the beacon is requested and queued within interrupt context
> > > 
> > > Well, another CPU could be in progress of walking down the mac80211 TX code
> > > and aquire a sequence number in the meantime before you requested the beacon.
> > > However that frame will be blocked by your driver locks, so the two seq
> > > numbers of the beacon and the other frame will be swapped, as the driver
> > > will queue the beacon first.
> 
> If rt2x00 would use a global lock to block all TX and beacons, then yes.
> But rt2x00 uses per-queue locking. When a beacon is being updated rt2x00
> will still allow regular frames to be queued.

It still leaves a race condition window. That's actually worse than
consistently breaking ;)

> But we can't halt the TX queues for the beacon update either, because
> ieee80211_stop_queues() should only be called from within the TX path.

I think the problem can only be fixed by doing sequence numbering in the driver.

-- 
Greetings Michael.
