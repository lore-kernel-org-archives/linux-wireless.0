Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:33641 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbcCZQo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Mar 2016 12:44:27 -0400
Received: by mail-oi0-f52.google.com with SMTP id d205so126561039oia.0
        for <linux-wireless@vger.kernel.org>; Sat, 26 Mar 2016 09:44:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQk7q7VerNC1KZK49REHn9rfo6sG5zW54P=-K3XkOL77pQ@mail.gmail.com>
References: <1458898743-21118-1-git-send-email-michal.kazior@tieto.com>
	<CA+BoTQk7q7VerNC1KZK49REHn9rfo6sG5zW54P=-K3XkOL77pQ@mail.gmail.com>
Date: Sat, 26 Mar 2016 09:44:26 -0700
Message-ID: <CAA93jw7BEsEOP8O2BQFXUibkGzkzBZuyWxBxs5XDCZmOt6D+Qg@mail.gmail.com> (sfid-20160326_174432_013832_0059FEA4)
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

Dear Michal:

I commented on and put up your results for the baseline driver here:

http://blog.cerowrt.org/post/rtt_fair_on_wifi/

And the wonderful result you got for the first ever fq_codel-ish
implementation here:

http://blog.cerowrt.org/post/fq_codel_on_ath10k/

I am running behind on this patch set, but a couple quick comments.


On Fri, Mar 25, 2016 at 2:55 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 25 March 2016 at 10:39, Michal Kazior <michal.kazior@tieto.com> wrote:
>> This implements a very naive dynamic queue limits
>> on the flat HTT Tx. In some of my tests (using
>> flent) it seems to reduce induced latency by
>> orders of magnitude (e.g. when enforcing 6mbps
>> tx rates 2500ms -> 150ms). But at the same time it
>> introduces TCP throughput buildup over time
>> (instead of immediate bump to max). More
>> importantly I didn't observe it to make things
>> much worse (yet).
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
>>
>> I'm not sure yet if it's worth to consider this
>> patch for merging per se. My motivation was to
>> have something to prove mac80211 fq works and to
>> see if DQL can learn the proper queue limit in
>> face of wireless rate control at all.
>>
>> I'll do a follow up post with flent test results
>> and some notes.
>
> Here's a short description what-is-what test naming:
>  - sw/fq contains only txq/flow stuff (no scheduling, no txop queue limits)
>  - sw/ath10k_dql contains only ath10k patch which applies DQL to
> driver-firmware tx queue naively
>  - sw/fq+ath10k_dql is obvious
>  - sw/base today's ath.git/master checkout used as base
>  - "veryfast" tests TCP tput to reference receiver (4 antennas)
>  - "fast" tests TCP tput to ref receiver (1 antenna)
>  - "slow" tests TCP tput to ref receiver (1 *unplugged* antenna)
>  - "fast+slow" tests sharing between "fast" and "slow"
>  - "autorate" uses default rate control
>  - "rate6m" uses fixed-tx-rate at 6mbps
>  - the test uses QCA9880 w/ 10.1.467
>  - no rrul tests, sorry Dave! :)

rrul would be a good baseline to have, but no need to waste your time
on running it every time as yet. It stresses out both sides of the
link so whenever you get two devices with these driver changes on them
it would be "interesting". It's the meanest, nastiest test we have...
if you can get past the rrul, you've truly won.

Consistently using tcp_fair_up with 1,2,4 flows and 1-4 stations as
you are now is good enough.

doing a more voip-like test with slamming d-itg into your test would be good...

>
> Observations / conclusions:
>  - DQL builds up throughput slowly on "veryfast"; in some tests it
> doesn't get to reach peak (roughly 210mbps average) because the test
> is too short

It looks like having access to the rate control info here for the
initial and ongoing estimates will react faster and better than dql
can. I loved the potential here in getting full rate for web traffic
in the usual 2second burst you get it in (see above blog entries)

>  - DQL shows better latency results in almost all cases compared to
> the txop based scheduling from my mac80211 RFC (but i haven't
> thoroughly looked at *all* the data; I might've missed a case where it
> performs worse)

Well, if you are not saturating the link, latency will be better.
Showing how much less latency is possible, is good too, but....

>  - latency improvement seen on sw/ath10k_dql @ rate6m,fast compared to
> sw/base (1800ms -> 160ms) can be explained by the fact that txq AC
> limit is 256 and since all TCP streams run on BE (and fq_codel as the
> qdisc) the induced txq latency is 256 * (1500 / (6*1024*1024/8.)) / 4
> = ~122ms which is pretty close to the test data (the formula ignores
> MAC overhead, so the latency in practice is larger). Once you consider
> the overhead and in-flight packets on driver-firmware tx queue 160ms
> doesn't seem strange. Moreover when you compare the same case with
> sw/fq+ath10k_dql you can clearly see the advantage of having fq_codel
> in mac80211 software queuing - the latency drops by (another) order of
> magnitude because now incomming ICMPs are treated as new, bursty flows
> and get fed to the device quickly.


It is always good to test codel and fq_codel separately, particularly
on a new codel implementation. There are so many ways to get codel
wrong or add an optimization that doesn't work (speaking as someone
that has got it wrong often)

If you are getting a fq result of 12 ms, that means you are getting
data into the device with a ~12ms standing queue there. On a good day
you'd see perhaps 17-22ms for "codel target 5ms" in that case, on the
rtt_fair_up series of tests.

if you are getting a pure codel result of 160ms, that means the
implementation is broken. But I think (after having read your
description twice), the baseline result today of 160ms of queuing was
with a fq_codel *qdisc* doing the work on top of huge buffers, the
results a few days ago were with a fq_codel 802.11 layer, and the
results today you are comparing, are pure fq (no codel) in the 802.11e
stack, with fixed (and dql) buffering?

if so. Yea! Science!

...

One of the flaws of the flent tests is that conceptually they were
developed before the fq stuff won so big, and looking hard at the
per-queue latency for the fat flows requires either looking hard at
the packet captures or sampling the actual queue length. There is that
sampling capability in various flent tests, but at the moment it only
samples what tc provides (Drops, marks, and length) and it does not
look like there is a snapshot queue length exported from that ath10k
driver?

...

As for a standing queue of 12ms at all in wifi... and making the fq
portion work better, it would be quite nice to get that down a bit
more. One thought (for testing purposes) would be to fix a txop at
1024,2048,3xxxus for some test runs. I really don't have a a feel for
framing overhead on the latest standards. (I loathe the idea of
holding the media for more than 2-3ms when you have other stuff coming
in behind it...)

 Another is to hold off preparing and submitting a new batch of
packets; when you know the existing TID will take 4ms to transmit,
defer grabbing the next batch for 3ms. Etc.

It would be glorious to see wifi capable of decent twitch gaming again...

>  - slow+fast case still sucks but that's expected because DQL hasn't
> been applied per-station
>
>  - sw/fq has lower peak throughput ("veryfast") compared to sw/base
> (this actually proves current - and very young least to say - ath10k
> wake-tx-queue implementation is deficient; ath10k_dql improves it and
> sw/fq+ath10k_dql climbs up to the max throughput over time)
>
>
> To sum things up:
>  - DQL might be able to replace the explicit txop queue limiting
> (which requires rate control info)

I am pessimistic. Perhaps as a fallback?

>  - mac80211 fair queuing works

:)

>
> A few plots for quick and easy reference:
>
>   http://imgur.com/a/TnvbQ
>
>
> Michał
>
> PS. I'm not feeling comfortable attaching 1MB attachment to a mailing
> list. Is this okay or should I use something else next time?

I/you can slam results into the github blogcerowrt repo and then pull
out stuff selectively....
