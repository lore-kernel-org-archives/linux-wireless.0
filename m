Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:40071 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab3BGJae (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 04:30:34 -0500
Received: by mail-wi0-f177.google.com with SMTP id hm14so2601412wib.4
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2013 01:30:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1360228991.8038.3.camel@jlt4.sipsolutions.net>
References: <7384f4ddc838247a0f467708d66baa8c@posedge.com> <1360225230.8038.1.camel@jlt4.sipsolutions.net>
 <CABPxzYLnWjxtN_c1sFXpA3Ye9ZNvQgV1dU0z=59j0WqgM-rUpg@mail.gmail.com> <1360228991.8038.3.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 7 Feb 2013 15:00:11 +0530
Message-ID: <CABPxzYLwEfzwS9b8dAGjbqT2MLo9FdTKkRwWKDvzxp82ObB-9Q@mail.gmail.com> (sfid-20130207_103040_764952_0CCB868E)
Subject: Re: [RFC] mac80211: Add support for Tx-AMSDU viz debugfs.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: chaitanyatk@posedge.com, linux-wireless@vger.kernel.org,
	maheshp@posedge.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 7, 2013 at 2:53 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2013-02-07 at 14:49 +0530, Krishna Chaitanya wrote:
>> On Thu, Feb 7, 2013 at 1:50 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > On Thu, 2013-02-07 at 00:01 -0800, chaitanyatk@posedge.com wrote:
>> >
>>
>> > Hmm. I'm not exactly happy with using (one of) the last control flag for
>> > a pure debug facility.
>> >
>> Hmm...initially i tried to add qos header in the debugfs itself but to avoid
>> code redundancy went with the TX_CTL. But in either case we need some kind
>> of flag to skip adding the qos header by mac80211 (or) to set the AMSDU
>> bit in the qos control header.
>
> I guess the question is whether we really need this code in the tree at
> all? It seems like a (relatively) obscure debug feature for which I'm
> not sure we should touch the TX fastpath?

AMSDU in itself is rarely used feature in 802.11. So your concern i s
understandable.

But the problem is every time we have to test the Rx-AMSDU
which is mandatory for WFA 802.11n cert, we need to procure a adapter
which supports it, which is difficult. Thats the scenario we have faced
which lead us to work on this.With this feature in place we can use
any opensource adapter and driver for that purpose.

Again, Its a trade off between stability and usability :-)
