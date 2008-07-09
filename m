Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.231]:57152 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbYGIO2N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 10:28:13 -0400
Received: by wr-out-0506.google.com with SMTP id 69so2154441wri.5
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 07:28:12 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh beacons
Date: Wed, 9 Jul 2008 16:37:01 +0200
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200807091511.14288.IvDoorn@gmail.com> <200807091600.44437.mb@bu3sch.de> <1215612322.3246.12.camel@johannes.berg>
In-Reply-To: <1215612322.3246.12.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807091637.02090.IvDoorn@gmail.com> (sfid-20080709_162819_415042_52C624D9)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 July 2008, Johannes Berg wrote:
> On Wed, 2008-07-09 at 16:00 +0200, Michael Buesch wrote:
> > On Wednesday 09 July 2008 16:04:50 Ivo van Doorn wrote:
> > > On Wednesday 09 July 2008, Michael Buesch wrote:
> > > > On Wednesday 09 July 2008 15:11:45 Ivo van Doorn wrote:
> > > > > Currently only beacons generated in AP mode have the software
> > > > > sequence number inserted. This means IBSS and Mesh mode are broken
> > > > > for all hardware that require software sequence numbers.
> > > > 
> > > > Does software seq numbering even work at all?
> > > > What about packets that get sent between the driver requested the
> > > > beacon and the driver does actually queue it?
> > > 
> > > For rt2x00 the beacon is requested and queued within interrupt context
> > 
> > Well, another CPU could be in progress of walking down the mac80211 TX code
> > and aquire a sequence number in the meantime before you requested the beacon.
> > However that frame will be blocked by your driver locks, so the two seq
> > numbers of the beacon and the other frame will be swapped, as the driver
> > will queue the beacon first.

If rt2x00 would use a global lock to block all TX and beacons, then yes.
But rt2x00 uses per-queue locking. When a beacon is being updated rt2x00
will still allow regular frames to be queued.

But we can't halt the TX queues for the beacon update either, because
ieee80211_stop_queues() should only be called from within the TX path.

> Indeed, I was wrong.
> 
> I wonder if we should remove the hwseq support completely. It's much
> easier for the driver to do this, especially since we pass a vif pointer
> with driver-private data to all relevant functions and the driver could
> keep the current sequence number in there. Or, just like hwseq would,
> keep a global sequence number?

I think that would be moving the same problem to the driver side,
and I am not really a big fan of the idea to put all queue handling under
1 big lock instead of the per-queue locking which is currently the case.

> How does that affect multi-bss support btw? Do we have to use sw seqno
> for that?

As far as rt2x00 is concerned, all hardware that supports multi-bss also
support HW sequence counters. rt2400pci and rt2500pci are the only ones
requiring SW sequence counters, and they can't do multi-bss.

Ivo
