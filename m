Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:44593 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbYGETb3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 15:31:29 -0400
Received: by nf-out-0910.google.com with SMTP id d3so483195nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jul 2008 12:31:27 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Rt2400-devel] [PATCH] rt2x00: Fix NULL pointer error =?iso-8859-15?q?in=09adhoc/master?= mode
Date: Sat, 5 Jul 2008 21:37:59 +0200
Cc: Bryan Batten <BryanBatten@sbcglobal.net>, linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200807051511.57995.IvDoorn@gmail.com> <200807052126.16913.IvDoorn@gmail.com> <1215285776.6848.21.camel@johannes.berg>
In-Reply-To: <1215285776.6848.21.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807052137.59412.IvDoorn@gmail.com> (sfid-20080705_213132_323028_DA2DCF73)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 05 July 2008, Johannes Berg wrote:
> On Sat, 2008-07-05 at 21:26 +0200, Ivo van Doorn wrote:
> > On Saturday 05 July 2008, Johannes Berg wrote:
> > > 
> > > > Hmm, in that case I have to fix something in the beacondone handler
> > > > to prevent it requesting a beacon when mac80211 hasn't supplied anything
> > > > yet..
> > > 
> > > I was working in this area... Can you take a quick look at this patch
> > > and let me know what you think?
> > > http://johannes.sipsolutions.net/patches/kernel/all/2008-07-05-18%3a42/mac80211-beacon-revamp.patch
> > 
> > Patch looks good to me, it wouldn't change anything about the above since t2x00 would still
> > call ieee80211_beacon_get() when the beacon wasn't provided by mac80211 yet.
> 
> Oh, of course, I just was writing on the patch and read your mail and
> replied instead of sending you another one :)
> 
> One thing I'm worried about is the sequence numbers, but that bug is
> already there... IIRC you needed software sequence numbers for your
> drivers, but what about the beacons? I haven't _changed_ anything, but
> IBSS beacons seem to not get a software sequence number.

That problem is only in rt2400pci and rt2500pci who raise the beacon interrupt,
all other drivers have the template and auto sequence numbers.
But no sequence numbers for the beacons, I think that will definately cause
problems for those 2 drivers.

But the function ieee80211_include_sequence() is being called from within the
ieee80211_beacon_get() function. Only for the Mesh it doesn't seem to be called.

> > But the flags that mark what has changed is definately a good idea,
> > that will prevent some redundant register writes. :)
> 
> :)
> Only once you use the flags. My patch is intentionally minimal.

Not a problem, with that patch some other beaconing in the rt2x00 code
will change anyway. :)

Ivo
