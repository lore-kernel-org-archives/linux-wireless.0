Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:42131 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbYGIOBM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 10:01:12 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh beacons
Date: Wed, 9 Jul 2008 16:00:44 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>
References: <200807091511.14288.IvDoorn@gmail.com> <200807091538.09387.mb@bu3sch.de> <200807091604.50199.IvDoorn@gmail.com>
In-Reply-To: <200807091604.50199.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807091600.44437.mb@bu3sch.de> (sfid-20080709_160115_282398_A7D0F576)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 July 2008 16:04:50 Ivo van Doorn wrote:
> On Wednesday 09 July 2008, Michael Buesch wrote:
> > On Wednesday 09 July 2008 15:11:45 Ivo van Doorn wrote:
> > > Currently only beacons generated in AP mode have the software
> > > sequence number inserted. This means IBSS and Mesh mode are broken
> > > for all hardware that require software sequence numbers.
> > 
> > Does software seq numbering even work at all?
> > What about packets that get sent between the driver requested the
> > beacon and the driver does actually queue it?
> 
> For rt2x00 the beacon is requested and queued within interrupt context

Well, another CPU could be in progress of walking down the mac80211 TX code
and aquire a sequence number in the meantime before you requested the beacon.
However that frame will be blocked by your driver locks, so the two seq
numbers of the beacon and the other frame will be swapped, as the driver
will queue the beacon first.

-- 
Greetings Michael.
