Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CECDEC433F4
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 18:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CBDB208D9
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 18:21:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uuMFN/l3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8CBDB208D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbeIYAYj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Sep 2018 20:24:39 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41438 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728455AbeIYAYj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 20:24:39 -0400
Received: by mail-lf1-f67.google.com with SMTP id l26-v6so17584044lfc.8;
        Mon, 24 Sep 2018 11:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=FVjMgUwENdHqDkB5AUXBgYcuysCr6o3N3yY8E95aaR0=;
        b=uuMFN/l3pVf2U6WY0DgpoD71NJ0GnjSyo4M5+5SSBVpG2EmuslhcLiQO+zp+fGBsG1
         DYhnUX3/0X4eVzjJqPzKAT+XBAiJQwaZcePJ5U6ZlvTbNvFrQv7MmMG7lTpGJVbG5GfK
         4atVPwomEbFMKPBBz0P9+kGV80/1W0GNVGP/cbPICRRgEbf5zsIVyfNDEW64uhO0xn1d
         9VubehwwmoOVKByKZG0A8WlM51srvBdofkyWLwYkmqhDN/aNNxayMC9slSYzpfj8a494
         /zQECdjFcNx7HI3OHyYB9GsSBfQl1g1KdhPjS+VJhlXs0DvR60o9eU9sIPOiR0R52w/N
         /dhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=FVjMgUwENdHqDkB5AUXBgYcuysCr6o3N3yY8E95aaR0=;
        b=Hr7IRGUhc3Yrnl5KmvSMHyh/FTAuJAuWj9fkwbVeXcHuEdHQhiaPf8TKYaJfFxWBiA
         75+FQcSGlT6A0Pmfa/YgZ0bxteJqrAF+tiAFhWy61naExHr7Te051J7q96fDLgE3LQip
         TH1Sacb3xEGifsekeV82QfjFqQAOcpzh6Qd9CmatZtRX5Q9rKy1XlBNw3noE4F4aNh6q
         I3veeX9J9v/P8EhCa4cnrTGPHjG6/44KVXb5thY5cBwyDrhuIQVogakpGD0zB7SBD8Jx
         XsGtqbCcZX2sDEpUqnxJ0MWf7XYVOTqVlDJkZ3b87VM1H1h9NyQODLA/lLV8uJAKdW3M
         UxGQ==
X-Gm-Message-State: ABuFfojntdw1PLaIUC69MCrjq6mKKzEHO4PJoRA3P0a1fySIf/VJOKX5
        czzzrRFjM18d6bPNVbvGvrFbEb7uWtsrGwxwRSMUYw==
X-Google-Smtp-Source: ACcGV63iT+Y44m5sYfC/ts0/9Haqw8ZxZ79C7qr3lcVyXIL/vHASToSVgx7XcVtLV1jl+1oEi/Iy+bISNS00MYeNiXg=
X-Received: by 2002:a19:8f57:: with SMTP id r84-v6mr9691lfd.131.1537813271541;
 Mon, 24 Sep 2018 11:21:11 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a2e:424d:0:0:0:0:0 with HTTP; Mon, 24 Sep 2018 11:21:10
 -0700 (PDT)
In-Reply-To: <20180920204548.2405-1-natechancellor@gmail.com>
References: <20180920204548.2405-1-natechancellor@gmail.com>
From:   Stanislav Yakovlev <stas.yakovlev@gmail.com>
Date:   Mon, 24 Sep 2018 22:21:10 +0400
Message-ID: <CA++WF2PzFuVrxu1hP+uQ0+sfcPQbPJY1Y=uOdmLPY6R78efOKQ@mail.gmail.com>
Subject: Re: [PATCH] wireless: ipw2x00: Remove unnecessary parentheses
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 21/09/2018, Nathan Chancellor <natechancellor@gmail.com> wrote:
> Clang warns when multiple pairs of parentheses are used for a single
> conditional statement.
>
> drivers/net/wireless/intel/ipw2x00/ipw2200.c:5655:28: warning: equality
> comparison with extraneous parentheses [-Wparentheses-equality]
>                 if ((priv->ieee->iw_mode == IW_MODE_ADHOC)) {
>                      ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~
> drivers/net/wireless/intel/ipw2x00/ipw2200.c:5655:28: note: remove
> extraneous parentheses around the comparison to silence this warning
>                 if ((priv->ieee->iw_mode == IW_MODE_ADHOC)) {
>                     ~                    ^               ~
> drivers/net/wireless/intel/ipw2x00/ipw2200.c:5655:28: note: use '=' to
> turn this equality comparison into an assignment
>                 if ((priv->ieee->iw_mode == IW_MODE_ADHOC)) {
>                                          ^~
>                                          =
> 1 warning generated.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/134
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/net/wireless/intel/ipw2x00/ipw2200.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Looks fine, thanks!

Stanislav.
