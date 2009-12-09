Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:48922 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbZLIBsN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 20:48:13 -0500
Message-ID: <4B1F01D4.6020803@openwrt.org>
Date: Wed, 09 Dec 2009 02:48:04 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: 8an@praha12.net
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 4/4] ath5k: Implement mac80211 callback set_coverage
References: <200912061820.26320.8an@praha12.net> <200912062123.13098.8an@praha12.net> <4B1CCF51.2040304@openwrt.org> <200912090216.09816.8an@praha12.net>
In-Reply-To: <200912090216.09816.8an@praha12.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2009-12-09 2:15 AM, Lukáš Turek wrote:
> On 7.12.2009 10:48 you wrote:
>> ACKTimeout is:  aSIFSTime + aSlotTime + aPHY-RX-START-Delay
> 802.11a uses SIFS of 16 µs and 9 µs slot time, that's 25 µs in total. However, 
> the athctrl calculation uses 21 µs ACK timeout for zero distance. And I know 
> the result is correct, as we are using it on 70 links with distances varying 
> between 100m and 8km.
> 
> I don't say the standard is wrong, just that the hardware might start counting 
> at a different moment than the standard assumes.
> 
>> Of course, the distance settting code in iw probably also needs
>> changing, as it needs to accomodate for aAirPropagationTime being the
>> round trip time, not one-way.
> Well, according to my interpretation the aAirPropagationTime is the one-way 
> delay. I think it makes sense when we consider the reason the slots are used 
> in CSMA/CA:
> 
> Station waits a random number of slots. If no other station was transmitting 
> at the beginning of a previous slot, the station starts its own transmit. So 
> the slot time has to be at least the time needed to switch the radio from RX 
> to TX plus the one-way propagation delay, so that every other station can 
> hear the medium is busy on time.
The document also mentions this about the definition of aAirPropagationTime:

Twice the propagation time (in microseconds) for a signal to cross the
maximum distance between the most distant allowable STAs that are slot
synchronized.
If it was only one-way instead of round trip, the ACKTimeout formula
would not make sense, as it would only take one way into account,
however both the data frame and the ack frame need time to reach their
destination.

> Anyway, I think there's only one sure way to determine the correct base ACK 
> timeout for different modes: experiment. It's easy to detect that the ACK 
> timeout is too low - packetloss grows dramatically.
> 
> The main observation is this: ACK timeout does not depend on slot time!
> In retrospect it makes sense: station waits only SIFS before sending ACK, not 
> a single slot.
Some hardware internally calculates the ACK timeout based on the
configured slot time. Broadcom does it this way.
Maybe adjusting the ACK timeout without adjusting the slot time works,
but it'll probably interfere with CSMA.

> The measured values of minimum slot times (with AR5212 and AR5414) are these:
> 
> 802.11a: 21 µs
> 802.11b: 27 µs
> 802.11g: 19 µs
How did you measure it?

> I can't give much explanation, the difference of 6 µs between 11a and 11b 
> might be the difference of SIFS (16µs vs. 10µs). 11g uses 10 µs SIFS too, but 
> with additional 6 µs "signal extension", maybe that's why the value is closer 
> to 11a than 11b. It's all just guessing, though.
> 
> So I propose to use 21 µs in 802.11a mode and 27 µs in 802.11b/g mode (as 
> there might be some 802.11b clients and 6µs won't make much difference).
> What do you think?
I'm guessing that most hardware does have some degree of tolerance for
timing variation. IMHO, if the standard recommends slightly higher but
working values for the same distance, we should use that rather than
experimentally determined limits.

- Felix
