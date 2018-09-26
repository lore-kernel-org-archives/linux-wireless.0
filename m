Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A154AC43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 18:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F24821547
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 18:04:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F24821547
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=candelatech.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbeI0ASv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 20:18:51 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:57874 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbeI0ASv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 20:18:51 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 86F1A40A539;
        Wed, 26 Sep 2018 11:04:41 -0700 (PDT)
Subject: Re: How many null-data probes on connection loss?
To:     Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <9a1447d9-9a61-dc2d-0101-33c6bdeb946f@candelatech.com>
 <1537951137.28767.5.camel@sipsolutions.net>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <fc564b2e-b6f2-75db-a2d9-99ea55a63c4a@candelatech.com>
Date:   Wed, 26 Sep 2018 11:04:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.0
MIME-Version: 1.0
In-Reply-To: <1537951137.28767.5.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 09/26/2018 01:38 AM, Johannes Berg wrote:
> On Tue, 2018-09-25 at 16:12 -0700, Ben Greear wrote:
>> While testing out some other issue, I noticed that my ath10k system creates
>> several hundred null-data probes when I abruptly down the AP the station
>> is connected to.
>>
>> I guess this is because I use the mac80211 stack to handle the probes, and
>> the firmware then retries each mac80211 probe many times.
>>
>> So, in the case where mac80211 is sending a null-data probe, is the assumption
>> that the driver will try each frame exactly once?
>
> Not really, it should be treated like any other management frame.
>
>> Or is several hundred frames expected?  I'm guessing the former, but before I go
>> hacking firmware, I thought I would ask...
>
> Certainly not several hundred, but maybe a dozen? I think iwlwifi uses
> 16, and minstrel would set up max_rate_tries, which drivers set to
> somewhere between 1 and 18? One seems s a bit low, mt76?
>
> johannes
>

I have been running with mac80211/mlme.c's max_nullfunc_tries set to 5 for many years.
Long ago it helped with connectivity issues with lots of vdevs and and/orloaded APs
if I recall correctly.

In fact, I see 62 frames captured on air all with the same sequence number
in the test I just did, and subsequent frames with the next seq-no are sent
immediately after the first one.  The frames are all right after each other, so
I guess this is probably firmware doing lots of HW retransmits and then *also*
doing software retransmits in the firmware (my reading of mlme.c indicates it should
only probe every 500ms).

I think I'll start by making sure the firmware does not do software retransmits
for frames from the driver (self-gen frames are OK to be retransmitted I guess).

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

