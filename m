Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:33708 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbcEFHXe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2016 03:23:34 -0400
Received: by mail-oi0-f49.google.com with SMTP id v145so129638663oie.0
        for <linux-wireless@vger.kernel.org>; Fri, 06 May 2016 00:23:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQnrPqitDkXpqhEV3cxwdnr9J3NT-q6xDQN-nphNOgVfFQ@mail.gmail.com>
References: <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
	<1462446039-1070-1-git-send-email-michal.kazior@tieto.com>
	<1462446039-1070-6-git-send-email-michal.kazior@tieto.com>
	<CAA93jw6+WvTttjgBsU08epcXwSCHxv3Eh=m32xi72AiKYnGOCQ@mail.gmail.com>
	<CA+BoTQnED8EiLFNWq=8CPVAtufi0R5WjzAf6Pkf6cxUON_xY4g@mail.gmail.com>
	<CAA93jw6dJ=fUK_Sr1Pcrm8wES9o_aC+oHqXcQksc_yKbqv8ikA@mail.gmail.com>
	<CA+BoTQnrPqitDkXpqhEV3cxwdnr9J3NT-q6xDQN-nphNOgVfFQ@mail.gmail.com>
Date: Fri, 6 May 2016 00:23:33 -0700
Message-ID: <CAA93jw4+OuFFhwdC1-vm66Gi6ZZSoAbyOfw67VO9jJbOV6EM6Q@mail.gmail.com> (sfid-20160506_092338_796086_E4B6C3B3)
Subject: Re: [PATCHv4 5/5] mac80211: add debug knobs for codel
From: Dave Taht <dave.taht@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	make-wifi-fast@lists.bufferbloat.net,
	"codel@lists.bufferbloat.net" <codel@lists.bufferbloat.net>,
	Avery Pennarun <apenwarr@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 5, 2016 at 11:33 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 6 May 2016 at 07:51, Dave Taht <dave.taht@gmail.com> wrote:
>> On Thu, May 5, 2016 at 10:27 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
>>> On 5 May 2016 at 17:21, Dave Taht <dave.taht@gmail.com> wrote:
>>>> On Thu, May 5, 2016 at 4:00 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
>>>>> This adds a few debugfs entries to make it easier
>>>>> to test, debug and experiment.
>>>>
>>>> I might argue in favor of moving all these (inc the fq ones) into
>>>> their own dir, maybe "aqm" or "sqm".
>>>>
>>>> The mixture of read only stats and configuration vars is a bit confusing.
>>>>
>>>> Also in my testing of the previous patch, actually seeing the stats
>>>> get updated seemed to be highly async or inaccurate. For example, it
>>>> was obvious from the captures themselves that codel_ce_mark-ing was
>>>> happening, but the actual numbers out of wack with the mark seen or
>>>> fq_backlog seen.  (I can go back to revisit this)
>>>
>>> That's kind of expected since all of these bits are exposed as
>>> separate debugfs entries/files. To avoid that it'd be necessary to
>>> provide a single debugfs entry/file whose contents are generated on
>>> open() while holding local->fq.lock. But then you could argue it
>>> should contain all per-sta-tid info as well (backlog, flows, drops) as
>>> well instead of having them in netdev*/stations/*/txqs.
>>> Hmm..
>>
>> I have not had time to write up todays results to any full extent, but
>> they were pretty spectacular.
>>
>> I have a comparison of the baseline ath10k driver vs your 3.5 patchset
>> here on the second plot:
>>
>> http://blog.cerowrt.org/post/predictive_codeling/
>>
>> The raw data is here:
>> https://github.com/dtaht/blog-cerowrt/tree/master/content/flent/qca-10.2-fqmac35-codel-5
>
> It's probably good to explicitly mention that you test(ed) ath10k with
> my RFC DQL patch applied. Without it the fqcodel benefits are a lot
> less significant.

Yes. I am trying to establish a baseline before and after, starting at
the max rate my ath9k (2x2) can take the ath10k (2x2) at a distance of
about 12 feet. Without moving anything.

https://github.com/dtaht/blog-cerowrt/tree/master/content/flent/stock-4.4.1-22
has the baseline stats from that ubuntu 16.04 kernel...
 but the comparison plots I'd generated there were against the ct-10.1
firmware and before I'd realized you'd used the smaller quantum. Life
is *even* better with using the bigger quantum in the
qca-10.2-fqmac35-codel-5 patchset.

>
> (oh, and the "3.5" is pre-PATCHv4 before fq/codel split work:
> https://github.com/kazikcz/linux/tree/fqmac-v3.5 )

I have insufficient time in life to track any but the most advanced
patchset, and I am catching up as fast as I can. First up was finding
the max ath9k performance, (5x reduction in latency, no reduction in
throughput at about 110mbit).

Then I'll try locking the bitrate at say 24mbit for another run. You
already showed the latency reduction at 6mbit at about 100x to 1, so I
don't plan to repeat that.

then I'll get another ath10k 3x3 up and wash, rinse, repeat.

I would not mind if your patch 4.1 had good stats generation (maybe
put all the relevant stats in a single file?) and defaulted to quantum
1514, since it seems likely I'll not get done this first test run
before monday.

Additional test suggestions wanted? I plan to add the tcp_square_wave
tests to the next run to show how much better the congestion control
is, and I'll add iperf3 floods too.

I am not sure how avery is planning to test each individual piece.

>
>>
>> ...
>>
>> a note: quantum of the mtu (typically 1514) is a saner default than 300,
>>
>> (the older patch I had, set it to 300, dunno what your default is now).
>
> I still use 300.
>
>
>> and quantum 1514, codel target 5ms rather than 20ms for this test
>> series was *just fine* (but more testing of the lower target is
>> needed)
>
> I would keep 20ms for now until we get more test data. I'm mostly
> concerned about MU performance on ath10k which requires significant
> amount of buffering.

ok.

>
>> However:
>>
>> quantum "300" only makes sense for very, very low bandwidths (say <
>> 6mbits), in other scenarios it just eats extra cpu (5 passes through
>> the loop to send a big packet) and disables
>> the "new/old" queue feature which helps "push" new flows to flow
>> balance. I'd default it to the larger value.
>
> Perhaps this could be dynamically adjusted to match the slowest
> station known to rate control in the future?

Meh. We've done a lot of fiddling with the quantum to not much avail.
300 was a good number at really low rates. The rest of the time, the
larger number is vastly easier on cpu AND on flow balance.

https://dev.openwrt.org/ticket/21326

> Oh, and there's
> multicast..

Multicast is it's own queue in the per-station queueing model.

>
>
> Michał



-- 
Dave Täht
Let's go make home routers and wifi faster! With better software!
http://blog.cerowrt.org
