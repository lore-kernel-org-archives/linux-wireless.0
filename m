Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:33862 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbcC3A55 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 20:57:57 -0400
Received: by mail-ob0-f176.google.com with SMTP id kf9so37281982obc.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2016 17:57:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQnDtWNGQGkBNeBGSrjkjQc4dFuivQTL=0_1D+ooE-9+RQ@mail.gmail.com>
References: <1458898743-21118-1-git-send-email-michal.kazior@tieto.com>
	<CA+BoTQk7q7VerNC1KZK49REHn9rfo6sG5zW54P=-K3XkOL77pQ@mail.gmail.com>
	<CAA93jw7BEsEOP8O2BQFXUibkGzkzBZuyWxBxs5XDCZmOt6D+Qg@mail.gmail.com>
	<CA+BoTQnDtWNGQGkBNeBGSrjkjQc4dFuivQTL=0_1D+ooE-9+RQ@mail.gmail.com>
Date: Tue, 29 Mar 2016 17:57:56 -0700
Message-ID: <CAA93jw4ooS_oc___qTzwqmZ4BPbOSem0Z8V_qc0zq2hh5Qv2Rg@mail.gmail.com> (sfid-20160330_025802_028430_C9DA4462)
Subject: Re: [RFC] ath10k: implement dql for htt tx
From: Dave Taht <dave.taht@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net,
	"codel@lists.bufferbloat.net" <codel@lists.bufferbloat.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As a side note of wifi ideas complementary to codel, please see:

http://blog.cerowrt.org/post/selective_unprotect/

On Tue, Mar 29, 2016 at 12:49 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 26 March 2016 at 17:44, Dave Taht <dave.taht@gmail.com> wrote:
>> Dear Michal:
> [...]
>> I am running behind on this patch set, but a couple quick comments.
> [...]
>>>  - no rrul tests, sorry Dave! :)
>>
>> rrul would be a good baseline to have, but no need to waste your time
>> on running it every time as yet. It stresses out both sides of the
>> link so whenever you get two devices with these driver changes on them
>> it would be "interesting". It's the meanest, nastiest test we have...
>> if you can get past the rrul, you've truly won.
>>
>> Consistently using tcp_fair_up with 1,2,4 flows and 1-4 stations as
>> you are now is good enough.
>>
>> doing a more voip-like test with slamming d-itg into your test would be good...
>>
>>>
>>> Observations / conclusions:
>>>  - DQL builds up throughput slowly on "veryfast"; in some tests it
>>> doesn't get to reach peak (roughly 210mbps average) because the test
>>> is too short
>>
>> It looks like having access to the rate control info here for the
>> initial and ongoing estimates will react faster and better than dql
>> can. I loved the potential here in getting full rate for web traffic
>> in the usual 2second burst you get it in (see above blog entries)
>
> On one hand - yes, rate control should in theory be "faster".
>
> On the other hand DQL will react also to host system interrupt service
> time. On slow CPUs (typically found on routers and such) you might end
> up grinding the CPU so much you need deeper tx queues to keep the hw
> busy (and therefore keep performance maxed). DQL should automatically
> adjust to that while "txop limit" might not.

Mmmm.... current multi-core generation arm routers should be fast enough.

Otherwise, point taken (possibly). Even intel i3 boxes need offloads to get to
line rate.


>>
>> It is always good to test codel and fq_codel separately, particularly
>> on a new codel implementation. There are so many ways to get codel
>> wrong or add an optimization that doesn't work (speaking as someone
>> that has got it wrong often)
>>
>> If you are getting a fq result of 12 ms, that means you are getting
>> data into the device with a ~12ms standing queue there. On a good day
>> you'd see perhaps 17-22ms for "codel target 5ms" in that case, on the
>> rtt_fair_up series of tests.
>
> This will obviously depend on the number of stations you have data
> queued to. Estimating codel target time requires smarter tx
> scheduling. My earlier (RFC) patch tried doing that.

and I loved it. ;)

>
>> if you are getting a pure codel result of 160ms, that means the
>> implementation is broken. But I think (after having read your
>> description twice), the baseline result today of 160ms of queuing was
>> with a fq_codel *qdisc* doing the work on top of huge buffers,
>
> Yes. The 160ms is with fq_codel qdisc with ath10k doing DQL at 6mbps.
> Without DQL ath10k would clog up all tx slots (1424 of them) with
> frames. At 6mbps you typically want/need a handful (5-10) of frames to
> be queued.
>
>> the
>> results a few days ago were with a fq_codel 802.11 layer, and the
>> results today you are comparing, are pure fq (no codel) in the 802.11e
>> stack, with fixed (and dql) buffering?
>
> Yes. codel target in fq_codel-in-mac80211 is hardcoded at 20ms now
> because there's no scheduling and hence no data to derive the target
> dynamically.

Well, for these simple 2 station tests, you could halve it, easily.

With ecn on on both sides, I tend to look at the groupings of the ecn
marks in wireshark.

>
>
>> if so. Yea! Science!
>>
>> ...
>>
>> One of the flaws of the flent tests is that conceptually they were
>> developed before the fq stuff won so big, and looking hard at the
>> per-queue latency for the fat flows requires either looking hard at
>> the packet captures or sampling the actual queue length. There is that
>> sampling capability in various flent tests, but at the moment it only
>> samples what tc provides (Drops, marks, and length) and it does not
>> look like there is a snapshot queue length exported from that ath10k
>> driver?
>
> Exporting tx queue length snapshot should be fairly easy. 2 debugfs
> entries for ar->htt.max_num_pending_tx and ar->htt.num_pending_tx.

K. Still running *way* behind you on getting stuff up and running. The
ath10ks I ordered were backordered, should arrive shortly.

>
>
>>
>> ...
>>
>> As for a standing queue of 12ms at all in wifi... and making the fq
>> portion work better, it would be quite nice to get that down a bit
>> more. One thought (for testing purposes) would be to fix a txop at
>> 1024,2048,3xxxus for some test runs. I really don't have a a feel for
>> framing overhead on the latest standards. (I loathe the idea of
>> holding the media for more than 2-3ms when you have other stuff coming
>> in behind it...)
>>
>>  Another is to hold off preparing and submitting a new batch of
>> packets; when you know the existing TID will take 4ms to transmit,
>> defer grabbing the next batch for 3ms. Etc.
>
> I don't think hardcoding timings for tx scheduling is a good idea. I

wasn't suggesting that, was suggesting predicting a minimum time to
transmit based on the history.

> believe we just need a deficit-based round robin with time slices. The
> problem I see is time slices may change with host CPU load. That's why
> I'm leaning towards more experiments with DQL approach.

OK.

>
>> It would be glorious to see wifi capable of decent twitch gaming again...
>>
>>>  - slow+fast case still sucks but that's expected because DQL hasn't
>>> been applied per-station
>>>
>>>  - sw/fq has lower peak throughput ("veryfast") compared to sw/base
>>> (this actually proves current - and very young least to say - ath10k
>>> wake-tx-queue implementation is deficient; ath10k_dql improves it and
>>> sw/fq+ath10k_dql climbs up to the max throughput over time)
>>>
>>>
>>> To sum things up:
>>>  - DQL might be able to replace the explicit txop queue limiting
>>> (which requires rate control info)
>>
>> I am pessimistic. Perhaps as a fallback?
>
> At first I was (too) considering DQL as a nice fallback but the more I
> think about the more it makes sense to use it as the main source of
> deriving time slices for tx scheduling.

I don't really get how dql can be applied per station in it's current forrm.

>
>
>>>  - mac80211 fair queuing works
>>
>> :)
>>
>>>
>>> A few plots for quick and easy reference:
>>>
>>>   http://imgur.com/a/TnvbQ
>>>
>>>
>>> Michał
>>>
>>> PS. I'm not feeling comfortable attaching 1MB attachment to a mailing
>>> list. Is this okay or should I use something else next time?
>>
>> I/you can slam results into the github blogcerowrt repo and then pull
>> out stuff selectively....
>
> Good idea, thanks!

You got commit privs.

>
>
> Michał
