Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 725FAC282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 436DF21872
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:27:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fLCvnp0y";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iwpMJbtR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbfBAM1F (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:27:05 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36176 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbfBAM1F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 07:27:05 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8C80360398; Fri,  1 Feb 2019 12:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024024;
        bh=XnzyrtNsem/uOmYbhq1+CErxJa1B7TPp4MiEzrHLX+0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=fLCvnp0yX9B6raagpD7eGsuXrRS5ichXZIqIhF3tqKeWdVRkIk5zsTJSkmjvCzRoT
         7c60Jyp5y4YTmQ9O+oFtgKyUHPLyGOfSp510d2WDWNOEJmwHBKFW7Rg3bL8JwlfAPk
         miQ13UNWUy10N+6R9VADqw44qs0AwJT7ND7sokoQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0FE7C6043F;
        Fri,  1 Feb 2019 12:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024024;
        bh=XnzyrtNsem/uOmYbhq1+CErxJa1B7TPp4MiEzrHLX+0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=iwpMJbtRq/NhNVGzIZu9xnj0kTEYnfx7BqdzO2PjYGjITTMzs7V5VQTo3aSx4KRR+
         LvoC0m4nU566gZsHYDA9WgQ7it8yiCxBFs/XOYnjMacF3EQKE6IMlKPlTEgqHUutVR
         ehkSQ6ftnrndz6M2bIMbyl5xRyz7/OX1PR7YmF44=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0FE7C6043F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rsi: Suppress sdhci warnings in mmc
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1547803087-2767-1-git-send-email-siva8118@gmail.com>
References: <1547803087-2767-1-git-send-email-siva8118@gmail.com>
To:     Siva Rebbagondla <siva8118@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Rishikesh Basu <rishikesh.basu@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Ganapathi Kondraju <ganapathi.kondraju@redpinesignals.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190201122704.8C80360398@smtp.codeaurora.org>
Date:   Fri,  1 Feb 2019 12:27:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Siva Rebbagondla <siva8118@gmail.com> wrote:

> From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> 
> while inserting and removing sdio module multiple times, we are getting
> sdhci warnings. This is because, improper assignment of ocr_avail value.
> Fixed this by assigning proper value.
> 
> This patch is enhancement for commit 78e450719c702 ("rsi: Fix 'invalid
> vdd' warning in mmc").
> 
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

Patch applied to wireless-drivers-next.git, thanks.

1e1b4161e859 rsi: Suppress sdhci warnings in mmc

-- 
https://patchwork.kernel.org/patch/10769587/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

