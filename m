Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B282FC43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 18:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DA6F21547
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 18:47:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DA6F21547
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=candelatech.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbeI0BBY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 21:01:24 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:59200 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbeI0BBX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 21:01:23 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 6896740A539;
        Wed, 26 Sep 2018 11:47:03 -0700 (PDT)
Subject: Re: How many null-data probes on connection loss?
To:     Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <9a1447d9-9a61-dc2d-0101-33c6bdeb946f@candelatech.com>
 <1537951137.28767.5.camel@sipsolutions.net>
 <fc564b2e-b6f2-75db-a2d9-99ea55a63c4a@candelatech.com>
 <1537986415.28767.17.camel@sipsolutions.net>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <7ed031b0-19d9-46db-33d9-082999e5ed22@candelatech.com>
Date:   Wed, 26 Sep 2018 11:47:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.0
MIME-Version: 1.0
In-Reply-To: <1537986415.28767.17.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 09/26/2018 11:26 AM, Johannes Berg wrote:
> On Wed, 2018-09-26 at 11:04 -0700, Ben Greear wrote:
>
>> I have been running with mac80211/mlme.c's max_nullfunc_tries set to 5 for many years.
>> Long ago it helped with connectivity issues with lots of vdevs and and/orloaded APs
>> if I recall correctly.
>
> That's different, that's the number of distinct frames mac80211 will
> send.
>
> I thought you were asking about *retries*.

Well, it retries the probe action 5 times in my case.

I am also asking about total amount of retried frames on the air.

>> In fact, I see 62 frames captured on air all with the same sequence number
>> in the test I just did, and subsequent frames with the next seq-no are sent
>> immediately after the first one.  The frames are all right after each other, so
>> I guess this is probably firmware doing lots of HW retransmits and then *also*
>> doing software retransmits in the firmware (my reading of mlme.c indicates it should
>> only probe every 500ms).
>
> Yes.
>
>> I think I'll start by making sure the firmware does not do software retransmits
>> for frames from the driver (self-gen frames are OK to be retransmitted I guess).
>
> You do want it to be doing retries for frames from the driver, since you
> want it to recover from temporary collisions with a microwave and
> whatnot ... just not *that many*, I guess.

 From what I can tell so far, my firmware has this sort of logic:

frame from stack to the driver
   -> send to firmware
   -> in firmware, hardware will do up to X retries (maybe 16 or so, need to check)
   -> On failure, the firmware may re-queue the packet (firmware-software retry)
   -> back to hardware retries (~32 frames on air at this point)
   ...
   Eventually tx-fail notification is sent back to the driver one way or another.

I am thinking it would be best to have the software retry in the firmware
disabled.

Then, when mac80211 sends a null-data frame, you would see at most about
16 of them on air, every 500ms or so until it recovers or considers the
connection lost.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

