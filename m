Return-Path: <SRS0=5mL6=Z4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA64C43603
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Dec 2019 23:44:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A957A2082E
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Dec 2019 23:44:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="M5UbEIBM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfLFXov (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 6 Dec 2019 18:44:51 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:59182 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfLFXov (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Dec 2019 18:44:51 -0500
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 03E2C137531;
        Fri,  6 Dec 2019 15:44:50 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 03E2C137531
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1575675891;
        bh=brQmNkR9PrnRs05ydsCxZV3oTLxCc/Mye+QqLBgFi3o=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=M5UbEIBM7q4aN9rIHcXaKNqsr3tjU63iUAT1y2w915Snd8ZEzHdMq3U5Vlujra05c
         fXdZzZ69mOcHrwfZYHp3yK8tT4G9AS0LlqpumVpkt7ZwZb8TBY9haQn4AayKhQJMrD
         imOIQGQo6b5CVYnKUYiOcMCX97DI1/8LA0KC/uy0=
Subject: Re: debugging TXQs being empty
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kan Yan <kyan@google.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <bbc516f28782175b27ac5e19dcdeac13cd6ee76a.camel@sipsolutions.net>
 <fd23a26dea59128ede8c1c4d02fb2f3514ffb5e9.camel@sipsolutions.net>
 <CA+iem5tjTpO_2MKL_pEu7enTa-8=g5vY3=2WJKjg9f=JA2eCEw@mail.gmail.com>
 <9b89b3b294295063aec045b9e863a44ad20b8782.camel@sipsolutions.net>
 <bf0cced86a1466285f74eb845e73fbaea1dff1c0.camel@sipsolutions.net>
 <9bcbab4b562669b96198c632f476b1b74956ca09.camel@sipsolutions.net>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <336996e4-d9fe-bf3a-72fb-6919bd0adcbf@candelatech.com>
Date:   Fri, 6 Dec 2019 15:44:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <9bcbab4b562669b96198c632f476b1b74956ca09.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 12/6/19 3:49 AM, Johannes Berg wrote:
> On Fri, 2019-12-06 at 10:12 +0100, Johannes Berg wrote:
>> On Fri, 2019-12-06 at 09:41 +0100, Johannes Berg wrote:
>>> Maybe somehow TSO is interacting badly with the TXQs and the tracking
>>> here, since TSO makes the traffic *very* bursty? A 64k packet in the
>>> driver will typically expand to 9 or 10 A-MSDUs I think?
>>
>> No, that all seems well. Without TSO (with the trivial mac80211 patch to
>> let me turn it off with ethtool) I get about 890Mbps, so about 5% less.
>> That's not actually *that* bad, I guess due to software A-MSDU in
>> mac80211, but it's not really the right direction :)
>>
>> Changing wmem_max/tcp_mem to outrageous values also didn't really make
>> any difference.
>>
>> I guess it's time to see if I can poke into the TCP stack to figure out
>> what's going on...
> 
> Sadly no functioning kprobes on the system ... bpftrace -l lists them,
> but can't actually use them.
> 
> If I also change net.ipv4.tcp_limit_output_bytes to an outrageous value
> (10x) I can recover a bit more than half of the performance loss with
> TSO disabled, but it makes no real difference with TSO enabled.
> 
> Either way, what bothers me somewhat is that the backlog fluctuates so
> much. Sometimes I see a backlock of 2MB or more, while it *still*
> manages to go completely empty.
> 
> Shouldn't I expect the steady state to have a somewhat even backlog? Why
> does this vary so much?
> 
> johannes
> 


I did some tests today:

kernel is 5.2.21+, with the fix for ax200 upload corruption bug.
AP is QCA 9984 based PC (i5 processor) running ath10k-ct firmware/driver, configured for 2x2 160Mhz
STA is PC (i5 processor) with AX200
OTA, about 5 feet apart
AP reports STA is sending at MCS-9 160Mhz (AX200 STA does not report tx rate it seems)
Our LANforge tool is traffic generator, running directly on AP and STA machine.

Download UDP, I see about 697Mbps goodput
Upload UDP, I see about 120Mbps goodput

TCP download, about 660Mbps
TCP upload, about 99Mbps

Our hacked version of pktgen, bps includes down to Ethernet frame:
Download: 740Mbps
Upload: 129Mbps

I changed AP to 80Mhz mode, and re-ran the UDP tests:

Upload 137Mbps
Download 689Mbps

Though not confirmed today, one of us reports about 1.7Gbps download on AX200 against an enterprise /AX AP,
and only abuot 600Mbps upload in that same system.  That is in isolation chamber and such.

So, for whatever reason(s), we see consistent poor upload performance on AX200.

For reference, we have previously seen about 1.1Gbps upload between QCA9984 station and 4x4 /AC APs
(and about 1.3Gbps download goodput), so in general, wifi upload can run faster.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

