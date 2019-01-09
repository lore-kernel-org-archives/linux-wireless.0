Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C447C43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 11:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFF1F21783
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 11:17:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="C+WwaQSZ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Dn0NNZfG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730818AbfAILRk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jan 2019 06:17:40 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40904 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730111AbfAILRk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jan 2019 06:17:40 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9D3D3608CF; Wed,  9 Jan 2019 11:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547032659;
        bh=JU0ssnZNWz4auGPtPCG85Rk1lG4OaE62ftTmLt6Qjbc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=C+WwaQSZt3qcoQwkQyKnOHO0tdbiEui4/WWwU05Vl5WAx4BpA6fidEnCSS+sw6Meb
         IWg1ou2h670gp1Z2rgIe20M3fdG+5yQBoiYWLF8GPpQJomQ2d55lRkDzWk3jklZiy0
         M2CS9I8JECLoQmZiWFvguasGvratFD2JE2K1USwU=
Received: from x230.qca.qualcomm.com (unknown [83.145.195.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 730196095E;
        Wed,  9 Jan 2019 11:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547032656;
        bh=JU0ssnZNWz4auGPtPCG85Rk1lG4OaE62ftTmLt6Qjbc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Dn0NNZfG74Mt8ZSstkyZTDhvaqo5uI4FIz240+VLNypJqZwd4fPBYX0AxMd4m2ITa
         ddVrULCejXQWOikWIb+XFP+dsu2Pqao/7CCSeN9TYzrXhD8yhOWVAbZSiMY6RH7Tzj
         pxWLIz9/Z5gwwsjZVKiYoSSMHFqHkFFQMbXRKGII=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 730196095E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Kangjie Lu <kjlu@umn.edu>, pakki001@umn.edu,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: brcm80211: add a check for the status of usb_register
References: <20181226012227.70524-1-kjlu@umn.edu>
        <87zhsbqeuu.fsf@kamboji.qca.qualcomm.com>
        <7ddb04d4-f45f-2b41-12da-d17e8f8c1173@broadcom.com>
Date:   Wed, 09 Jan 2019 13:17:28 +0200
In-Reply-To: <7ddb04d4-f45f-2b41-12da-d17e8f8c1173@broadcom.com> (Arend Van
        Spriel's message of "Wed, 9 Jan 2019 09:28:19 +0100")
Message-ID: <87r2dmcc6v.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Arend Van Spriel <arend.vanspriel@broadcom.com> writes:

> On 1/8/2019 5:43 PM, Kalle Valo wrote:
>> Kangjie Lu <kjlu@umn.edu> writes:
>>
>>> usb_register() may fail, so let's check its status and issue an error
>>> message if it fails.
>>>
>>> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
>>> ---
>>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 6 +++++-
>>
>> The title prefix should be "brcmfmac: " but I can fix that.
>
> Hi Kalle,
>
> I wanted to ack this patch, but can not locate it in my email not in
> linux-wireless patchwork. Was it posted to the networking list only?

I do see it on linux-wireless patchwork:

https://patchwork.kernel.org/patch/10742769/

> Using scripts/get_maintainer.pl with the patch would reveal the lists
> to post to in order of preference. For wireless driver changes I
> refrain to linux-wireless only, but that is a personal choice I guess.

Yeah, I guess in general wireless patches are just noise for netdev
people.

-- 
Kalle Valo
