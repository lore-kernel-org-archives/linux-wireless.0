Return-Path: <SRS0=hJv2=OF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC46FC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 08:24:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA06F20672
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 08:24:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W9q2/XVS";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QWZD1AQA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA06F20672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbeKZTSE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 26 Nov 2018 14:18:04 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46288 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbeKZTSE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Nov 2018 14:18:04 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2D3E56081E; Mon, 26 Nov 2018 08:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543220682;
        bh=cq59/I8FXvoId6+OjPrsQuyZmkRQkBPJmF7os7jbA8w=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=W9q2/XVS4UXUyufJwdyNyO+hy2K6jiAKT0Z7HsknVQOf4qhkQl0bcAsP3PaaIDooW
         b7OBoRJ7ucZlwjWJ/cAH6tMgh55qFcdOrU4N3bQBR5/mkt27qWV8MxvnLb78Uka1ox
         Q9FJEhfJ8zShGSbECL+CljbqPRaUIO3ZkEHbxJOc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 63D6A60227;
        Mon, 26 Nov 2018 08:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543220681;
        bh=cq59/I8FXvoId6+OjPrsQuyZmkRQkBPJmF7os7jbA8w=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=QWZD1AQALEF9bbO5FnuHiZto6ApGeh/sB7S68a+8u5aROAD+bbkCa/OjTNEVqYtIH
         R4iK28XsdObNSCdZdlU/Gh83+3ysmNxhSc9bO19bRhETUi78nJag22KGVimdKKPCsD
         2xmJ50/kaVotiyKOCFSPGld+AeGMcCJzYY8D7bAk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 63D6A60227
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Govind Singh <govinds@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ath10k: fix a NULL vs IS_ERR() check
References: <20181126081143.tvu55aimdc3safcq@kili.mountain>
Date:   Mon, 26 Nov 2018 10:24:38 +0200
In-Reply-To: <20181126081143.tvu55aimdc3safcq@kili.mountain> (Dan Carpenter's
        message of "Mon, 26 Nov 2018 11:11:43 +0300")
Message-ID: <8736rob60p.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:

> The devm_memremap() function doesn't return NULLs, it returns error
> pointers.
>
> Fixes: ba94c753ccb4 ("ath10k: add QMI message handshake for wcn3990 client")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/wireless/ath/ath10k/qmi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
> index f0429bee35c2..37b3bd629f48 100644
> --- a/drivers/net/wireless/ath/ath10k/qmi.c
> +++ b/drivers/net/wireless/ath/ath10k/qmi.c
> @@ -931,9 +931,9 @@ static int ath10k_qmi_setup_msa_resources(struct ath10k_qmi *qmi, u32 msa_size)
>  		qmi->msa_mem_size = resource_size(&r);
>  		qmi->msa_va = devm_memremap(dev, qmi->msa_pa, qmi->msa_mem_size,
>  					    MEMREMAP_WT);
> -		if (!qmi->msa_va) {
> +		if (IS_ERR(qmi->msa_va)) {
>  			dev_err(dev, "failed to map memory region: %pa\n", &r.start);
> -			return -EBUSY;
> +			return PTR_ERR(qmi->msa_va);

That's a very good find!

But how has this even worked before? I would assume devm_memremap()
always returns a non-NULL value and ath10k would have interpreted that
as an error?

-- 
Kalle Valo
