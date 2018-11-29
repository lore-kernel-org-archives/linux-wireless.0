Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DAE0C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 13:51:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AF7020863
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 13:51:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OJFbh1Oq";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OJFbh1Oq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AF7020863
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbeK3A4y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 19:56:54 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57432 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbeK3A4y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 19:56:54 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 98A5A6020A; Thu, 29 Nov 2018 13:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543499488;
        bh=Zh8Ngj/DlZv+2avqklNQlcUXkbFd1Faq4e6cEhdYiSQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=OJFbh1OqURIHDZbIk0IynwarPiFYkv3qZQUlfiedL0IOwvDLFqj6skj5mWPIZH3b5
         BaGp1sbswTQhXAx4kWdSkPoo+WRxk8I7Sb3lJcHLFoDJO1NCmmdTBEobXdsz/6SknS
         2+8/Vdycr6YHxjsgIb8es3OS5aVGz1WtFt2lz2E4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EAF32602FE;
        Thu, 29 Nov 2018 13:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543499488;
        bh=Zh8Ngj/DlZv+2avqklNQlcUXkbFd1Faq4e6cEhdYiSQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=OJFbh1OqURIHDZbIk0IynwarPiFYkv3qZQUlfiedL0IOwvDLFqj6skj5mWPIZH3b5
         BaGp1sbswTQhXAx4kWdSkPoo+WRxk8I7Sb3lJcHLFoDJO1NCmmdTBEobXdsz/6SknS
         2+8/Vdycr6YHxjsgIb8es3OS5aVGz1WtFt2lz2E4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EAF32602FE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Rakesh Pillai <pillair@codeaurora.org>, ath10k@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: remove an unnecessary NULL check
References: <20181129103214.5tudci6izlfaasqx@kili.mountain>
Date:   Thu, 29 Nov 2018 15:51:24 +0200
In-Reply-To: <20181129103214.5tudci6izlfaasqx@kili.mountain> (Dan Carpenter's
        message of "Thu, 29 Nov 2018 13:32:14 +0300")
Message-ID: <87sgzk56w3.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:

> The "survey" pointer is the address of an array element.  We know that
> it can't be NULL so this check can be removed.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index 659513bf4ddc..6a04727b63ce 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -2578,7 +2578,7 @@ static void ath10k_wmi_event_chan_info_unpaired(struct ath10k *ar,
>  
>  	survey = &ar->survey[idx];
>  
> -	if (!params->mac_clk_mhz || !survey)
> +	if (!params->mac_clk_mhz)
>  		return;

Can you please CC linux-wireless so that patchwork sees this?

-- 
Kalle Valo
