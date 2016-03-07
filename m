Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:35511 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbcCGQ0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 11:26:11 -0500
MIME-Version: 1.0
In-Reply-To: <56DD99AA.8050403@openwrt.org>
References: <1456492163-11437-1-git-send-email-michal.kazior@tieto.com>
 <E1abfnE-0000VS-00@www.xplot.org> <CA+BoTQk6J7kgdie9aX24MB+8PxN3oFUh0eVdmVrdyptW5RxQXg@mail.gmail.com>
 <CAPp0ZBYP9UzUTtPz=vivUQkE2FiGSsJjDaecQtPuK8y_d3ccqA@mail.gmail.com> <56DD99AA.8050403@openwrt.org>
From: Avery Pennarun <apenwarr@gmail.com>
Date: Mon, 7 Mar 2016 11:25:50 -0500
Message-ID: <CAHqTa-2-uZ0PUdwp33E588EU2a7T6KnTYs8RWfNDEzgOLseG9g@mail.gmail.com> (sfid-20160307_172619_185901_F79EC8BD)
Subject: Re: [RFC/RFT] mac80211: implement fq_codel for software queuing
To: Felix Fietkau <nbd@openwrt.org>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	Tim Shepard <shep@alum.mit.edu>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Network Development <netdev@vger.kernel.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Dave Taht <dave.taht@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Andrew Mcgregor <andrewmcgr@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 7, 2016 at 10:09 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2016-03-07 15:05, Avery Pennarun wrote:
>> On Fri, Mar 4, 2016 at 1:32 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
>>> On 4 March 2016 at 03:48, Tim Shepard <shep@alum.mit.edu> wrote:
>>> [...]
>>>> (I am interested in knowing what other mac80211 drivers have been
>>>>  modified to use the mac80211 intermediate software queues.   I know
>>>>  Michal mentioned he has patches for ath10k that are not yet released,
>>>>  and I know Felix is finishing up the mt76 driver which uses them.)
>>>
>>> Patches for ath10k are under review since quite some time now (but are
>>> not merged yet). The latest re-spin is:
>>>
>>>   http://lists.infradead.org/pipermail/ath10k/2016-March/006923.html
>>
>> Hi all, on Friday I had a chance to experiment with some of these
>> patches, specifically Tim's ath9k patch (to use intermediate queues),
>> plus MIchal's patch to use fq_codel with the intermediate queues.  I
>> didn't attempt any fine tuning; I just slapped them together to see
>> what happens.  (I tried applying Michal's ath10k patches too, but got
>> stuck since they seem to be applied against the upstream v4.4 kernel
>> and didn't merge cleanly with the latest mac80211 branch.  Maybe I was
>> doing something wrong.)
>>
>> Test setup:
>>    AP (ath9k) -> 2x2 strong signal -> STA1 (mwifiex)
>>         -> attenuator (-40 dB) -> 1x1 weak signal  -> STA2 (mwifiex)
>>
>> STA2 generally gets modulation levels around MCS0-2 and STA1 usually
>> gets something like MCS12-15.
>>
>> With or without this patch, results with TCP iperf were fishy - I
>> think packet loss patterns were particularly bad and caused 2-second
>> TCP retry timeouts occasionally - so I removed TCP from the test and
>> switched the UDP iperf instead.
>>
>> I ran isoping (https://gfiber.googlesource.com/vendor/google/platform/+/master/cmds/isoping.c)
>> from the AP to both stations to measure two-way latency during all
>> tests.  (I used -r2 for two packets/sec in each direction in order not
>> to affect the test results too much.)
>>
>> Overall results:
>>
>> - Running one iperf at a time, I saw ~45 Mbps to STA1 and ~7 Mbps to STA2.
>>
>> - Running both iperfs at once, without the patches, latencies got
>> extremely high (~600ms sometimes) and results were closer to
>> byte-fairness than airtime-fairness (ie. ~7 Mbps each).
>>
>> - Running both iperfs at once, with the patches, latencies were still
>> high (usually high 2-digit, sometimes low 3-digit latencies) but we
>> got closer to airtime-fairness than byte-fairness (~17 Mbps and ~2
>> Mbps).
>>
>> - With only one iperf running, without the patches, latencies were
>> high to both stations.  With the patches, latency was
>> mid-double-digits to the non-iperf station (pretty good!) while being
>> low-mid triple-digits to the busy iperf station.  This suggests that
>> we are getting per-station queuing (yay!) but does make me question
>> whether the fq_ in fq_codel was working.
>
> Please change the 'if (flow->txqi)' check in ieee80211_txq_enqueue to:
> if (flow->txqi && flow->txqi != txqi)
> This should hopefully fix the fq_ part ;)

Oops, I saw your message about that earlier and totally forgot to
apply the change.  But maybe that was for the best, because it doesn't
seem to uniformly make things better.

*Without* your change, I observe that my iperf3 session to STA1 (high
speed) seems to complain about a lot of out-of-order packets.  *With*
your change, the out-of-order complaints seem to go away, which is
nice.  The throughput measurements look about the same both ways.

However, *without* your change, isoping latency to STA1 (low speed)
seems to be pretty stable in the ~100ms range (although it fluctuates
a bit).  *With* your change, STA2 latency fluctuates wildly as low as
1.x ms (yay!) but as high as 800ms (boo).  STA1 latency is fairly low
in both cases.

I have to admit, I haven't read any of this code in enough detail to
have a guess as to why this might be. But I did switch back and forth
between the two versions a few times to confirm that it seems to be
repeatable.

Just to compare, I went back to a version that contains only Tim's
patch (intermediate queues) but not fq_codel.  That one seems to have
much less variability in the isoping times (~50-100ms under load).
The best case isn't as good, but the worst case is much less bad.
This suggests to me that maybe codel's per-station drop rate is
oscillating (perhaps it needs to ramp less quickly?).  I wonder if the
competing codels between stations also confuse each other: as one
ramps down, maybe the other one would be encouraged to ramp up?
