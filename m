Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7271C64EBC
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 05:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9609521470
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 05:37:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XGIVjrq7";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MrYMiukd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9609521470
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbeJDM3P (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 08:29:15 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58542 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbeJDM3O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 08:29:14 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0818E60C6C; Thu,  4 Oct 2018 05:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538631462;
        bh=GdffzGI0Sq6e+lPsUzqYUhMCydIwYPLHgDLmM4AGq+c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=XGIVjrq7ach2+5K2FV5XaEcSYvlRsLYUE7EfDysvLd7epUT8sh1uERypmlvYsVku4
         ovA7x8wyKFg5gTFd6OlViM34en02L0tnmVUbxySwUAI3FoH3BAuGKMi//svLZoPMls
         1McpzIQBgHqJ6chxXCLDWBPqvuWv8bB6jkT+TbAA=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 13AFD6081B;
        Thu,  4 Oct 2018 05:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538631461;
        bh=GdffzGI0Sq6e+lPsUzqYUhMCydIwYPLHgDLmM4AGq+c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MrYMiukdo0tekbaLzDambH54I8iNMxFYhwEHsZtp9xehHe9JU2EoqGBOQnMTMnZx9
         J4jrV3wHwJW9MRsmDvUvO60nwi3ivAekAbV5XmG0PFztVdV87pUGNuAMsWcgRnqTpP
         wbR96ZnxMHt3pl3FpCvTiGHUKZzrv/3Ku5aGODvk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 13AFD6081B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull request: mt76 2018-10-01
References: <25927d7a-ddb0-a588-0979-a45f87f7e8b2@nbd.name>
Date:   Thu, 04 Oct 2018 08:37:36 +0300
In-Reply-To: <25927d7a-ddb0-a588-0979-a45f87f7e8b2@nbd.name> (Felix Fietkau's
        message of "Mon, 1 Oct 2018 13:31:52 +0200")
Message-ID: <87r2h6qnkv.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> Here's another large batch of mt76 code cleanup / deduplication / fixes
>
> - Felix
>
> The following changes since commit 93ed990e3a6e722b7b1e1d59b3ceb8d91e36e682:
>
>   qtnfmac: remove set but not used variable 'vif' (2018-09-20 15:12:13 +0300)
>
> are available in the Git repository at:
>
>   https://github.com/nbd168/wireless tags/mt76-for-kvalo-2018-10-01
>
> for you to fetch changes up to 5289976ad887deb07c76df7eecf553c264aeebed:
>
>   mt76: mt76x2: fix multi-interface beacon configuration (2018-10-01 13:26:21 +0200)
>
> ----------------------------------------------------------------
> mt76 patches for 4.20
>
> * unify code between mt76x0, mt76x2
> * mt76x0 fixes
> * tx power configuration fix for 76x2
> * more progress on mt76x0e support
> * support for getting firmware version via ethtool
> * fix for rx buffer allocation regression on usb
> * fix for handling powersave responses
> * fix for mt76x2 beacon transmission
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
