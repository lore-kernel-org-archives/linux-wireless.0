Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42851 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab0IOKQn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 06:16:43 -0400
Subject: Re: RFC:  mac80211/ath9k:  allow scanning single channel if other
 VIF is associated.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4C9059DC.7060009@candelatech.com>
References: <4C8EB03D.7070808@candelatech.com>
	 <20100915030316.GB30253@jm.kir.nu>  <4C9059DC.7060009@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 12:16:36 +0200
Message-ID: <1284545796.3842.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-14 at 22:30 -0700, Ben Greear wrote:

> > If I understood the change correctly, it would prevent running full
> > scans when in associated state. That does not sound reasonable behavior
> > and scanning should not cause an association to be lost. Did I miss
> > something or what exactly is this trying to do?
> 
> That's pretty much what I'm trying to do.  We had similar code in
> our 2.6.31 kernel with ath5k. Imagine getting 50 virtual stations
> started with WPA and all of them trying to scan all channels at once!

They can't ... cfg80211 limits it to one scan at a time per hardware ...

> I think for the multi-VIF scenario, it should scan the single associated
> channel by default, but it would be nice to allow full scans on demand.

Go change your userspace then to request only the single channel scan.

> (I would very much like to work with standard wpa_supplicant, but if hacking it
> is the only way, then I can attempt that.)

Yes, I don't see how we can reasonably work around this in the kernel.

> > If you want to limit scans a single channel in some special use cases,
> > you should be able to do that in user space, too, at least for the
> > initial scan before connection. As a future optimization, we should
> > somehow be able to merge scan requests from multiple VIFs into a single
> > one, i.e., share the results from a single scan to multiple VIFs..
> 
> Merging would be nice.  Maybe store the results in the global hardware/phy
> structs and just return that to user-space so long as it's relatively fresh?

That's what we do, unless userspace requests a new scan.

johannes

