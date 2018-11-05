Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A6DC46464
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 21:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36B572084F
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 21:17:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="cC5b9w64"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36B572084F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387814AbeKFGi5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 01:38:57 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35325 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387527AbeKFGiy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 01:38:54 -0500
Received: by mail-ed1-f68.google.com with SMTP id d6-v6so8768703edi.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 13:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HS4Aju5GFnrf8tyDrkKUFltwJc+IxN+9c6+1D0ef2k0=;
        b=cC5b9w64exAfqn5IsWqCRhPMrjN5mbicVVFKgluljZdUM+9uGMsaVi7ku1Gv2KZlek
         tbS0x+1A8AQOxOzmyLSiddSzsCj1PLuO5FINMvV0D+l/GJzeHtvIHvn40XqjkZtIB8Vb
         U8pARzhN+HVCo+yl7txc7JLd4LGUW914XGPGI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HS4Aju5GFnrf8tyDrkKUFltwJc+IxN+9c6+1D0ef2k0=;
        b=Zy0KZKcdZx1yk+dWlfqPSW5FKtLaCzzuf2tRkxqBoiO+vTDpL2OURqZrTgGm1RWRkm
         pLfqXf+L64ogBlU0EFg1G60lkDF7MwkCuXXWBinz4T37BP6jucYFB5/ICIIme9Z3I1bM
         zv1hNY6abRW7/QpNd6eZT6ZfZnwJkFFwpjGqzNCNhxDs26/XtdIlQ2c4ltuLJegzrb7j
         67DB7QLYeqSZyI2egk8u/LZ/bQqNkMBiTUaZmP6+/Q/MTohFkGkjyTuR5WNXB26BSp+s
         2LDf7A85kMBQ2okeLV+mVNPLg0N3d2xp/T/znURQ2ZOVqdOyRhO4lPvQZ0DT4/xQmEwd
         wOjg==
X-Gm-Message-State: AGRZ1gJRlyjlm6ZjbFmK6mmPNPvrGLyZFlRVLNpb2wVoaqJjm53kw6Z3
        py5Xd70mbvA81TtiY5qi1NMWi89n3wM=
X-Google-Smtp-Source: AJdET5dRJpolzcgDjAzeQOX9/T7U7NAYE0sC+IWrHLmrNFwNGohuwR1N5bSyy64FNxnybVjjBRbzyA==
X-Received: by 2002:a50:f110:: with SMTP id w16-v6mr19683801edl.0.1541452635682;
        Mon, 05 Nov 2018 13:17:15 -0800 (PST)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id fx18-v6sm7172622ejb.31.2018.11.05.13.17.13
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 13:17:13 -0800 (PST)
Received: by mail-ed1-f50.google.com with SMTP id y10-v6so2256764edr.4
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 13:17:13 -0800 (PST)
X-Received: by 2002:a50:c907:: with SMTP id o7-v6mr18992724edh.6.1541452633046;
 Mon, 05 Nov 2018 13:17:13 -0800 (PST)
MIME-Version: 1.0
References: <20181013005504.46399-1-briannorris@chromium.org> <20181105130403.93B6560600@smtp.codeaurora.org>
In-Reply-To: <20181105130403.93B6560600@smtp.codeaurora.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 5 Nov 2018 13:17:00 -0800
X-Gmail-Original-Message-ID: <CA+ASDXMz37pOFjeETM_xUQSBuLvki6G==v=RUO1T5G1t6Yv+dg@mail.gmail.com>
Message-ID: <CA+ASDXMz37pOFjeETM_xUQSBuLvki6G==v=RUO1T5G1t6Yv+dg@mail.gmail.com>
Subject: Re: [PATCH 1/4] ath10k: snoc: remove 'wcn3990' from generic resource handling
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, govinds@codeaurora.org,
        Doug Anderson <dianders@chromium.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Nov 5, 2018 at 5:04 AM Kalle Valo <kvalo@codeaurora.org> wrote:
> This patchset (I think it was with the first patch, but not sure) had some
> conflicts but 3-way merge was able to automatically solve them. Please check
> the end result anyway:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=77adda81e264e0c93af9570ac4ada82a5d0f5d99

I see the same. There were some unrelated changes to this file that
you merged to your pending tree in the meantime. The end result looks
fine to me. Thanks for the heads up.

Brian
