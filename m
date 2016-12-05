Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57540 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752102AbcLER3C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 12:29:02 -0500
Subject: Re: [PATCH] mac80211: Return avg sig, rx, tx values in ethtool stats.
To: Ben Greear <greearb@candelatech.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <1480442872-7358-1-git-send-email-greearb@candelatech.com>
 <1480946891.31788.10.camel@sipsolutions.net>
 <58457D63.2010605@candelatech.com>
 <1480949600.31788.29.camel@sipsolutions.net>
 <5845813C.8070904@candelatech.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <ca0c6cee-6a7c-509c-3d88-801dbca43ddc@nbd.name> (sfid-20161205_182906_204188_07364F01)
Date: Mon, 5 Dec 2016 18:28:52 +0100
MIME-Version: 1.0
In-Reply-To: <5845813C.8070904@candelatech.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-12-05 16:01, Ben Greear wrote:
> 
> 
> On 12/05/2016 06:53 AM, Johannes Berg wrote:
>>
>>> Unless I screwed up, this patch also returns an average.
>>
>> Oops, sorry. I missed the whole mac_div() indirection thing.
>>
>> I'm not super convinced anyway though - all of this data already is
>> available in a much more reliable fashion, even trackable when stations
>> are removed (all data gets sent in the DEL_STATION notification), so
>> adding a crippled way to get the same data seems a bit strange?
> 
> Ethtool stats are easy to program against, and I am already making the
> get-stats call to get other things, so it was a quick tweak to return
> these additional values.  I agree the stats are of somewhat limited worth,
> but the cost to get them is also pretty small code wise :)
You're still adding bloat for everybody for the sake of a little
convenience on your side. I think that's a bad trade-off.
nl80211 is not *that* hard to program against...

I don't really see much point in duplicating an arbitrary subset of
nl80211 information in ethtool.

- Felix
