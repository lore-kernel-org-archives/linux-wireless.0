Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36115 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbcEFGdJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2016 02:33:09 -0400
Received: by mail-wm0-f46.google.com with SMTP id n129so45319674wmn.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 May 2016 23:33:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA93jw6dJ=fUK_Sr1Pcrm8wES9o_aC+oHqXcQksc_yKbqv8ikA@mail.gmail.com>
References: <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
	<1462446039-1070-1-git-send-email-michal.kazior@tieto.com>
	<1462446039-1070-6-git-send-email-michal.kazior@tieto.com>
	<CAA93jw6+WvTttjgBsU08epcXwSCHxv3Eh=m32xi72AiKYnGOCQ@mail.gmail.com>
	<CA+BoTQnED8EiLFNWq=8CPVAtufi0R5WjzAf6Pkf6cxUON_xY4g@mail.gmail.com>
	<CAA93jw6dJ=fUK_Sr1Pcrm8wES9o_aC+oHqXcQksc_yKbqv8ikA@mail.gmail.com>
Date: Fri, 6 May 2016 08:33:07 +0200
Message-ID: <CA+BoTQnrPqitDkXpqhEV3cxwdnr9J3NT-q6xDQN-nphNOgVfFQ@mail.gmail.com> (sfid-20160506_083313_714784_EB58659E)
Subject: Re: [PATCHv4 5/5] mac80211: add debug knobs for codel
From: Michal Kazior <michal.kazior@tieto.com>
To: Dave Taht <dave.taht@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	make-wifi-fast@lists.bufferbloat.net,
	"codel@lists.bufferbloat.net" <codel@lists.bufferbloat.net>,
	Avery Pennarun <apenwarr@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 May 2016 at 07:51, Dave Taht <dave.taht@gmail.com> wrote:
> On Thu, May 5, 2016 at 10:27 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
>> On 5 May 2016 at 17:21, Dave Taht <dave.taht@gmail.com> wrote:
>>> On Thu, May 5, 2016 at 4:00 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
>>>> This adds a few debugfs entries to make it easier
>>>> to test, debug and experiment.
>>>
>>> I might argue in favor of moving all these (inc the fq ones) into
>>> their own dir, maybe "aqm" or "sqm".
>>>
>>> The mixture of read only stats and configuration vars is a bit confusing.
>>>
>>> Also in my testing of the previous patch, actually seeing the stats
>>> get updated seemed to be highly async or inaccurate. For example, it
>>> was obvious from the captures themselves that codel_ce_mark-ing was
>>> happening, but the actual numbers out of wack with the mark seen or
>>> fq_backlog seen.  (I can go back to revisit this)
>>
>> That's kind of expected since all of these bits are exposed as
>> separate debugfs entries/files. To avoid that it'd be necessary to
>> provide a single debugfs entry/file whose contents are generated on
>> open() while holding local->fq.lock. But then you could argue it
>> should contain all per-sta-tid info as well (backlog, flows, drops) as
>> well instead of having them in netdev*/stations/*/txqs.
>> Hmm..
>
> I have not had time to write up todays results to any full extent, but
> they were pretty spectacular.
>
> I have a comparison of the baseline ath10k driver vs your 3.5 patchset
> here on the second plot:
>
> http://blog.cerowrt.org/post/predictive_codeling/
>
> The raw data is here:
> https://github.com/dtaht/blog-cerowrt/tree/master/content/flent/qca-10.2-fqmac35-codel-5

It's probably good to explicitly mention that you test(ed) ath10k with
my RFC DQL patch applied. Without it the fqcodel benefits are a lot
less significant.

(oh, and the "3.5" is pre-PATCHv4 before fq/codel split work:
https://github.com/kazikcz/linux/tree/fqmac-v3.5 )


>
> ...
>
> a note: quantum of the mtu (typically 1514) is a saner default than 300,
>
> (the older patch I had, set it to 300, dunno what your default is now).

I still use 300.


> and quantum 1514, codel target 5ms rather than 20ms for this test
> series was *just fine* (but more testing of the lower target is
> needed)

I would keep 20ms for now until we get more test data. I'm mostly
concerned about MU performance on ath10k which requires significant
amount of buffering.


> However:
>
> quantum "300" only makes sense for very, very low bandwidths (say <
> 6mbits), in other scenarios it just eats extra cpu (5 passes through
> the loop to send a big packet) and disables
> the "new/old" queue feature which helps "push" new flows to flow
> balance. I'd default it to the larger value.

Perhaps this could be dynamically adjusted to match the slowest
station known to rate control in the future? Oh, and there's
multicast..


Michał
