Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E53B4C282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 22:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA13F2082E
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 22:54:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="bws3975s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbfBDWyp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 17:54:45 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:36152 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728356AbfBDWym (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 17:54:42 -0500
Received: by mail-ed1-f68.google.com with SMTP id d12so353786edy.3
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2019 14:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/8xiycFUoNZ0um1b1oNS4+gQZaxHi73TvcpH3Qrfl80=;
        b=bws3975s2ZvfNc9xmkkHavKX6eXi7Qb7eoQSwVPD7dwNR+zVXT/gcn+QizghsKkaf3
         WsztJmh2L/pjtxGAFNYQ1+97EPJD7Moh1HDvc8cOuOxlt3LbGvFamQDDR1n632mqUPUM
         OuNnmKNgYB+yTVogpwJuwjrIBEQ+sKf0nASBw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/8xiycFUoNZ0um1b1oNS4+gQZaxHi73TvcpH3Qrfl80=;
        b=Br3lgFlnZdzXm2oGJ2az1EklaWEhBpssnQxNBP3ytdunLNu1ow0kS/lfBKH+vQ9ZQF
         YmcYFeh7JAhURndJlY++SKy5IGCnvWbz30fzD/ZXxoUuJ3avxzM43v6OW7+rCW6Ggr8h
         VZAgruyuzPcAn6NXb0GyCJybn4RSrXJ5iijcZO7vNqovS/6R/ZDxYABZ2p5UCnr1lvsb
         +oxZdR0o3po8qkEAjfNgbAXS4++Vz2sD1DlmjYdGpU9qZWjTZE0pLtFXH+Ka1fXus4Em
         JTboH4PDtjPxNCQh58Lat10d7nEez9G1A19FsKcMIx2KLsqYmihxRHG54+kVGbequSgZ
         UBfA==
X-Gm-Message-State: AHQUAuYeWMXP2LYqfNBQ5hg9qkC4f/EBCm9o+lPKWdIC+XDgpXmPfTIv
        LgZYe6fZHYJWtz3ov1W5nz7S909U+Pk=
X-Google-Smtp-Source: AHgI3IbMxnvuX7exR/7tX63vCZHRSHcrwV2e4G4hMfULSYC+mnDkc4UshyyFeJmwFVlumJgIkwkuOA==
X-Received: by 2002:a50:9dc1:: with SMTP id l1mr1337479edk.272.1549320880559;
        Mon, 04 Feb 2019 14:54:40 -0800 (PST)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id i24sm4551629edq.0.2019.02.04.14.54.39
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Feb 2019 14:54:39 -0800 (PST)
Received: by mail-ed1-f41.google.com with SMTP id p6so1433275eds.0
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2019 14:54:39 -0800 (PST)
X-Received: by 2002:a50:ca86:: with SMTP id x6mr1259145edh.287.1549320878771;
 Mon, 04 Feb 2019 14:54:38 -0800 (PST)
MIME-Version: 1.0
References: <20181107185643.240346-1-briannorris@chromium.org> <20190204164254.86E0860734@smtp.codeaurora.org>
In-Reply-To: <20190204164254.86E0860734@smtp.codeaurora.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 4 Feb 2019 14:54:27 -0800
X-Gmail-Original-Message-ID: <CA+ASDXO4bMY9tWjeKND1+7yBC47XimNEohQEpyA-TZxgS7Xiiw@mail.gmail.com>
Message-ID: <CA+ASDXO4bMY9tWjeKND1+7yBC47XimNEohQEpyA-TZxgS7Xiiw@mail.gmail.com>
Subject: Re: [PATCH REGRESSION] Revert "ath10k: add quiet mode support for QCA6174/QCA9377"
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Yu Wang <yyuwang@codeaurora.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        Govind Singh <govinds@codeaurora.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Feb 4, 2019 at 8:43 AM Kalle Valo <kvalo@codeaurora.org> wrote:
> Brian Norris <briannorris@chromium.org> wrote:
>
> > This reverts commit cfb353c0dc058bc1619cc226d3cbbda1f360bdd3.
> >
> > WCN3990 firmware does not yet implement this feature, and so it crashes
> > like this:
> >
> >   fatal error received: err_qdi.c:456:EX:wlan_process:1:WLAN RT:207a:PC=b001b4f0
> >
> > This feature can be re-implemented with a proper service bitmap or other
> > feature-discovery mechanism in the future. But it should not break
> > working boards.
> >
> > Fixes: cfb353c0dc05 ("ath10k: add quiet mode support for QCA6174/QCA9377")
> > Cc: Yu Wang <yyuwang@codeaurora.org>
> > Cc: Rakesh Pillai <pillair@codeaurora.org>
> > Cc: Govind Singh <govinds@codeaurora.org>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Brian Norris <briannorris@chromium.org>
>
> This regression should be fixed by (which is in v4.20):
>
> 53884577fbce ath10k: skip sending quiet mode cmd for WCN3990
>
> So this revert should not be needed anymore and I'll drop this.

Yes, that seems to work for me. I'll probably replace the revert with
the above in my downstream. Thanks!

Can't really be fixed now, but it would have been nice to have a Fixes
tag on that one.

Brian
