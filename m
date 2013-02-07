Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:50577 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab3BGO51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 09:57:27 -0500
Received: by mail-wg0-f47.google.com with SMTP id dr13so2126467wgb.14
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2013 06:57:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1360246653.8038.9.camel@jlt4.sipsolutions.net>
References: <7384f4ddc838247a0f467708d66baa8c@posedge.com> <1360225230.8038.1.camel@jlt4.sipsolutions.net>
 <CABPxzYLnWjxtN_c1sFXpA3Ye9ZNvQgV1dU0z=59j0WqgM-rUpg@mail.gmail.com>
 <1360228991.8038.3.camel@jlt4.sipsolutions.net> <CABPxzYLwEfzwS9b8dAGjbqT2MLo9FdTKkRwWKDvzxp82ObB-9Q@mail.gmail.com>
 <5113B42A.4020708@openwrt.org> <1360246653.8038.9.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 7 Feb 2013 06:57:05 -0800
Message-ID: <CABPxzYJG3xP0_Wy-1HMjWx-YoHp5WmhrfBH5vBvOJ4WQ_7Nzrg@mail.gmail.com> (sfid-20130207_155730_827163_D9FDB1A1)
Subject: Re: [RFC] mac80211: Add support for Tx-AMSDU viz debugfs.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>, chaitanyatk@posedge.com,
	linux-wireless@vger.kernel.org, maheshp@posedge.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 7, 2013 at 6:17 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2013-02-07 at 15:03 +0100, Felix Fietkau wrote:
>
>> > But the problem is every time we have to test the Rx-AMSDU
>> > which is mandatory for WFA 802.11n cert, we need to procure a adapter
>> > which supports it, which is difficult. Thats the scenario we have faced
>> > which lead us to work on this.With this feature in place we can use
>> > any opensource adapter and driver for that purpose.
>> >
>> > Again, Its a trade off between stability and usability :-)
>> How about injecting A-MSDU packets via cooked monitor mode or nl80211
>> frame tx and thus shifting the debug-only code into userspace?
>
> nl80211 won't work -- no support for data frames (and I'd rather not add
> it), but monitor mode (why cooked?) seems fine.

But whats the use of sending an AMSDU if we are not connected?
First check in the code is to check for a connection.
