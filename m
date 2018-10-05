Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA36C00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 899E220875
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:32:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YirNn+Cw";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LbDDUyvi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 899E220875
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbeJEPab (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:30:31 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40502 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727750AbeJEPab (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 11:30:31 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8464B60866; Fri,  5 Oct 2018 08:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538728371;
        bh=N+CuAk7j0TWlRItuFmWqiMuLtzmfRLuWKxb4nIOfNsc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=YirNn+CwK8yG7E1R3bWCnSNZXIw4ZL7+WmOQCO3XPn7hh0s4tTpeOs6Hpd4mqFVGj
         5YUFG1bd0dw0oQ3nDt344fHHPTpPpi8HygLP9AjfbLJcR6EkBOdFQ+OfNLQIAIjJvJ
         9yWoWXqglTi7x5ByMshqkSlfgVFPW7Hxt+QYIK4Q=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7643060224;
        Fri,  5 Oct 2018 08:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538728370;
        bh=N+CuAk7j0TWlRItuFmWqiMuLtzmfRLuWKxb4nIOfNsc=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=LbDDUyvifLniFStoD0sW+ZtUx6OmSvF9VsPyOtmWPPoSV6Bgei1MMX9BjxbgIuV3W
         gYXy9sQ6AA1OpPgF1Dhu4r4bJQ8mdRQb1m46XV9+F4u4Yqa7TV3A2ien3BI8OoTkzo
         GYGWbx2wRIFnLznUJ5Rh8bXVQ4l4PDgQyAmOHPVw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7643060224
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rtlwifi: Removed unused define and code efuse_re_pg*
 from wifi.h
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181001092514.14359-1-pkshih@realtek.com>
References: <20181001092514.14359-1-pkshih@realtek.com>
To:     <pkshih@realtek.com>
Cc:     <linux-wireless@vger.kernel.org>, <joe@perches.com>,
        <rickveens92@gmail.com>, <Larry.Finger@lwfinger.net>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181005083251.8464B60866@smtp.codeaurora.org>
Date:   Fri,  5 Oct 2018 08:32:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<pkshih@realtek.com> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> The following:
>  bool efuse_re_pg_sec1flag;
>  u8 efuse_re_pg_data[8];
> are not referenced anywhere in the rtlwifi code.
> 
> This patch is originally created by Rick Veens <rickveens92@gmail.com>,
> and Joe Perches <joe@perches.com> reminded to apply it to rtlwifi.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

9c22211e1d71 rtlwifi: Removed unused define and code efuse_re_pg* from wifi.h

-- 
https://patchwork.kernel.org/patch/10621717/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

