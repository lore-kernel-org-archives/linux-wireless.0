Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A5EC10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 06:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 811FA20663
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 06:48:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="g6FPp6RI";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YCOzmMf3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbfDPGsA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 02:48:00 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35934 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbfDPGsA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 02:48:00 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CD30360E3E; Tue, 16 Apr 2019 06:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555397278;
        bh=GuvEf4JhvqUkR2GYNDIruEJU7MAzPOx63kAy/HuJATo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=g6FPp6RIxl1PvDi345VzVKz3J48B4to5mXwVn60Strg+TYqmfsJFBxpIoEJD36Fy8
         me6rgV1krEA+a274Dd4Is7qn/6gaz/locroOkSiyMZMlhDaxr4dOLtdIC/eNaZNU08
         zOw3IfJUcjYQk5QvdLAL9rQT7qub7MfD3SUliEdw=
Received: from [10.204.79.15] (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mojha@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 63728607CA;
        Tue, 16 Apr 2019 06:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555397277;
        bh=GuvEf4JhvqUkR2GYNDIruEJU7MAzPOx63kAy/HuJATo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=YCOzmMf3bPcqKb9+3i5XOUD0v/Kwome1COe1U5LWWoJZbrb7OOhqUIhi6GImgnBWE
         XJoDT7M4ZtU+UUYlRVxb0LHG8CLWnTzdW+t1RG4iuWG8s4vr199TReF7sBX4m3K8kD
         ap7tzMGk6U/NG9T50W1t0x+tERCsgnG8r1ajnzrI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 63728607CA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mojha@codeaurora.org
Subject: Re: [PATCH] iwlegacy: fix spelling mistake "acumulative" ->
 "accumulative"
To:     Colin King <colin.king@canonical.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190415103703.11254-1-colin.king@canonical.com>
From:   Mukesh Ojha <mojha@codeaurora.org>
Message-ID: <4c87d5c6-c5f8-c3f5-b0b9-2a70b888a622@codeaurora.org>
Date:   Tue, 16 Apr 2019 12:17:42 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190415103703.11254-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 4/15/2019 4:07 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Fix spelling mistakes in rx stats text. I missed these from an earlier
> round of fixing the same spelling mistake.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

Cheers,
-Mukesh

> ---
>   drivers/net/wireless/intel/iwlegacy/3945-debug.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/intel/iwlegacy/3945-debug.c b/drivers/net/wireless/intel/iwlegacy/3945-debug.c
> index a2960032be81..4b912e707f38 100644
> --- a/drivers/net/wireless/intel/iwlegacy/3945-debug.c
> +++ b/drivers/net/wireless/intel/iwlegacy/3945-debug.c
> @@ -185,7 +185,7 @@ il3945_ucode_rx_stats_read(struct file *file, char __user *user_buf,
>   	pos +=
>   	    scnprintf(buf + pos, bufsz - pos,
>   		      "%-32s     current"
> -		      "acumulative       delta         max\n",
> +		      "accumulative      delta         max\n",
>   		      "Statistics_Rx - CCK:");
>   	pos +=
>   	    scnprintf(buf + pos, bufsz - pos,
> @@ -273,7 +273,7 @@ il3945_ucode_rx_stats_read(struct file *file, char __user *user_buf,
>   	pos +=
>   	    scnprintf(buf + pos, bufsz - pos,
>   		      "%-32s     current"
> -		      "acumulative       delta         max\n",
> +		      "accumulative      delta         max\n",
>   		      "Statistics_Rx - GENERAL:");
>   	pos +=
>   	    scnprintf(buf + pos, bufsz - pos,
> @@ -346,7 +346,7 @@ il3945_ucode_tx_stats_read(struct file *file, char __user *user_buf,
>   	pos +=
>   	    scnprintf(buf + pos, bufsz - pos,
>   		      "%-32s     current"
> -		      "acumulative       delta         max\n",
> +		      "accumulative      delta         max\n",
>   		      "Statistics_Tx:");
>   	pos +=
>   	    scnprintf(buf + pos, bufsz - pos,
> @@ -447,7 +447,7 @@ il3945_ucode_general_stats_read(struct file *file, char __user *user_buf,
>   	pos +=
>   	    scnprintf(buf + pos, bufsz - pos,
>   		      "%-32s     current"
> -		      "acumulative       delta         max\n",
> +		      "accumulative      delta         max\n",
>   		      "Statistics_General:");
>   	pos +=
>   	    scnprintf(buf + pos, bufsz - pos,
