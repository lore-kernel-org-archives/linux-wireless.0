Return-Path: <SRS0=1os+=N7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD1ADC18DF5
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 09:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C2E2206BB
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 09:53:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="OOCb1fxa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C2E2206BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbeKTUVv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Nov 2018 15:21:51 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:38291 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727985AbeKTUVv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Nov 2018 15:21:51 -0500
Received: by mail-yw1-f66.google.com with SMTP id i20so519556ywc.5
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2018 01:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=a7/W7byzzrm2azhPYA+Q8+0uHnI9zjKDlQsyKHPmnbY=;
        b=OOCb1fxausnD7bdvZDLaiAtNyqMZX24koQuTttiYDdujw2JLZvx++hg4wCAYHn5yqL
         U+0Yx8U3fXcHuyWqOvbLDNYYICsD1dYJd023mYJnCdkVh52E9+dVMZ9iuKoebG5mjq+6
         oSzPTcPU3olewnvHaEInXzRu7cOSXtS2r7PfY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=a7/W7byzzrm2azhPYA+Q8+0uHnI9zjKDlQsyKHPmnbY=;
        b=s8tQ+v9gkx/fUMQEtQpm+Jy6K7hrhWs9nF4i/QAPrpGmrZBKo3UMDvdiZYhNDpAJln
         XMESFdj7J4RYnQJ8lC4RWYlssBwBxHyWMjnIih5fE0BImGdPkpOI9wAd8qnOA3NhCyeB
         L4gTQj/9sQWC8KE4FyQjcP8v0jKZZVLkESgWVXzq7/Th3D18hS6thhHuXD/GWWNPJNxh
         XQviXNXkNrC2NIxnjTLE30lclabhWbLy38ZFAh5QdKyYFpw0tCjBsNec8PkTEOUWlpoX
         vBWEE3gY8rBxPg9QPy9a0c1qaWOB1t2c2VYiuwI/G6aDoPDJ1uSgth2Wk4Jw7hLwCPrt
         gUCg==
X-Gm-Message-State: AGRZ1gL0ovMVWuW3kcWcml2g5aBTsVOfaj50lan3OdEuE1C2FwxptSwZ
        uSHSLx9CpxTjBDLToUYl+xZmcg==
X-Google-Smtp-Source: AJdET5erdYi5rsxJRxuLm38fnqHn8roh98RoDBI2QG/HiDLkiH/vMurt6MiMXdsAHCEzegUDdul6Jg==
X-Received: by 2002:a81:33c4:: with SMTP id z187mr1134853ywz.294.1542707614893;
        Tue, 20 Nov 2018 01:53:34 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id g81-v6sm5311245ywa.100.2018.11.20.01.53.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Nov 2018 01:53:34 -0800 (PST)
Subject: Re: [PATCH V2 3/8] brcmfmac: set SDIO F1 MesBusyCtrl for CYW4373
To:     Madhan Mohan R <MadhanMohan.R@cypress.com>
References: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
 <1542007730-47284-4-git-send-email-chi-hsien.lin@cypress.com>
 <0925038a-a767-351d-5b03-f8fa10b8aad1@broadcom.com>
 <20181120085049.GB1563@aremote02.aus.cypress.com>
Cc:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <4cfaa1cc-2561-6c8d-18b1-4f5a61790cfe@broadcom.com>
Date:   Tue, 20 Nov 2018 10:53:32 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20181120085049.GB1563@aremote02.aus.cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/20/2018 9:50 AM, Madhan Mohan R wrote:
> On Mon, Nov 12, 2018 at 10:13:07AM +0100, Arend van Spriel wrote:
>> On 11/12/2018 8:29 AM, Chi-Hsien Lin wrote:
>>> From: Madhan Mohan R <MadhanMohan.R@cypress.com>
>>>
>>> Along with F2 watermark (existing) configuration, F1 MesBusyCtrl
>>> should be enabled & configured to avoid overflow errors.
>>
>> I am a bit confused. Why is it necessary to program the watermark in
>> both SBSDIO_WATERMARK (0x10008) and SDSDIO_FUNC1_MESBUSYCTRL
>> (0x1001D).
>> Looks suspicious to me.
>>
>> Regards,
>> Arend
>
> Hi Arend,
>
> Register SDSDIO_FUNC1_MESBUSYCTRL(0x1001D) Bits [6:0] is programmed with
> SDIO RX path watermark whereas the register SBSDIO_WATERMARK(0x10008) is
> for the SDIO TX path.

Thanks, Madhan

That makes sense. Maybe it would be good to express the tx vs rx detail 
in the code.

Regards,
Arend
