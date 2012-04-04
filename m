Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54702 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab2DDPN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2012 11:13:58 -0400
Message-ID: <4F7C652D.5050702@candelatech.com> (sfid-20120404_171401_564403_309E2CC2)
Date: Wed, 04 Apr 2012 08:13:49 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH 2/2] ath9k:  Add more recv stats.
References: <1333469939-26213-1-git-send-email-greearb@candelatech.com> <4F7C3815.8060902@openwrt.org>
In-Reply-To: <4F7C3815.8060902@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/04/2012 05:01 AM, Felix Fietkau wrote:

>> + * @rx_beacons:  No. of beacons received.
>> + * @rx_frags:  No. of rx-fragements received.
> Why should the driver keep track of those last two?

Well, for instance, I often see around 5Mbps of total rx bytes
(as counted by the NIC), but much less transmitted.  And this is
with stations sending to stations.

I was trying to figure out where the extra packets come from.  It
seems beacons is a lot of it so it seemed worth counting.  And maybe
fragments count towards that too since there would be more overhead???

As for rx-frags, just seemed useful to know how many frags
were received.  My understanding is that this is like receiving
1/2 of a packet at a time...so if we wanted to know how many
real packets the NIC received, we'd need to take frags v/s non-frags
into account.  The current logic that counts 'all-packets' for
the rx path is counting individual fragments, I think.

At least for beacons, as long as they are always passed up
the stack, I can count them in the mac80211 layer instead if
you prefer.

Thanks,
Ben

>
> - Felix


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
