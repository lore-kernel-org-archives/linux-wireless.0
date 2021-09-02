Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA81C433EF
	for <linux-wireless@archiver.kernel.org>; Thu,  2 Sep 2021 18:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA31561054
	for <linux-wireless@archiver.kernel.org>; Thu,  2 Sep 2021 18:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347000AbhIBSi0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 2 Sep 2021 14:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346893AbhIBSiY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Sep 2021 14:38:24 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E95C061757
        for <linux-wireless@vger.kernel.org>; Thu,  2 Sep 2021 11:37:15 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id bg1so1746249plb.13
        for <linux-wireless@vger.kernel.org>; Thu, 02 Sep 2021 11:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=squareup.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aIWjYpBOUYzVzaVlUDHdrgyjE4CFE+gBvpcecdsULzo=;
        b=NV6f8kZoTYuzX/tEjhOIkZ4cpIS/VfQdeKinotKC8ZjhsAiCS16sCfz/4yzYlaqFQF
         RSPN7uJMPJxNdjDhFRR/hTOsQX8yJjYahr3+R0eLgd0uhiqDFnODPmNmVo0C5eHuuDqI
         S43I6WjyS7OB4O/Bo/iLeBKjd+PyN4mD2xfUI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aIWjYpBOUYzVzaVlUDHdrgyjE4CFE+gBvpcecdsULzo=;
        b=lHApksHgQvxjMGkw8fdpZI1yHDHNOopaTprtuWtSnUz4pQeIzzpPO2gIp7CiaXiOxA
         R0kJ4BQ5TgaE8gp21e3rySFqqM4sfuscWVv/3tUyh7nELNylFvXbk1++ZlUz2+PO3jfS
         I6iVXfv2rMXnoDx7sKfSkeoxRJGR5xMT4ZBotr76DDyfoWsoOjK5+C83/+oC2oVcO2Mg
         jxyYvDIFDJrbwKIXbj4b1+iXTIgFP8Cx2v7zdGuJ9wDN7pkd9F91c5j3HpQe1Csxij1u
         SIN1DRcSH+MQ0J/ExzrZ0HiuKwCJpCUxpCtv6gXveZgWysV9w+g57tH3Omo/rM9OLwzJ
         yLZg==
X-Gm-Message-State: AOAM530LCF0bGtt3dXSFKVI5dhA2UCi4Sl0zlwD5GU/t7pEyBU1EUzlt
        Lal0LfQLx/AR/tYWYpOjFMSg5Q==
X-Google-Smtp-Source: ABdhPJwkIh9FL7oKT+VZsNlyxhEYjWCIOxTFKVBxQ+EOwMADJ3K/P9pveiCVJlUMeAwnHQfsTZCapg==
X-Received: by 2002:a17:90a:6507:: with SMTP id i7mr5390673pjj.205.1630607834855;
        Thu, 02 Sep 2021 11:37:14 -0700 (PDT)
Received: from benl-m5lvdt.local ([2600:6c50:4d00:2376:7473:9ba9:f43f:3a4b])
        by smtp.gmail.com with ESMTPSA id j14sm2895983pjg.29.2021.09.02.11.37.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 11:37:14 -0700 (PDT)
Subject: Re: [PATCH v2] wcn36xx: handle connection loss indication
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210901180606.11686-1-benl@squareup.com>
 <8735qn2ats.fsf@codeaurora.org>
From:   Benjamin Li <benl@squareup.com>
Message-ID: <3a587de2-f605-fd17-4d70-878b13354b39@squareup.com>
Date:   Thu, 2 Sep 2021 11:37:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <8735qn2ats.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 9/2/21 9:37 AM, Kalle Valo wrote:
> Benjamin Li <benl@squareup.com> writes:
> 
>> Firmware sends delete_sta_context_ind when it detects the AP has gone
>> away in STA mode. Right now the handler for that indication only handles
>> AP mode; fix it to also handle STA mode.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Benjamin Li <benl@squareup.com>
>> Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
>> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> 
> How well is this tested? I'm pondering should I queue this to v5.15 or
> v5.16, at the moment I'm leaning towards v5.16.
>
It was an issue reported during internal testing, and the patch has not
yet had soak time with our quality team/field devices. v5.16 sounds fine.

Ben
