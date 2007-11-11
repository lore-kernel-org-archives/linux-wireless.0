Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:56570 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbXKKDAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Nov 2007 22:00:08 -0500
Date: Sat, 10 Nov 2007 18:58:08 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
Subject: Re: [RFC] b43: multiple MAC addresses support
Message-ID: <20071111025808.GK4031@jm.kir.nu> (sfid-20071111_030019_018886_E3367C3F)
References: <1194572631.4793.64.camel@johannes.berg> <1194605550.4793.93.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1194605550.4793.93.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 09, 2007 at 11:52:30AM +0100, Johannes Berg wrote:

> Something I'm not clear on right now is the timing of it all. If there
> are say two BSSes, the driver can simply program the hardware to half
> the beacon period and then the beacons will alternate. But if there are
> seven BSSes, the beacon period might not be divisible by seven so timing
> errors will happen and, worse yet, accumulate. Does hostapd somehow
> account for this? Or should the beaconing work completely differently,
> for example with all N beacons sent in a burst?

You could always modify the beacon period to a suitable number that
would be divisible by whatever number of BSSes there are and/or add
empty slot to move from, say, 7 to 8, and just not send a beacon at some
of the slots. Sending a burst of all beacons at the same time is also a
valid option up to a certain limit on how long a time would be allocated
for this. However, this may have some timing issues when there are
multiple power save buffered broadcast/multicast frames waiting to be
sent out. In general, it would be good to try to send the beacon frames
as close to their correct time as possible to allow power saving
stations to remain asleep most of the time. Some low-level operation
would also need to make sure the beacon timestamp is correct if the
frame gets delayed due to other frames.

I think it would be perfectly fine to try to simply the configuration
and implementation by requiring all BSSes to use the same beacon
interval and allow small changes in the interval, if needed. hostapd
does not have code for this type of modifications. I've done some
experiments with configuring the hardware to use beacon interval divided
by number of BSSes, but ended up using burst of beacon frames instead
(and all BSSes were forced to use the same beacon interval).

-- 
Jouni Malinen                                            PGP id EFC895FA
