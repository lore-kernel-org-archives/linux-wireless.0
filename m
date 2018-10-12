Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC349C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 11:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A20422086A
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 11:35:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YDMtCis/";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ae0RI6G+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A20422086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbeJLTHQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 15:07:16 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53150 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbeJLTHQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 15:07:16 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 50F066072E; Fri, 12 Oct 2018 11:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539344115;
        bh=Q/tIw/+kHvpXSyHIjCIcEaMYtOfa1OtPwTTHB5q4ANQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=YDMtCis/p3kQiAEDa7BjCeacZaR355GGBAkWwYVrhshBeqepPyRzmgqpdQYvCdnri
         uuKE/94uduLO1tpQPDb7bGmF/AE4yRklW3qOrg1hXYYg24D+M8tsmMWqFzhsJ1I/7G
         VNDQGBC+flhjncSjivOPlfPlYAHV9Qd+opRz7reE=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C9CF16031A;
        Fri, 12 Oct 2018 11:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539344114;
        bh=Q/tIw/+kHvpXSyHIjCIcEaMYtOfa1OtPwTTHB5q4ANQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Ae0RI6G++HtoK76fStFLnZvgaAo1zedC3mddxqmTtOpEMzyBwbbLS0HLQm/E2JwCo
         l4xF6ys0hpXnwvFudrpYaa47mSSnAUH3shMr5F8R1FQ3gDKkdJeGoVSmkQnTAWA1Gy
         doTCtLksnG6CfmC8JyP6u1q9ueHxBrx/MuoIf7I8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C9CF16031A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/2] ath10k: report tx rate using
 ieee80211_tx_rate_update()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1539261904-9016-3-git-send-email-akolli@codeaurora.org>
References: <1539261904-9016-3-git-send-email-akolli@codeaurora.org>
To:     Anilkumar Kolli <akolli@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181012113515.50F066072E@smtp.codeaurora.org>
Date:   Fri, 12 Oct 2018 11:35:15 +0000 (UTC)
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

Depends on:

f8252e7b5a83 mac80211: implement ieee80211_tx_rate_update to update rate

Currently in mac80211-next.

-- 
https://patchwork.kernel.org/patch/10636627/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

