Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB256C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 15:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC94820685
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 15:14:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC94820685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=candelatech.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbeI1VjF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 17:39:05 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:53384 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728451AbeI1VjF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 17:39:05 -0400
Received: from [192.168.1.47] (unknown [50.34.223.145])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 56FDA40A5CB;
        Fri, 28 Sep 2018 08:14:47 -0700 (PDT)
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
 <a409f0b7-5a91-1add-484d-588a554f0cd4@candelatech.com>
 <1538119161.14416.57.camel@sipsolutions.net>
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <da09e014-3335-dc46-0e94-ee7ce3f318e7@candelatech.com>
Date:   Fri, 28 Sep 2018 08:14:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1538119161.14416.57.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 09/28/2018 12:19 AM, Johannes Berg wrote:
> On Thu, 2018-09-27 at 08:32 -0700, Ben Greear wrote:
>
>>> It seems though that if there's some noise or so on the channel you
>>> wouldn't be transmitting, so what kind of "network glitches" might
>>> affect this? AP going away unexpectedly for some time?
>>
>> I am thinking that if the 'timeout' is 500ms, and the number of probes is 2
>> (the default values), then it should probe at 0ms, and at 250ms, and then finally
>> fail at 500ms if nothing was received.  In otherwords, X probes, x/timeout apart.
>
> That seems reasonable I guess. Although I'm not sure - perhaps once we
> know it failed we *do* want to try a bit quicker again? Otherwise we
> have a totally dead period there in the meantime, no?

I don't think the tx path stops just because the mlme decides probes
are timing out, so if AP is really functional, you won't have a dead period.

If it is dead, then the sooner you probe and discover timeout and disconnect,
the sooner you can re-connect to some better AP (assuming one exists).  A
false disconnect due to missing a few probes would be disruptive though, and
probing very often in idle situations would use more airtime, so
of course there is a trade-off.

While watching the sniffer, it seems the initial mlme probe happens about
3 seconds after I admin down the AP, and then disconnect is about 1s after
that (I have my timeout set to 1000ms instead of default 500ms, and I have retry
count set to 5 instead of 2.

Did you see that patch I posted?  It looks good in the sniffer and logs,
as far as I can tell....

Thanks,
Ben

>
> johannes
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
