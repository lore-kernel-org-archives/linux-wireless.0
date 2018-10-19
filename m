Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ABDAECDE43
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 18:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA5E32086E
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 18:32:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA5E32086E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=candelatech.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbeJTCjs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 22:39:48 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:44146 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727193AbeJTCjs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 22:39:48 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 0351940A5C4;
        Fri, 19 Oct 2018 11:32:30 -0700 (PDT)
Subject: Re: Where to report mpdus tx vs failed?
To:     Steve deRosier <derosier@gmail.com>
References: <104c8823-e867-6244-a528-979482c7fccc@candelatech.com>
 <CALLGbRKOLVg0bLhezLkEA_MPCg_S1L-drJNy3fSWxPJXJV+ajQ@mail.gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <93888bdc-b27d-78db-7fde-e881fa74c99b@candelatech.com>
Date:   Fri, 19 Oct 2018 11:32:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.0
MIME-Version: 1.0
In-Reply-To: <CALLGbRKOLVg0bLhezLkEA_MPCg_S1L-drJNy3fSWxPJXJV+ajQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/19/2018 11:25 AM, Steve deRosier wrote:
> On Fri, Oct 19, 2018 at 10:34 AM Ben Greear <greearb@candelatech.com> wrote:
>>
>> While debugging rate-ctrl in ath10k, I found the amount of mpdus transmitted vs failed
>> ratio useful.  Probably more useful than retries since retries could count an attempt at
>> 80Mhz followed by HW trying a 40Mhz rate (afaik).
>>
>> Is there a good way to report this up the stack in a useful manner?  I currently only
>> get this stat for the first frame in an transmitted ampdu.
>>
>
> debugfs? Is it useful for someone working on it, like a sysadmin or
> kernel programmer?  Or is it useful for programs to know?  In the
> first case I'd say debugfs, in the second case I'd suggest it goes in
> some tx stats structure that is reported by netlink.
>
> Also, is it something that is given by (or should be given by) all
> drivers, or is it very driver-specific?

I was hoping I could fit it into some existing stat.  It is sort of like
retries, so that will be my first attempt.

By investigating an RF sniff, I notice the 9880 ath10k (with my fw
and driver, at least), will retransmit about 30% of the frames when running
at least one of my test cases (small udp frame transmit to AP that can only do about mcs5 or mcs7
reliably at 3x3 nss).

I'd like to report this stat in my wifi test tool if nothing else, but
likely other people would make use of it as well.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

