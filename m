Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:39428 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbYHLPnM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2008 11:43:12 -0400
Date: Tue, 12 Aug 2008 18:42:23 +0300
From: Jouni Malinen <j@w1.fi>
To: Helmut Schaa <hschaa@suse.de>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
Subject: Re: Pondering: how to improve mac80211 roaming ...
Message-ID: <20080812154223.GE4981@jm.kir.nu> (sfid-20080812_174316_009634_83474186)
References: <200808120838.52888.hs4233@mail.mn-solutions.de> <20080812082246.GD4981@jm.kir.nu> <200808121440.24098.hschaa@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200808121440.24098.hschaa@suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 12, 2008 at 02:40:23PM +0200, Helmut Schaa wrote:

> JFYI I already started to rework the existing scan code in mac80211
> (software scan) to do something like background scanning:
> 
> 1) notify current AP about leaving the channel
> 2) scan one channel

It might be useful to leave this "one" as a parameter to allow easy
experiments with scanning more than one channel at a time to reduce
latency. Ideally, this--along the interval for background scans--could
be something that is dynamically changed based on the expected traffic
pattern. Whenever there is lot of data traffic being (mostly
successfully) transmitted, it would be beneficial not to jump to other
channels as frequently or for as long a time. If there has not been any
data transmission for some time, it may be more acceptable to scan more
frequently and to remain away from the operational channel for longer
periods of time. Though, we should also keep in mind that background
scans are going to increase power consumption on otherwise inactive
situation, so setting a suitable policy for this can get quite complex.

If we can somehow figure out whether there is periodic need for some
traffic (e.g., VoIP), it would also be nice to be able to schedule the
background scans to happen when there is no expected packet being sent
or received at the time. Obviously, this gets much more complex, so this
is not really something that would need to be included in the first
version ;-). Anyway, it would be useful to keep in mind that there may
be needs for making the background scan parameters change dynamically
and there is need to be able to configure a suitable policy from user
space.

-- 
Jouni Malinen                                            PGP id EFC895FA
