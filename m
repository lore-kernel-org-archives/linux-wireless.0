Return-Path: <SRS0=PZxT=RJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D1D8C43381
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 08:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A2D220828
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 08:59:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="SIpB7uv2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbfCFI7H (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Mar 2019 03:59:07 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:33546 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbfCFI7G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Mar 2019 03:59:06 -0500
Received: by mail-yw1-f67.google.com with SMTP id i204so9365075ywb.0
        for <linux-wireless@vger.kernel.org>; Wed, 06 Mar 2019 00:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0MIl5o5aBAQDGFDq+SLI31hAjhNyRZ8SeiN1e92tLig=;
        b=SIpB7uv2DhV6ZqDro6HPWQ7Ef4U69SsLJd/FJiG3wEi4rYBAQqLf3Yc7s4OxGkpNAE
         UO/s8QvppSIHgeD53Lt9mwypsPO8b7MN8LJ95j2Xqzpj73RGMqaiM8RJSzPvh8B1C1UP
         2v8IQIrhc1Zpfmq5X2OIoD4sm9JLsuNjGMQn4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0MIl5o5aBAQDGFDq+SLI31hAjhNyRZ8SeiN1e92tLig=;
        b=N4OQlY6HzmjDX36yA2kPx3EkK9jbaWf9eFjkQ3kFiSvulJhRRDKuvWDZdIpwU3+qkQ
         F2SacdmZaTwSh1joQiZnsdr3CUX9NC4UoqzFOpKvF7g5sXgXJNgzesx0PdE/+p2wHMrB
         H1xpM0iRsT4Jwp+7wgzFwN+lJAGYfSrv3Fe0YqRwnMEdLA5hRUBYsDVEU5ObcnLwbdSL
         Z8QSCItEnB3q8S/PtnSL2CZiTFs+ySjqYutRkJ9uYNULgJXFEZTkS2pSRuSr83NjbZGA
         ehJyCOXDlXXhhbI7nxa3fpPVtgLtK7hRmsuUtphOoTA0v91SnMjfQG1/f7018Plgt5NH
         hOMA==
X-Gm-Message-State: APjAAAXt0ZTBbtjvH6Ctsz421qO/3HToKHrypuupnqLsH8v4o7CZnq0l
        unQ04YKhIH4r1U4EOviR7CUE4Q==
X-Google-Smtp-Source: APXvYqxqmaLWBDP0lB+wBikWMoQfZgQynRJz6JAw+J3UbQQe7BbRddvqdmPi7F8AhZNEEmplONnMwQ==
X-Received: by 2002:a5b:2cf:: with SMTP id h15mr5603786ybp.237.1551862745272;
        Wed, 06 Mar 2019 00:59:05 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id d138sm365853ywa.43.2019.03.06.00.59.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 00:59:04 -0800 (PST)
Subject: Re: [PATCH 2/4] brcmfmac: get RAM info right before downloading PCIe
 firmware
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20190226131119.7907-1-zajec5@gmail.com>
 <20190226131119.7907-3-zajec5@gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <b77273dd-f682-332f-7e47-12222ef502ba@broadcom.com>
Date:   Wed, 6 Mar 2019 09:59:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190226131119.7907-3-zajec5@gmail.com>
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
> It's important as brcmf_chip_get_raminfo() also makes sure that memory
> is properly setup. Without it the firmware could report invalid RAM
> address like 0x04000001.
> 
> During a normal brcmfmac lifetime brcmf_chip_get_raminfo() is called on
> probe by the brcmf_chip_recognition(). This change allows implementing
> further improvements like handling errors by resetting a device with
> the brcmf_pcie_reset_device() and redownloading a firmware afterwards.

Thanks, Rafał

How about avoiding the ramsize adjustment in redownloading scenario. We 
could add a reinit field in devinfo and check that.

	/* Some of the firmwares have the size of the memory of the device
	 * defined inside the firmware. This is because part of the memory in
	 * the device is shared and the devision is determined by FW. Parse
	 * the firmware and adjust the chip memory size now.
	 */
	if (!devinfo->reinit)
		brcmf_pcie_adjust_ramsize(devinfo, (u8 *)fw->data, fw->size);

Regards,
Arend

> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 6 ++++--
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h | 1 +
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 6 ++++++
>   3 files changed, 11 insertions(+), 2 deletions(-)

