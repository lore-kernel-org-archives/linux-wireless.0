Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22155C43143
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 23:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD2EA206B2
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 23:05:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD2EA206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=candelatech.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbeI2Fa6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 29 Sep 2018 01:30:58 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:37324 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbeI2Fa5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Sep 2018 01:30:57 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 0C90A40A69D;
        Fri, 28 Sep 2018 16:04:57 -0700 (PDT)
Subject: Re: [RFC 2/2] ath10k: reporting estimated tx airtime for fairness
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
References: <1538008874-11692-1-git-send-email-rmanohar@codeaurora.org>
 <1538008874-11692-2-git-send-email-rmanohar@codeaurora.org>
 <87lg7lfxtw.fsf@toke.dk> <34bac7851e6c9d3194cef87bd952c388@codeaurora.org>
 <25469b4a-219d-f941-15ad-a1c95308dd69@candelatech.com>
 <df1c4f9bde7682646c901305d1c0ab5d@codeaurora.org>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <4678c2a6-93ab-5688-1907-73ceb74999c4@candelatech.com>
Date:   Fri, 28 Sep 2018 16:04:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.0
MIME-Version: 1.0
In-Reply-To: <df1c4f9bde7682646c901305d1c0ab5d@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 09/28/2018 03:47 PM, Rajkumar Manoharan wrote:
> On 2018-09-28 12:57, Ben Greear wrote:
>> On 09/28/2018 12:47 PM, Rajkumar Manoharan wrote:
>>> On 2018-09-28 08:25, Toke Høiland-Jørgensen wrote:
>>>
>>>> So this just uses the calculated airtime based on rate and size? Wasn't
>>>> there supposed to be an airtime usage value reported by the firmware? :)
>>>>
>>> Firmware interface changes are in progress. Airtime for sta/tid will be reported via
>>> htt tx-compl and rx ind messages. Meantime I thought it would be useful to use Kan's changes
>>> for ATF validation in ath10k using existing firmware. :)
>>
>> Maybe you can get the firmware guys to report the tx rate in the tx-completion
>> (like I have been doing for years in my ath10k-ct firmware)?  Then let the host
>> do the air-time calculating?
>>
>> I'll give them firmware patches if the want :)
>>
> Ben,
>
> As you know, it needs cleanup in firmware to free up space for new interface
> changes. Most of time we try to leverage rsvd/unused slots. I am aware of that
> you did a lot of clean up in CT firmware which is quite hard in official
> firmware as it also has to support prop. releases. Kalle can answer much better.

There are hard ways to get more space in the firmware, but there are also some
easier ones (un-used members in structs, better natural packing, and such).

If there was a QCA firmware engineer that could promptly discuss these things
with me and apply patches, I can feed them patches.

And, the 10.4 firmware already has some extra space in its tx descriptor that
can be used to report tx-status without much additional code or RAM.  The wave-1 stuff
needs some more serious hacking and does consume more memory.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

