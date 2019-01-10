Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41AB3C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 09:01:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 136A6214C6
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 09:01:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gEvzX8OI";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HZNRJPjn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbfAJJBP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 04:01:15 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:41076 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbfAJJBO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 04:01:14 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C2152608C6; Thu, 10 Jan 2019 09:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547110874;
        bh=QQnjrMOleA6m7NP6mbQceGcYX+3WM67o/7egS/oX6w4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gEvzX8OIF39mMxqswQdo5inhcU0WW6jTQDCGnlo+D+p+VrDUQS8hynDacZ7Xwiglj
         t/jYUm1kL7BMz/OldYagyXGhpl4zkm5/P4jkqnN9n/QYE6uKB5v4+9peXIMrALX6qL
         lBrBIZ5p/7p9lUMGIZ7N09IlFg3mdH2b2q3LR4gQ=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C726E608A5;
        Thu, 10 Jan 2019 09:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547110873;
        bh=QQnjrMOleA6m7NP6mbQceGcYX+3WM67o/7egS/oX6w4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HZNRJPjnDRBcDQRUAzV9CoSFKZWzR0AKnrmbAxEz2JWQXnDE1esoKBBgfPfKMS5uU
         5zskc7XfQxdOOKlcqiRtoVZtq53pVidp7VQKRN7xYaWft0Fz43LJVjTnRX3h8ntaus
         pXliEHDGOwQZ0pAkmAnrRfjwwB1D7JkzAV6us3aU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C726E608A5
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
Subject: Re: [PATCH v3] mwifiex: add support for sd8977 chipset
References: <CY4PR18MB1237E51E20E86ED04AF401D0A0840@CY4PR18MB1237.namprd18.prod.outlook.com>
Date:   Thu, 10 Jan 2019 11:01:09 +0200
In-Reply-To: <CY4PR18MB1237E51E20E86ED04AF401D0A0840@CY4PR18MB1237.namprd18.prod.outlook.com>
        (Ganapathi Bhat's message of "Thu, 10 Jan 2019 08:45:54 +0000")
Message-ID: <87wonc6g4q.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ganapathi Bhat <gbhat@marvell.com> writes:

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

Changelog missing:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#changelog_missing

But no need to resend, just reply to this mail and explain what changed
from v2.

-- 
Kalle Valo
