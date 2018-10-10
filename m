Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F4FC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 17:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 312C120870
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 17:10:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 312C120870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=candelatech.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbeJKAdd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 20:33:33 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:48774 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727433AbeJKAdc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 20:33:32 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id D53E940A5C4;
        Wed, 10 Oct 2018 10:10:26 -0700 (PDT)
Subject: Re: Tool to debug wifi pkt sniffs?
To:     Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@toke.dk>
References: <a44e3947-29a9-d7ba-abec-59bc1b92b201@candelatech.com>
 <87pnwqaiso.fsf@toke.dk>
 <CAA93jw768_OOUB1w81_9Ck_XgSbDG4P2nBfuptT+SLXCf3voTA@mail.gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <01b77936-f6d4-271a-d7d2-0fd2cf70f7bd@candelatech.com>
Date:   Wed, 10 Oct 2018 10:10:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.0
MIME-Version: 1.0
In-Reply-To: <CAA93jw768_OOUB1w81_9Ck_XgSbDG4P2nBfuptT+SLXCf3voTA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/03/2018 01:29 PM, Dave Taht wrote:
> On Wed, Oct 3, 2018 at 1:16 PM Toke Høiland-Jørgensen <toke@toke.dk> wrote:
>>
>> Ben Greear <greearb@candelatech.com> writes:
>>
>>> Hello,
>>>
>>> I often find myself wanting to figure out what equipment is to blame (and why)
>>> in a wifi environment.
>>>
>>> I am thinking writing a tool that would parse a pcap file and look at frames
>>> in enough detail to flag block-ack bugs, rate-ctrl bugs, guess at the sniffer's
>>> capture ability, etc.
>>>
>>> Does anyone have anything already written that they would like to share, or know
>>> of projects that might already do some of this?
>>
>> Not sure if this fits your criteria, but Sven's tool to create airtime
>> charts from packet sniffing data immediately came to mind:
>>
>> https://github.com/cloudtrax/airtime-pie-chart
>
> I have used that. Oy, it's a PITA. Some of kathie's code over here
> (example: https://github.com/pollere/pping ) uses the slightly less
> painful http://libtins.github.io/ library for parsing packets.

I couldn't find anything that did what I wanted, so I wrote my own.

The (perl) code is in the wifi-diag directory of this public repo:

https://github.com/greearb/lanforge-scripts

The rest of the scripts in that repo are not related to the wifi-diag script, so just ignore those.

Here is example output for what I have so far:

https://www.candelatech.com/oss/wifi-diag/netgear-up-5s/index.html

The general idea is to get a performance test going, and then use tshark or similar
to grab a short sample (my script is slow, it can process only about 400 packets per second
on my desktop, so a 5 sec capture at full speed takes around 5 minutes to process),
and then pipe that decoded pcap into my script.

It tries to pay attention to latencies between block-ack and next AMPDU frame,
MCS distributions, packet-type distributions, retries, and other
such things.  I'm guessing tweaking wmm settings (or changing QoS in the generated traffic)
would be visible in this kind of metric, for instance.

The goal is to be able to answer the question of why one AP is faster or slower than another
when running the same test case.

Feedback (and even patches) is welcome...what other things can I report that would
be helpful?


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

