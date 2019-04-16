Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA90C10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 07:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79B952073F
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 07:23:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="h9mILkfp";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cpImp2Jc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbfDPHXi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 03:23:38 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57834 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbfDPHXi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 03:23:38 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3B9E3611DC; Tue, 16 Apr 2019 07:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555399417;
        bh=MEWK2D9JnuIvvAB7Mp0eYbbRYcrl6WlWi/3gERSi4c0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=h9mILkfpeIPYM8g/h2KwMAyhD6zcQAm5KLuuC11xwcUzBpQC3t5KIhwgmgGjYQfrM
         gS7mWNpf77dk5F2LIplZ98qlyZ6Cmw2p20TcpSOHXUK35vgLoVReUJ4PFZblOSoCbB
         cCKgqxqQWYtnuhHbkyy3uBH3fcv+Uc0QuHNEEG7o=
Received: from [10.204.79.15] (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mojha@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 11B9F608D4;
        Tue, 16 Apr 2019 07:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555399416;
        bh=MEWK2D9JnuIvvAB7Mp0eYbbRYcrl6WlWi/3gERSi4c0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=cpImp2JcRrO1HqbUFpVLqDZaDzaXcxZL3UbE1PmhMdPKn5MIPTa2LeDHe80817cUM
         07Pe0BBI+O84dH2xAlmvahLogGoyaNICcYY1jCG2NCxnWRJgU0XMg87EOr7GSg+XAb
         rLeapCVNQeoROtoX1hXOUU9eEbxiT7pmLnjJlttE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 11B9F608D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mojha@codeaurora.org
Subject: Re: [PATCH] staging: wilc1000: fix spelling mistake "dissconect" ->
 "disconnect"
To:     Colin King <colin.king@canonical.com>,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190415163330.28166-1-colin.king@canonical.com>
From:   Mukesh Ojha <mojha@codeaurora.org>
Message-ID: <fe128fa2-7ba3-3d56-6b97-61bd98ebebc3@codeaurora.org>
Date:   Tue, 16 Apr 2019 12:53:22 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190415163330.28166-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 4/15/2019 10:03 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> There is a spelling mistake in a netdev_err error message, fix it.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

Cheers,
-Mukesh

> ---
>   drivers/staging/wilc1000/host_interface.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index e1a35bb426f9..ed15bd1bcd56 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -774,7 +774,7 @@ int wilc_disconnect(struct wilc_vif *vif)
>   	result = wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
>   				      wilc_get_vif_idx(vif));
>   	if (result) {
> -		netdev_err(vif->ndev, "Failed to send dissconect\n");
> +		netdev_err(vif->ndev, "Failed to send disconnect\n");
>   		return result;
>   	}
>   
