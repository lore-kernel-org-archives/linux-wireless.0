Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF79C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:00:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3DE520815
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:00:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="h5O779gb";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lqoKJPy9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732714AbeLTRAC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 12:00:02 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:53710 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730530AbeLTRAB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 12:00:01 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 64C9A60595; Thu, 20 Dec 2018 17:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545325201;
        bh=Z8esnI05L0gVsyacIPEuYeIxE474I8TTVwgc67ARySU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=h5O779gbpViAvIMnyiN73S4oWj+vehV8qZTxBIanrtA4Zqstp52knGaS6ZU9moMx5
         xwBFlc+Wd9oam8+2Te37AxhNVtsmm9kkRkT/w1RAQL/V6RCJudvoNaDLS3SZvW+PCn
         umh4SvI7VwUGdxuqX2uifJW1xb7yGGMLLlWYB+Zk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 05A906034E;
        Thu, 20 Dec 2018 16:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545325201;
        bh=Z8esnI05L0gVsyacIPEuYeIxE474I8TTVwgc67ARySU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=lqoKJPy9kiFo7/KOXSO9QzACuT3sUT1m1PDj5aCSiDFaz++vG6pa9uMevVIwqUSfw
         Q5lOBomRpNE3sTZUhiHtu5vyQ0/Bmq78WlzjLHVtzfya8q3yhdTf31rO8pbdF1oomX
         cWddNLCDmJCJbfaIyBbV0rXbGpO50yGDSt9yy6Eg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 05A906034E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath10k: report tx rate using ieee80211_tx_rate_update()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1540530438-11292-1-git-send-email-akolli@codeaurora.org>
References: <1540530438-11292-1-git-send-email-akolli@codeaurora.org>
To:     Anilkumar Kolli <akolli@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181220170001.64C9A60595@smtp.codeaurora.org>
Date:   Thu, 20 Dec 2018 17:00:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Anilkumar Kolli <akolli@codeaurora.org> wrote:

> Mesh path metric needs tx rate information from ieee80211_tx_status()
> call but in ath10k there is no mechanism to report tx rate information
> via ieee80211_tx_status(), the tx rate is only accessible via
> sta_statiscs() op.
> 
> Per peer tx stats has tx rate info available, Tx rate is available
> to ath10k driver after every 4 PPDU sent in the air. For each PPDU,
> ath10k driver updates rate informattion to mac80211 using
> ieee80211_tx_rate_update().
> 
> Per peer txrate information is updated through per peer statistics
> and is available for QCA9888/QCA9984/QCA4019/QCA998X only
> 
> Tested on QCA9984 with firmware-5.bin_10.4-3.5.3-00053
> Tested on QCA998X with firmware-5.bin_10.2.4-1.0-00036
> 
> Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

9a9cf0e63f70 ath10k: report tx rate using ieee80211_tx_rate_update()

-- 
https://patchwork.kernel.org/patch/10656925/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

