Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:43867 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbYIVW4K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 18:56:10 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1515840fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 22 Sep 2008 15:56:09 -0700 (PDT)
Message-ID: <1ba2fa240809221556j19800873ldf396cfc1980b92a@mail.gmail.com> (sfid-20080923_005614_999960_E6749284)
Date: Tue, 23 Sep 2008 01:56:08 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Progress on aggregation
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1222121467.3023.89.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080922174103.GF6048@tesla>
	 <43e72e890809221233l4dc446e9hdf71fc94270020dc@mail.gmail.com>
	 <1222121467.3023.89.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 23, 2008 at 1:11 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-09-22 at 12:33 -0700, Luis R. Rodriguez wrote:
>> On Mon, Sep 22, 2008 at 10:41 AM, Luis R. Rodriguez
>> <lrodriguez@atheros.com> wrote:
>> > Just a quick note on the progress of aggregation. It works but we still
>> > need to hanld the rtnl_lock() in a sane way. Johannes we proposing we
>> > use a workqueue for this.
>> >
>> > * iwl4965 has been tested to work
>> > * ath9k *does* xmit aggregate frames but throughput is low
>> >
>> > Since ath9k still needs some work we are looking into it.
>> > Tomas, have you had a chance to consider the workqueue usage
>> > for the rtnl_lock()? I figure to leave that to you as we
>> > are still looking into the throughput issues with aggreation with
>> > ath9k.
>>
>> Also, we currently handle aggregation buffering internally in our
>> driver so the whole amdpu_queue stuff is not required for us as we
>> don't have internal aggregation schedulers in hardware. For now we'll
>> use it though as we just want to get it working and for 2.6.27 we have
>> not alternative. For us, what will the ampdu_queues represent then? We
>> don't exactly have a limit on this except for the standard limitations
>> of 16 TIDs per station so what do you recommend to set this to?
>
> You've only enabled STA mode (and maybe IBSS but there it rarely
> matters) so anything like 8-16 would probably be fine.
>
TIDs 8-16 are reserved for HCCA and nobody implements this. In
addition you probably won't aggregate voice TIDs as aggregation impose
great delay, so 5 is only reasonable numbers for aggregation.
Aggregation for IBSS is not in the spec, it's rather cumbersome to support.

Anyhow in theory you need #supported sta * 8/16 queues, where in STA
mode it's 1 * 16 = 16 in AP mode it can goes to hundreds queues. In
practice you cannot push so much traffic on one channel.  I don't have
any statistics in hand what is maximal effective number of concurrent
aggregations on the air but I guess is up to 10.

I've did some first implementation with work item (start ba session)
but it start to look more massive change....I will send the rfc

Tomas
