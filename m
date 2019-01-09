Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC1FC43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 10:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D47121738
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 10:30:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Jpner2+4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbfAIKaA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jan 2019 05:30:00 -0500
Received: from mail-yb1-f181.google.com ([209.85.219.181]:36471 "EHLO
        mail-yb1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729222AbfAIKaA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jan 2019 05:30:00 -0500
Received: by mail-yb1-f181.google.com with SMTP id a190so2788687ybg.3
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jan 2019 02:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7Gf/B8MlACFqji3ttwFxEXrGLGSNVArMb3PbrdS5ruM=;
        b=Jpner2+49jDwWaNptST5RWNXf29tToqoBfGkovuzA/c3dLbdHgBYde3Wz6Y0fXhVnH
         K2zsSOgBSFYmlhb1mkt/bYdHyen/moTkHcs4qKvemXqv//Wz9W8TQGes6TJviDXYip4y
         6wzbu7shUQoy87dRoqbPHTQkHUDzfZ/kfctyA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7Gf/B8MlACFqji3ttwFxEXrGLGSNVArMb3PbrdS5ruM=;
        b=jEolfocPoQLZbfRGloNSjhF3vD3psg2n9uI49QdmUoX7A1uoydCZA7R0DTTY+U+kPs
         hQzeHI5RVgv39dNCjlY0tE2bQp1fq2y+eZxGIBdraCmK+3Qgp8ojXh6B7M5FW0++80Fd
         p28zGmrNAiHXxxsBOqfHwXZ6jzu6Ckrpmdgy89NfMnKJkg+sZDQL3kKn11BQ1CSPT0II
         Adj+mk62KDrdv8yqWP0s7LC/sw/I95L/lNjYM3TMFDm+AoLoqINowmAN8Utt2BpxHo13
         WE7QllbNi5MtvMqnlC/HOKpqp6svtIw9Awut+rimztvVIV3bIxVqxjRKLH9h1YSxa9Cb
         0vVw==
X-Gm-Message-State: AJcUukcnY2zzbo3w33BF+Pw7qIa1Ui8Jp5qRP8L3e1fq4RWHoXJebG58
        8vgyHC1HsSyh4S4OM+hkqif424rxW/rABKhJRjfXduJZgjcVX6fRUFVUyu9JR4cM6j3w8mF6dI6
        mnPlwvdNi/ePq3BOppcCZnm9p/jjtsesTddkZGiA8mtcks1KWLLsXjlFgeXY4STe9qjNUZ5UA+I
        YuJiFfDl9+8AdVuQ==
X-Google-Smtp-Source: ALg8bN7wVJ60xYIDBGAgCm+MOuTCy/Z942L0jlUvhZf27PuLJba2ornDBHjAs4wVvFKJ1w2UQ1iPcA==
X-Received: by 2002:a25:1256:: with SMTP id 83mr4918828ybs.243.1547029798633;
        Wed, 09 Jan 2019 02:29:58 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id f62sm23860078ywd.68.2019.01.09.02.29.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 02:29:58 -0800 (PST)
Subject: Re: [REGRESSION] hostapd 2.4..2.7 broken with 4.18+
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <20181224110925.GY26090@n2100.armlinux.org.uk>
 <CAF7Mx6r_q7H4ioFLoF1eKHrvmtE0xViG__uDNByaNjrGGJWx+Q@mail.gmail.com>
 <874lajrtkh.fsf@kamboji.qca.qualcomm.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <8379dfa7-e49f-659e-9ccc-e5b9d973ff80@broadcom.com>
Date:   Wed, 9 Jan 2019 11:29:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <874lajrtkh.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/8/2019 5:40 PM, Kalle Valo wrote:
> Arend Van Spriel<arend.vanspriel@broadcom.com>  writes:
> 
>> Response using Gmail on phone
> Unfortunately it had HTML and not sure if it made it to the list, so
> copying your response in full below just in case. Russell, does the
> commit below fix your problem?

Thanks, Kalle

I am pretty sure it did not make it to the list as I got a bounce 
message from it. I use my phone sparingly to reply.

Gr. AvS

> 861cb5eb467f brcmfmac: Fix access point mode
> 
