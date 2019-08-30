Return-Path: <SRS0=jb13=W2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B6A6C3A5A4
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Aug 2019 11:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17C6E2186A
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Aug 2019 11:03:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="eFtQ08oj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfH3LDQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 30 Aug 2019 07:03:16 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34106 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfH3LDQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Aug 2019 07:03:16 -0400
Received: by mail-wm1-f67.google.com with SMTP id y135so4138388wmc.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Aug 2019 04:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/6rJXpyU5uSX2XcxIQgLawITemN1VdIxT4IEdo6B2gU=;
        b=eFtQ08ojUVQt8ea227d+CptaFRmOsqkNVx4PccUle/1H7XSsdAPi35yI/aFjzgkb/E
         SFw9r/Zc/BaQCeB6T0qv0TKVGaqzCnEMBIp1kunajZIKAXiCPBUds4FtRcAi7pIAEXVO
         hy4ZFw5Vp2xCWnk05Q+70noj7qvT4ZX3eOJaI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/6rJXpyU5uSX2XcxIQgLawITemN1VdIxT4IEdo6B2gU=;
        b=c99GHguAGIS7LBy8mQhSoRlJ6SJc/FLXnUPuj+ujc0FXUT8QVCXfAGL5BxLV2rJN04
         L2AktI38vitUsiwKZDRYtsrTVTF2DRtvaXKeKjf/3O7blEd5WO9/+i/xFFjm9UKHzip1
         okZmMDUWZ8OCGRldfwpBhg9rvF032cRlVWnaEZaFYbhV5AVemeUZztiL6ImnMuyxWkxm
         n9+he14qB+qR1/aVMtlzlG5fRwbKZzVMhAaxX3pugi1wRFyt5RU2eFpFn9LkLiE634Eq
         LyhPhomkjzMc7Y8MEL2cbLFqcC7ByFqcxPtJ02vCrF/z5QMBZllsdTJ17kMVfU5qEJIP
         brYg==
X-Gm-Message-State: APjAAAWsLvBLZ4Iu4TUn9JQBEOKmdL2JFYwIsJkKfO537W/DIor2wC3e
        8i17XO275GiuBBxSQaoXrztxQA==
X-Google-Smtp-Source: APXvYqwUSppxmHaK5pBfo/uspfEaSwnP5WUOooA/LJ7D9lPEw+7kAzTBoU+hBWhcKfRre9SfxWQiVA==
X-Received: by 2002:a1c:4c04:: with SMTP id z4mr17550297wmf.1.1567162994262;
        Fri, 30 Aug 2019 04:03:14 -0700 (PDT)
Received: from [10.176.68.244] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id n9sm5834526wrp.54.2019.08.30.04.03.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 04:03:13 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: Add new helper function for channels
To:     Johannes Berg <johannes@sipsolutions.net>,
        Amar Singhal <asinghal@codeaurora.org>, jouni@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, jjohnson@codeaurora.org,
        rmanohar@codeaurora.org
References: <1567115381-7831-1-git-send-email-asinghal@codeaurora.org>
 <01082dca-8d71-c674-1f61-ab5d7e07c007@broadcom.com>
 <6222b9d9d125c4c3a9f60cc0fe73cef2011b9959.camel@sipsolutions.net>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <9a9c8024-a9f9-72f9-557a-c185dca9c15c@broadcom.com>
Date:   Fri, 30 Aug 2019 13:03:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6222b9d9d125c4c3a9f60cc0fe73cef2011b9959.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 8/30/2019 12:41 PM, Johannes Berg wrote:
> On Fri, 2019-08-30 at 12:40 +0200, Arend Van Spriel wrote:
> 
>>> +EXPORT_SYMBOL(ieee80211_channel_op_class_to_frequency);
>>
>> The function ieee80211_operating_class_to_band() uses ranges within
>> switch statement, eg.:
>>
>>           case 128 ... 130:
>>                   *band = NL80211_BAND_5GHZ;
>>                   return true;
> 
> No that you remind me - how is this new function not just a composition
> of the existing ones?
> 
> i.e. just convert the op_class to band first, and then (band, channel)
> to freq?

yup. that would have my preference actually.

Regards,
Arend
