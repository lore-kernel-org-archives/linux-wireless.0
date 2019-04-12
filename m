Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 158F9C10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 21:49:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D587B2082E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 21:49:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="II0nuSM4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfDLVtR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 17:49:17 -0400
Received: from [208.74.158.174] ([208.74.158.174]:33634 "EHLO
        mail3.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbfDLVtR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 17:49:17 -0400
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 4C48013C2B9;
        Fri, 12 Apr 2019 14:49:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 4C48013C2B9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1555105756;
        bh=XJowCejKfvFg/9ruHg/KEc3qfdNXjqNBCfykh4cV2kE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=II0nuSM4AFIGXh+Y8qpgpXdvgVuW0oKfrd/jD0rpZveU7U+x0AsiZ0Dn/4FDf4KxT
         VPXhC1SZsr+DZmTHrZZ0OnEB1eMf+yCFJWa0wZxOyqubTksNcWc43BJSmY/0gkDQep
         hLYUt0qt6N0OkaOPwHmpGR2ifeJGveKUvOe8yRco=
Subject: Re: [PATCH 2/2] iw: Print current time in station info dump
To:     Kirtika Ruchandani <kirtika@google.com>
Cc:     linux-wireless@vger.kernel.org
References: <1555105210-22996-1-git-send-email-greearb@candelatech.com>
 <1555105210-22996-2-git-send-email-greearb@candelatech.com>
 <CAOXD1ifE_rxU0fV6tXK2WpdOU2x9-b0J4cGsuqf3whi7YapBzA@mail.gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <ab7f61a1-0af6-a754-d9a0-388ebd0c8f15@candelatech.com>
Date:   Fri, 12 Apr 2019 14:49:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAOXD1ifE_rxU0fV6tXK2WpdOU2x9-b0J4cGsuqf3whi7YapBzA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 4/12/19 2:43 PM, Kirtika Ruchandani wrote:
> On Fri, Apr 12, 2019 at 2:40 PM <greearb@candelatech.com> wrote:
>>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> This lets us more precisely calculate the absolute timestamp
>> of last-rix (ie, now - idle).
> 
> Can you use 64-bit timestamps? struct timeval suffers from the
> overflow after 2038 problem.

What is the preferred API to do this?  Whatever it is, it would need
to compile on old crufty systems as well.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

