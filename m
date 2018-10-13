Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2937BC28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 12:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E51A820865
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 12:00:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Mg2jSNPt";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TCJWBTbp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E51A820865
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbeJMTgk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 15:36:40 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39960 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbeJMTgk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 15:36:40 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 230CE6072E; Sat, 13 Oct 2018 11:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539431988;
        bh=+xHzGxZ1lcEIR2p7HkOWM+n8eAsYmTvoGX8NFvZ3O+c=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Mg2jSNPtdxAY4xJNqqnPArowO/FKK+/UhnkP7ux58tV3GK9QanzdEWGNcXaxOEz8o
         V258JeN9dTNhc8u4HS9c72ofDJasFN8tbodHm0+JoFVqvtO5WGr4vT+aPvASTV8+xE
         Bk+TPH4DOcWwWtHvjIpUz4NDybjfl9DTKJ09LI28=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7D035601D2;
        Sat, 13 Oct 2018 11:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539431987;
        bh=+xHzGxZ1lcEIR2p7HkOWM+n8eAsYmTvoGX8NFvZ3O+c=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=TCJWBTbp4fE5K8jnIIM0zUAIU2qRKDw3z6ScK7sFMiO1udDpnzopEO/l6OdYcZyk7
         qvcDG5rwrcWoMuNypDsZDfStIC32G/mVRBz8L8rvMUf2cs8dxibY9xefAhe25eVGmN
         Lov+aRrj77HzhqVcIax/VDby+8gD/1sqA6jt2ZRE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7D035601D2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8821ae: add in a missing break in switch
 statement
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181006184246.29985-1-colin.king@canonical.com>
References: <20181006184246.29985-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Tsang-Shian Lin <thlin@realtek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181013115948.230CE6072E@smtp.codeaurora.org>
Date:   Sat, 13 Oct 2018 11:59:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The switch case RATR_INX_WIRELESS_MC has a missing break, this seems
> to be unintentional as the setting of variable ret gets overwritten
> when the case falls through to the following RATR_INX_WIRELESS_AC_5N
> case.  Fix this by adding in the missing break.
> 
> Detected by CoverityScan, CID#1167237 ("Missing break in switch")
> 
> Fixes: 3c05bedb5fef ("Staging: rtl8812ae: Add Realtek 8821 PCI WIFI driver")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Dropping this patch per discussion.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10629291/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

