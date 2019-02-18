Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A7EBC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 16:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3961C20836
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 16:04:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QKkxNf2i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732251AbfBRQEx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 11:04:53 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32979 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730490AbfBRQEx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 11:04:53 -0500
Received: by mail-wr1-f68.google.com with SMTP id i12so19021971wrw.0;
        Mon, 18 Feb 2019 08:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cqRRYnkDD5nmlXYpdZRju1VRoZ6YxGGQYALWiNfygnc=;
        b=QKkxNf2iYAAYinHynmyWle4TQ8jH/VRaZB/v4vdlvDDFSEmoj2AHAAXbDiGSzvkfYH
         Gefl3KKublBKNRRfzT6lhQXQSszR+E1r+LtVsFBFEeQEfMcNeGTXzCN1nje18jlyXatz
         tR5pN8HiBMc1pdyqceXK+iHxDc7UPWvz1gET2oGXv95TeZbBPg8QB8VZosBA9yxHl2Li
         OCE1D+tF012l1UHEMYI/layCD8vDrOTVWIql7GSjOjRhQg6PN8evp+1XAhgTMEWs1Vyh
         fX/bvOgc3j2xxORSednQTGOCqHoXf3nzHlKvolqSUsj5aWngfgLVQNMefEAVcLP1wEup
         F1bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cqRRYnkDD5nmlXYpdZRju1VRoZ6YxGGQYALWiNfygnc=;
        b=PIPnE++2FEuw01kc6cIsWYLNedQxxXpGiiTajYrVdEZGTqm32xDC+rVwbq7zHLOSRr
         l9RKExRpl23DVvymhuOJdSbsRsYr9NDHosdzMg+OL7THfIbNBEFkqi6W69xIgjEkNqLO
         pque0S8JUBE6HGRK+cJ/M3Jb/6P1RrWUVlCMmHw3NEkHXasOgngaYpiHnexaQn20BD6Z
         2nBLH5NvznBRk+x/8YFaZcsDElEtFGcEk18pNKfnIN+IILurp2mcVn/fbYcl6AviMf1+
         owLbF4hD931kNqzEAnoUdcuDskzzpMNngsvWW/puUFw7awVTT3U+BedUe/J1Ha9P7DYR
         YG7Q==
X-Gm-Message-State: AHQUAuYAeH4yti1GLYt90C1gDlqfkgsB5Sf3koJQSh4SzpbfeNy3Ommt
        iylF6Nvgd9+4H5JpiFTP4sE=
X-Google-Smtp-Source: AHgI3Ibe3o1iBSEXLvmcdD0LGpDXknjmk1bnjp+4UfPQyh42fdyaBLyka3krCNuzNEPdDoPSdVej+w==
X-Received: by 2002:a5d:4e44:: with SMTP id r4mr2770295wrt.228.1550505890951;
        Mon, 18 Feb 2019 08:04:50 -0800 (PST)
Received: from debian64.daheim (p4FD09F2C.dip0.t-ipconnect.de. [79.208.159.44])
        by smtp.gmail.com with ESMTPSA id h71sm32934604wme.20.2019.02.18.08.04.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 18 Feb 2019 08:04:50 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1] helo=debian64.localnet)
        by debian64.daheim with esmtp (Exim 4.92-RC6)
        (envelope-from <chunkeey@gmail.com>)
        id 1gvlPV-0002HX-IL; Mon, 18 Feb 2019 17:04:49 +0100
From:   Christian Lamparter <chunkeey@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] carl9170: clean up a clamp() call
Date:   Mon, 18 Feb 2019 17:04:49 +0100
Message-ID: <2108216.StK4OeqmAv@debian64>
In-Reply-To: <20190218093154.GC7712@kadam>
References: <20190218093154.GC7712@kadam>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Monday, February 18, 2019 10:31:54 AM CET Dan Carpenter wrote:
> The parameter order for clamp is supposed to be clamp(value, low, high).
> When we write it in this order it's equivalent to
> min(head->plcp[3] & 0x7f, 75) which works in this context where the min
> is zero.  But it's not a correct use of the API.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Christian Lamparter <chunkeey@gmail.com>

> ---
>  drivers/net/wireless/ath/carl9170/rx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
> index f7c2f19e81c1..8e154f6364a3 100644
> --- a/drivers/net/wireless/ath/carl9170/rx.c
> +++ b/drivers/net/wireless/ath/carl9170/rx.c
> @@ -427,7 +427,7 @@ static int carl9170_rx_mac_status(struct ar9170 *ar,
>  		if (head->plcp[6] & 0x80)
>  			status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
>  
> -		status->rate_idx = clamp(0, 75, head->plcp[3] & 0x7f);
> +		status->rate_idx = clamp(head->plcp[3] & 0x7f, 0, 75);
>  		status->encoding = RX_ENC_HT;
>  		break;
>  
> 




