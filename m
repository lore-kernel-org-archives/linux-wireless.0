Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D44FC4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 20:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 635F1206C0
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 20:47:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="OHxRQe4t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731165AbfDDUrc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 16:47:32 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39134 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728743AbfDDUrc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 16:47:32 -0400
Received: by mail-lf1-f66.google.com with SMTP id m13so2788955lfb.6
        for <linux-wireless@vger.kernel.org>; Thu, 04 Apr 2019 13:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lj7E0dX/n40xL9DviNuZFYN3qlP/0blpKhCIQVM1Noo=;
        b=OHxRQe4tknqzI3KJ77CK0N68mnchHgfZ+2xhr2CG02T/h6b3IGBmAbJ2/e7r+vCrF9
         Q8TUXAKzlrMDfjIYoooHsr2ZIWLjLY13afv05+6ufRoMFwil7lSTS5TXzIOo9ab3m3Mf
         dr/mEnEWMScIWjoB9EGceddpryw6Pby5PXQa8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lj7E0dX/n40xL9DviNuZFYN3qlP/0blpKhCIQVM1Noo=;
        b=V39V2XiCdXGRSThdZohrbUnjrVtVE8kQgMOUyjKjBKGNsigQPS6bH9r8Ox+i7fz7CO
         qg6/zgcujaaBp7iMeLyVhGnYFLmBEGo13nSo2mYDf8BmJ0i72Nn1L4nmWWmG1t1FLART
         h4CLm2MExf3FITiugbT3paPYtHGNn+G/FgqUd18lltCEykFT2HeIs9okKFv4DgdD9+8e
         EKQfoss4yyhoLNpE2kRlL+oZJf/RBkHCiukgIF4AQS4PKKdZc9IbxBmbiGQAUUcmAOaD
         gvFVMkcGOSBmsxHjm2kRKtc6iDFG6Tt6nWoVKRDfhSiC4t/0KIe3MUAGAiCcfbpeqLLY
         hR9Q==
X-Gm-Message-State: APjAAAU10alPQXC2Xqz8KTSxkNyDeekZySfyzbDFaTRDvd5tuuZMxcoz
        38vhDWjMifsYqKZ6rMo66xniVL7ZO4g=
X-Google-Smtp-Source: APXvYqxCPW1FYsuQCDkjVqvRkK0ASBxIUUNHQbXNeAIHebU2sKqqFXc/cpQA64GY4vh9uK/Zf6glrQ==
X-Received: by 2002:a19:ef19:: with SMTP id n25mr4410088lfh.0.1554410850420;
        Thu, 04 Apr 2019 13:47:30 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id y13sm3822419lfl.22.2019.04.04.13.47.29
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Apr 2019 13:47:29 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id v14so2837373lfi.0
        for <linux-wireless@vger.kernel.org>; Thu, 04 Apr 2019 13:47:29 -0700 (PDT)
X-Received: by 2002:a19:7d84:: with SMTP id y126mr4559966lfc.124.1554410848649;
 Thu, 04 Apr 2019 13:47:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190404040106.40519-1-dianders@chromium.org> <874l7egxdj.fsf@codeaurora.org>
In-Reply-To: <874l7egxdj.fsf@codeaurora.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Thu, 4 Apr 2019 13:47:17 -0700
X-Gmail-Original-Message-ID: <CA+ASDXNfOUmMEWYwts8PuiDaEjuoPK+tZ0BhDSSte5u5toydkA@mail.gmail.com>
Message-ID: <CA+ASDXNfOUmMEWYwts8PuiDaEjuoPK+tZ0BhDSSte5u5toydkA@mail.gmail.com>
Subject: Re: [PATCH] mwifiex: Make resume actually do something useful again
 on SDIO cards
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Douglas Anderson <dianders@chromium.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Ryan Case <ryandcase@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Ganapathi Bhat <gbhat@marvell.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Xinming Hu <huxinming820@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Apr 3, 2019 at 10:20 PM Kalle Valo <kvalo@codeaurora.org> wrote:
> Douglas Anderson <dianders@chromium.org> writes:
> > Fixes: fc3a2fcaa1ba ("mwifiex: use atomic bitops to represent adapter status variables")
> > Signed-off-by: Douglas Anderson <dianders@chromium.org>
>
> I'm planning to queue this for 5.1.

With an explicit

Cc: <stable@vger.kernel.org>

please? Somebody would likely pick it up anyway, but it's nice to be explicit.

Not that it really matters, but also:

Reviewed-by: Brian Norris <briannorris@chromium.org>

Thanks,
Brian
