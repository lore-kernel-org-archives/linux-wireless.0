Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1341C10F0E
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 16:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DA062087C
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 16:32:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="slc5t3WI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfDOQc3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 12:32:29 -0400
Received: from [208.74.158.174] ([208.74.158.174]:42268 "EHLO
        mail3.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfDOQc3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 12:32:29 -0400
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id E65E613755B;
        Mon, 15 Apr 2019 09:32:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com E65E613755B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1555345949;
        bh=KPQjphhkZdsNv+AHNHc3H+cFOHBK2m9QScDAZrTOT98=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=slc5t3WISVW2np6BZSjWqMrtbI5dvwoi7SCDt/t3HmZ48ESccHzT+9WfXYHqHrMGU
         ouPGpBZ7b27EmHCdkmMqJuj3DXR3m2qV0CdkVgom83eT9qU/thnlkqTZQpGFQ8Ndcw
         kUhIivTfbUsU1KXvCrpYTyj0c7O3uE9q3ve+605g=
Subject: Re: [PATCH 1/2] wireless: Support auth-at-ms timer in sta-info
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20190412213710.17292-1-greearb@candelatech.com>
 <cf95c43bcfe1bd4d8fbc8aca8ecc65dac9eeae0c.camel@sipsolutions.net>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <a8865096-f19e-608f-13c2-08036876d316@candelatech.com>
Date:   Mon, 15 Apr 2019 09:32:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <cf95c43bcfe1bd4d8fbc8aca8ecc65dac9eeae0c.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 4/15/19 4:15 AM, Johannes Berg wrote:
> On Fri, 2019-04-12 at 14:37 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Report time stamp of when sta became authenticated.
> 
> You didn't actually implement this ;-)
> 
> Did you mean associated?
> 
>> + * @auth_at_ms: time in ms of the last assoc -> auth transition.
> 
> There's commonly not really such a transition?

Oh, I guess AUTHORIZED is only when doing .1x authentication?  My test case
was (luckly?) doing that, so I didn't notice the bug.

I'll change to setting the timer in the ASSOC state instead.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

