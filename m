Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B959BC43143
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 04:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ADAC20684
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 04:44:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aeWtgZq6";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nXEvfU4t"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6ADAC20684
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbeJBL0M (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 07:26:12 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59648 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbeJBL0M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 07:26:12 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A408D60C4B; Tue,  2 Oct 2018 04:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538455497;
        bh=BH0/w5/gavWaTjmRzjFg/f8bVHuqSMUmc9egvNKEhqw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=aeWtgZq6S+m2GYpCP6Wo1LifUFeqXdWA1NxQsYrCrBV/tCpltZY8iyz/UEuRCk1mz
         mhGC8NOzMfKyPPiSw0zp2HaD3hvXKrQcyhhHi3vwuONrZUOTKytuABaK3xsW8X4eu9
         OsyDNqfw/6SH1eTz8w0Y8yo2clicwz9XMNEe1oR4=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0680F60866;
        Tue,  2 Oct 2018 04:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538455497;
        bh=BH0/w5/gavWaTjmRzjFg/f8bVHuqSMUmc9egvNKEhqw=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=nXEvfU4tFnxfIYJ7Cm0eN1aAHIZy7B+MgeEU+akOGAdoeFVd3WvBDxxsrg+zWbjjk
         NWyw9q0WoI29l8Cu16q9JkgXynht1mp+knG4a8YMDjDnOcjN82RPdkBU/KTIgqUIgg
         b0juSpfeEaoFydCTA3ggSrIPprrfi3quJrz2SRHM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0680F60866
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/5] ath9k: add counters for good and errorneous
 FFT/spectral frames
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180919103711.19304-2-sw@simonwunderlich.de>
References: <20180919103711.19304-2-sw@simonwunderlich.de>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        Simon Wunderlich <sw@simonwunderlich.de>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181002044457.A408D60C4B@smtp.codeaurora.org>
Date:   Tue,  2 Oct 2018 04:44:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Simon Wunderlich <sw@simonwunderlich.de> wrote:

> This is helpful to see whether spectral samples get discarded.
> 
> Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

5 patches applied to ath-next branch of ath.git, thanks.

03224678c013 ath9k: add counters for good and errorneous FFT/spectral frames
b796a6c04e65 ath9k: return when short FFT frame was handled
2f85786b8a57 ath9k: fix and simplify FFT max index retrieval
4e7a3fa5394e ath9k: FFT magnitude check: don't consider lower 3 data bits
4fb5837ac2bd ath9k: fix reporting calculated new FFT upper max

-- 
https://patchwork.kernel.org/patch/10605607/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

