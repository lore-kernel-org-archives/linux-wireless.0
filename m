Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49546 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033838AbdAENS6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2017 08:18:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 05 Jan 2017 18:48:56 +0530
From: Tamizh chelvam <tamizhchelvam@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: c_traja@qti.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH 2/4] cfg80211: Add new NL80211_CMD_SET_BTCOEX_PRIORITY to
 support BTCOEX
In-Reply-To: <1483354130.4596.5.camel@sipsolutions.net>
References: <1478610932-21954-1-git-send-email-c_traja@qti.qualcomm.com>
 <1478610932-21954-3-git-send-email-c_traja@qti.qualcomm.com>
 <1480949353.31788.27.camel@sipsolutions.net>
 <5e5e8971c96293a81e7cb37bcdfbd593@codeaurora.org>
 <1481645351.20412.34.camel@sipsolutions.net>
 <134cc8e58ecb804b6dda0137c4c37be8@codeaurora.org>
 <1481881024.27953.14.camel@sipsolutions.net>
 <ae82112880d55451342e7a6e5a47c33f@codeaurora.org>
 <1483354130.4596.5.camel@sipsolutions.net>
Message-ID: <a5521b4e246de90ed8526891c84a97e5@codeaurora.org> (sfid-20170105_141902_636418_0B02EF30)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-01-02 16:18, Johannes Berg wrote:
>> > 1) does it even make sense to split it out per AC? wouldn't it be
>> > weird
>> > if you supported this only for VO and BK, and not the others, or
>> > something like that?
>> >
>> 
>> It has support for BE, VI, management and beacon frames also.
>> Or do you meant to say like support only for VO and BK?
> 
> I mean - does it make sense for a piece of hardware to support only
> VO/BK, without the others? I don't really see how that would make
> sense, but maybe I'm missing something?
> 
> IOW - why have all these bits rather than just one?

Hardware supports data across all the access categories, this is just 
meant for prioritising the traffic.
f.e, If the fw/target has both wlan and bt traffic queued and if VO is 
set as priority, then wlan VO packets
will be pushed out of the radio first and then the bt traffic.

Here we do not block traffic either from wlan or BT, packets will 
definitely go out of the radio but traffic
arbitration will happen based on the priorities set.

> 
>> > 2) Wouldn't it make more sense to define this in nl80211 and just
>> > pass the bitmap through to userspace? That would save quite a bit
>> > of netlink mangling complexity.
>> >
>> 
>> Please let me know if the below design/thought is fine to you.
>> 
>> iw phyX set btcoex_priority <[vi, vo, be, bk, mgmt, beacon]>
> 
> That seems fine, but I don't see how the iw command line is relevant to
> the question of whether we pass flag attributes or a bitmap??
> 
>> By this command user should give one or more than one frame types
>> for 
>> this btcoex priority,
>> we will parse that in "iw" and send as a single bitmap(less than
>> 0x64)  to the driver?
> 
> Right, and also to nl80211. Why not?

Yes user space to nl80211 and to driver

> 
> johannes
