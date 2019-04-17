Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE23C282DA
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 12:37:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFD5B20835
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 12:37:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TjSHjSNx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732080AbfDQMhz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 08:37:55 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39854 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731790AbfDQMhz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 08:37:55 -0400
Received: by mail-ot1-f65.google.com with SMTP id f10so20506564otb.6
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2019 05:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+bBJ1FV0N6JdenHqhwFag1jwMNbBgEBG5KACOm/sHtI=;
        b=TjSHjSNxByeuLsmCLELE/H004Rnv28cxjbX9jdVfO/pFzdib8j0RigKsq8VsSzc5UA
         emgs8AkCzWVwtIEsV4MtwQhsELLUtrpXtxq+PrrWV5EJ5Tx5WWL2ph1AN5WRqPJvXOeb
         EpFaaUUUnsbuBYwwgMj7M5q+racQL1TgMzP8gVRkMKpPx9ISqaBBywhYM6sl1be1Cr+b
         kjMS78dsilIfws8xmJOGf/e9Lo7JcgQFLj4kW4PEnqy1m+1UWYgpN8VX2xSiab227/0p
         psrVlzEDNorxTbYvRIy1JMqxcwNrui5GnbkKW2nQJkTSCRfYJRkYXl+fyoSO6cRrxHaH
         mP1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+bBJ1FV0N6JdenHqhwFag1jwMNbBgEBG5KACOm/sHtI=;
        b=AQxGKrxcTLDMhVscoUPcMeUEooqi2XMAYrI1eCeEpERfpACfANn+R9t926IC+n5+dg
         sK3tcWbH0g3VyZqeWCmLDIe6zODslWTTJn59lUx5VcaABl8M/fMIVcuPf83AMrzklwuQ
         T1bJXb8yuz4HR2m3HHvWcRH+lM3shBdNk+5llA27FwLUbH1zY9n59c3x8LfwHUmdQHG0
         fW+sWA6fP18Y0U2OKRJOA+xmDXctYiyI3y2r4XxJ7DT+LfbZlZxY0wCrnov2Eu6q7ZJK
         joydZvrpBMMlix9Rq9edrVSZTp0LcU5p4pQJHj64s9r3D8jnnW7PUPC/i9Gb7zT7iFnM
         RlmQ==
X-Gm-Message-State: APjAAAXYnVeMKn1yzwkYB8j3Kl8d5gvJXovvGu2ZB5GUDKcWHAffDXUN
        FfSDOKB/SvDYlS5zxqYdJZY=
X-Google-Smtp-Source: APXvYqwmL30njLbXkEYq21SSPt+aeP5PD0hPawddSwCZu425mP+0+WRWDSu+1Z8uPLGtkHuMId8scA==
X-Received: by 2002:a9d:6c98:: with SMTP id c24mr22283912otr.324.1555504674956;
        Wed, 17 Apr 2019 05:37:54 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id s124sm21563142oia.24.2019.04.17.05.37.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Apr 2019 05:37:53 -0700 (PDT)
Subject: Re: [PATCH] rtlwifi: rtl8188ee: Remove extraneous file
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Andrew Morton <akpm@linux-foundation.org>
References: <20190417003547.26271-1-Larry.Finger@lwfinger.net>
 <87tvex49yj.fsf@kamboji.qca.qualcomm.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <d393389d-f3f0-491e-c83b-50065f388d75@lwfinger.net>
Date:   Wed, 17 Apr 2019 07:37:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <87tvex49yj.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 4/16/19 9:55 PM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
> 
>> Somehow file drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej was
>> incorporated into the sources. Obviously, it can be removed.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Reported-by: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> ---
>> Andrew,
>>
>> Thanks.
>>
>> Larry
>> ---
>>   drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej | 10 ----------
>>   1 file changed, 10 deletions(-)
>>   delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej
>>
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej
>> b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej
>> deleted file mode 100644
>> index aa03d4605d8c..000000000000
>> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej
>> +++ /dev/null
> 
> What tree is this? On wireless-drivers I can't find this file:
> 
> $ ls drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej
> /bin/ls: cannot access 'drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej': No such file or directory
> $
> 
> Actually I cannot find any .rej files:
> 
> $ find -name '*.rej'
> $
> 

It is in wireless-drivers-next. This extraneous file was added in commit 
05f1be9594d5 ("rtlwifi: Convert the wake_match variable to local").

Larry


