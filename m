Return-Path: <SRS0=PZxT=RJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0560AC43381
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 09:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2D7020828
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 09:02:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="D9OhbY5M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729046AbfCFJCh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Mar 2019 04:02:37 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46942 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbfCFJCh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Mar 2019 04:02:37 -0500
Received: by mail-pg1-f193.google.com with SMTP id 196so7862033pgf.13
        for <linux-wireless@vger.kernel.org>; Wed, 06 Mar 2019 01:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=10Y0ITRgUYgQ8KM0SPJ3eo3G9ExKdWZ39EHqserIXcw=;
        b=D9OhbY5MCehZ6jp8YOE+DOB2oh2XTy+wd2k+5yAvuDGcqRccw6+yEssdDD0rbsjmIC
         0XQmgtwgaNMKTGYA7qWdO7qiZKd1HIMnnbAaSCHIim6V0bM8AcSldh9Zflxw8+8ys4EZ
         0v2X3J8Q3KgFsKSEWM6+tsspbyoLc1Rmlqbb8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=10Y0ITRgUYgQ8KM0SPJ3eo3G9ExKdWZ39EHqserIXcw=;
        b=JmqIqgundYfhEadWNBaK8u25WdYKSEMHl4udszRnvth7N9KLKIbRZ+J7PAi259/IHu
         I0/RxjP/BmS7wUmIKXkO3fDxRiUESuUT0QSdHeJQySaZ0WvdsVBC+RvB8asgDdTZxUVi
         2pPCJECgAqPZrXYPM1L5e12YnCd4vtVRn2HwBHnXK9k0cidFLTXWctiCDVjGPRNrD0DY
         LOMhVDVotiTEB8ZRFuLxXLqN/kH7ALUUaezGXHTWzn39PjoIgwKIHtvEWJ806CXYk7mI
         0ueozlbhnIVOf4b3rmIKIZzaI8JPrgmbdpg8tF2x6HN2GkuTJH8LxQiUxWNwenDeGeL4
         N08w==
X-Gm-Message-State: APjAAAU8gTTVeQFOdSakw3WUXnBmZ7S23a6h5yDVvc/dGqZLdPM+S8sG
        OPZ7sIJAAaJPFb6FkGS79rdAbg==
X-Google-Smtp-Source: APXvYqxJjVR6si2R2HXUC6ZhCIUva+laqYuNkOlVHtrOPWpGXI3hBD9vp5kwWLQO9BdFODpj+mv3iQ==
X-Received: by 2002:a62:64d1:: with SMTP id y200mr6193501pfb.161.1551862956369;
        Wed, 06 Mar 2019 01:02:36 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id h65sm1582849pgc.93.2019.03.06.01.02.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 01:02:35 -0800 (PST)
Subject: Re: [PATCH 3/4] brcmfmac: add a function designated for handling
 firmware fails
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20190226131119.7907-1-zajec5@gmail.com>
 <20190226131119.7907-4-zajec5@gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <a80dca6c-0575-2ae9-9e1f-1382dfbeefb1@broadcom.com>
Date:   Wed, 6 Mar 2019 10:02:37 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190226131119.7907-4-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2/26/2019 2:11 PM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This improves handling PCIe firmware halts by printing a clear error
> message and replaces a similar code in the SDIO bus support.
> 
> It will also allow further improvements like trying to recover from a
> firmware crash.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  2 ++
>   .../net/wireless/broadcom/brcm80211/brcmfmac/core.c    | 10 ++++++++++
>   .../net/wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  2 +-
>   .../net/wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  4 ++--
>   4 files changed, 15 insertions(+), 3 deletions(-)
