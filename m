Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35823 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315AbcDAIBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 04:01:25 -0400
Received: by mail-wm0-f48.google.com with SMTP id 191so10797248wmq.0
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2016 01:01:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQk7q7VerNC1KZK49REHn9rfo6sG5zW54P=-K3XkOL77pQ@mail.gmail.com>
References: <1458898743-21118-1-git-send-email-michal.kazior@tieto.com>
	<CA+BoTQk7q7VerNC1KZK49REHn9rfo6sG5zW54P=-K3XkOL77pQ@mail.gmail.com>
Date: Fri, 1 Apr 2016 10:01:24 +0200
Message-ID: <CA+BoTQ=8rZ8mo=MXcWrq3Yxj63k9aMh2W=2dPZCkYVvv=XRcCw@mail.gmail.com> (sfid-20160401_100130_008013_1B9C4EC2)
Subject: Re: [RFC] ath10k: implement dql for htt tx
From: Michal Kazior <michal.kazior@tieto.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dave Taht <dave.taht@gmail.com>,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Re-posting text only as it was blocked by most mailing list servers:

The original attachment can be fetched at:
  http://kazikcz.github.io/dl/2016-04-01-flent-ath10k-dql.tar.gz

On 25 March 2016 at 10:55, Michal Kazior <michal.kazior@tieto.com> wrote:
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
>
> \
> Observations / conclusions:
>  - DQL builds up throughput slowly on "veryfast"; in some tests it
> doesn't get to reach peak (roughly 210mbps average) because the test
> is too short
>
>  - DQL shows better latency results in almost all cases compared to
> the txop based scheduling from my mac80211 RFC (but i haven't
> thoroughly looked at *all* the data; I might've missed a case where it
> performs worse)
>
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
>
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
>  - mac80211 fair queuing works
>
>
> A few plots for quick and easy reference:
>
>   http://imgur.com/a/TnvbQ



Michał
