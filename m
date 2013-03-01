Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51158 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab3CANGG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 08:06:06 -0500
Message-ID: <5130A7AA.6060205@openwrt.org> (sfid-20130301_140611_190296_B53D1098)
Date: Fri, 01 Mar 2013 14:05:46 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: Adrian Chadd <adrian@freebsd.org>,
	Bob Copeland <me@bobcopeland.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>,
	Sujith Manoharan <sujith@msujith.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
References: <1360329197-72631-1-git-send-email-nbd@openwrt.org> <20757.1753.863278.858198@gargle.gargle.HOWL> <511508A6.8020104@openwrt.org> <CAMcMvsjE=NNqt_q=vepZbFE8vwLypN2qZwyXg=aCBj3vvYOpMw@mail.gmail.com> <51152D9E.1040106@openwrt.org> <20130227192030.GW12537@pogo> <CAJ-VmonSQi1SZVrkvcuS8dubqSAy8s1RCGJounL1EA23z3FXzw@mail.gmail.com> <512ECE01.8010102@openwrt.org> <20130228114724.GB16369@localhost> <512F5709.60907@openwrt.org> <CAJ-Vmom_YFWOU5+eAYv=mnUKVOuP6n3OO32GbO7AcwTgi5-HwQ@mail.gmail.com> <512FAB01.2050104@openwrt.org> <CAJ-Vmokr4_k5QKrvVGU-1pG0Y07iW9evyRkj_U4-zQ5TH1ZHBQ@mail.gmail.com> <51307F80.4010202@openwrt.org> <CAJ-Vmok9-dmC5-vhHA1DE_KW6mp7P3tijrSz-3D45jjQthbcCA@mail.gmail.com> <513082F8.8080002@openwrt.org> <CAD2nsn3pEOHJ+Cmd+sRm32jObU09cv+wae+3hsFtRzN5WLyFtg@mail.gmail.com> <51309177.2040106@openwrt.org> <CAD2nsn0Z0tuvs1hdp9DbGby_3LpHwywXnU7wbzUBRSFEGjESTA@mail.gmail.com>
In-Reply-To: <CAD2nsn0Z0tuvs1hdp9DbGby_3LpHwywXnU7wbzUBRSFEGjESTA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-03-01 1:32 PM, Mohammed Shafi wrote:
> On Fri, Mar 1, 2013 at 5:01 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> On 2013-03-01 12:18 PM, Mohammed Shafi wrote:
>>> Hi Felix,
>>>
>>> On Fri, Mar 1, 2013 at 3:59 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>>>> On 2013-03-01 11:22 AM, Adrian Chadd wrote:
>>>>> On 1 March 2013 02:14, Felix Fietkau <nbd@openwrt.org> wrote:
>>>>>
>>>>>>> Having access to schedule which peer and how much to send to each peer
>>>>>>> would be nice. Stuff like "peer X only can have up to x ms in this WME
>>>>>>> class this round", so you don't have a busy, close peer monopolising
>>>>>>> the air. It also means you can start doing smart things with far away
>>>>>>> peers who retransmit a lot - they're likely tying up a lot of airtime.
>>>>>>>
>>>>>>> None of this is new. It's just, you know, new to open source. :-)
>>>>>
>>>>>> In my opinion this doesn't really belong into a rate control module.
>>>>>> There should be a tx scheduling API to take care of this. Before I
>>>>>> implement something like this, I plan on exposing all per-station driver
>>>>>> queues to mac80211. This is necessary for a few other things anyway,
>>>>>> e.g. unifying software aggregation logic and fixing its buffer management.
>>>>>
>>>>> Sure, but then some more clever tricks end up being difficult to
>>>>> implement. For example, knowing if a client is tying up too much
>>>>> airtime at the given rate and whether to back them off for a bit. Or
>>>>> to use smaller aggregation limits for certain clients because your'e
>>>>> trying to be "fairer" when trying to keep latency low. That kind of
>>>>> thing.
>>>>>
>>>>> I think "rate control" should likely be expanded to "tx scheduling" as
>>>>> a whole, rather than sitting as a separate thing that just selects the
>>>>> rate for a node who has already been chosen to transmit.
>>>> Even with client airtime use, I still don't see how tx scheduling and
>>>> rate control belong together. In my opinion, the rate selection should
>>>> not be based on client airtime usage or the current load, as it can
>>>> optimize for throughput/airtime ratio without it.
>>>>
>>>
>>> Algorithm folks and Engineers had spent considerable time on ath9k rate control.
>>> Wouldn't be a great idea to remove it completely, We can have it optional.
>>> With lot of throughput tests ran over internally and with the test
>>> team verification,
>>> it wouldn't be fair to throw it away.
>> Regardless of how much time was spent tuning it, it still has a really
>> bad design, bad implementation and a number of practical issues.
>> It seems to be tuned entirely for artificial benchmarks in clean air. It
>> also starts with a very high rate without having proven that it works.
>> I don't think anybody is going to fix all of these issues, and even if
>> somebody does, it would invalidate pretty much all of the tuning/testing
>> that went into this code.
>>
> 
> We can certainly question the design and implementation, but it was proven
> to work well and had been tested by more hands(even with propitiatory stuff).
> Even if some one thinks it as bad, we should still allow it as an option.
> For instance if the environment is pretty good/pretty bad, we should give
> the users an option to choose between the two, that's why we should retain
> it.
I agree that we should keep it for a while, but we should probably
change the default soon. As for giving *users* the option of choosing
rate control based on the environment, I think it's a bad idea! Regular
users can't really be expected to know enough about the details of rate
control to make a meaningful decision, nor should they be. Simply being
lazy and telling every user to just test which one works better for them
is also a bad idea.

The default implementation needs to be good for all kinds of
environments. minstrel_ht is already tuned to work quite well in tough
environments with heavy interference, so closing the performance gap in
clean environments should be quite easy. The main thing I need to get
that done is good quality test feedback - something that I didn't get a
lot of, neither from users, nor from QCA.

> Further its been tested internally, by customers and more folks.
Right, and a few of those customers complained about bad performance
with ath9k, and also reported that switching to minstrel_ht fixed their
issues :)
Good to know that it's been tested, but where are the results? Who is
going to take care of the long standing *known* issues?
One of these issues (too high bitrate before rate feedback is available)
led to somebody from Google hacking up a crappy workaround in
wpa_supplicant that disables high bitrates during connect.

Saying that it has been tested does not necessarily imply that it's any
good or that it works properly in all normal scenarios ;)

> Its been also worked by some serious developers and Engineers.
Well, I do consider myself a serious developer and engineer as well :)

- Felix
