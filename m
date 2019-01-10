Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6873C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 07:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7823F214DA
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 07:40:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bFGOm5sr";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bFGOm5sr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfAJHkY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 02:40:24 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36594 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfAJHkY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 02:40:24 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EF4946079B; Thu, 10 Jan 2019 07:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547106023;
        bh=sfAuZL6n3oeOyJtS4k6qQXrcwtl5ZICSBXUI24ji0fo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bFGOm5srDoDgRuZ+4Ea8Xg9sjGroguVGMB2iCE0Gqyr3BWQh3eVXvk8gPVxOcdomz
         x65d7C0cqhAYfbCABe09em7MyhJoLU6tAcf6Vc4PXujGUQMsA98wbpOevyUI6NGJvL
         hVzLDtoD4nAQRS80bCQoeGbbKGrlRTIAa28qMP6c=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 81187601D1;
        Thu, 10 Jan 2019 07:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547106023;
        bh=sfAuZL6n3oeOyJtS4k6qQXrcwtl5ZICSBXUI24ji0fo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bFGOm5srDoDgRuZ+4Ea8Xg9sjGroguVGMB2iCE0Gqyr3BWQh3eVXvk8gPVxOcdomz
         x65d7C0cqhAYfbCABe09em7MyhJoLU6tAcf6Vc4PXujGUQMsA98wbpOevyUI6NGJvL
         hVzLDtoD4nAQRS80bCQoeGbbKGrlRTIAa28qMP6c=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 81187601D1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ganapathi Bhat <gbhat@marvell.com>
Cc:     "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Hemantkumar Suthar <shemant@marvell.com>
Subject: Re: [PATCH v2] mwifiex: add support for sd8977 chipset
References: <CY4PR18MB1237AEF3375B348254E0298FA08B0@CY4PR18MB1237.namprd18.prod.outlook.com>
Date:   Thu, 10 Jan 2019 09:40:20 +0200
In-Reply-To: <CY4PR18MB1237AEF3375B348254E0298FA08B0@CY4PR18MB1237.namprd18.prod.outlook.com>
        (Ganapathi Bhat's message of "Wed, 9 Jan 2019 14:46:09 +0000")
Message-ID: <871s5l6jvf.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ganapathi Bhat <gbhat@marvell.com> writes:

>>From a0f96e630eb5b74b047149e23c161a9f06fb2cc5 Mon Sep 17 00:00:00 2001
> From: Hemantkumar Suthar <shemant@marvell.com>
>
> This patch adds support for 8977 chipset to mwifiex with SDIO
> interface. Register offsets and supported feature flags are
> updated. Firmware image used will be mrvl/sd8977_uapsta.bin.
>
> Signed-off-by: Hemantkumar Suthar <shemant@marvell.com>
> Signed-off-by: Rakesh Parmar <rakeshp@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

I'm not sure if git automatically removes '>From ' (never seen it
before) so I'll remove it manually if needed.

-- 
Kalle Valo
