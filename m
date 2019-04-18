Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA41C10F0E
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 10:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F1132083D
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 10:42:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dWfFrXbu";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="o4+8t5NU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388812AbfDRKmH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Apr 2019 06:42:07 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40434 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388550AbfDRKmG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Apr 2019 06:42:06 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 45F55602DC; Thu, 18 Apr 2019 10:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555584126;
        bh=tGSjuaw02wSb4bUQvtmSKZ1K7Gzpj8zUfHshmJbXtlk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=dWfFrXbuQ9z/S3lC+Qcd2m1pm8SnCxn2ukKjhOl4ClfLwZ61BDUNCeRZl8pPUciHc
         +vExYfbQkPMOLFOU+4Mo3nB4cBdPTwMUTk9GNLDBR4ERAiuGpDTDUmsFYANRk+LGWB
         ttDy7Md/N/t60aJR8hQhRObceYjacZyazcKI1+w8=
Received: from [10.204.79.15] (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mojha@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BC5BB601B4;
        Thu, 18 Apr 2019 10:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555584125;
        bh=tGSjuaw02wSb4bUQvtmSKZ1K7Gzpj8zUfHshmJbXtlk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=o4+8t5NUpwUQT5H1lhY0VO8IIXpITYzgdvVtUnDUJHvL12tWuImVpQmfiFhnG8qUT
         FZW1iKLKv3THx+jhs0GIEbIdmjkLdFk3KnymFRJue9YwC121GOrHJs7vDgS1dMSf8t
         ffWmQR2+iE7GukQwvq46+Gl3iN1tFOJgEsX/y8Vc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BC5BB601B4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mojha@codeaurora.org
Subject: Re: [PATCH] NFC: st95hf: fix spelling mistake: "receieve" ->
 "receive"
To:     Colin King <colin.king@canonical.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Daniel Mack <daniel@zonque.org>, linux-wireless@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190418095756.9264-1-colin.king@canonical.com>
From:   Mukesh Ojha <mojha@codeaurora.org>
Message-ID: <15834163-7c70-3471-01bb-ad92fba3182e@codeaurora.org>
Date:   Thu, 18 Apr 2019 16:12:01 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190418095756.9264-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 4/18/2019 3:27 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> There is a spelling mistake in a dev_error message. Fix it.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

Cheers,
-Mukesh
> ---
>   drivers/nfc/st95hf/core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
> index a50a95cfcfd8..d72d48243141 100644
> --- a/drivers/nfc/st95hf/core.c
> +++ b/drivers/nfc/st95hf/core.c
> @@ -327,7 +327,7 @@ static int st95hf_echo_command(struct st95hf_context *st95context)
>   					  &echo_response);
>   	if (result) {
>   		dev_err(&st95context->spicontext.spidev->dev,
> -			"err: echo response receieve error = 0x%x\n", result);
> +			"err: echo response receive error = 0x%x\n", result);
>   		return result;
>   	}
>   
