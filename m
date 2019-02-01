Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F47C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A305B21872
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:20:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EwFTs9jq";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PPpS13YV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbfBAMUW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:20:22 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58288 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbfBAMUW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 07:20:22 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 510B860867; Fri,  1 Feb 2019 12:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549023621;
        bh=0i/CEAM2nPcEoJrCo6pmKUBtFQVS9c9jnSDxywYgiaw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=EwFTs9jqzho9nVoFMLqwpJHv0dU5E2kYwm0qaeNT8M/dkKxzQ+R4EYV29MX6VNIy4
         7sRiT3J5ZuULWxf6p7wa184XbnonJFUWiQTwdOxnl/8tvQeuJY4KUfJ+IqLWNqrBjM
         n1GxPduOhG3Zl5XGhenWln5njjPzmWNh3oGBa8Dw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7C3B76043F;
        Fri,  1 Feb 2019 12:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549023620;
        bh=0i/CEAM2nPcEoJrCo6pmKUBtFQVS9c9jnSDxywYgiaw=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=PPpS13YVIdn2qonIDO2IHTF6bQowSCHd4TQCEIWZEXKNoFDWUP8mlFxV7Qq0hlJvp
         tYIyK2wgYmRnz6zcEQXSDUcBfxu4PGUeigCahD9SIsTb+D4KRjH1SUjzqdngO+7jFj
         ofiIRNdXDmpwTA+Jes3sWLI1biqFFy7VVvpeq1Ik=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7C3B76043F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl818x: fix indentation issue
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190117152859.6873-1-colin.king@canonical.com>
References: <20190117152859.6873-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190201122021.510B860867@smtp.codeaurora.org>
Date:   Fri,  1 Feb 2019 12:20:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a statement that is indented too deeply. Fix this.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: John W. Linville <linville@tuxdriver.com>

Patch applied to wireless-drivers-next.git, thanks.

2d76fff865d6 rtlwifi: rtl818x: fix indentation issue

-- 
https://patchwork.kernel.org/patch/10768407/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

