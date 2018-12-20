Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56697C43612
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 202A6218E0
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:08:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="B/TbUwWJ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WVKacGE3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731473AbeLTRIH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 12:08:07 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37378 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729720AbeLTRIG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 12:08:06 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 972A2602CB; Thu, 20 Dec 2018 17:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545325685;
        bh=KrWKHejGY40TA7+09WJc5pMyNHKFaezQJxUmW+p8Ei0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=B/TbUwWJsCOd1zUgSUZQq9wcy0+Z70TQWfq5mJQ7GJHeF07IP5evnT0Z+Tp9685xj
         E8gq8BGPzYL2P1zoXKl2LIAmUw7EmKL9lhuOCSHsbZ2flmX7IXFZsE1dsyjvACcm0c
         bq3GRyh7ki4lzMxY12splHYMtuMDeCm6sG5vwDHI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7FF356014B;
        Thu, 20 Dec 2018 17:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545325685;
        bh=KrWKHejGY40TA7+09WJc5pMyNHKFaezQJxUmW+p8Ei0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=WVKacGE3FhT7DtNQvd3myWsZTnhdfVqkpGQjMwkTCk/nxlyboSgqIyPTPB2Qago+q
         uROE8guLViTGeWgZa+plBmqwBz9nCJ50erhKdb3BYvtQQ9rtYlm9kvf/ODNEX3kVNE
         NVu/MwGjgsr/5yfCUqoP+Gvfq6tCDr63r8L7OPFY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7FF356014B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 1/3] dt: bindings: add missing dt properties for
 WCN3990 wifi node
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1541423318-19312-2-git-send-email-govinds@codeaurora.org>
References: <1541423318-19312-2-git-send-email-govinds@codeaurora.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     briannorris@chromium.org, andy.gross@linaro.org,
        ath10k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-wireless@vger.kernel.org, robh+dt@kernel.org,
        sboyd@kernel.org, dianders@chromium.org,
        linux-kernel@vger.kernel.org, Govind Singh <govinds@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181220170805.972A2602CB@smtp.codeaurora.org>
Date:   Thu, 20 Dec 2018 17:08:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Govind Singh <govinds@codeaurora.org> wrote:

> Add missing optional properties in WCN3990 wifi node.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> Tested-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

5fac78aac91d dt: bindings: ath10k: add missing dt properties for WCN3990 wifi node
a3542d0c73ce dt: bindings: ath10k: add bindings for wifi iommu node

-- 
https://patchwork.kernel.org/patch/10668237/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

