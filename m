Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:34535 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaAIQXb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 11:23:31 -0500
Received: by mail-wi0-f180.google.com with SMTP id hn9so167273wib.13
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jan 2014 08:23:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140107162655.GB9092@w1.fi>
References: <20140106075126.GA31046@w1.fi> <1389110387.4645.26.camel@jlt4.sipsolutions.net>
 <20140107162655.GB9092@w1.fi>
From: Laudin Alessandro Molina T <laudin.molina@gmail.com>
Date: Thu, 9 Jan 2014 17:23:00 +0100
Message-ID: <CACX7s6MHvzeBf1m4K3t=ZBS5g_WJGdse9S-sOLiH+X22mgwUKA@mail.gmail.com> (sfid-20140109_172335_398801_7F95F4AA)
Subject: Re: [RFC 2/3] cfg80211: MinChannelTime and MaxChannelTime for scan requests
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm an student and I'm interested in the 802.11 scanning. I've
investigating over this subject over the last months. I'll take the
opportunity to share some points.

2014/1/7 Jouni Malinen <j@w1.fi>:
> On Tue, Jan 07, 2014 at 04:59:47PM +0100, Johannes Berg wrote:
>> On Mon, 2014-01-06 at 09:51 +0200, Jouni Malinen wrote:
>> > This adds new nl80211 attributes to allow MinChannelTime and
>> > MaxChannelTime to be specified for scan requests. The parameters can be
>> > used to control the amount of time spent on each channel during a scan
>> > as specified in the IEEE Std 802.11-2012 MLME-SCAN.request() primitive.
>>
>> What are the specific use cases for this? Our driver is likely to muck
>> around with these in the future, possibly depending on traffic levels
>> etc., so I wonder what this addresses and whether it can be unified in
>> some way?
>
> I don't have any specific use case in mind. These are parameters
> included in the standard and there are various new use cases coming up
> for IEEE 802.11 scanning and those could potentially be able to use this
> type of parameters. Similarly, I'd actually like to see quite a bit
> additional flexibility in scanning operations like partial scan reports
> (event notification of updated BSSes per channel etc.) and aborting
> scans, etc., that has also come up in the past.

As M. Stewart said in a previous mail, there are some scenarios where
the scanning algorithms depends on the application priorities, to add
another examples:

- A mobile station is moving (for example someone is walking on the
street with some available community networks) so, to take advantage
of an eventual connection the scanning needs to be very fast, then it
might need a list of candidate APs ASAP, no matter if the list in
incomplete. In this scenario the values for Min/MaxChannelTime should
be short enough to accomplish time restrictions.

- On the other side, the same station could arrive to one specific
place (for example an office or home) so the user might prefer the
full AP list, so it could choose to connect to the best one.

>
>> Would you expect these to always be specified, to the point where our
>> driver no longer has any flexibility in adjusting things internally?
>

According to our studies there are not one pair of values that will be
optimum in all the scenarios, these values depends on the network
deployment and on the user (and the applications it is using). To get
things more complicated, the optimum values might change from channel
to channel. In summary, I would say that flexibility on the user-side
it's really important.

[...]

>> If you specify a very long min_chan_time, that's unlikely to please
>> drivers. Especially if multi-channel mode is implemented, maybe in
>> conjunction with operating as a GO or a client that wants to hear DTIM
>> beacons, this might become very complicated.
>
> Agreed. I was thinking of adding some limits on how large a value could
> be set, but could not come up with any specific, justifiable value. (And
> the standard was not very helpful either with the "N/A" as the valid
> range ;-).

We have seen Probe Responses arriving after 300ms, although in a city
center spontaneous deployment ~90% of the Probe Responses arrive
before 50ms. Anyway, I would only suggest to check for positive
values.

Also, the values for max_chan_time does not have to be greater than
min_chan_time (notice that in the standard max_chan_time starts after
min_chan_time expires). It could be possible to have something like
min_chan_time=8TU and min_chan_time=2TU.

[...]

Another questions:

- What about IEEE80211_PROBE_DELAY (Probe Delay)? Why won't allow to
adjust this value? I'm not sure about the definition/use of this
delay. Could any of you help me with an explanation of this?

- What would be a reasonable value? In an IEEE discussion I found a
reference to 0.1ms but in the kernel it takes HZ/33 (~30ms), that is a
lot bigger.


Best regards,
-- 
Laudin Alessandro Molina
GPG fingerprint = DAE4 8A7F D5EE 48EE 60C7  F7BC 628F 18CA E307 2B89
