Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D8CBC282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 21:56:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 395BB20866
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 21:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbfAVV4Y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 16:56:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37922 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfAVV4Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 16:56:24 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1gm41u-0004y4-NB
        for linux-wireless@vger.kernel.org; Tue, 22 Jan 2019 21:56:22 +0000
Received: by mail-io1-f70.google.com with SMTP id p4so51194iod.17
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2019 13:56:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hQ/WHJmY7NdoE/DY6ykO4y3yEyIdYPOvJGngDJhm1ts=;
        b=ubhKKcJdQsZW0nbvo7lt95FLh5/rLXaAIoCLD5fln9YRigbHDU3QnBybM0pN+RW/Lx
         rHdNXGMtBZuD4dJ7CALmzu8QQ+wzuWqK5dHLtJiqjkokZD1TeKKkuFx4TBRREv2c5WUc
         vJxj8/jZuisiT8kCrN7CQZM5oZ8irqNIK8ar1eRnEAnUIUe90ZnSpet8BJdyneeE4aDA
         QP+3i5p9j6fzI3uZT/empJZqT1tELEd1zK/MS98Uusrv65aEfq4m5wl5rHXGrcC0aPQB
         jDHAE1eA7ExTqJzudaqWlN8QdG+sAVZlHJN+E1srzrSj30eNgMZ1b5G3TWjgj5A2pQm9
         7efQ==
X-Gm-Message-State: AHQUAub88xPSJXX8aS1PPy66iEOcj5yfzMCfTi0C7fVyuMxChLDVdVBF
        ZII6wBkbpRgppkA4DVWKax6glLW9M9DDhqHBbsGmWTw76SeoqOnBxTCzD6FzeM9ORkxdQptCFiW
        HMi4kPCLzkgVy8GHbq6YyUqIahTdxQ3hwzm5aXH6OlJjO
X-Received: by 2002:a24:bd48:: with SMTP id x69mr166904ite.81.1548194181647;
        Tue, 22 Jan 2019 13:56:21 -0800 (PST)
X-Google-Smtp-Source: ALg8bN5po4tdMeKzyWIN6Q+M1gGe0LW4+mtamahurHxJumHl+SoJjh7E9ai5Lb+541PXBXNGiFj+1w==
X-Received: by 2002:a24:bd48:: with SMTP id x69mr166893ite.81.1548194181319;
        Tue, 22 Jan 2019 13:56:21 -0800 (PST)
Received: from localhost ([2605:a601:ac2:fb20:b0c3:23ce:f04b:2786])
        by smtp.gmail.com with ESMTPSA id k2sm8507968itk.35.2019.01.22.13.56.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Jan 2019 13:56:20 -0800 (PST)
Date:   Tue, 22 Jan 2019 15:56:19 -0600
From:   Seth Forshee <seth.forshee@canonical.com>
To:     Rui Salvaterra <rsalvaterra@gmail.com>
Cc:     wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless-regdb: Add 5725-5875 MHz rule for Portugal (PT)
Message-ID: <20190122215619.GX7206@ubuntu-xps13>
References: <CALjTZvZ6gAVH17fZwzM=PeO6CjtQCGoep=bqi6yYb6TJ6u5nfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALjTZvZ6gAVH17fZwzM=PeO6CjtQCGoep=bqi6yYb6TJ6u5nfg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Jan 12, 2019 at 09:35:11PM +0000, Rui Salvaterra wrote:
> According to [1], SRD devices in this range are allowed in Portugal, as
> specified in this document (page 56), and in compliance with ETSI EN 300 440-1.
> 
> [1] https://www.anacom.pt/streaming/25.5_10.000mhz.pdf?contentId=271706&field=ATTACHED_FILE
> 
> Signed-off-by: Rui Salvaterra <rsalvaterra@gmail.com>

Applied. Note though that your patch was malformed, the tabs had been
replaced by a single space. I fixed this up manually, but in the future
please try to ensure that your patch is not getting mangled when you
send it. Thanks!

> ---
>  db.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/db.txt b/db.txt
> index fa5c0e0..66751f0 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -1044,6 +1044,8 @@ country PT: DFS-ETSI
>   (5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
>   (5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
>   (5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
> + # short range devices (ETSI EN 300 440-1)
> + (5725 - 5875 @ 80), (25 mW)
>   # 60 GHz band channels 1-4, ref: Etsi En 302 567
>   (57000 - 66000 @ 2160), (40)
> 
> -- 
> 2.20.1
