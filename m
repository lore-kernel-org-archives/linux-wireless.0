Return-Path: <SRS0=6Pxi=7L=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29761C433E0
	for <linux-wireless@archiver.kernel.org>; Fri, 29 May 2020 17:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E98E62065C
	for <linux-wireless@archiver.kernel.org>; Fri, 29 May 2020 17:41:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="VQxAXh1V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgE2Rli (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 May 2020 13:41:38 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:24164 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726549AbgE2Rli (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 May 2020 13:41:38 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590774097; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=z3/+BzcNWuNyJ/PPhv1oZOQCAe8HxM1NQYnZ727fjl4=;
 b=VQxAXh1VQ8/V3xZvSFrWh4z/ur/UFkCqrh8hEszC9pAquiQoQ/0hZJdc9xh7Js8CaP32O2/i
 6/uqfkZi7QQXroBMAMst6IITttE4Ytc/vUBFy8XHeO71jO7+cvRvLzXQpOPhMUxZXR+vzF2Q
 ka8NA3JdpxvPHDzFQxeYxNSsFm4=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5ed1494744a25e00522de95c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 29 May 2020 17:41:27
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 384F8C433C6; Fri, 29 May 2020 17:41:26 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D082AC433CA;
        Fri, 29 May 2020 17:41:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D082AC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mwifiex: Parse all API_VER_ID properties
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200521123444.28957-1-pali@kernel.org>
References: <20200521123444.28957-1-pali@kernel.org>
To:     =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?utf-8?q?Marek_Beh=C3=BAn?= <marek.behun@nic.cz>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200529174126.384F8C433C6@smtp.codeaurora.org>
Date:   Fri, 29 May 2020 17:41:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Pali Rohár <pali@kernel.org> wrote:

> During initialization of SD8997 wifi chip kernel prints warnings:
> 
>   mwifiex_sdio mmc0:0001:1: Unknown api_id: 3
>   mwifiex_sdio mmc0:0001:1: Unknown api_id: 4
> 
> This patch adds support for parsing all api ids provided by SD8997
> firmware.
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> Acked-by: Ganapathi Bhat <ganapathi.bhat@nxp.com>

Patch applied to wireless-drivers-next.git, thanks.

86cffb2c0a59 mwifiex: Parse all API_VER_ID properties

-- 
https://patchwork.kernel.org/patch/11562833/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

