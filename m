Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39638 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab3DXQAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 12:00:36 -0400
Message-ID: <51780198.4060602@candelatech.com> (sfid-20130424_180040_182276_6C7D49A4)
Date: Wed, 24 Apr 2013 09:00:24 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Question on ieee80211_tx_status
References: <5176DD33.9000100@candelatech.com>  (sfid-20130423_233115_840840_D02CAECE) <1366801969.21854.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1366801969.21854.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/24/2013 04:12 AM, Johannes Berg wrote:
> On Tue, 2013-04-23 at 12:12 -0700, Ben Greear wrote:
>> It appears that ieee80211_tx_status also scales poorly
>> when using large numbers of virtual stations connected
>> to a single AP, due to for_each_sta_info(local, hdr->addr1, sta, tmp)...
>>
>> I'm going to try using the vif-hashing to make this faster,
>> but first a question:
>>
>> Since it matches on MAC addresses, should it
>> just return at the bottom of the loop since it has
>> found a match, and MACs are supposed to be unique?
>>
>> 	for_each_sta_info(local, hdr->addr1, sta, tmp) {
>> 		/* skip wrong virtual interface */
>> 		if (!ether_addr_equal(hdr->addr2, sta->sdata->vif.addr))
>> 			continue;
>> ...
>
> I think that'd be mostly safe, since we don't allow the same station to
> be added to multiple VLANs. However, I'm not entirely sure if it really
> is safe in the case of WDS interfaces.

Would you ever need to send an ACK multiple times?  If so, then
my approach would be wrong, but if you never should, then my
approach would be more right than the current code.

It would seem to me that you should never ack a packet more
than once, but I don't actually know enough about the protocol
to know if that is a valid assumption.

>> If so, that would be a good improvement since the hash can easily
>> be turned into a linear search even in AP mode (without all of
>> my virtual-station scenarios)...
>
> I don't really see how the hash could be linear? When the low byte of
> MAC addresses is the same, but otherwise?

Sure, just randomize octed 3 and 4 and leave octet 5 the
same.  Easily done in certain test tools :)

The new RFC patch I posted uses a better hash, and fixes all
of the linear walk issues that show up in 'perf top' with
300 stations on a relatively weak Atom system...

Also, to deal with cases where sdata may have duplicate macs,
I just added a for_each_sdata() macro that should quickly
walk a hash list of sdata objects and get the same behaviour
efficiently (assuming that you don't have large amounts of
sdata with the same MAC, but that seems unlikely to happen).

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

