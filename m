Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93836C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 14:54:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FC7B20652
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 14:54:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="R4t7LI+5";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YHo4dg38"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbfAQOyN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 09:54:13 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:50794 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727709AbfAQOyM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 09:54:12 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D76326084F; Thu, 17 Jan 2019 14:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547736851;
        bh=9WcADlFlGg0FoNfnFxMeo31KF+JfTzJg1xgEuhJHGPk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=R4t7LI+5teCRVTKTKgNEA4BXsANKO3NhwxZWm41Vlwj9go/knpNbn75mF6TlQjjPi
         cot+ZjEcnXVUwxFm3QfptJAIJ7ZmSY+sErgX8VcbNd0yudijwCLljDpIADCrVdWF4F
         NwJXQwUGqIZf60f40Hogb8zgEwG3nhBja2PYJ1vw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 336F46053B;
        Thu, 17 Jan 2019 14:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547736849;
        bh=9WcADlFlGg0FoNfnFxMeo31KF+JfTzJg1xgEuhJHGPk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YHo4dg38CmIff9kq1NcxfVTVKTnCniHUkuPxpR0gmIMnVvMSaPfELXO8dg8jlmB1W
         Ij31KFXsZjCc5Kes2TNzBe385kE2TJVssNdePC7q8HSV0PWQ4Nrp0XMhvtGdsU5daR
         i510Z/f7ZFk9XdlWGxPBvW9RfUM09DPzGsyAnGKk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 336F46053B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Colin King <colin.king@canonical.com>
Cc:     Solomon Peachy <pizza@shaftnet.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cw1200: fix indentation issues
References: <20190117143623.29363-1-colin.king@canonical.com>
Date:   Thu, 17 Jan 2019 16:54:05 +0200
In-Reply-To: <20190117143623.29363-1-colin.king@canonical.com> (Colin King's
        message of "Thu, 17 Jan 2019 14:36:23 +0000")
Message-ID: <87sgxrpc6q.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> writes:

> From: Colin Ian King <colin.king@canonical.com>
>
> There are two lines that have indentation issues, fix these.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/st/cw1200/fwio.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/st/cw1200/fwio.c b/drivers/net/wireless/st/cw1200/fwio.c
> index 30e7646d04af..b7881232499c 100644
> --- a/drivers/net/wireless/st/cw1200/fwio.c
> +++ b/drivers/net/wireless/st/cw1200/fwio.c
> @@ -465,8 +465,8 @@ int cw1200_load_firmware(struct cw1200_common *priv)
>  
>  	if (!(val32 & ST90TDS_CONFIG_ACCESS_MODE_BIT)) {
>  		pr_err("Device is already in QUEUE mode!\n");
> -			ret = -EINVAL;
> -			goto out;
> +		ret = -EINVAL;
> +		goto out;

Just out of curiosity, how do you find these?

-- 
Kalle Valo
