Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbbKWPGR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 10:06:17 -0500
Subject: Re: [RFC v5 4/5] mac80211: use Kconfig counters to elide unnecessary
 code
To: Johannes Berg <johannes@sipsolutions.net>
References: <1447365652-23716-1-git-send-email-johannes@sipsolutions.net>
 <1447365652-23716-5-git-send-email-johannes@sipsolutions.net>
 <5653283C.8050207@suse.com> <1448290682.5792.6.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
From: Michal Marek <mmarek@suse.com>
Message-ID: <56532B67.5080508@suse.com> (sfid-20151123_160620_841452_81D37DD1)
Date: Mon, 23 Nov 2015 16:06:15 +0100
MIME-Version: 1.0
In-Reply-To: <1448290682.5792.6.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-11-23 15:58, Johannes Berg wrote:
> On Mon, 2015-11-23 at 15:52 +0100, Michal Marek wrote:
>>  
>> So one issue with this logic is that it is not safe to build and use an
>> out-of-tree mac80211 driver after the kernel has been built. Also, any
>> new driver needs the 'count MAC80211_NUM_DRIVERS' annotation, but there
>> is the runtime check to catch omissions. 
> 
> Indeed, the runtime check will catch both of these.

Will it catch the former case? The driver built out of has not way to
select or increment any of the CONFIG_MAC80211_* options.


>> Since this is targeting users
>> of very specific configs, how about an opt-in scheme à la
>>
>> - User has to select CONFIG_MAC80211_SINGLE_DRIVER, the help text
>>   explains the caveats and lists drivers known to work in such mode.
>> - mac80211 uses the Kconfig-defined constants + dynamic bits iff
>>   CONFIG_MAC80211_SINGLE_DRIVER=y, otherwise it behaves as before.
>> - Some build- or compile-time check ensuring that we are not building /
>>   loading multiple drivers with CONFIG_MAC80211_SINGLE_DRIVER=y.
> 
> That'd be possible - but I know of at least one potential use case that
> would like to have two similar drivers, with similar flags: some
> routers ship with ath9k hardware for the 2.4 GHz band and ath10k
> hardware for the 5 GHz band. Doing "single-driver" and avoiding the
> counters would not allow those to have any kind of optimisation, and
> such low-power platforms are the ones who'd most likely benefit from
> it...

I see.


> I'd actually Cc'ed you out of confusion, thinking you were maintaining
> kconfig. I guess I really should've Cc'ed Yann instead.

That's fine. It is a very interesting problem :-).

Michal

