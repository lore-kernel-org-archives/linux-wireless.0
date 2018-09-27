Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25EDEC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCD92215F0
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:32:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DCD92215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=candelatech.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbeI0VvR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 17:51:17 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:54150 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbeI0VvR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 17:51:17 -0400
Received: from [192.168.1.47] (unknown [50.34.223.145])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id B171F40B4B8;
        Thu, 27 Sep 2018 08:32:24 -0700 (PDT)
Subject: Re: How many null-data probes on connection loss?
To:     Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <9a1447d9-9a61-dc2d-0101-33c6bdeb946f@candelatech.com>
 <1537951137.28767.5.camel@sipsolutions.net>
 <fc564b2e-b6f2-75db-a2d9-99ea55a63c4a@candelatech.com>
 <1537986415.28767.17.camel@sipsolutions.net>
 <7ed031b0-19d9-46db-33d9-082999e5ed22@candelatech.com>
 <1537987703.28767.22.camel@sipsolutions.net>
 <e3c18a8d-9a58-54c5-9aaa-b778299f527b@candelatech.com>
 <1538032363.14416.2.camel@sipsolutions.net>
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <a409f0b7-5a91-1add-484d-588a554f0cd4@candelatech.com>
Date:   Thu, 27 Sep 2018 08:32:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1538032363.14416.2.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 09/27/2018 12:12 AM, Johannes Berg wrote:
> On Wed, 2018-09-26 at 15:21 -0700, Ben Greear wrote:
>>
>> Now only 4 retries per frame, but it seems mac80211 is all 5 of its
>> null-data probes within a few miliseconds.  Is that expected, or should
>> there be a bit more pause between each of the probe requests to better
>> weather periodic network glitches?
>
> Hmm. That's a good point, but it seems we've never considered this
> before. This must be a consequence of retrying immediately on lost ACK,
> but I guess I could see that delaying it for a little bit would make
> sense.
>
> We do delay it if there's no reliable ACK reporting, IIRC, but if we
> know it failed for sure ...
>
> It seems though that if there's some noise or so on the channel you
> wouldn't be transmitting, so what kind of "network glitches" might
> affect this? AP going away unexpectedly for some time?

I am thinking that if the 'timeout' is 500ms, and the number of probes is 2
(the default values), then it should probe at 0ms, and at 250ms, and then finally
fail at 500ms if nothing was received.  In otherwords, X probes, x/timeout apart.

I should have a patch to make it work more like I think it should work
later today for discussion.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
