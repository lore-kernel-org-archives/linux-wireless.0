Return-Path: <SRS0=9HFQ=MT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98C17C64EB8
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 00:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E7322087D
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 00:48:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RVkWyI2k"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E7322087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbeJGHxa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 7 Oct 2018 03:53:30 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:32850 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbeJGHxa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Oct 2018 03:53:30 -0400
Received: by mail-oi1-f193.google.com with SMTP id a203-v6so13276634oib.0;
        Sat, 06 Oct 2018 17:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KvLdhcYzwUL/IJwy+ZMdyT45YRpi1CApohmlilxGAhQ=;
        b=RVkWyI2kEuKDp2b4wSKrAYus5vFDtZ9WP3OJIIwwfAOjRFlnNmmRocOlHQC60my0ND
         cZb66Pzyfavw5WOoRRykx4qTZvh0ZEFID+aWkL90TBRneu4PXqTOC2XwF0uivHjt2O7q
         HrqKkfInYqJ9GgSyPNJ6dys7K9r6kTn+3CrFPmyBhUVjLRpqT7kG0hZ06wSnSHuBJR9Y
         5bINdcv5GGfCJaaVueZIUGlhl39wEd4PlRCe3vEBn2KyeEgyMMzyJ8OUVSTtZqhvfNLa
         ZqfiXRF4nwYY0HVpDWENNVHqrqDnKL1yDnWatr3muIK8h4rlnQi5XGqnn9EALGNBwvKY
         Smqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KvLdhcYzwUL/IJwy+ZMdyT45YRpi1CApohmlilxGAhQ=;
        b=LLhiwKNyJdmO26izhgmapeXzca0D8qnU8c0Zdyw+tNAnge153AcTeguFZkMvhivOWL
         DSu1Cj3g/yXF+nL802Om8DtOotOEN9juTvpZSa79B5HbAzwv1NGbcecbDS7qQs4Jsvay
         8DbZpcnBrc6DLBct1EWsNgGpOCHyBfodJ8x0LOitGaDGuyHwHmNA0OSLPc/Qyb4gyo+0
         kUxJ9RNTXmgczxoZkHzTTbTWDIxKh/0UiQwLH2cbUu4AmfuJWfFVExaSgFjDA7rxaZrx
         dHCWUnOqYtf+WpTO5a70xGw08e4buFhoCTRxvpM6/Syky4EQrFQNeKJ6p1xddNgosPXV
         6/RA==
X-Gm-Message-State: ABuFfohdsubsfl/yxQEqSB3I/feX/d1oqE7VuClrES0GDLbG4XbMiF/u
        t99PNgiY5pLEf1AaBFsPjFeSQBhI
X-Google-Smtp-Source: ACcGV60PzIEDqImdzSkavrZ1DJIjIJRMGouAu+I5Oq84Sp25pUWw/34+EoxMnhFtz2cgnRjBoTETCw==
X-Received: by 2002:aca:5c3:: with SMTP id 186-v6mr2232657oif.185.1538873291336;
        Sat, 06 Oct 2018 17:48:11 -0700 (PDT)
Received: from [192.168.1.107] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id j79-v6sm5679545oiy.13.2018.10.06.17.48.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Oct 2018 17:48:10 -0700 (PDT)
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
 <a4286648-dda5-eb46-97bf-f0314ec2d113@lwfinger.net>
 <b0971d2219b7121d06fc2439922a2b759203dd2b.camel@perches.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <617cf0d8-a99a-1f8c-b1a2-7e3f07aa6d24@lwfinger.net>
Date:   Sat, 6 Oct 2018 19:48:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <b0971d2219b7121d06fc2439922a2b759203dd2b.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/6/18 5:03 PM, Joe Perches wrote:
> On Sat, 2018-10-06 at 17:00 -0500, Larry Finger wrote:
>> On 10/6/18 3:17 PM, Joe Perches wrote:
>>> On Sat, 2018-10-06 at 15:05 -0500, Larry Finger wrote:
>>>> On 10/6/18 2:30 PM, Kalle Valo wrote:
>>>>> Colin King <colin.king@canonical.com> writes:
>>>>>
>>>>>> From: Colin Ian King <colin.king@canonical.com>
>>>>>>
>>>>>> The switch case RATR_INX_WIRELESS_MC has a missing break, this seems
>>>>>> to be unintentional as the setting of variable ret gets overwritten
>>>>>> when the case falls through to the following RATR_INX_WIRELESS_AC_5N
>>>>>> case.  Fix this by adding in the missing break.
>>>>>>
>>>>>> Detected by CoverityScan, CID#1167237 ("Missing break in switch")
>>>>>>
>>>>>> Fixes: 3c05bedb5fef ("Staging: rtl8812ae: Add Realtek 8821 PCI WIFI driver")
>>>>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>>>>>> ---
>>>>>>     drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c | 1 +
>>>>>
>>>>> Is the fixes line correct? This patch is not for staging.
>>>>
>>>> No, the correct fixes commit is 21e4b0726dc67 (" rtlwifi: rtl8821ae: Move driver
>>>> from staging to regular tree").
>>>>
>>>> This driver was initially placed in staging as it was needed for a special
>>>> project, which is the commit that Colin used. As the patch subject states, the
>>>> driver was later moved to the regular wireless tree.
>>>>
>>>> That break is required, thus ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>
>>>
>>> Why not remove this entirely and use the generic routine in
>>> drivers/net/wireless/realtek/rtlwifi/base.c?
>>>
>>> Is there a real difference?
>>
>> I did not see any difference other than the removal of a bunch of magic numbers
>> and better formatting.
> 
> Me neither.

Colin,

Do you want to push the new patch removing the duplicate routine from rtl8821ae?

Larry
