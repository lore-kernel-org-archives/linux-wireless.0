Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41106 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750992AbeEPEeJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 00:34:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 16 May 2018 10:04:08 +0530
From: Sriram R <srirrama@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 0/2] nl80211/mac80211 Add support for per-rate rx statistics
In-Reply-To: <1526367603.3255.3.camel@sipsolutions.net>
References: <1526361481-7159-1-git-send-email-srirrama@codeaurora.org>
 <1526367603.3255.3.camel@sipsolutions.net>
Message-ID: <44cd0e995e3caf7b44fcf5676cb57b5a@codeaurora.org> (sfid-20180516_063413_393900_A0D60C03)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-15 12:30, Johannes Berg wrote:
> On Tue, 2018-05-15 at 10:47 +0530, Sriram R wrote:
>> This patchset adds support for the collection and propagating of
>> per-rate, per-station rx statistics when enabled by a userspace 
>> application.
>> 
>> These statistics can be useful in understanding the quality of
>> communication with our peers and in evaluating how different peers
>> are communicating in different MCS/BW/NSS during different time 
>> periods and environment.
> 
> So ... I know that you're aware of my rate statistics collection code
> (at least you should be, I showed it to Jouni), so I think you should
> state why that approach isn't suitable.
> 
Hi Johannes,

  I really liked your approach of publishing the rate statistics only 
when subscribers exist and to push the data when we hit some limits (pkt 
count nearing UINT16_MAX or when 'escape' entries gets used).

But, I wanted to avoid,
	1. Static indexing and memory allocation based on MCS count((8x3)24 
entries for HT and (10x3)30 for VHT within allocated 36 entries) so that 
it's scalable.
	2. Remote chance of dropping a stats(Though it does not have much 
impact)

And to allow,
	1. A 'station dump' kind of interface to dump the complete collected 
stats instead of returning only current snapshot of the stats within 
kernel.

> In particular, I don't like the idea that you implement here of 
> allowing
> unresponsive (or dead) userspace to let the data pile up indefinitely. 
> I
> think we should be sending it out upon reaching a threshold to limit 
> the
> memory consumption in the kernel more reliably.
I agree with you that this does not allow deterministic memory 
allocation within kernel (when rate stats are enabled).

I'll revisit this approach to address your concern and to allow a data 
aggregator kind of usersapce application to collect info and provide 
complete stats.

Also, do you feel it would be good to have both ,i.e complete stats 
collection within kernel(this approach) and dump+clear of stats on 
reaching threshold(your approach) and have one of these two modes 
selected based on the requirement.

Thanks,
Sriram.R
> 
> johannes
