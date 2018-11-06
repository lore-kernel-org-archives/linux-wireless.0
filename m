Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CBA8C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 025E32081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:57:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="flP7f9nE";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="f09E1gtg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 025E32081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389344AbeKGCXW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:23:22 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56522 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389214AbeKGCXW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:23:22 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A31B3605FD; Tue,  6 Nov 2018 16:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523435;
        bh=9LMKUKsEfm2vU8KkmpdXiTBuWWy/9AVwmbStrC/JQig=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=flP7f9nEOfIFbs+nxcwMCMeWOEg/9PUrMU4v2iwZfLBrbTJUeOkYBU6G20bVaVHkG
         xJBsDi8KTcDXDvPudWcD+tbRZdaRPfbbke+KJDXC+c2zn0sftwCMM9A519M/rlRfo2
         /Q+bN1H+papBRy2JN45mS2DI23asyryat8w5FSYs=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 37BF6601D7;
        Tue,  6 Nov 2018 16:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523435;
        bh=9LMKUKsEfm2vU8KkmpdXiTBuWWy/9AVwmbStrC/JQig=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=f09E1gtggzV3NiSYUw4SsEyrFP4Wsjw/81Fbh3zElZdXgTKJ0YhYrDqheBRVUDCVQ
         MQI08P4q+CUQ3C2qPBxa771B6LQZlJwjPMvEn3DiY298dLWCO8HsOIbILIz8hsA80d
         5PQ18GfMfEqIKK5duinS7Edk7K0bkCZMbUkp98EU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 37BF6601D7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: fix spelling mistake "Retreiving" ->
 "Retrieving"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181016174342.1867-1-colin.king@canonical.com>
References: <20181016174342.1867-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S . Miller" <davem@davemloft.net>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106165715.A31B3605FD@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 16:57:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Trivial fix to spelling mistake in brcmf_err error message.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

e966a79c2f76 brcmfmac: fix spelling mistake "Retreiving" -> "Retrieving"

-- 
https://patchwork.kernel.org/patch/10643927/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

