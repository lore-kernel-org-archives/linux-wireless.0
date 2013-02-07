Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36324 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758208Ab3BGPTA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 10:19:00 -0500
Message-ID: <5113C5E0.5050509@openwrt.org> (sfid-20130207_161905_412808_021A3539)
Date: Thu, 07 Feb 2013 16:18:56 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>, chaitanyatk@posedge.com,
	linux-wireless@vger.kernel.org, maheshp@posedge.com
Subject: Re: [RFC] mac80211: Add support for Tx-AMSDU viz debugfs.
References: <7384f4ddc838247a0f467708d66baa8c@posedge.com> <1360225230.8038.1.camel@jlt4.sipsolutions.net> <CABPxzYLnWjxtN_c1sFXpA3Ye9ZNvQgV1dU0z=59j0WqgM-rUpg@mail.gmail.com> <1360228991.8038.3.camel@jlt4.sipsolutions.net> <CABPxzYLwEfzwS9b8dAGjbqT2MLo9FdTKkRwWKDvzxp82ObB-9Q@mail.gmail.com> <5113B42A.4020708@openwrt.org> <1360246653.8038.9.camel@jlt4.sipsolutions.net> <CABPxzYJG3xP0_Wy-1HMjWx-YoHp5WmhrfBH5vBvOJ4WQ_7Nzrg@mail.gmail.com>
In-Reply-To: <CABPxzYJG3xP0_Wy-1HMjWx-YoHp5WmhrfBH5vBvOJ4WQ_7Nzrg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-02-07 3:57 PM, Krishna Chaitanya wrote:
> On Thu, Feb 7, 2013 at 6:17 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Thu, 2013-02-07 at 15:03 +0100, Felix Fietkau wrote:
>>
>>> > But the problem is every time we have to test the Rx-AMSDU
>>> > which is mandatory for WFA 802.11n cert, we need to procure a adapter
>>> > which supports it, which is difficult. Thats the scenario we have faced
>>> > which lead us to work on this.With this feature in place we can use
>>> > any opensource adapter and driver for that purpose.
>>> >
>>> > Again, Its a trade off between stability and usability :-)
>>> How about injecting A-MSDU packets via cooked monitor mode or nl80211
>>> frame tx and thus shifting the debug-only code into userspace?
>>
>> nl80211 won't work -- no support for data frames (and I'd rather not add
>> it), but monitor mode (why cooked?) seems fine.
> 
> But whats the use of sending an AMSDU if we are not connected?
> First check in the code is to check for a connection.
I mentioned cooked monitor because putting the hw in monitor mode may
not always be desirable, and cooked monitor bypasses that.

You can send the AMSDU while you're connected. mac80211 treats injected
frames that match the address of a local interface similar to regular tx
on that interface, except for bypassing the normal 802.11 header
encapsulation, so it should work for your tests.

- Felix
