Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51197 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973Ab2DFQvd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 12:51:33 -0400
Message-ID: <4F7F1F13.8060003@openwrt.org> (sfid-20120406_185137_543698_541968A7)
Date: Fri, 06 Apr 2012 18:51:31 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH 2/2] ath9k:  Add more recv stats.
References: <1333469939-26213-1-git-send-email-greearb@candelatech.com> <4F7C3815.8060902@openwrt.org> <4F7C652D.5050702@candelatech.com>
In-Reply-To: <4F7C652D.5050702@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-04-04 5:13 PM, Ben Greear wrote:
> On 04/04/2012 05:01 AM, Felix Fietkau wrote:
> 
>>> + * @rx_beacons:  No. of beacons received.
>>> + * @rx_frags:  No. of rx-fragements received.
>> Why should the driver keep track of those last two?
> 
> Well, for instance, I often see around 5Mbps of total rx bytes
> (as counted by the NIC), but much less transmitted.  And this is
> with stations sending to stations.
> 
> I was trying to figure out where the extra packets come from.  It
> seems beacons is a lot of it so it seemed worth counting.  And maybe
> fragments count towards that too since there would be more overhead???
> 
> As for rx-frags, just seemed useful to know how many frags
> were received.  My understanding is that this is like receiving
> 1/2 of a packet at a time...so if we wanted to know how many
> real packets the NIC received, we'd need to take frags v/s non-frags
> into account.  The current logic that counts 'all-packets' for
> the rx path is counting individual fragments, I think.
> 
> At least for beacons, as long as they are always passed up
> the stack, I can count them in the mac80211 layer instead if
> you prefer.
When you only need the packet type based counters for debugging stuff,
why not just create a monitor mode interface and count in user space?
I think that would make more sense, since these counters are irrelevant
for most users, and avoiding unnecessary work in the rx path is useful
for performance reasons.

- Felix
