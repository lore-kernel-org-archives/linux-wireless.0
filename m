Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D5BC169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 11:20:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C970218D3
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 11:20:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MOek5Egc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fS3PrPqc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfAaLUr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 06:20:47 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:53082 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbfAaLUq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 06:20:46 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 27D66608D2; Thu, 31 Jan 2019 11:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548933646;
        bh=YssKof48YxTHnoUNY2Cf15ElS2h2rTxz0zw9hbvgRog=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MOek5EgcoUqw04IB1zIa5b3ukxXiiqN7n/+OkLjYXThxkhypdAXeNIao1mFIXghSN
         3/rkMl4oBVnNNaaG2sILrYU/uS/i0Ibv5vWLgHVZ0n94OKNgtDVNFFE+d5YhV6xTTo
         v02eOQR+axzKgszN0lQhQt3cf2zRlmA1i3giQy1Q=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5E2076047C;
        Thu, 31 Jan 2019 11:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548933645;
        bh=YssKof48YxTHnoUNY2Cf15ElS2h2rTxz0zw9hbvgRog=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=fS3PrPqcy62uLBsp72W0zmC/SKApakaYmwmQ9EZh2aTgVkewELJvpw3Oz8lNV+KtH
         OkuwkO+FM5w+kchsWbNH9sJhjlZQD/eBmpOesAzdd+HBr4PzxwC6SfNmLkne3mc2Xy
         GZZh6rXB3e4I4VOTJB3XyVRc5P8N/woWYX0mAIUI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5E2076047C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] mt76: add driver for MT7603E and MT7628/7688
References: <20190130140756.91317-1-nbd@nbd.name>
        <20190130140756.91317-3-nbd@nbd.name>
Date:   Thu, 31 Jan 2019 13:20:42 +0200
In-Reply-To: <20190130140756.91317-3-nbd@nbd.name> (Felix Fietkau's message of
        "Wed, 30 Jan 2019 15:07:56 +0100")
Message-ID: <87pnsdrs39.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> This driver is for a newer generation of 2x2 MediaTek 802.11n chipsets.
> MT7603E is a PCIe chip.
> MT7628 and MT7688 are MIPS SoC devices with built-in WLAN.
> MT7688 is limited to 1x1
>
> This driver fully supports AP, station, mesh, ad-hoc and monitor mode.
>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

[...]

> --- /dev/null
> +++ b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
> @@ -0,0 +1,201 @@
> +/* SPDX-License-Identifier: ISC */
> +/*
> + * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */

If you have the SPDX tag I don't think you need to have the license text
anymore. My understanding is that the SPDX identifier and copyright is
enough.

This comment is for all files in this patch.

-- 
Kalle Valo
