Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lang.hm ([66.167.227.134]:55605 "EHLO bifrost.lang.hm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751485AbdJFWqq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Oct 2017 18:46:46 -0400
Date: Fri, 6 Oct 2017 15:40:14 -0700 (PDT)
From: David Lang <david@lang.hm>
To: Johannes Berg <johannes@sipsolutions.net>
cc: =?ISO-8859-15?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [Make-wifi-fast] [RFC] mac80211: Add airtime fairness
 accounting
In-Reply-To: <1507310319.19300.28.camel@sipsolutions.net>
Message-ID: <alpine.DEB.2.02.1710061536220.4994@nftneq.ynat.uz> (sfid-20171007_004650_111876_BB03BBED)
References: <20171006115232.28688-1-toke@toke.dk> <1507298832.19300.20.camel@sipsolutions.net> <87lgkoqrhs.fsf@toke.dk> <1507310319.19300.28.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 6 Oct 2017, Johannes Berg wrote:

>> Well, calculating the duration from the rate and size is what ath9k
>> is currently doing, and that has all the information available to do
>> so (I did verify that the airtime was almost identical on the TX and
>> RX side for the same traffic).
>
> It's still iffy - with aggregation you might have a better idea of the
> total airtime, but not really see - in the higher layers - all the
> padding that comes between A-MPDUs etc. I think many drivers could do
> better by exposing the total airtime from the device/firmware, whereas
> exposing _all_ the little details that you need to calculate it post-
> facto will be really difficult, and make the calculation really hard.

perfect is the enemy of good enough :-)

I don't think the intent is to try and be a perfect accounting, if the total 
calculated time ends up being > 100%, it doesn't really matter, what matters is 
the relative behavior of the stations, and while the naive calculation fails to 
properly reward a station that's being more efficient, it is still good enough 
to punish stations using lower bandwidth modes (which is a far larger cause of 
problems)

while it's ideal to have the driver provide the airtime, falling back to a naive 
(but relativly cheap) calculation if a time isn't provided.

David Lang
