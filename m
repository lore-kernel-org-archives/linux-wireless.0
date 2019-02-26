Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 738C1C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43B7620651
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:06:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FU+J2b/U";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PrkhYCLs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbfBZNGT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 08:06:19 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:47526 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfBZNGS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 08:06:18 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7B9BA61A88; Tue, 26 Feb 2019 13:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551186377;
        bh=kHsAkFKKJEMKrv43JVrUY99u4uFk0E2GZwvOdoIA8sk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=FU+J2b/U0wh5L3hxU7V+LECviNOlbh6aNQyNUTpDGRNqClYZEJZcgFsFB9BINRvtO
         IM9o7NSHPFiKeGA+G8lfbNfNrDNwIuSygAzVwsli+moCSui0H0ZHWzFQ/1t9eI1n5K
         AGvrUXj4yxltHZuJ0ExJJVOFqhduutz90oFZ2U7Y=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7B13361A88;
        Tue, 26 Feb 2019 13:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551186376;
        bh=kHsAkFKKJEMKrv43JVrUY99u4uFk0E2GZwvOdoIA8sk=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=PrkhYCLs6g5dC7bjwFzU4kVNTNcbiUmNWcpahAD+d2wFl2ENbvW2dDp1iPaRLn6Ur
         bVUaN/XO04EdpRuKX5TIpGIGrcTpt5uWqjA6Q21pn/1LJDVPmmGjJCaBxXlJvGTudo
         wO/WQPKeJQrBepFq4uWACQnneLQF8cd1nnTbkTgY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7B13361A88
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: remove the calibration data fetch for sdio
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1550470471-28002-1-git-send-email-wgong@codeaurora.org>
References: <1550470471-28002-1-git-send-email-wgong@codeaurora.org>
To:     Wen Gong <wgong@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190226130617.7B9BA61A88@smtp.codeaurora.org>
Date:   Tue, 26 Feb 2019 13:06:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wen Gong <wgong@codeaurora.org> wrote:

> The calibration data fetch will trigger sdio error, then sdio will
> become fail untill reboot system.
> 
> If happens when run ifconfig wlan down, then ifconfig wlan up will
> fail untill reboot system.Remove it fix the ifconfig wlan issue.
> 
> Tested with QCA6174 SDIO with firmware
> WLAN.RMH.4.4.1-00005-QCARMSWP-1.
> 
> Signed-off-by: Wen Gong <wgong@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

6566abea0b97 ath10k: remove the calibration data fetch for sdio

-- 
https://patchwork.kernel.org/patch/10817363/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

