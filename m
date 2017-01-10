Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57398 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752681AbdAJV1c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jan 2017 16:27:32 -0500
Subject: Re: [PATCH net-next] bridge: multicast to unicast
To: Johannes Berg <johannes@sipsolutions.net>,
        =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20170102193214.31723-1-linus.luessing@c0d3.blue>
 <1483706872.4089.8.camel@sipsolutions.net>
 <8836daaa-9638-4502-d079-fd428595f822@nbd.name>
 <1483710841.12677.1.camel@sipsolutions.net>
 <22fad045-57c6-7789-d19f-f47bd0faf441@fami-braun.de>
 <20170107145516.GE3134@otheros> <1483949336.17582.3.camel@sipsolutions.net>
 <6f5ec9f1-800a-2bc4-2f41-9d803343bb22@fami-braun.de>
 <20170109212345.GA5513@otheros> <20170109133032.221f8669@xeon-e3>
 <20170110041816.GJ5513@otheros> <1484045763.1014.0.camel@sipsolutions.net>
Cc: "M. Braun" <michael-dev@fami-braun.de>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <73f29777-cf95-de99-f7a9-9d82e94c298d@nbd.name> (sfid-20170110_222756_452302_57539330)
Date: Tue, 10 Jan 2017 22:27:25 +0100
MIME-Version: 1.0
In-Reply-To: <1484045763.1014.0.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-01-10 11:56, Johannes Berg wrote:
> On Tue, 2017-01-10 at 05:18 +0100, Linus Lüssing wrote:
>> On Mon, Jan 09, 2017 at 01:30:32PM -0800, Stephen Hemminger wrote:
>> > I wonder if MAC80211 should be doing IGMP snooping and not bridge
>> > in this environment.
>> 
>> In the long term, yes. For now, not quite sure.
> 
> There's no "for now" in the kernel. Code added now will have to be
> maintained essentially forever.
I'm not sure that putting the IGMP snooping code in mac80211 is a good
idea, that would be quite a bit of code duplication.
This implementation works, it's very simple, and it's quite flexible for
a number of use cases.

Is there any remaining objection to merging this in principle (aside
from potential issues with the code)?

- Felix
