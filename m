Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE99CC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 07:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D441206DF
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 07:21:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Nlknxib4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfCKHVQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 03:21:16 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:57084 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfCKHVQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 03:21:16 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id x2B7L5e5098203;
        Mon, 11 Mar 2019 02:21:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1552288865;
        bh=67q5ZnH1MQkGKYWJOQqRKqAo9/CXJhYr2puCNPSeLFg=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Nlknxib4iEm/TLMUZ0BvaQgMmueb70X43T19+yzbS0pNwyLKmVT7IJI46SUXTiL1m
         dL+0r+J37vOPHZGwvHwCBai5RhkIOnbFqUToICaAwLAklrEHoI/k5EebeP7ozH6FJe
         mtLCf3zF0a8zzoJffZpi5CyiaGwXw2aKEcX1Zqqs=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x2B7L5sw123606
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 11 Mar 2019 02:21:05 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Mon, 11
 Mar 2019 02:21:04 -0500
Received: from dlep33.itg.ti.com (157.170.170.75) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_0,
 cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.1.1591.10 via Frontend Transport;
 Mon, 11 Mar 2019 02:21:04 -0500
Received: from [172.24.190.89] (ileax41-snat.itg.ti.com [10.172.224.153])
        by dlep33.itg.ti.com (8.14.3/8.13.8) with ESMTP id x2B7KvrF014354;
        Mon, 11 Mar 2019 02:20:58 -0500
Subject: Re: Nokia N900: wl1251 spi3.0: EOW timed out on
To:     Merlijn Wajer <merlijn@wizzup.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     linux-omap <linux-omap@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>
References: <3819003e-2ab3-0325-de0d-9fa07b51ee9f@wizzup.org>
 <436a9a35-539a-3fe8-2225-36b45c7e5412@wizzup.org>
 <165d492e-435b-40a8-f784-5f2d08803514@ti.com>
 <1b2918b4-1765-5aba-4752-1d04bdfea925@wizzup.org>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <ddfababf-3d3c-85c1-e1d8-762b4c41f19c@ti.com>
Date:   Mon, 11 Mar 2019 12:51:57 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <1b2918b4-1765-5aba-4752-1d04bdfea925@wizzup.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 11/03/19 12:53 AM, Merlijn Wajer wrote:
> Hi,
> 
> On 10/03/2019 05:16, Vignesh Raghavendra wrote:
>> Hi.
>>
>> On 10-Mar-19 6:23 AM, Merlijn Wajer wrote:
>>>
>>> Hi,
>>>
>>> On 10/03/2019 00:22, Merlijn Wajer wrote:
>>>> Hi,
>>>>
>>>> I just migrated to Linux 5.0  (from 4.15) on my Nokia N900, and I'm
>>>> getting a lot of messages like this:
>>>>
>>>>> wl1251 spi3.0: EOW timed out
>>
>>
>> Could you try if this patch fixes the issue? This is part of latest mainline tree but not part of 5.0:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=baf8b9f8d260c55a86405f70a384c29cda888476
> 
> This seems to fix the issue. Would it make sense to queue this for an
> upcoming fixes release for 5.0?
> 

Patch carries "Cc: stable@vger.kernel.org" tag. So, will be backported
to stable trees. It will be part of one of 5.0.y stable releases.

> Cheers,
> Merlijn
> 

-- 
Regards
Vignesh
