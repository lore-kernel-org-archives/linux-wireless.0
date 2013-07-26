Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50650 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab3GZR7r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 13:59:47 -0400
Message-ID: <51F2B90E.2070501@openwrt.org> (sfid-20130726_195950_548860_31E91512)
Date: Fri, 26 Jul 2013 19:59:42 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [WT PATCH 4/6] mac80211: Add per-sdata station hash, and sdata
 hash.
References: <1372546738-25827-1-git-send-email-greearb@candelatech.com>   <1372546738-25827-4-git-send-email-greearb@candelatech.com>   (sfid-20130630_005944_514926_D21D8724) <1373532936.8201.5.camel@jlt4.sipsolutions.net>  <51DECF5B.7040002@candelatech.com> <1374828780.8248.24.camel@jlt4.sipsolutions.net> <51F247C1.3090702@openwrt.org> <51F29439.3050607@candelatech.com> <51F297F8.5090608@openwrt.org> <51F29F1C.9000607@candelatech.com>
In-Reply-To: <51F29F1C.9000607@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-07-26 6:09 PM, Ben Greear wrote:
> On 07/26/2013 08:38 AM, Felix Fietkau wrote:
>> The global hash (with added vif-addr mixing) not only completely fixes
>> the many-STA-vif case, also has some other advantages compared to the
>> per-sdata hash:
>> - Lookup is easier in setups with multiple AP VLANs
>> - Better cache footprint (especially important for small embedded devices).
>> - You don't need a separate sdata lookup before the sta lookup.
>>
>> I'm not convinced that keeping separate hashes is cleaner. Especially in
>> the AP_VLAN case, ownership is not clear in any way, since there's some
>> overlap between multiple sdata entities (belonging to the same BSS).
> If someone wants to post such a patch, we can run it through our test
> rigs, but I have little time or interest for re-doing the
> hashing code again at this time.  If your approach does fix the performance
> issues we saw, then I'll be more than happy to drop my patch and use
> your method.
I don't have time to create such a patch myself at this point. I just
want to make sure that changes you post don't negatively affect small
embedded devices - and this is where the per-sdata hashing could be
problematic in my opinion.

- Felix
