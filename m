Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42448 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757984Ab3BVRDc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 12:03:32 -0500
Message-ID: <5127A4E0.8080101@openwrt.org> (sfid-20130222_180339_101001_9694E44D)
Date: Fri, 22 Feb 2013 18:03:28 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Antonio Quartulli <antonio@open-mesh.com>
CC: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	Marek Lindner <marek@open-mesh.com>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [RFC] design discussion: Collecting information for (non-peer)
 stations
References: <20130215171938.GA4140@pandem0nium> <51279AFA.3000608@openwrt.org> <20130222163643.GB3757@open-mesh.com>
In-Reply-To: <20130222163643.GB3757@open-mesh.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-02-22 5:36 PM, Antonio Quartulli wrote:
> On Fri, Feb 22, 2013 at 08:21:14AM -0800, Felix Fietkau wrote:
>> Hi,
>> 
>> Since this is a rare special case, I think it really does not belong
>> into the mac80211 data path. How about creating a monitor mode device
>> and claiming it from within the kernel in your own module via rx_handler
>> (the same mechanism that the bridge code uses to hook into the data path
>> of a normal net_device). You can extract relevant information from the
>> radiotap headers.
> 
> I think this would increase the complexity given the fact that each and every
> packet needs to be encapsulated into the radiotap header..
I think it's only a slight increase in complexity.

> Then, most of the information that people wants to grab does not appear in
> such header.
What's missing?

> Other than that, by hooking into the mac80211 rx_path, in an early point, packets can
> then be dropped as usual (all those packets not going to this device), while
> with this monitor-like solution all of them have to be carried up to the virtual
> interface.
If the data path overhead here is really that important, then I suggest
adding a new minimalistic data path hook that allows you to inspect the
packets with the rx data in the cb from an external module. The actual
node tracking and reporting should be outside of mac80211 as long as the
reasons for putting it in have not been properly justified.

> Imho this introduces a not negligible complexity that it is better to avoid.
> 
> And what about 802.11s? I don't think this is a good solution for them..

I have yet to see an explanation how this gathering of semi-related data
points even helps 802.11s. I only noticed this bit here by Thomas:
> I can't think of anything that would be specifically useful for
> 802.11s right now, and we can always extend the statistics in the
> future. One case where this might be useful is if the driver has a
> limited number of station slots, the MPM could monitor neighbor
> stations for a more "suitable" peer candidate, but your existing stats
> should cover that.
Is 'limited number of station slots' even a real issue or just an
abstract hypothetical? What are other things in 802.11s that this would
be useful for?

I think before non-peer tracking like this gets shoved into mac80211, a
lot more work needs to be done on justifying the extra code by
describing *specific* use cases that aren't just random data-gathering
for some user space based monitoring thingie.

- Felix
