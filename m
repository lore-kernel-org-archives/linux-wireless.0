Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E1B4C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 09:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41F8C2082A
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 09:06:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DE0u1Wh2";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="j+NpO5Fc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41F8C2082A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbeKESY3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 13:24:29 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54440 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbeKESY3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 13:24:29 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F137A6077A; Mon,  5 Nov 2018 09:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541408748;
        bh=Aup7kmp58nYkN7emvwrVAtGV3wOfSPGPpWC1Tk7FBKg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DE0u1Wh2DdVjM9Tv/XddKR02uexAM9ad6J5UeCbXAShF8YsFmXKZ/DVRldgGD6a/v
         b3oAHW1MyVqSEQpJ6irGnK+1zSJVGHPyCoRiA/1kZQJ52wuF4H2NmRaMtJhWcGHv/H
         CoQbc7fR8HpAGHvFXDTlQzLj6+05O5huyM6QlwsU=
Received: from x230.qca.qualcomm.com (37-33-75-124.bb.dnainternet.fi [37.33.75.124])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C867C6044B;
        Mon,  5 Nov 2018 09:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541408747;
        bh=Aup7kmp58nYkN7emvwrVAtGV3wOfSPGPpWC1Tk7FBKg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=j+NpO5Fc9bKqqLLCiO2+SkCl35z1Cj67ygxxRnAabhaMWWDBF1uAh4jj/7EzVC0Ge
         Sqiow1s8UxANiwOzgCkAuC+IpxEJgHrgCMYLEiW0uzyrNs1AgZQORTKQ3yjli4n0YP
         phMLqqs5sPkD0cgJ0Jbtpq3tFtxjDKpwZ2JiAxvU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C867C6044B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Priit Laes <plaes@plaes.org>
Cc:     linux-kernel@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: Re: [PATCH 2/5] brcmfmac: Use common CORDIC_FLOAT macro from lib
References: <cover.f21c8e62e188620d586edb3f77514e6237122c4c.1541238842.git-series.plaes@plaes.org>
        <4bd6e7758bc0d88b33cdb09448633bb5b97aba7c.1541238842.git-series.plaes@plaes.org>
Date:   Mon, 05 Nov 2018 11:05:42 +0200
In-Reply-To: <4bd6e7758bc0d88b33cdb09448633bb5b97aba7c.1541238842.git-series.plaes@plaes.org>
        (Priit Laes's message of "Sat, 3 Nov 2018 11:59:41 +0200")
Message-ID: <877ehrhp21.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Priit Laes <plaes@plaes.org> writes:

> Now that cordic library has the CORDIC_FLOAT macro, use that
>
> Signed-off-by: Priit Laes <plaes@plaes.org>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c | 4 ++--
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c   | 4 ++--

The driver is "brcmsmac" (note the 's', not 'f'), you should fix the
title accordingly.

> --- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
> @@ -3447,8 +3447,8 @@ wlc_lcnphy_start_tx_tone(struct brcms_phy *pi, s32 f_kHz, u16 max_val,
>  
>  		theta += rot;
>  
> -		i_samp = (u16) (FLOAT(tone_samp.i * max_val) & 0x3ff);
> -		q_samp = (u16) (FLOAT(tone_samp.q * max_val) & 0x3ff);
> +		i_samp = (u16)(CORDIC_FLOAT(tone_samp.i * max_val) & 0x3ff);
> +		q_samp = (u16)(CORDIC_FLOAT(tone_samp.q * max_val) & 0x3ff);

I haven't seen the patch 1 yet, but just from seeing this patch I don't
get what's the benefit.

-- 
Kalle Valo
