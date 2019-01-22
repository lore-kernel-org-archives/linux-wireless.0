Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CBB2C282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 21:13:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14C9420870
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 21:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfAVVN4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 16:13:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37280 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbfAVVNz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 16:13:55 -0500
Received: from mail-yb1-f198.google.com ([209.85.219.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1gm3Mo-00043z-9A
        for linux-wireless@vger.kernel.org; Tue, 22 Jan 2019 21:13:54 +0000
Received: by mail-yb1-f198.google.com with SMTP id 124so12875122ybb.9
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2019 13:13:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uaD2LBSHc6hfCyUyACA7iugHV5Ci/pV6nsns0jLr8Og=;
        b=mOGYr84TxLVHLG3nRfdui1mYhS0v+OnmvHeZwiZeW6UOsdcyXBa8vZ50Kt8KFS7yle
         zUohDeFPAe53LayHMI4pvE+x6G6d3WlSQCzscyzoGwwqs6ghK90FAH2OxJzFnOgCcXht
         OsjJrOnceznZB1uDPNzQ2O//8bZwjQWzOiFBNKmaSC3y/OPsUwjcGtTJfaWSwUlv6OKV
         uWqUjZCe1m9mJWnuI3wfCMin5P/erV1ZA4GGqe4EXarOYI58E0x7mzaG8fNtmdb/JzlO
         vjbZlqz44C/zvycc0bsqJLDuZL1dxL+JiuZJXlviL1pB3Y16LS4Kwtks/LRVv/MZ3ZqE
         jFjw==
X-Gm-Message-State: AJcUukeONrJmCUr62oTK68NjVsdksj3Bx4/vmB1GbIfPq+qIw08ZAZpw
        KQuz88G7wm5WZeYamPfiQw986jjdBil1yatbZOSqckcPrCAVqLiYuN+cfjmtLJbbGDJAYVhfhkG
        BPqVor6TeumJSuwXhXmg+ftfst9MG7dGYUXJnovu23fxT
X-Received: by 2002:a0d:ca11:: with SMTP id m17mr2680315ywd.319.1548191633295;
        Tue, 22 Jan 2019 13:13:53 -0800 (PST)
X-Google-Smtp-Source: ALg8bN4GTdWFkQdQ6P9VVGgoeX/TvWhlbwg19o7hntS+yDsjWlGmRMiqkKT5oJ6S3mC1L7rHSA6K5w==
X-Received: by 2002:a0d:ca11:: with SMTP id m17mr2680298ywd.319.1548191632982;
        Tue, 22 Jan 2019 13:13:52 -0800 (PST)
Received: from localhost ([2605:a601:ac2:fb20:b0c3:23ce:f04b:2786])
        by smtp.gmail.com with ESMTPSA id a72sm10246426ywh.42.2019.01.22.13.13.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Jan 2019 13:13:52 -0800 (PST)
Date:   Tue, 22 Jan 2019 15:13:51 -0600
From:   Seth Forshee <seth.forshee@canonical.com>
To:     chaitanya.mgit@gmail.com
Cc:     wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless-regdb: update 60ghz band rules for us
Message-ID: <20190122211351.GW7206@ubuntu-xps13>
References: <20181218080815.19395-1-chaitanya.mgit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181218080815.19395-1-chaitanya.mgit@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Dec 18, 2018 at 01:38:15PM +0530, chaitanya.mgit@gmail.com wrote:
> From: Chaitanya Tata <Chaitanya.Mgit@gmail.com>
> 
> Include channels 4, 5 & 6 for US in 60GHz band. FCC extended the
> 57-64GHz band till 71GHz with almost same rules.

This looks right to me based on my research. You're missing one thing
though. You need to provide a Signed-off-by tag, please see the
CONTRIBUTING file for more information. If you reply with your tag I
will add it when I apply the patch. Thanks!

> ---
>  db.txt | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/db.txt b/db.txt
> index fa5c0e0..ae650dd 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -1280,9 +1280,9 @@ country US: DFS-FCC
>  	(5490 - 5730 @ 160), (23), DFS
>  	(5735 - 5835 @ 80), (30)
>  	# 60g band
> -	# reference: http://cfr.regstoday.com/47cfr15.aspx#47_CFR_15p255
> -	# channels 1,2,3, EIRP=40dBm(43dBm peak)
> -	(57240 - 63720 @ 2160), (40)
> +	# reference: section IV-D https://docs.fcc.gov/public/attachments/FCC-16-89A1.pdf
> +	# channels 1-6 EIRP=40dBm(43dBm peak)
> +	(57240 - 71000 @ 2160), (40)
>  
>  country UY: DFS-FCC
>  	(2402 - 2482 @ 40), (20)
> -- 
> 2.17.1
> 
