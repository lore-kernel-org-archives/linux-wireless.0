Return-Path: <SRS0=48GF=S2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1833DC282CE
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 08:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB3BE218DA
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 08:46:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="EmY7igJU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbfDXIqS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Apr 2019 04:46:18 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46364 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727441AbfDXIqQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Apr 2019 04:46:16 -0400
Received: by mail-ed1-f68.google.com with SMTP id d1so15125796edd.13
        for <linux-wireless@vger.kernel.org>; Wed, 24 Apr 2019 01:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qzWtjEz6pzRD7UW3ElrYACnK/cbDXvSYesdHWcWgvxM=;
        b=EmY7igJUbDJTmU9tKQArzqmHQHnezutjo0mvcJa/4oOF1Ic3eQfN1agqdAFauD7zkp
         K/3XNnUyIceqhKRiHUjmERT53Tu3VQG8AZvT8GzSR/p+3BfSYE4aNUnzB4fTwKVqst5J
         LVKittnX2FMVirzY74bds0fb4XemgQ54Az/dQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qzWtjEz6pzRD7UW3ElrYACnK/cbDXvSYesdHWcWgvxM=;
        b=tzIyc1vC/meeem4BO7cDH5yLVmwkSFOMt2RU8T/Sdk3fpF41sIBauPL1+oG7avApHb
         rM6TRuxgzTWRYMGzCxvcSoNnuZ/UkU0E6dZ1Hq7LTqRM0NYVLNFPJwJG9Zo+xxpFzydk
         wdnBzsms77tnqHPyviR3vundqizTF/2MTavdcCtlhrMq+p041sb54NnZuTrJ2gHirPGZ
         ESXupF9rRQlBV2NucVrEtO19Fg1NZsyguxFtBP16A8iRbMqu7LxDRrfmYHqT4j6SDk+X
         SVxPjxNY4X2+VNLvjpVgp+/5wfIqftuHPfLrOszeS2svygtiNy2R21dwFm3sEBri1YFs
         rQgQ==
X-Gm-Message-State: APjAAAW4YNF3cYGY3P4s2Ak+QIq8oGNMmpgyeF5U5V9l8e6Q164KYj1D
        tgjkewt7v0PUVDca1tw1lc5dtA==
X-Google-Smtp-Source: APXvYqxk1bgmtlnJiJxF8SdGkUZCaElC5GXrI6B/fey0IT0yst+NG19awbzhF+XQvpySb8U/yeKwLA==
X-Received: by 2002:a17:906:a311:: with SMTP id j17mr15680546ejz.269.1556095574629;
        Wed, 24 Apr 2019 01:46:14 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id b26sm3412758ejb.0.2019.04.24.01.46.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Apr 2019 01:46:14 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: remove the duplicate line of sending mail box
 interrupt
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
To:     Wright Feng <Wright.Feng@cypress.com>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Cc:     linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <1555901236-145920-1-git-send-email-wright.feng@cypress.com>
 <16a4dcd3418.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
Message-ID: <164b59e8-633b-84cc-179f-9bdd7ec696a7@broadcom.com>
Date:   Wed, 24 Apr 2019 10:46:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <16a4dcd3418.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 4/24/2019 7:24 AM, Arend Van Spriel wrote:
> On April 22, 2019 4:47:31 AM Wright Feng <Wright.Feng@cypress.com> wrote:
> 
>> The line is duplicate so remove it from pcie.c. We don't need to send
>> host to dongle mail box interrupt twice after writing data.
> 
> Hi Wright,
> 
> Thanks for the patch. I am a bit early as it is not uncommon that 
> hardware requires an extra kick. Might be the case here for some chips. 
> Will follow-up on it.

Hi Wright,

I checked in our dhd driver code and it also does a double write. Turns 
out to be a hardware workaround so we need to keep this. It is worth a 
comment though.

Thanks,
Arend
