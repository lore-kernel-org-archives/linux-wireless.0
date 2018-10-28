Return-Path: <SRS0=/i66=NI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70E09C6786F
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Oct 2018 15:48:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07C8620873
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Oct 2018 15:48:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="un4dqGzM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 07C8620873
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbeJ2AdK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 28 Oct 2018 20:33:10 -0400
Received: from mail.toke.dk ([52.28.52.200]:41917 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727639AbeJ2AdJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Oct 2018 20:33:09 -0400
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1540741690; bh=IHUhFdTokxvTm+Mu2oveaTEL5hvp/jxPL3U5H09j9sY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=un4dqGzMf9PRYJf8TEp+hkONLlNHy4gnFou/FSSLXfmw9PiW1DXMm6RWjybmxSBTm
         gyH92pIaZpNciYpoLiUQ8WitKQ2r7BJaoxs0AUvLZCS+wzd+DwJCU0nhNRlsqgky/O
         1hqAEFNegxtLj8H9CegHbToPL1X4v6XUxHG/jr+i72zuPKhxNzDmbVeMxVSshRx5i8
         baHINEvO3n4kpd0+eo9vA1Jme4ady6TxWl2iSebvLIB6XNnQaUB3o2km08RN0iaWKu
         oUWLiquNZwvqCJHfBnRocT8q07cQexwhRCShcaBSGmqDkahlyiXihaAsfCFFPvsXAa
         FZlgZNozY4jxQ==
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 3/6] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <9c2b790132a9a89fecd7dd79dc67d891@codeaurora.org>
References: <1540033534-11211-1-git-send-email-rmanohar@codeaurora.org> <1540033534-11211-4-git-send-email-rmanohar@codeaurora.org> <8736ssbxp9.fsf@toke.dk> <9c2b790132a9a89fecd7dd79dc67d891@codeaurora.org>
Date:   Sun, 28 Oct 2018 16:48:09 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87woq2843q.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2018-10-26 07:16, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>=20
>>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
> [...]
>>>  	u8 max_nan_de_entries;
>>>  	u8 tx_sk_pacing_shift;
>>> +	u32 airtime_weight;
>>>  };
>>=20
>> This doesn't make sense. Airtime weights can be set by userspace, so
>> even if a driver sets another default it is not guaranteed to be
>> honoured. So what's the point?
>>=20
> The reason for driver specific default is to avoid performance impact
> in ath10k when the user is using vanilla ath10k with default airtime.
> As I mentioned earlier, mac80211 default (256us) is too low for 11ac
> devices especially with driver is bursting aggregation.
>
> Yes. I do understand the user can change airtime at anytime but It
> must be noted that different airtime weight will result in different
> throughput. IMHO the defaults should not impact current benchmark.
> Otherwise it will be alarmed as regression later. isn't it?

My point is that if the user has to know the implementation-specific
limitations of each driver before setting a weight, then it's not a
particularly friendly API. I think we should be able to do better than
that...

>> So since we're rotating the queue on every call to the function, I'm
>> wondering if this actually succeeds in throttling the slow station's
>> airtime usage enough to achieve fairness? So I'll ask again: Did you
>> test the fairness performance, and how?
>>=20
> We are collecting data of mixed clients (11ac, 11n and legacy) keeping
> them at same distance and different distance. So that lower rate
> clients will interfere higher MCS rate station. Also configuring
> different airtime weight for each stations so that throttling low rate
> clients more should help higher performing(better MCS) clients.
>
> By allowing different airtime for each stations, the user can control
> guest network over primary network. Also It helped to improve
> performance of preferred station and algo. to control station is given
> to cloud or user application.
>
> As of now, We are testing with 4 11ac clients of same distance. And
> collecting the performance data in multiple iteration. Below are
> current data of station's performance (Mbps) against airtime weight.
>
> airtime   station1(%airtime)  station2     station3       station4=20
> (Mbps)
>
> No ATF      182               168          166            169
>
> 4ms         170 (100%)        164 (100%)   185  (100%)    175 (100%)
>
> 4ms         277 (70%)         115 (10%)    103 (10%)      105 (10%)
>
> 4ms         223 (40%)         214 (40%)    109 (10%)       94 (10%)
>
> 4ms         337 (90%)         182 (8%)      23 (1%)        30 (1%)

So this looks like it's doing *something*, but not like it's succeeding
in achieving the set percentages. Did you check if the actual airtime
values (in debugfs) corresponds to the configured weights?

>
>              STA1(11ac)  STA2 (11n)  STA3(11a)
>              =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> No ATF       225         166         3.5
>
> ATF (4ms)    234         151         3.5

This also shows like ATF has no effect?

>> Also, taking a step back:
>>=20
>> With this, we're doing lots of work to make sure that the hardware's
>> round-robin scheduling queue lines up with mac80211; so if we do this
>> anyway, why can't we just control the order directly from mac80211
>> (which is what we do with the other next_txq() API)?
>>=20
> The only way to enforce mac80211 ordering in ath10k is to disable pull
> mode in firmware and always operates in push mode similar to ath9k.

And I assume that is not too likely to happen, or? What is the benefit
of pull mode at the firmware level?

-Toke
