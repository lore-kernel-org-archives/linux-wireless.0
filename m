Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD0BEC169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 14:16:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 968A220844
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 14:16:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="a2OGQRCY";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LGzDvzNW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727602AbfBHOQG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 09:16:06 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54556 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbfBHOQG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 09:16:06 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CD4976032C; Fri,  8 Feb 2019 14:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549635364;
        bh=1t9eIGIS/HKguyz3JWZoTJvhW/KqEgDom1f/AAVJwcE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=a2OGQRCYeYbfwD510apaymoWOqpzn7VRdZSH8kMRxNDLgMDPNlGr4VSpaCoTZQDcl
         eynTgjYVHlHN0pBSbeVdvbJTRKFJS8TSx2CXnS3n0FD29dTZp7DINYyfUxjUUh4dZ1
         Xfor2rKV/8qSliGbwPOXZpRu7qwGA3S0gsPOgodU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5F0AC602CC;
        Fri,  8 Feb 2019 14:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549635364;
        bh=1t9eIGIS/HKguyz3JWZoTJvhW/KqEgDom1f/AAVJwcE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=LGzDvzNWLty5PgK1F/5ur7/6kHK2VAqRutCy+uy/SbB2e08ZLp/PBY04QnlHOGcRu
         6laHi9XrQzU/e/0BgrCNjYeBCMWbbZ/1IRAs744C9NZC3NeRlDYVdk1z0NeeO5Jm5a
         NJbqQbpcj4WfiIvUoJOGqz0KvA+9Rxs0ab6/FRxY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5F0AC602CC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Enable Factory Test Mode for WCN3990
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1535526038-4299-1-git-send-email-pillair@codeaurora.org>
References: <1535526038-4299-1-git-send-email-pillair@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190208141604.CD4976032C@smtp.codeaurora.org>
Date:   Fri,  8 Feb 2019 14:16:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rakesh Pillai <pillair@codeaurora.org> wrote:

> The support to put WCN3990 firmware into Factory
> test mode is not present currently. The WCN3990
> firmware can operate in Factory test mode based
> on the mode it receives in the wlan enable message
> from the host driver.
> 
> When the host driver is started in testmode send
> the operating mode as UTF mode, to the WCN3990
> firmware, in the wlan enable message to start the
> firmware in Factory test mode.
> 
> Tested on: WCN3990
> Tested FW: WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1.
> 
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

I was able to apply with 3-way merge but please double check the results:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=ef562f95826f412c14f59ca916ff55931bed0813

Applying: ath10k: Enable Factory Test Mode for WCN3990
Using index info to reconstruct a base tree...
M       drivers/net/wireless/ath/ath10k/ahb.c
M       drivers/net/wireless/ath/ath10k/core.c
M       drivers/net/wireless/ath/ath10k/hif.h
M       drivers/net/wireless/ath/ath10k/mac.c
M       drivers/net/wireless/ath/ath10k/pci.c
M       drivers/net/wireless/ath/ath10k/sdio.c
M       drivers/net/wireless/ath/ath10k/snoc.c
M       drivers/net/wireless/ath/ath10k/usb.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/ath/ath10k/usb.c
Auto-merging drivers/net/wireless/ath/ath10k/snoc.c
Auto-merging drivers/net/wireless/ath/ath10k/sdio.c
Auto-merging drivers/net/wireless/ath/ath10k/pci.c
Auto-merging drivers/net/wireless/ath/ath10k/mac.c
Auto-merging drivers/net/wireless/ath/ath10k/hif.h
Auto-merging drivers/net/wireless/ath/ath10k/core.c
Auto-merging drivers/net/wireless/ath/ath10k/ahb.c

-- 
https://patchwork.kernel.org/patch/10579559/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

