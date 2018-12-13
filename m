Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E8D3C65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 15:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 448EF2086D
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 15:02:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YDz4uuCq";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kiQKNi0w"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 448EF2086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbeLMPCl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 10:02:41 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:53020 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbeLMPCk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 10:02:40 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BE5E8607BA; Thu, 13 Dec 2018 15:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544713359;
        bh=1Pzi16H3tkjNW442TdDH0VdFrQpmRQQczdVevoeq8pU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=YDz4uuCqpSwzH3Ka/Fq7fpOlRsNuWKE8jguDZHGR8fLAyxwaSqKgsli0rii05ZUOV
         PHFR+B6aCOwwvV6T6UEXsfci2GYYjXcntaypFopLH11uEGpxGk1xt40QHg52/op2XN
         Q43iYAM6Y2Z4nfApiY+w8sNEZYfIbtEfv29o6qzM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DB6F16013C;
        Thu, 13 Dec 2018 15:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544713357;
        bh=1Pzi16H3tkjNW442TdDH0VdFrQpmRQQczdVevoeq8pU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=kiQKNi0wElSTk5Mj/s/9G33LRnuSXmRW/GTjlt+A3MQ3si+LKOcU6j9XSJxfyPoHy
         2vYKYNWt6jnTlKpxDvUgBTuvynJCqsViT4IGnf/fkAOm9wHNseoyuuO9NI7dKf0YEC
         xIzlSEKrOvITbzmoLmzY4QOfG9MSI9IhkefjCNow=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DB6F16013C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] b43: remove set but not used variables 'tx_pwr_state,
 tmp2'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1543994766-7057-1-git-send-email-yuehaibing@huawei.com>
References: <1543994766-7057-1-git-send-email-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Priit Laes <plaes@plaes.org>,
        Kees Cook <keescook@chromium.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <b43-dev@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181213150239.BE5E8607BA@smtp.codeaurora.org>
Date:   Thu, 13 Dec 2018 15:02:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/broadcom/b43/phy_n.c: In function 'b43_nphy_op_recalc_txpower':
> drivers/net/wireless/broadcom/b43/phy_n.c:5898:7: warning:
>  variable 'tx_pwr_state' set but not used [-Wunused-but-set-variable]
> 
> drivers/net/wireless/broadcom/b43/phy_n.c:6047:20: warning:
>  variable 'tmp2' set but not used [-Wunused-but-set-variable]
> 
> 'tx_pwr_state' never used since introduction in commit
> 8615eb2870f1 ("b43: N-PHY: support setting custom TX power")
> 
> 'tmp2' not used any more since commit c002831a07dd ("b43: N-PHY: use helper
> for checking IPA")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

662a7b078cff b43: remove set but not used variables 'tx_pwr_state,tmp2'

-- 
https://patchwork.kernel.org/patch/10713095/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

