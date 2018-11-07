Return-Path: <SRS0=0pA5=NS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2740C0044C
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 14:53:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B26F2085B
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 14:53:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="hwkm++i6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B26F2085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbeKHAXu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Nov 2018 19:23:50 -0500
Received: from mail.toke.dk ([52.28.52.200]:37081 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbeKHAXu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Nov 2018 19:23:50 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1541602388; bh=LSpfdQ4JAPVFZjOgmh02BC0hX8QwebBPMb7KQF90mNU=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=hwkm++i6IkAw6ScyEiUSmweQtDsMPlM9M6iKj0kGqR0khgVh2QKQGlbe8g8RotGiE
         2UifCct0dGjGrlpPYkGi/7n4jNK0IotSrp+lXQe0Fj15IETjAaGKEEi/7VF2sHW5MM
         po4Udm/2YB3ufr9OzOm1kSLCegkxeJWlQJKL23hN+Cgz8p2IJ1MVi57ycBDi1Vfo7A
         pEtGp9GzPGIcE5XrDlwiTWsS1suEMEF8Mm6w/FsUlGogjPvg8LrF7dM6ad9UNP1FxT
         UzLSolRYG5kR32BYGCPNAIoqfZwzDbJnLQf0hKt9DpA6YyfkaWM00ojhlNGvBYQJo5
         qxUYzHG6Mwn6g==
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 3/6] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <10b644b6c7f436a892e3e9f4fd5e179d@codeaurora.org>
References: <1540033534-11211-1-git-send-email-rmanohar@codeaurora.org> <1540033534-11211-4-git-send-email-rmanohar@codeaurora.org> <8736ssbxp9.fsf@toke.dk> <9c2b790132a9a89fecd7dd79dc67d891@codeaurora.org> <87woq2843q.fsf@toke.dk> <8fd3524bfe022ccd2a8b61a3314ed32b@codeaurora.org> <5d8415fe50e8505eb62c5a0d1b40bb2a@codeaurora.org> <87h8gzpy9t.fsf@toke.dk> <10b644b6c7f436a892e3e9f4fd5e179d@codeaurora.org>
Date:   Wed, 07 Nov 2018 15:53:06 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87va59uegc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2018-11-02 03:30, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>=20
>>> On 2018-10-28 15:01, Rajkumar Manoharan wrote:
>>>> On 2018-10-28 08:48, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>>>>=20
>>>>>>=20
>>>>>> 4ms         223 (40%)         214 (40%)    109 (10%)       94 (10%)
>>>>>>=20
>>>>>> 4ms         337 (90%)         182 (8%)      23 (1%)        30 (1%)
>>>>>=20
>>>>> So this looks like it's doing *something*, but not like it's
>>>>> succeeding
>>>>> in achieving the set percentages. Did you check if the actual=20
>>>>> airtime
>>>>> values (in debugfs) corresponds to the configured weights?
>>>>>=20
>>>> No. Will check that.
>>>>=20
>>> Toke,
>>>=20
>>>  From above results, different airtime for each station is reflecting=20
>>> on
>>> output performance. Unfortunately I don't see such tput difference,=20
>>> when
>>> the tx mode is fixed in push-only. Even low weight station is giving
>>> same
>>> performance. Are you also seeing the same behavior in your setup?=20
>>> Could
>>> you please share your results?
>>=20
>> Sorry, I've been travelling this week; I'll be back in the office next
>> week and can run some tests then. I may also have an idea for a
>> different algorithm that will work better in pull mode, but need to see
>> if it works at all first :)
>>=20
> Wow... :)
>
> Meanwhile we did some more experiments with both modes. The experiment
> was done in open environment and fixed rate and UDP traffic ran for 60
> seconds.
>
> Seems like push mode not honoring the configured weight. Always the
> airtime was almost same whereas in pull-mode airtime is changing based
> on configured weight. Hence I would like to know your results.

Right, so I verified that the current version of the patch set still
works with ath9k. However, the ath10k card I have doesn't seem to
support peer stats, so I can't test ath10k.=20

$ lspci | grep Qualcomm
03:00.0 Network controller: Qualcomm Atheros QCA986x/988x 802.11ac Wireless=
 Network Adapter

$ cat /sys/kernel/debug/ieee80211/phy1/ath10k/chip_id=20
0x043202ff

$ cat /sys/kernel/debug/ieee80211/phy1/ath10k/wmi_services  | grep PEER
WMI_SERVICE_PEER_CACHING                 -
WMI_SERVICE_PEER_STATS                   -


Is there a way to force-enable airtime support, is this a hardware issue?

> 		sta1		sta2		sta3		sta4
> pull-mode	8s(205us)	18s(3.2ms)	8s(205us)	14s(410us)
> 		12s(256us)	12s(256us)	13s(256us)	12s(256us)
> 		14s(4ms)	13s(4ms)	14s(4ms)	13s(4ms)
>
> push-mode	15s(205us)	12s(3.2ms)	16s(205us)	12s(410us)
> 		15s(256us)	12s(256us)	16s(256us)	12s(256us)
> 		14s(4ms)	13s(4ms)	16s(4ms)	12s(4ms)

Right, so the pull-mode results are encouraging! *Something* is
happening, at least, even though the aggregate airtime doesn't quite
match the ratios of the configured weights.

Are you running the UDP generator on the AP itself, or on a separate
device, BTW? If it's on the AP, the userspace socket can get throttled,
which will interfere with results, so it's better to have it on a
separate device (connected via ethernet).

As for push-mode, could this be because of bad buffer management? I.e.,
because there's a lag between the time airtime is registered, and the
time that airtime usage is reported, the driver just pushes a whole
bunch of packets to the firmware when it gets the chance, which prevents
the scheduler from throttling properly. This could also explain the
better, but not quite perfect, results in pull mode, assuming that pull
mode results in better firmware buffer management which reduces, but
doesn't quite remove, the lag.

If this is indeed the reason, the queue limit patches should hopefully
be a solution. So guess we need to get those working as well :)

-Toke
