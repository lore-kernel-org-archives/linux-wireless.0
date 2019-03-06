Return-Path: <SRS0=PZxT=RJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5CE0C43381
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 09:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC70E206DD
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 09:08:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="gIlGzNFl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbfCFJIx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Mar 2019 04:08:53 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44216 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbfCFJIx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Mar 2019 04:08:53 -0500
Received: by mail-ed1-f66.google.com with SMTP id b20so9654356edw.11
        for <linux-wireless@vger.kernel.org>; Wed, 06 Mar 2019 01:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kGgOBCmicW7PoRDaLv/CzdeNuLvslnR6J60bVdoyucc=;
        b=gIlGzNFloG2cSv7lRPIoRj0xkxhP1uri5VOOFNeqPVKC/rt99ZOj3YmMgzHB5WS9NM
         lEgaFk4htbqZtmuQrbLFkXdnVmGP+dmkoeVh+zM7M6FipQtSk12BIqPYgD8HxlNBjvK3
         ZC7geHQ/gIIAdld+cxDCDNvLyNLPbPTNnGK5A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kGgOBCmicW7PoRDaLv/CzdeNuLvslnR6J60bVdoyucc=;
        b=uixzPPgjeC719o/xq9vgyU0ZsPhS2eGD+BiD2MQuX5ZIrsxQdus5Q9uIi68N9P4p3i
         qnBhTeE9ft8aQwKsBNEEmgN4bPUpt5/zbx6bISMz0r2UFs2EszpKA66w5LIBXhPPzAfh
         y3SgSuFaua6ocENuhCsKucZ4q/2JNOvZNN4pSHkVmRuQP89+Dlw23dh10mJ2863jh2rw
         2Al9/qz7DiuJ4PqhYcFqW81E78JEykakWQq8ioIUXBDpQhmS/IMjtpDp0TpjonZdwypj
         SjMR4Dj3vIq02B8EZsVzY4hZqDwnxFzL+7AneHDkLqR/6788acOamkY3vXBtJXXHCdsn
         Mocw==
X-Gm-Message-State: APjAAAVOay0DiuSy62yedWhZdDI+YRmboS/Jd5oT9sgnYI6P42jNyHwI
        0F0rkd+X2eMIom0mA8jsDlp+og==
X-Google-Smtp-Source: APXvYqy3iXRfUgfyGF8p+EpmlVx1fC8hFL1HKENNJQr7cIJS6s35pHoKtkv5yYyIGWajNQlimCIZxA==
X-Received: by 2002:a17:906:485:: with SMTP id f5mr3237142eja.85.1551863331401;
        Wed, 06 Mar 2019 01:08:51 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id f5sm222293ejf.25.2019.03.06.01.08.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 01:08:50 -0800 (PST)
Subject: Re: [PATCH 4/4] brcmfmac: reset PCIe bus on a firmware crash
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20190226131119.7907-1-zajec5@gmail.com>
 <20190226131119.7907-5-zajec5@gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <b33340cc-20ac-9bae-7735-1849dab06a27@broadcom.com>
Date:   Wed, 6 Mar 2019 10:08:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190226131119.7907-5-zajec5@gmail.com>
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
> This includes bus reset & reloading a firmware. It should be sufficient
> for a user space to (setup and) use a wireless device again.
> 
> Support for reset on USB & SDIO can be added later.

It should be noted that you end up with a new wiphy instance though. We 
could try to avoid that in subsequent change.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>   .../broadcom/brcm80211/brcmfmac/bus.h         | 10 ++++++
>   .../broadcom/brcm80211/brcmfmac/core.c        | 12 +++++++
>   .../broadcom/brcm80211/brcmfmac/core.h        |  2 ++
>   .../broadcom/brcm80211/brcmfmac/pcie.c        | 35 +++++++++++++++++++
>   4 files changed, 59 insertions(+)
