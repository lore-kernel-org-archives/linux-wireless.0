Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF700C10F0E
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 16:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A5AF2183F
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 16:32:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="LC8ljuIS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389619AbfDRQcM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Apr 2019 12:32:12 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:45675 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388301AbfDRQcI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Apr 2019 12:32:08 -0400
Received: by mail-vs1-f67.google.com with SMTP id o10so1470272vsp.12
        for <linux-wireless@vger.kernel.org>; Thu, 18 Apr 2019 09:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7aEoO3va/0BYOjnj8WvPH3DexQjXPldBvVCPc/BO0+E=;
        b=LC8ljuIS5vQfdwj932zztWi2uWtQdGmIdN0IIpsyiY77Bi4RDLcIvAo69jBT1JMlYG
         WJZ/QDfIWn+DqAp1S0hK8lWv9LnFufnqdAwmtIaRScKvGXHGbspyzpuKv795j3mLdvqg
         6Vnk51E3Xcv8blk7fPARmZ8hM/jqctLsUKl7M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7aEoO3va/0BYOjnj8WvPH3DexQjXPldBvVCPc/BO0+E=;
        b=ZYfn3onaGqbhqAt85usTq6D+ldDjtJE2KxCEeEdVniTETM2SmL27gVqiQPGsJ9pf7t
         URnN7dDaRcGpKHAcS9b6WFbyX0S/WMhHQvfV63Y91MPG3v4hhSeF4EU/htDt4oFmpUYQ
         1imlfEzxYUNDoZHeo7czpNhxaWCTSHl5Q6+ll/oxV5TyMlJJyREqFqkfwmIQA7bn4O/f
         10sJ4NrlTnnHXWC6fkJLSrVxY588kE39xp7xOBqlpdFEBfh8Hw4IK+5jNkUHX7FOqpYM
         /lutjXg2jNXe545SsIoILByiss5ppcFCWSn17WJtAw75eHUKiceLmCojkFgOvW06UrUT
         P6/g==
X-Gm-Message-State: APjAAAXWhGBp9ly/TUwaq1vBfaav2fpI6Qt6gzf9XCAha4HJ8mEjhHdc
        EE+39vVR0/YA+Is6EkTIvtwPr8oiuxM=
X-Google-Smtp-Source: APXvYqxXhIBchUfV+BBx5iUis7PR0jz8hssChNus+/JcHx7g/cbwpv0vzv6y08hPBn/lvILckGW5xg==
X-Received: by 2002:a05:6102:401:: with SMTP id d1mr53516091vsq.178.1555605127701;
        Thu, 18 Apr 2019 09:32:07 -0700 (PDT)
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com. [209.85.222.49])
        by smtp.gmail.com with ESMTPSA id y1sm1468538uai.0.2019.04.18.09.32.04
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Apr 2019 09:32:06 -0700 (PDT)
Received: by mail-ua1-f49.google.com with SMTP id n16so940344uae.10
        for <linux-wireless@vger.kernel.org>; Thu, 18 Apr 2019 09:32:04 -0700 (PDT)
X-Received: by 2002:ab0:2692:: with SMTP id t18mr23156240uao.106.1555605123742;
 Thu, 18 Apr 2019 09:32:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190404040106.40519-1-dianders@chromium.org> <874l7egxdj.fsf@codeaurora.org>
 <CA+ASDXNfOUmMEWYwts8PuiDaEjuoPK+tZ0BhDSSte5u5toydkA@mail.gmail.com> <87ef6hruno.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87ef6hruno.fsf@kamboji.qca.qualcomm.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Thu, 18 Apr 2019 09:31:51 -0700
X-Gmail-Original-Message-ID: <CAD=FV=WgTUgMg-r2ZJ6rKOiv5Lw_m-EX6c0it6znA9v8AO+z_A@mail.gmail.com>
Message-ID: <CAD=FV=WgTUgMg-r2ZJ6rKOiv5Lw_m-EX6c0it6znA9v8AO+z_A@mail.gmail.com>
Subject: Re: [PATCH] mwifiex: Make resume actually do something useful again
 on SDIO cards
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Brian Norris <briannorris@chromium.org>,
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

Hi,

On Thu, Apr 4, 2019 at 8:35 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Brian Norris <briannorris@chromium.org> writes:
>
> > On Wed, Apr 3, 2019 at 10:20 PM Kalle Valo <kvalo@codeaurora.org> wrote:
> >> Douglas Anderson <dianders@chromium.org> writes:
> >> > Fixes: fc3a2fcaa1ba ("mwifiex: use atomic bitops to represent
> >> > adapter status variables")
> >> > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> >>
> >> I'm planning to queue this for 5.1.

Do you know when you plan to queue this?  I don't see the patch in
Linus's tree nor in linux-next.  Just want to make sure it didn't get
forgotten...

Thanks!

-Doug
