Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37249 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758137Ab3BGOD0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 09:03:26 -0500
Message-ID: <5113B42A.4020708@openwrt.org> (sfid-20130207_150329_604633_029233B3)
Date: Thu, 07 Feb 2013 15:03:22 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>, chaitanyatk@posedge.com,
	linux-wireless@vger.kernel.org, maheshp@posedge.com
Subject: Re: [RFC] mac80211: Add support for Tx-AMSDU viz debugfs.
References: <7384f4ddc838247a0f467708d66baa8c@posedge.com> <1360225230.8038.1.camel@jlt4.sipsolutions.net> <CABPxzYLnWjxtN_c1sFXpA3Ye9ZNvQgV1dU0z=59j0WqgM-rUpg@mail.gmail.com> <1360228991.8038.3.camel@jlt4.sipsolutions.net> <CABPxzYLwEfzwS9b8dAGjbqT2MLo9FdTKkRwWKDvzxp82ObB-9Q@mail.gmail.com>
In-Reply-To: <CABPxzYLwEfzwS9b8dAGjbqT2MLo9FdTKkRwWKDvzxp82ObB-9Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-02-07 10:30 AM, Krishna Chaitanya wrote:
> On Thu, Feb 7, 2013 at 2:53 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Thu, 2013-02-07 at 14:49 +0530, Krishna Chaitanya wrote:
>>> On Thu, Feb 7, 2013 at 1:50 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>>> > On Thu, 2013-02-07 at 00:01 -0800, chaitanyatk@posedge.com wrote:
>>> >
>>>
>>> > Hmm. I'm not exactly happy with using (one of) the last control flag for
>>> > a pure debug facility.
>>> >
>>> Hmm...initially i tried to add qos header in the debugfs itself but to avoid
>>> code redundancy went with the TX_CTL. But in either case we need some kind
>>> of flag to skip adding the qos header by mac80211 (or) to set the AMSDU
>>> bit in the qos control header.
>>
>> I guess the question is whether we really need this code in the tree at
>> all? It seems like a (relatively) obscure debug feature for which I'm
>> not sure we should touch the TX fastpath?
> 
> AMSDU in itself is rarely used feature in 802.11. So your concern i s
> understandable.
> 
> But the problem is every time we have to test the Rx-AMSDU
> which is mandatory for WFA 802.11n cert, we need to procure a adapter
> which supports it, which is difficult. Thats the scenario we have faced
> which lead us to work on this.With this feature in place we can use
> any opensource adapter and driver for that purpose.
> 
> Again, Its a trade off between stability and usability :-)
How about injecting A-MSDU packets via cooked monitor mode or nl80211
frame tx and thus shifting the debug-only code into userspace?

- Felix

