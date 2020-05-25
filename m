Return-Path: <SRS0=BuOi=7H=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 238BFC433E0
	for <linux-wireless@archiver.kernel.org>; Mon, 25 May 2020 16:14:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECFA72073B
	for <linux-wireless@archiver.kernel.org>; Mon, 25 May 2020 16:14:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="kaqFpcQh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391223AbgEYQOI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 May 2020 12:14:08 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:58942 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgEYQOI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 May 2020 12:14:08 -0400
Received: from [192.168.254.4] (unknown [50.34.197.93])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 2FC1913C2B0;
        Mon, 25 May 2020 09:14:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 2FC1913C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1590423247;
        bh=lETtZcwZzP9M6Ntf5ZfshL0QfvgFYjUadyEO5zFWooQ=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=kaqFpcQhKn6UswEmtyOTMAjimoM95ameTl3UXMpIp3T6Wr6NdSrYhQOg1VmuJEv9f
         2QyJ9PfuBIAh+LdM6HdQkqinA9uPU7eS5mWk/v3Jo/I23dSHY/Rx89+RiLrHDiC9eg
         R6CPTMeB56SzdFMKy9MbjdI+ybBwYxhIG+wMldyY=
Subject: Re: mac80211 spam and deadlock on OpenWrt
To:     Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <e5caffb7-b387-9010-8445-54992ccf6e4c@candelatech.com>
 <83abd321a059b4bed470775333f3dbc598661c68.camel@sipsolutions.net>
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <a1fa1a38-4985-6311-fd06-8353ef7275ff@candelatech.com>
Date:   Mon, 25 May 2020 09:14:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <83abd321a059b4bed470775333f3dbc598661c68.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 05/25/2020 02:25 AM, Johannes Berg wrote:
> On Wed, 2020-05-13 at 06:56 -0700, Ben Greear wrote:
>> Hello,
>>
>> I've been running some stress tests against OpenWrt APs.  My AP partially died yesterday
>> during a test and did not recover.  It looks like firmware became non responsive,
>> but then it could not recover due to what I think is bugs I fixed long ago in
>> the kernel that I normally use.  The OpenWrt image is using my ath10k-ct driver and firmware,
>> but stock OpenWrt kernel/mac80211 as far as I know.
>>
>> I think there are several issues:
>>
>> 1)  The WARN-ON about check-sdata-in-driver should be a warn-on-once.  Spamming serial
>>    console logs like this is both very slow and also useless for debugging.
>>
>> I posted a patch with this title some time back to mitigate this problem:
>> "mac80211: Don't spam kernel with sdata-in-driver failures."
>>
>> 2)  I suspect that the ensuing lockup may be fixed by this patch I posted
>> back in 12/1/2016:
>> "mac80211:  do not iterate active interfaces when in re-configure"
>>
>> I have been running both of those patches since posting them to the list, so they have good
>> soak time in some strenuous wifi usage cases.
>
> Huh, these are kinda old I guess.
>
> Can you repost them?

For the warning log-spam, you could grab patch 3 and 4 from this series I posted late last year:

[PATCH 00/10] Ben's grab bag of mac80211 patches

I think patch 5 in there is also nice to have, we passed email about it, but not sure it ever
made it upstream.

I'll dig out the 'iterate active' patch and post it stand-alone.

Thanks,
Ben

>
> johannes
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
