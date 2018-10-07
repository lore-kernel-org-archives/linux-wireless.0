Return-Path: <SRS0=9HFQ=MT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34A8CC46475
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 00:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF4A520834
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 00:57:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MXfalaP4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF4A520834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbeJGIBw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 7 Oct 2018 04:01:52 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39492 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbeJGIBw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Oct 2018 04:01:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SLdjYTeu6muTGx7U+bGZmODo3htucla5zxxrrlAOijI=; b=MXfalaP4h4BfvpVpHZQHI/a7f
        e2sPlLnEcATpoFjgE8dLITl9WClU66y/XnL2V2L9eZdTp3sA0IFRKhYabn4U7Gy/W/7Q5X9rKawoI
        4cLn33m9Qiymziyyl5WG4QZTj0wLy8Bj/QY348u093z90TP10klNaoUtzAPTYp+2ryuyJZvCmvo8D
        JmQjeffmup49dJ7ccgkQWmcafI0zAEfyv8jfLivu0zFdAeBklJOsqpxmDfkxY7KdXCDY0ZhH5QE9k
        tGbczLS2siW92PBuROlothaLotuQpDpIivf5PKuS6fZ1Bmxtn/JhCCFrLrx1VqQXaMEguEbsfsb+6
        nJVoULXUg==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=midway.dunlab)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g8xN2-0003sV-Qr; Sun, 07 Oct 2018 00:56:32 +0000
Subject: Re: [linuxwifi] [PATCH] fix iwlwifi on old cards in v4.19 was Re:
 4.19-rc[23] iwlwifi: BUG in swiotlb
To:     "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
References: <0c5e53e5-2afa-8d38-0b48-272c670c4bc5@infradead.org>
 <1536651177.3224.106.camel@sipsolutions.net> <20180916093414.GA4299@amd>
 <20180916094142.GB4299@amd> <20180916095535.GA4245@amd>
 <20180916095935.GA4388@amd>
 <0BA3FCBA62E2DC44AF3030971E174FB301336B20F4@HASMSX111.ger.corp.intel.com>
 <5c46135d-99ae-5c63-5cc9-f066cec6543c@infradead.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e4b4fb1a-5f78-378f-dec8-529bc92c2e08@infradead.org>
Date:   Sat, 6 Oct 2018 17:56:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <5c46135d-99ae-5c63-5cc9-f066cec6543c@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/6/18 5:44 PM, Randy Dunlap wrote:
> On 9/16/18 3:12 AM, Grumbach, Emmanuel wrote:
>>>
>>>
>>> .max_tfd_queue_size was ommited for old cards, leading to oops in swiotlb.
>>>
>>> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>>>
>>
>> I picked it up in our tree with minor commit message fixes.
>> I also added the Fixes tag for stable.
>>
>> Thanks!
> 
> Hi,
> Are we going to see this fix in 4.19?  hopefully.

Sorry, I see it now.

thanks,
-- 
~Randy
