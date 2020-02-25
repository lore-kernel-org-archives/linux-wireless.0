Return-Path: <SRS0=D23K=4N=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E832C35E04
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Feb 2020 18:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AB5420732
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Feb 2020 18:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582655576;
	bh=1D4jirQeNh+WIUAMHeozJMkSPoS8G5BWpbdXxGpUSCM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=wNO7nGunddm+XLNwWSVnTfRvJoC0jL6lh4fo5XjnI9vUr2ONWNEVVh5UfUGi2J292
	 tND3hUJtXsXN9Rts09qp4LqTBeCPaTh75HLd7AIK/Vn1QLoT4wGu3fFXk0715e2YyQ
	 axR0huaSiceXI3o1MhS36uoaWtLxSiuVu4ojYpVU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731583AbgBYScv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Feb 2020 13:32:51 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40233 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727983AbgBYScv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Feb 2020 13:32:51 -0500
Received: by mail-pj1-f65.google.com with SMTP id 12so60746pjb.5;
        Tue, 25 Feb 2020 10:32:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Gtj6sfpwxnSvCoIT+3yBy4O0RWgU8ztecOyfPUaR5NQ=;
        b=Cd1CdW9AgP19f7zfGsPZ6oKzH5xsVOx/HI+wWOVS1hHnxlVO9k2Q/H26QTOmMuv3dg
         s5MraD1SeqUIGRPy5YFDeboPdx4xgCUMnPqFYrKHewyIswCcLN8YuGxHc4knypF6RYgI
         ScICm6lJ5goFp4P7aNDOlK8AiPn0aptOPw76SE4Gz553MMT041HC72xqvdyvgCmUydZU
         gQ0FRwXicBM4IF51V/dKuMLRHq5dYAWwiwdhnY3nRW+m3XZUFCBaY5SoJyaM2hQ3Nidr
         Lu44Y8cxtuIKJmMjCMrv2Y3VokZaTOZukNyHcO4JEFIMJycWR/c4/eALxRFIl4ioy0Pf
         lOQg==
X-Gm-Message-State: APjAAAXD9bp0cvGz3CTKMghnrD7k/638ar1rbqU6IckK4wspBB6s65dU
        PJLypLr2Gj/4DA3cn1ccC4pkLAE8h2Y=
X-Google-Smtp-Source: APXvYqy5Eejjl7FYcMgUbawWDTZYklvZad8p1POrGVXn9AYhsH8Kabt/I0I6dh39XVbEmadkOID1hg==
X-Received: by 2002:a17:90b:309:: with SMTP id ay9mr377200pjb.22.1582655570290;
        Tue, 25 Feb 2020 10:32:50 -0800 (PST)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id t65sm17796978pfd.178.2020.02.25.10.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 10:32:48 -0800 (PST)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 1079A40297; Tue, 25 Feb 2020 18:32:48 +0000 (UTC)
Date:   Tue, 25 Feb 2020 18:32:48 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] prism54: Replace zero-length array with
 flexible-array member
Message-ID: <20200225183247.GW11244@42.do-not-panic.com>
References: <20200225012008.GA4309@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225012008.GA4309@embeddedor>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Feb 24, 2020 at 07:20:08PM -0600, Gustavo A. R. Silva wrote:
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
> 
> struct foo {
>         int stuff;
>         struct boo array[];
> };
> 
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
> 
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
> 
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
> 
> This issue was found with the help of Coccinelle.
> 
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

I'd rather we just remove this driver completely, as it has a
replacement upstream p54, and remained upstream just for a theoretical
period of time someone was not able to use p54 anymore. I'll follow up
with a removal of the driver.

  Luis
