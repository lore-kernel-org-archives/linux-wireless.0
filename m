Return-Path: <SRS0=g+pd=SV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F293BC282DA
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Apr 2019 04:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF3D720854
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Apr 2019 04:03:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fsRZQCT1";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="h0oDQPYR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbfDSEDS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Apr 2019 00:03:18 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55114 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbfDSEDS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Apr 2019 00:03:18 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 139386156F; Fri, 19 Apr 2019 04:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555646597;
        bh=PuPRDCs/gwkZtcIesXyz9fFaesQfwN078XRAdIlT+As=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=fsRZQCT1GfjsLR4KeFvYvctb+KzAJnXCcy+ICvBmnTzLGGwIwBRLmaO3DJcxppDi3
         AA6YXt8KM0RjXCtWD4vJ7HmbN77emrS+ZiGtu3yJdvIr1uMyiVh5ji0Nw3l7+FRX52
         5Bg3NpcPpESYFrIMoEtyXQaLiNOOQlvzgh3MtqME=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 45F4C614B5;
        Fri, 19 Apr 2019 04:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555646596;
        bh=PuPRDCs/gwkZtcIesXyz9fFaesQfwN078XRAdIlT+As=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=h0oDQPYRDqqZaqxa3B36FGdXtkuWW/NbQDcvbpJ4N1E3lgPJlFRNc2IBNXpbykv8S
         PR2D4f7/Mrv58bmR67KbMBz0XXVUiKEFhxV9NE44RjLQmA4NmbPvvytg48BVuatzt2
         pNkBXJv22Zc4LsLBfAxtqsZAsdu3oGrerb7GaJzM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 45F4C614B5
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Brian Norris <briannorris@chromium.org>,
        "open list\:ARM\/Rockchip SoC..." 
        <linux-rockchip@lists.infradead.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Ryan Case <ryandcase@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Ganapathi Bhat <gbhat@marvell.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "\<netdev\@vger.kernel.org\>" <netdev@vger.kernel.org>,
        Xinming Hu <huxinming820@gmail.com>
Subject: Re: [PATCH] mwifiex: Make resume actually do something useful again on SDIO cards
References: <20190404040106.40519-1-dianders@chromium.org>
        <874l7egxdj.fsf@codeaurora.org>
        <CA+ASDXNfOUmMEWYwts8PuiDaEjuoPK+tZ0BhDSSte5u5toydkA@mail.gmail.com>
        <87ef6hruno.fsf@kamboji.qca.qualcomm.com>
        <CAD=FV=WgTUgMg-r2ZJ6rKOiv5Lw_m-EX6c0it6znA9v8AO+z_A@mail.gmail.com>
Date:   Fri, 19 Apr 2019 07:03:11 +0300
In-Reply-To: <CAD=FV=WgTUgMg-r2ZJ6rKOiv5Lw_m-EX6c0it6znA9v8AO+z_A@mail.gmail.com>
        (Doug Anderson's message of "Thu, 18 Apr 2019 09:31:51 -0700")
Message-ID: <87k1fq1w1s.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Doug Anderson <dianders@chromium.org> writes:

> On Thu, Apr 4, 2019 at 8:35 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>> Brian Norris <briannorris@chromium.org> writes:
>>
>> > On Wed, Apr 3, 2019 at 10:20 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>> >> Douglas Anderson <dianders@chromium.org> writes:
>> >> > Fixes: fc3a2fcaa1ba ("mwifiex: use atomic bitops to represent
>> >> > adapter status variables")
>> >> > Signed-off-by: Douglas Anderson <dianders@chromium.org>
>> >>
>> >> I'm planning to queue this for 5.1.
>
> Do you know when you plan to queue this?  I don't see the patch in
> Linus's tree nor in linux-next.  Just want to make sure it didn't get
> forgotten...

It's on my queue and not forgotten:

https://patchwork.kernel.org/patch/10884883/

Due to various reasons I'm really struggling with patches right now,
sorry about that, but I'm slowly catching up. I should be able to apply
this within a week.

-- 
Kalle Valo
