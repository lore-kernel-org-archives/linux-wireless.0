Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55970 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751063AbeEUDq2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 20 May 2018 23:46:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 21 May 2018 09:16:27 +0530
From: Sriram R <srirrama@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 0/2] nl80211/mac80211 Add support for per-rate rx statistics
In-Reply-To: <1526635805.3805.7.camel@sipsolutions.net>
References: <1526361481-7159-1-git-send-email-srirrama@codeaurora.org>
 <1526367603.3255.3.camel@sipsolutions.net>
 <44cd0e995e3caf7b44fcf5676cb57b5a@codeaurora.org>
 <1526635805.3805.7.camel@sipsolutions.net>
Message-ID: <36b1baa590e67bd8eeeca0466006bb83@codeaurora.org> (sfid-20180521_054633_103734_A5CD7AF0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-18 15:00, Johannes Berg wrote:
> On Wed, 2018-05-16 at 10:04 +0530, Sriram R wrote:
> 
>> But, I wanted to avoid,
>> 	1. Static indexing and memory allocation based on MCS count((8x3)24
>> entries for HT and (10x3)30 for VHT within allocated 36 entries) so 
>> that
>> it's scalable.
> 
> Do you expect that the rate control on the other side flips through
> MCSes so fast that this little cache will need to be flushed
> significantly?
Not really Johannes. Dynamic allocation (with indexing based on encoded 
rate)was tried out in this patch
so as to have the rate table independent of MCS Count(so that it works 
without changes
when new mcs's is used in HE).
> 
>> 	2. Remote chance of dropping a stats(Though it does not have much
>> impact)
> 
> Yeah this doesn't seem like a concern either way. How many packets and
> how little time ... :)
Right!
> 
>> And to allow,
>> 	1. A 'station dump' kind of interface to dump the complete collected
>> stats instead of returning only current snapshot of the stats within
>> kernel.
> 
> This *completely* contradict keeping limits on the kernel memory
> consumed, so basically I don't think this is feasible.
Ok,Understood.
> 
>> Also, do you feel it would be good to have both ,i.e complete stats
>> collection within kernel(this approach) and dump+clear of stats on
>> reaching threshold(your approach) and have one of these two modes
>> selected based on the requirement.
> 
> No, honestly, I don't. If an application wants these statistics, then I
> feel that we can impose *some* requirements and not leave it at "let me
> just enable it and have the kernel do all the work for me".
Right, Thanks for the suggestions. I'll send the next revision based on 
your approach
of flushing the rate table(whenever its' requested or when we hit a 
limit)
Thanks and Regards,
Sriram.R
> 
> johannes
