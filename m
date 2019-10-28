Return-Path: <SRS0=NkA/=YV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D79DBCA9EC0
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Oct 2019 14:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE11021744
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Oct 2019 14:47:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QQAhywDm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390292AbfJ1OrD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Oct 2019 10:47:03 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:42994 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727982AbfJ1OrD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Oct 2019 10:47:03 -0400
Received: by mail-io1-f65.google.com with SMTP id k1so1997810iom.9;
        Mon, 28 Oct 2019 07:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yAdrULyPsP/saITrhQHAw973q46vIVzs8IC2ETW439M=;
        b=QQAhywDmsOGu3coSnKbJtF4iR4BVXWDs/vXUz52Ab9yVEeC53HQJehf1YFook6soIi
         cjiIb1IJSu1/VLEATHmher8rfFI2ExE49XBsd1/JaA1UADBln6n3ubYZyFkpvBURFm1Q
         NcWgXXEpQJPeWdxsKj9UEWIBq2UIgBbmUUrSkCglZU0wAkR9xYngIyOd2ge1O4ysOBHy
         bCVmT4L1t07zi1Eq95jlNFgZVSawQm5Yjf36/mZQAlj9Dwie827dJjMv6VBS7KshsV9J
         Ec1CdrIEz3Tofu0wvqU83PszdhDcztBGdUbm7rUOW/hgBoPE8smhTi9wEh10e1BAWIpn
         s75w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yAdrULyPsP/saITrhQHAw973q46vIVzs8IC2ETW439M=;
        b=NzZkccufFHngDqzK6iKXGc9hU6Pzv6yM3uarAKpeo+adGAbNmIx4vcOixhMK7/Bqns
         sHClYGkVl5GSeZum9fSCVTmU6Nj5h1xn+JQPrFYXZH5UmIb9zNIL4GHiHrBY5s+ISQzt
         DC++Dylm45qn+0Mqn/SvieC6Oi83Z1vzOwyCkdhOsl3JtHBZ/HR5qCUPyKlaWMrzo0eT
         KbCQsXvSHGptL5pFkXEPvinZOMQWTgrBSs7Fel2LAg2Tn9HIUvACTBO9D4EA8AcCt1sP
         TMyvh3F2lIMcRKa1sar39H1NMq3kjDjQDLtZ5T9QHs9PokLtihVAFd9qq14qApNgjIoP
         /aYg==
X-Gm-Message-State: APjAAAVxWTUV15gWiVTLEWgBvFUhNFOb88cW+O/af3qFRL7krAAhbQkg
        GjjQcGxVnmUg9c8el6h8+FAi9iXPsG+eUQCjfSE=
X-Google-Smtp-Source: APXvYqwRGrEMocwfiJKgngbQwJ1cUH7qFhJiEsIdi038NTMHy30hIo1Ql6GFXDTIDLNemPEdYg7e30CyxZlLg0llkrI=
X-Received: by 2002:a6b:ba44:: with SMTP id k65mr2436219iof.190.1572274022666;
 Mon, 28 Oct 2019 07:47:02 -0700 (PDT)
MIME-Version: 1.0
References: <20191027181600.11149-1-navid.emamdoost@gmail.com> <d0fc94581e0dce37d993c55edaae8fc40eaa7601.camel@sipsolutions.net>
In-Reply-To: <d0fc94581e0dce37d993c55edaae8fc40eaa7601.camel@sipsolutions.net>
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Date:   Mon, 28 Oct 2019 09:46:51 -0500
Message-ID: <CAEkB2ERK=LQNgzAk-O9UB4wBGQGfSLdUOuybBwWiPTnoipfuTQ@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: Fix memory leak in cfg80211_inform_single_bss_frame_data
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Navid Emamdoost <emamd001@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Oct 28, 2019 at 7:12 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Sun, 2019-10-27 at 13:15 -0500, Navid Emamdoost wrote:
> > In the implementation of cfg80211_inform_single_bss_frame_data() the
> > allocated memory for ies is leaked in case of an error. Release ies if
> > cfg80211_bss_update() fails.
>
> I'm pretty sure it's more complicated than this patch (and the previous
> one) - we already do free this at least in the case that "new =
> kzalloc(...)" fails in cfg80211_bss_update().

Now I agree, there are two cases of release for ies in cfg80211_bss_update().
But for future reference, I suspect the last two cases of goto drop to
be mishandling ies.


>
> Your Fixes: tag is also wrong, back then we didn't even have the dynamic
> allocation of the IEs.
>
> I'm dropping this patch and the other and will make a note to eventually
> look at the lifetime issue here you point out, but if you want to work
> on it instead let me know.
>
> johannes
>


-- 
Navid.
