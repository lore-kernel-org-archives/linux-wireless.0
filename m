Return-Path: <SRS0=iN42=SH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13BEAC4360F
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 06:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D669721850
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 06:50:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GrdDd6PA";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DBrN5vpH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730049AbfDEGuV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Apr 2019 02:50:21 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57696 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbfDEGuV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Apr 2019 02:50:21 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1B2CE60A24; Fri,  5 Apr 2019 06:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554447020;
        bh=H9k0gVtx5gKYg38E7Fd2ZAl28g1Od68z1VvgZVynxVw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=GrdDd6PABfN6cfZux366SJWK3QG1XEzUsN6DixnC5BQ8T5m9u6B20SwsQZwZY/JUn
         sQmnjK3u8kG7K/C9+QDghEuCT3gK5AG3031a78hP0OPhqYJbVxwWMVwcaJmgO0+rgE
         GL2I6saTSbgsJdZ5tLPZUbPvRhVB1VdprvX097W4=
Received: from [10.204.79.83] (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mojha@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2D444609F3;
        Fri,  5 Apr 2019 06:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554447019;
        bh=H9k0gVtx5gKYg38E7Fd2ZAl28g1Od68z1VvgZVynxVw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=DBrN5vpHeUUt4QO5cVoVHBlQSRKZ022sGRSvu1Oz6PcMDqN2sP/WKB4jkKLWdtG9e
         jFom2Nnjik2Z7gnwAKwJ7UABREHsvAGpUxNYhK+JFD7736AnXAoEaHFYBf/zZWP28m
         TmkiMdzZX0kkRZeNPk3wnQBudnygIJ2yZwNb0gA4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2D444609F3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mojha@codeaurora.org
Subject: Re: [PATCH] ath6kl: remove redundant check of status != 0
To:     Colin King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190404134723.24667-1-colin.king@canonical.com>
From:   Mukesh Ojha <mojha@codeaurora.org>
Message-ID: <f46c3ce4-dc62-2897-60b9-455e46c72e58@codeaurora.org>
Date:   Fri, 5 Apr 2019 12:20:14 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190404134723.24667-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 4/4/2019 7:17 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> The check on status not being zero is redundant as previous code
> paths that set status to an error value break out of the while
> loop and hence status is never non-zero at the check. Remove
> this redundant code.
>
> Addresses-Coverity: ("Logically dead code")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>


Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

Cheers,
-Mukesh

> ---
>   drivers/net/wireless/ath/ath6kl/htc_pipe.c | 3 ---
>   1 file changed, 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath6kl/htc_pipe.c b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
> index 434b66829646..c68848819a52 100644
> --- a/drivers/net/wireless/ath/ath6kl/htc_pipe.c
> +++ b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
> @@ -898,9 +898,6 @@ static int htc_process_trailer(struct htc_target *target, u8 *buffer,
>   			break;
>   		}
>   
> -		if (status != 0)
> -			break;
> -
>   		/* advance buffer past this record for next time around */
>   		buffer += record->len;
>   		len -= record->len;
