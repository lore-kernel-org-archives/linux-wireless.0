Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12473C432BE
	for <linux-wireless@archiver.kernel.org>; Fri, 27 Aug 2021 08:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E11E760187
	for <linux-wireless@archiver.kernel.org>; Fri, 27 Aug 2021 08:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244448AbhH0IsG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 27 Aug 2021 04:48:06 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:64906 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbhH0IsD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Aug 2021 04:48:03 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630054035; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=nuWZZjA/CahwoY0D3QK4iRrNop3uymnaep3vKQXmInE=;
 b=SO4zFHN8RMj+YmBtUHFe0zvmPlBw5991vL6aYghkOLd6pPY3g/ul949PqSeXXQey2b8B9ydQ
 /Ec9JqY7dqwEPhoqU7fXN5yyPMZBlgfAmVwQ2CGOZg+BG7SwCnDq/0qnWOhJo4NBh3Qi3UmQ
 iX3/ESjafkk7ZtkUts7NesUj1KE=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 6128a692d15f4d68a2db895d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 27 Aug 2021 08:47:14
 GMT
Sender: wgong=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 200C2C43616; Fri, 27 Aug 2021 08:47:14 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: wgong)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B3DC0C4338F;
        Fri, 27 Aug 2021 08:47:13 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 27 Aug 2021 16:47:13 +0800
From:   Wen Gong <wgong@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 8/8] mac80211: save transmit power envelope element and
 power constraint
In-Reply-To: <e985d4aa1556e9660cc7d4a3ff348d64764c4ad8.camel@sipsolutions.net>
References: <20210820122041.12157-1-wgong@codeaurora.org>
 <20210820122041.12157-9-wgong@codeaurora.org>
 <dfe27f657b4615369cf751d394f5cba75f5fdcc1.camel@sipsolutions.net>
 <25fcede26b99604a03d0b321b7120db4@codeaurora.org>
 <48ad47869e703cbef437378c508d6a5b64c160ae.camel@sipsolutions.net>
 <db22a4cb9a07e3845a50f436c7052feb@codeaurora.org>
 <0680b508a7864e02f55d763851f7460baa73b53f.camel@sipsolutions.net>
 <110489059796b17849d0f32fb5189828@codeaurora.org>
 <27680423e824dd67217cc6f1e62f9ac0a1af78f2.camel@sipsolutions.net>
 <01d9e4eadbb0d87edbc026fc719858a3@codeaurora.org>
 <3483aeb87a81dea538af3a2640cd49831274320f.camel@sipsolutions.net>
 <40e8c88cec2d3601afbfe187c57fac6b@codeaurora.org>
 <e985d4aa1556e9660cc7d4a3ff348d64764c4ad8.camel@sipsolutions.net>
Message-ID: <c2362285a37a21bb3d4131d84bd3db60@codeaurora.org>
X-Sender: wgong@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2021-08-27 16:30, Johannes Berg wrote:
> On Fri, 2021-08-27 at 16:28 +0800, Wen Gong wrote:
>> 
>> the TPE is only 8 pointer in the struct ieee802_11_elems.
> 
> 
> I know, but it's showing _just_ above the threshold for the warning 
> now,
> so if it was _just_ below the threshold before, adding 64 bytes could
> still do that. 64 bytes is a lot, after all, the threshold is only 512 
> I
> think.
> 
Yes, I will change to below in next version.
"struct ieee802_11_elems *elems = kzalloc(sizeof(*elems))"
> johannes
