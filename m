Return-Path: <SRS0=EMPu=SC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C38EC3E8A3
	for <linux-wireless@archiver.kernel.org>; Sun, 31 Mar 2019 07:16:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AC372183F
	for <linux-wireless@archiver.kernel.org>; Sun, 31 Mar 2019 07:16:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EAoY2xg9";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KQ7o0JzS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfCaHQD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 31 Mar 2019 03:16:03 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33822 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfCaHQD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 31 Mar 2019 03:16:03 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 999DC60790; Sun, 31 Mar 2019 07:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554016562;
        bh=qaK1YxD5XGsJdvYqbsBbiugcVBImMPl9uE9Y0kBGH7U=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=EAoY2xg9ai16/PEeitQfD32+Gc+3CQllyGI/LtGe53VXIYcJO2yY8SOPYNGOSveDf
         WBWbbNWGyHyq4Xpi+/my3Y3Pe0IjyJ56gNyDzY/msmSUX0vOsUAZ/sprSMT2OkPvDu
         tE3giBMJpgTey8FEAUhJzZhg3v8Ej3jm2lvuIhNU=
Received: from [10.79.166.22] (blr-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.18.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mojha@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 48CA1602FC;
        Sun, 31 Mar 2019 07:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554016561;
        bh=qaK1YxD5XGsJdvYqbsBbiugcVBImMPl9uE9Y0kBGH7U=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=KQ7o0JzSW6bLTONY4FAncwaHkVPLA3yNJK9mlywW2mcLZu0t7fFeEwx7VcNPKNLbg
         wKEPVvsNwBueOkp+a5YaGTxUnIDPMXLdMgy54MntiLmOVa6zeXlRb4/IVMjmzNt4cc
         smoitvfUIEiPim/xQVjnlWWoqQvNadtuq4IdOP44=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 48CA1602FC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mojha@codeaurora.org
Subject: Re: [PATCH] iwlegacy: remove redundant assignment to *res
To:     Colin King <colin.king@canonical.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190330201422.8024-1-colin.king@canonical.com>
From:   Mukesh Ojha <mojha@codeaurora.org>
Message-ID: <d4097a41-9d4e-866d-73c3-f9c978c9d7fd@codeaurora.org>
Date:   Sun, 31 Mar 2019 12:45:49 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190330201422.8024-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 3/31/2019 1:44 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Currently 1 is being assigned to *res and then it is immediately
> updated with the computed result.  The first assignment is
> redundant and can be removed.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

Cheers,
-Mukesh

> ---
>   drivers/net/wireless/intel/iwlegacy/4965.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/net/wireless/intel/iwlegacy/4965.c b/drivers/net/wireless/intel/iwlegacy/4965.c
> index ce4144a89217..a20b6c885047 100644
> --- a/drivers/net/wireless/intel/iwlegacy/4965.c
> +++ b/drivers/net/wireless/intel/iwlegacy/4965.c
> @@ -577,7 +577,6 @@ il4965_math_div_round(s32 num, s32 denom, s32 * res)
>   		sign = -sign;
>   		denom = -denom;
>   	}
> -	*res = 1;
>   	*res = ((num * 2 + denom) / (denom * 2)) * sign;
>   
>   	return 1;
