Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A88C677FC
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 17:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A940620652
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 17:26:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A940620652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbeJLAyk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 20:54:40 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50212 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbeJLAyk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 20:54:40 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BD79ED5A21AAE;
        Fri, 12 Oct 2018 01:26:24 +0800 (CST)
Received: from [127.0.0.1] (10.202.226.41) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.399.0; Fri, 12 Oct 2018
 01:26:20 +0800
Subject: Re: Question on FIELD_PREP() for static array
To:     Johannes Berg <johannes@sipsolutions.net>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        <jakub.kicinski@netronome.com>, <yamada.masahiro@socionext.com>,
        "Arnd Bergmann" <arnd@arndb.de>, <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <c8594a75-964b-01b0-382e-88bcb5b462f2@huawei.com>
 <40fd3d963820bf96547fa9b5e8c171c6a339674e.camel@perches.com>
 <1539195207.3687.178.camel@sipsolutions.net>
 <830ff9fb-07b1-86b6-4f57-af549a37a8c0@huawei.com>
 <1539271422.3687.217.camel@sipsolutions.net>
 <ef2d37ab-bef4-fd3f-a6f7-e68e60695e9b@huawei.com>
CC:     <linux-wireless@vger.kernel.org>, <nbd@nbd.name>
From:   John Garry <john.garry@huawei.com>
Message-ID: <ec680438-babe-4ee7-988b-c2466a11e789@huawei.com>
Date:   Thu, 11 Oct 2018 18:26:12 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.3.0
MIME-Version: 1.0
In-Reply-To: <ef2d37ab-bef4-fd3f-a6f7-e68e60695e9b@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.41]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>> Yeah, I have a patch now to reference it, but I don't see anything from
>> -Wvla with gcc 8.1?
>
> I'm using a 7.3.1-based toolchain
>
>>
>> See
>> https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git/commit/?id=3d7af878357acd9e37fc156928106f1a969c8942
>>
>> and its parent.
>>
>> Do you see -Wvla warnings there? Any idea how I could reproduce them?
>
> I'll try it, thanks

3d7af878357acd9e37f builds ok. However I am using 20181010-next (I'm not 
sure what yours is based on), and I just noticed that it includes this 
new guy:
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/Makefile?h=next-20181011&id=bc5701d8e27fd8beaf895176982fc6a97878f3b8

When I cherry-pick this onto your codebase@3d7af878357acd9e37f, the 
82011 code has warns.

Thanks,
John


>
> John
>
>>
>> johannes
>>
>> .
>>
>


