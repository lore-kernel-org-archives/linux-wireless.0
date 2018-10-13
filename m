Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63ED7C71122
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 12:01:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 296F920865
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 12:01:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EYS92jxN";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jsPcJUUr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 296F920865
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbeJMThw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 15:37:52 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40550 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbeJMThw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 15:37:52 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A423160866; Sat, 13 Oct 2018 12:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539432060;
        bh=zWRBAhx12KlOUEhBZwPlG4IDep6DXr9XO0r/NQwjhjg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=EYS92jxNK/fQ2TLd/M+bjDtecnWl5iLzSvM2KX7bKTpt2GTYGcdC20m87FRmfdixo
         vc3PwYz0HocCc0XBBz5Zn8R/ZpjNzJRklcE8eiptD0PnFGlEsjBku1GRk2VlYaoX4f
         eIH1a54Po0XsOFzYpWm9pD5PPGJTrzfQHvkioFFA=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AA5D6605A2;
        Sat, 13 Oct 2018 12:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539432060;
        bh=zWRBAhx12KlOUEhBZwPlG4IDep6DXr9XO0r/NQwjhjg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=jsPcJUUrwxXm9AC9ugLBStK7Mqs9lCGDTeJRiqFU57jgJiU1AVf6eD3hrX+5U/bl3
         qCmVtsqx89iSSYU1uquMxqkKQjcrlK2clQaJVzqY/dS+lI83KPPlKzDCluvMyxws86
         FO8I33y5oAlKx3CwmdjAcvBUkcZnm7/yEbYDtNMg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AA5D6605A2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8821ae: replace
 _rtl8821ae_mrate_idx_to_arfr_id with generic version
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181008085028.23874-1-colin.king@canonical.com>
References: <20181008085028.23874-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181013120100.A423160866@smtp.codeaurora.org>
Date:   Sat, 13 Oct 2018 12:01:00 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Function _rtl8821ae_mrate_idx_to_arfr_id is functionally identical to
> the generic version rtl_mrate_idx_to_arfr_id, so remove 
> _rtl8821ae_mrate_idx_to_arfr_id and use the generic one instead.
> 
> This also fixes a missing break statement found by CoverityScan in
> _rtl8821ae_mrate_idx_to_arfr_id, namely: CID#1167237 ("Missing break
> in switch")
> 
> Thanks to Joe Perches for spotting this when I submitted an earlier patch.
> 
> Fixes: 3c05bedb5fef ("Staging: rtl8812ae: Add Realtek 8821 PCI WIFI driver")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers-next.git, thanks.

c894696188d5 rtlwifi: rtl8821ae: replace _rtl8821ae_mrate_idx_to_arfr_id with generic version

-- 
https://patchwork.kernel.org/patch/10630249/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

