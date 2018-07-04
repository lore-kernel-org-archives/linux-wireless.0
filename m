Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:58552 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753046AbeGDHM7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 03:12:59 -0400
Message-ID: <1530688374.3324.1.camel@sipsolutions.net> (sfid-20180704_091308_089113_DDB9AB51)
Subject: Re: [PATCH] mac80211: don't put null-data frames on the normal TXQ
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        Peter Oh <peter.oh@bowerswilkins.com>,
        linux-wireless@vger.kernel.org
Cc: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Felix Fietkau <nbd@nbd.name>
Date: Wed, 04 Jul 2018 09:12:54 +0200
In-Reply-To: <e6812d98-53b4-a593-fc76-69b6e5f7b0fd@candelatech.com>
References: <20180703124725.30917-1-johannes@sipsolutions.net>
         <e9813f60-5cf5-a4bf-5906-623282319991@bowerswilkins.com>
         <1530661681.4735.51.camel@sipsolutions.net>
         <e6812d98-53b4-a593-fc76-69b6e5f7b0fd@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-07-03 at 21:24 -0700, Ben Greear wrote:

> > ath10k appears to not do aggregation in the host, and I guess the data
> > isn't split over multiple queues so the firmware has to determine/buffer
> > it some other way. No idea how that would work.
> 
> This is my current understanding of ath10k..hope it helps.

[snip]

Thanks Ben. I guess we can't really know whether or not it would be
buggy with (QoS-)NDP, but it shouldn't be since all the frames are
expected (by firmware) to go through the same path anyhow and it's
responsible for putting them together into aggregates. And, unlike Intel
firmware/hardware, it can't necessarily assume that one HW queue
consists only of packets allowed for aggregation.

johannes
