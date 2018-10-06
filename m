Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E28ECDE43
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 22:00:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AB2F208E7
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 22:00:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iTiE7Qpr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4AB2F208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbeJGFFY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 7 Oct 2018 01:05:24 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:39360 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbeJGFFY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Oct 2018 01:05:24 -0400
Received: by mail-ot1-f68.google.com with SMTP id l58so1263705otd.6;
        Sat, 06 Oct 2018 15:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Tp075FmuIlvyHV2/rq/ozvYfvFRoFkD4DDzfCZt/M14=;
        b=iTiE7Qprz8QQqh80RdO/ROViw3DnFk2y9GXKWcfKWCQgzTSHK2VUjiH8D3d19XwPRX
         OLs/UumrF4UBaJlTN2OAKfqwdRn3Tc1qb/PbXgC4/j4U3gaB95Z3wchtEJYbZG2RMUns
         1eR31KbVozzAlxq+Nok9WiIMjE4NrzUM1GBKqX8rQyrxruxdJxQHzmJTNBTgMoB+KzsM
         Sa3dkgvXf1Vasm6PVPEki/PI3EIcNSUIzBVbmXnL4DvpdXPD1PyW9YZZySI76VLZS1mu
         A6x72dEEduh3NDZ1wXZJ6Rjde9+FcH8obmUXs5dY7MnWw1utIFx5hsekxhVDahPC0Hc4
         uqfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tp075FmuIlvyHV2/rq/ozvYfvFRoFkD4DDzfCZt/M14=;
        b=rE0EUmOyOyI0PQ/gV3R8VN8nqvQNJnc6SDhl0x2PijsR4yYSxvCyEKLR46MRfk6zzo
         O55evXT2952503v+WnYdwfVLVmVI27lRNjtRwbzkeO+sOK7vSWk1hLyFCaQsq2bTQKzI
         pZllSR0m60CHmE8C3k8xJsQT3ogNIWPm0LTenUFdhmQ46DmXJ6N0eOGrhJik7nE+a+Hs
         EAjAlOaUbHPG3n/yFWblJP1S+RNbeCNKuYA9VGdNIiEdnuhIVInrYQ9EFMSbGtZi4S4L
         yBxftjDCYHwK1nsd7FwGtGoowfHZpuq5qnITg/5AI/Wh8gnbJQzWNOzR1MaYSO/IWm1R
         G1Dw==
X-Gm-Message-State: ABuFfoiPK5oPWZWTAB6/rahthtCwl0QzmfyjBxmLjF4gs4llOtkgx8pR
        8bznBxka0N2kgSeFlhJbrgf2eVro
X-Google-Smtp-Source: ACcGV60N2tf45CVkh3fNwskOc77mWwgeece/gzgxjWZw0GJ7pZgw1I3NPE9E9kec4OqAxFqk0UR7FA==
X-Received: by 2002:a9d:39f7:: with SMTP id y110-v6mr10315034otb.330.1538863227686;
        Sat, 06 Oct 2018 15:00:27 -0700 (PDT)
Received: from [192.168.1.107] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id s5sm1604364otc.40.2018.10.06.15.00.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Oct 2018 15:00:26 -0700 (PDT)
Subject: Re: [PATCH] rtlwifi: rtl8821ae: add in a missing break in switch
 statement
To:     Joe Perches <joe@perches.com>, Kalle Valo <kvalo@codeaurora.org>,
        Colin King <colin.king@canonical.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Tsang-Shian Lin <thlin@realtek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20181006184246.29985-1-colin.king@canonical.com>
 <87r2h2euuy.fsf@kamboji.qca.qualcomm.com>
 <a5113f03-7ac8-4be6-3d1c-5ba74639121e@lwfinger.net>
 <4e376919169bad265dc02040ae02548d2ac6c503.camel@perches.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <a4286648-dda5-eb46-97bf-f0314ec2d113@lwfinger.net>
Date:   Sat, 6 Oct 2018 17:00:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <4e376919169bad265dc02040ae02548d2ac6c503.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/6/18 3:17 PM, Joe Perches wrote:
> On Sat, 2018-10-06 at 15:05 -0500, Larry Finger wrote:
>> On 10/6/18 2:30 PM, Kalle Valo wrote:
>>> Colin King <colin.king@canonical.com> writes:
>>>
>>>> From: Colin Ian King <colin.king@canonical.com>
>>>>
>>>> The switch case RATR_INX_WIRELESS_MC has a missing break, this seems
>>>> to be unintentional as the setting of variable ret gets overwritten
>>>> when the case falls through to the following RATR_INX_WIRELESS_AC_5N
>>>> case.  Fix this by adding in the missing break.
>>>>
>>>> Detected by CoverityScan, CID#1167237 ("Missing break in switch")
>>>>
>>>> Fixes: 3c05bedb5fef ("Staging: rtl8812ae: Add Realtek 8821 PCI WIFI driver")
>>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>>>> ---
>>>>    drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c | 1 +
>>>
>>> Is the fixes line correct? This patch is not for staging.
>>
>> No, the correct fixes commit is 21e4b0726dc67 (" rtlwifi: rtl8821ae: Move driver
>> from staging to regular tree").
>>
>> This driver was initially placed in staging as it was needed for a special
>> project, which is the commit that Colin used. As the patch subject states, the
>> driver was later moved to the regular wireless tree.
>>
>> That break is required, thus ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>
> 
> Why not remove this entirely and use the generic routine in
> drivers/net/wireless/realtek/rtlwifi/base.c?
> 
> Is there a real difference?

I did not see any difference other than the removal of a bunch of magic numbers 
and better formatting.

Larry

