Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6972C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 09:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE93C20854
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 09:07:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YLpTwMHH";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YLpTwMHH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE93C20854
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbeKESZ4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 13:25:56 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57902 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbeKESZ4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 13:25:56 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B3DCC601DA; Mon,  5 Nov 2018 09:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541408834;
        bh=DC79dbbQm2wnZq9Nl8afw+KfYrwJBh3H+bpIx1O7JjQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YLpTwMHHwYEBwO6hBEElpFJjBy/SZ3lne1MbbzrjXg0qG2sAaTg1OyL10IaX/0Xl+
         AAvDc6Y5hP19sW2RuHgv8s49rAPEuBnxSe8l1peMhWDeH7P+z3MaZkixQrwoPzy9Z4
         Dp7QxXZZmqWnOFK+u5nEpy5Mn7WcW5FNnmzdL58U=
Received: from x230.qca.qualcomm.com (37-33-75-124.bb.dnainternet.fi [37.33.75.124])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 82800601DA;
        Mon,  5 Nov 2018 09:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541408834;
        bh=DC79dbbQm2wnZq9Nl8afw+KfYrwJBh3H+bpIx1O7JjQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YLpTwMHHwYEBwO6hBEElpFJjBy/SZ3lne1MbbzrjXg0qG2sAaTg1OyL10IaX/0Xl+
         AAvDc6Y5hP19sW2RuHgv8s49rAPEuBnxSe8l1peMhWDeH7P+z3MaZkixQrwoPzy9Z4
         Dp7QxXZZmqWnOFK+u5nEpy5Mn7WcW5FNnmzdL58U=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 82800601DA
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
Subject: Re: [PATCH 3/5] brcmfmac: Drop unused cordic defines and macros
References: <cover.f21c8e62e188620d586edb3f77514e6237122c4c.1541238842.git-series.plaes@plaes.org>
        <7f3dbe604102f7d765149fffef8a4e6b9fa15552.1541238842.git-series.plaes@plaes.org>
Date:   Mon, 05 Nov 2018 11:07:09 +0200
In-Reply-To: <7f3dbe604102f7d765149fffef8a4e6b9fa15552.1541238842.git-series.plaes@plaes.org>
        (Priit Laes's message of "Sat, 3 Nov 2018 11:59:42 +0200")
Message-ID: <8736sfhozm.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Priit Laes <plaes@plaes.org> writes:

> Now that we use library macros, we can drop internal copies
>
> Signed-off-by: Priit Laes <plaes@plaes.org>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_int.h | 7 +-------

Also here this is about brcmsmac.

> --- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_int.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_int.h
> @@ -220,13 +220,6 @@ enum phy_cal_mode {
>  #define BB_MULT_MASK		0x0000ffff
>  #define BB_MULT_VALID_MASK	0x80000000
>  
> -#define CORDIC_AG	39797
> -#define	CORDIC_NI	18
> -#define	FIXED(X)	((s32)((X) << 16))
> -
> -#define	FLOAT(X) \
> -	(((X) >= 0) ? ((((X) >> 15) + 1) >> 1) : -((((-(X)) >> 15) + 1) >> 1))
> -

Ah, now I see the benefit from patch 2. IMHO you could just fold patch 3
into patch 2, no need to split them.

-- 
Kalle Valo
