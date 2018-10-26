Return-Path: <SRS0=rthY=NG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC1C8ECDE44
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 23:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C1082085B
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 23:04:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DXbGrsJz";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Tkj1y5k0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C1082085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbeJ0HnU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 27 Oct 2018 03:43:20 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55100 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbeJ0HnU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Oct 2018 03:43:20 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2DBC66028B; Fri, 26 Oct 2018 23:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540595064;
        bh=5KNllXH/fCUdDOy2ipTacEHI0xkNXFRCmqimHyB4RII=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DXbGrsJzSLFgCTsoOlGiml5tt8qR5MnD1r0xZuehtz6HA2uX8+8yH+0WFfYNmbXgl
         Zv9kDYdN2UKKToEx5teGUvKQHPUFJM5zExOi31m7Q2Ls7iJopE/WVM1/op+CWvIMRI
         o6SazzjtzbO1Uzgowfyyi0T+Q0Hi+4KHAK9MrIF4=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id AC23560791;
        Fri, 26 Oct 2018 23:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540595063;
        bh=5KNllXH/fCUdDOy2ipTacEHI0xkNXFRCmqimHyB4RII=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Tkj1y5k0o1KeSCEX2GSWahk+xGdXUBPAbQV7GUsEaawwTLghLQCAhvdiQbH7W3V/f
         TUC8GKjbMSqlq+PRSJlTB5H4sJcotWQlh17ud/Lfy8TBRVkz60bSF0sjrKTAht1j8z
         lHm+es++NoJB+YD31OHyMRAoXHF9s53R+eXQs/UM=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 26 Oct 2018 16:04:23 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 3/6] mac80211: Add airtime accounting and scheduling to
 TXQs
In-Reply-To: <8736ssbxp9.fsf@toke.dk>
References: <1540033534-11211-1-git-send-email-rmanohar@codeaurora.org>
 <1540033534-11211-4-git-send-email-rmanohar@codeaurora.org>
 <8736ssbxp9.fsf@toke.dk>
Message-ID: <9c2b790132a9a89fecd7dd79dc67d891@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-26 07:16, Toke Høiland-Jørgensen wrote:
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> 
>> From: Toke Høiland-Jørgensen <toke@toke.dk>
[...]
>>  	u8 max_nan_de_entries;
>>  	u8 tx_sk_pacing_shift;
>> +	u32 airtime_weight;
>>  };
> 
> This doesn't make sense. Airtime weights can be set by userspace, so
> even if a driver sets another default it is not guaranteed to be
> honoured. So what's the point?
> 
The reason for driver specific default is to avoid performance impact
in ath10k when the user is using vanilla ath10k with default airtime.
As I mentioned earlier, mac80211 default (256us) is too low for 11ac 
devices
especially with driver is bursting aggregation.

Yes. I do understand the user can change airtime at anytime but It must 
be
noted that different airtime weight will result in different throughput.
IMHO the defaults should not impact current benchmark. Otherwise it will 
be
alarmed as regression later. isn't it?


> So since we're rotating the queue on every call to the function, I'm
> wondering if this actually succeeds in throttling the slow station's
> airtime usage enough to achieve fairness? So I'll ask again: Did you
> test the fairness performance, and how?
> 
We are collecting data of mixed clients (11ac, 11n and legacy) keeping 
them
at same distance and different distance. So that lower rate clients will
interfere higher MCS rate station. Also configuring different airtime 
weight
for each stations so that throttling low rate clients more should help 
higher
performing(better MCS) clients.

By allowing different airtime for each stations, the user can control 
guest
network over primary network. Also It helped to improve performance of 
preferred
station and algo. to control station is given to cloud or user 
application.

As of now, We are testing with 4 11ac clients of same distance. And 
collecting
the performance data in multiple iteration. Below are current data of
station's performance (Mbps) against airtime weight.

airtime   station1(%airtime)  station2     station3       station4 
(Mbps)

No ATF      182               168          166            169

4ms         170 (100%)        164 (100%)   185  (100%)    175 (100%)

4ms         277 (70%)         115 (10%)    103 (10%)      105 (10%)

4ms         223 (40%)         214 (40%)    109 (10%)       94 (10%)

4ms         337 (90%)         182 (8%)      23 (1%)        30 (1%)



             STA1(11ac)  STA2 (11n)  STA3(11a)
             ==========  ==========  =========

No ATF       225         166         3.5

ATF (4ms)    234         151         3.5

> 
> Also, taking a step back:
> 
> With this, we're doing lots of work to make sure that the hardware's
> round-robin scheduling queue lines up with mac80211; so if we do this
> anyway, why can't we just control the order directly from mac80211
> (which is what we do with the other next_txq() API)?
> 
The only way to enforce mac80211 ordering in ath10k is to disable pull
mode in firmware and always operates in push mode similar to ath9k.

-Rajkumar
