Return-Path: <SRS0=7415=NL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5FD5C0044C
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 06:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D53120821
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 06:17:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Dkf5JAJz";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="atqj50ru"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D53120821
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbeJaPOY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Oct 2018 11:14:24 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52042 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbeJaPOY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Oct 2018 11:14:24 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A60E6601B4; Wed, 31 Oct 2018 06:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540966661;
        bh=GzBuBmK8VPczhL7EZnxGYp3SKg0UuEhu21xxke46Nlg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Dkf5JAJzEb27TU5esyUDuvpjPj7YGOhQvQMHc0Bf7C4/oNUBWpfCxBjJO+tz7BoFS
         89M+h+QXWSPVmIeg8kE6u55HXJZicSF8L4iBN+amZZ9Jy1iSNecPooZKWOW8xepucM
         WNuDb8Lt6ieOs9gKm2guRooRfUQ60R0tkA+/Ctps=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id C09B1605A2;
        Wed, 31 Oct 2018 06:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540966660;
        bh=GzBuBmK8VPczhL7EZnxGYp3SKg0UuEhu21xxke46Nlg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=atqj50ruYGU/vQQFy7mm/yAkDeuDxEgTpeeswLBzGT6yTdHhwcKr3R4t7tkukvYb/
         rQXAC3oY6ZdcHCrD8zV2oPCDZmA6QWosIG+V5MXl6tKYPmGHMH5Ke30XKeSReOsPgC
         k9YLCEIhnnmkWL3+E46cI8vXiuvzUPlLZeZxINaI=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 31 Oct 2018 14:17:40 +0800
From:   yiboz@codeaurora.org
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH 3/6] mac80211: Add airtime accounting and scheduling to
 TXQs
In-Reply-To: <87woq2843q.fsf@toke.dk>
References: <1540033534-11211-1-git-send-email-rmanohar@codeaurora.org>
 <1540033534-11211-4-git-send-email-rmanohar@codeaurora.org>
 <8736ssbxp9.fsf@toke.dk> <9c2b790132a9a89fecd7dd79dc67d891@codeaurora.org>
 <87woq2843q.fsf@toke.dk>
Message-ID: <b452524e6155f075cc8125885c46de2d@codeaurora.org>
X-Sender: yiboz@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

在 2018-10-28 23:48，Toke Høiland-Jørgensen 写道：
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> 
>> On 2018-10-26 07:16, Toke Høiland-Jørgensen wrote:
>>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>> 
>>>> From: Toke Høiland-Jørgensen <toke@toke.dk>
>> [...]
>>>>  	u8 max_nan_de_entries;
>>>>  	u8 tx_sk_pacing_shift;
>>>> +	u32 airtime_weight;
>>>>  };
>>> 
>>> This doesn't make sense. Airtime weights can be set by userspace, so
>>> even if a driver sets another default it is not guaranteed to be
>>> honoured. So what's the point?
>>> 
>> The reason for driver specific default is to avoid performance impact
>> in ath10k when the user is using vanilla ath10k with default airtime.
>> As I mentioned earlier, mac80211 default (256us) is too low for 11ac
>> devices especially with driver is bursting aggregation.
>> 
>> Yes. I do understand the user can change airtime at anytime but It
>> must be noted that different airtime weight will result in different
>> throughput. IMHO the defaults should not impact current benchmark.
>> Otherwise it will be alarmed as regression later. isn't it?
> 
> My point is that if the user has to know the implementation-specific
> limitations of each driver before setting a weight, then it's not a
> particularly friendly API. I think we should be able to do better than
> that...
> 
>>> So since we're rotating the queue on every call to the function, I'm
>>> wondering if this actually succeeds in throttling the slow station's
>>> airtime usage enough to achieve fairness? So I'll ask again: Did you
>>> test the fairness performance, and how?
>>> 
>> We are collecting data of mixed clients (11ac, 11n and legacy) keeping
>> them at same distance and different distance. So that lower rate
>> clients will interfere higher MCS rate station. Also configuring
>> different airtime weight for each stations so that throttling low rate
>> clients more should help higher performing(better MCS) clients.
>> 
>> By allowing different airtime for each stations, the user can control
>> guest network over primary network. Also It helped to improve
>> performance of preferred station and algo. to control station is given
>> to cloud or user application.
>> 
>> As of now, We are testing with 4 11ac clients of same distance. And
>> collecting the performance data in multiple iteration. Below are
>> current data of station's performance (Mbps) against airtime weight.
>> 
>> airtime   station1(%airtime)  station2     station3       station4
>> (Mbps)
>> 
>> No ATF      182               168          166            169
>> 
>> 4ms         170 (100%)        164 (100%)   185  (100%)    175 (100%)
>> 
>> 4ms         277 (70%)         115 (10%)    103 (10%)      105 (10%)
>> 
>> 4ms         223 (40%)         214 (40%)    109 (10%)       94 (10%)
>> 
>> 4ms         337 (90%)         182 (8%)      23 (1%)        30 (1%)
> 
> So this looks like it's doing *something*, but not like it's succeeding
> in achieving the set percentages. Did you check if the actual airtime
> values (in debugfs) corresponds to the configured weights?
> 
>> 
>>              STA1(11ac)  STA2 (11n)  STA3(11a)
>>              ==========  ==========  =========
>> 
>> No ATF       225         166         3.5
>> 
>> ATF (4ms)    234         151         3.5
> 
> This also shows like ATF has no effect?
> 
>>> Also, taking a step back:
>>> 
>>> With this, we're doing lots of work to make sure that the hardware's
>>> round-robin scheduling queue lines up with mac80211; so if we do this
>>> anyway, why can't we just control the order directly from mac80211
>>> (which is what we do with the other next_txq() API)?
>>> 
Toke and Raj,

How about treating any txqs before the txq that FW asked for in 
push-pull mode
as pending txqs? Then we can dequeue and reorder them.And airtime weight 
need
to be tuned to make sure it won't cost too much time. After that, check 
the txq
FW wishes to fetch in txq_may_transmit.

Is this way able to achieve fairness and line up with mac80211?
Also, we may need to consider if FW supports in this way.

>> The only way to enforce mac80211 ordering in ath10k is to disable pull
>> mode in firmware and always operates in push mode similar to ath9k.
> 
> And I assume that is not too likely to happen, or? What is the benefit
> of pull mode at the firmware level?
> 
> -Toke
