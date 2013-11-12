Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33800 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab3KLWWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 17:22:52 -0500
Message-ID: <5282AA36.2070703@candelatech.com> (sfid-20131112_232256_082474_FE142153)
Date: Tue, 12 Nov 2013 14:22:46 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Association often fails first time when roaming with 802.11r.
References: <52828324.3060105@candelatech.com> <1384285594.14301.10.camel@jlt4.sipsolutions.net> <52828A27.1040103@candelatech.com> <1384287024.14301.11.camel@jlt4.sipsolutions.net> <52829163.5010201@candelatech.com>
In-Reply-To: <52829163.5010201@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/2013 12:36 PM, Ben Greear wrote:
> On 11/12/2013 12:10 PM, Johannes Berg wrote:
>> On Tue, 2013-11-12 at 12:05 -0800, Ben Greear wrote:
>>> A more correct roam also takes about 150ms, but at least not because of the
>>> error in my previous email.  Seems it takes it 100+ms to go if-up after
>>> the assoc-request is sent.  I'll go dig into that further.
>>
>> The interface is already up (has to be to authenticate), the event you
>> get at that point (just after the ~110ms delay) is for LOWER_UP really -
>> which means carrier_on() in the kernel I believe. At that point you'd
>> need kernel level tracing or messages to investigate.
>>
>> Maybe something is waiting for a beacon there?
> 
> At least in the case I just looked at, it seems there were lots and lots
> of retries of the re-assoc request from station to AP, and AP finally answers
> after ~100ms.  We had the cisco's configured for OTA, so possibly that was
> part of the issue.
> 
> On a second test, with cisco configured for non-OTA, it seems the response
> comes back within 3ms, and there are no retransmits.
> 
> Looking at sniffer trace makes everything look nice at first, but if I compare the
> actual packet timestamps with supplicant log time-stamps, it seems that it took
> 109ms from the time that supplicant sent the packet until the sniffer saw it.
> I didn't see any other retransmits, and ACKs seem to show up normally in
> the sniff.

I think it must have something to do with the ath9k driver resetting
itself or maybe going to sleep when it notices no other stations are associated.  If I add
a second station (in this case, I am roaming between two APs on the
same channel), then the roam time is reliably < 50ms, usually around 40ms.

When I have a single station, I see kernel logs such as this
below (I added timestamps to logging messages).

I'm dropping hostapd mailing from any further replies, as this does not
seem to be an issue with it's logic...

Nov 12 14:07:29 localhost kernel: sta1: authenticate with dc:a5:f4:ff:4f:ae at: 1384294049.787434
Nov 12 14:07:29 localhost kernel: sta1: send auth to dc:a5:f4:ff:4f:ae (try 1/3) at: 1384294049.801891
Nov 12 14:07:29 localhost kernel: cfg80211: Calling CRDA to update world regulatory domain
Nov 12 14:07:29 localhost kernel: sta1: authenticated at: 1384294049.809826
Nov 12 14:07:29 localhost kernel: sta1: associate with dc:a5:f4:ff:4f:ae (try 1/3), at: 1384294049.817346
Nov 12 14:07:29 localhost kernel: cfg80211: World regulatory domain updated:
Nov 12 14:07:29 localhost kernel: cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Nov 12 14:07:29 localhost kernel: cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 12 14:07:29 localhost kernel: cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 12 14:07:29 localhost kernel: cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Nov 12 14:07:29 localhost kernel: cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 12 14:07:29 localhost kernel: cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 12 14:07:29 localhost kernel: cfg80211: Calling CRDA for country: US
Nov 12 14:07:29 localhost kernel: cfg80211: Regulatory domain changed to country: US
Nov 12 14:07:29 localhost kernel: cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Nov 12 14:07:29 localhost kernel: cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Nov 12 14:07:29 localhost kernel: cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Nov 12 14:07:29 localhost kernel: cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 12 14:07:29 localhost kernel: cfg80211:   (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 12 14:07:29 localhost kernel: cfg80211:   (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 12 14:07:29 localhost kernel: cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Nov 12 14:07:29 localhost kernel: cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
Nov 12 14:07:29 localhost kernel: sta1: RX AssocResp from dc:a5:f4:ff:4f:ae (capab=0x11 status=0 aid=1) at: 1384294049.929579
Nov 12 14:07:29 localhost kernel: sta1: associated


Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

