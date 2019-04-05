Return-Path: <SRS0=iN42=SH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67CD0C4360F
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 03:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36FD020657
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 03:35:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KuTn2dL2";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JPYz3nEw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbfDEDfr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 23:35:47 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53572 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728735AbfDEDfr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 23:35:47 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6A44E60770; Fri,  5 Apr 2019 03:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554435346;
        bh=pH5NRHK3JOeaMjJpO5sz2vfcWdz8zkPBSCKyEFpyFn4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KuTn2dL2bUsnzb32vR7k+396N+otM2gShdUz4dX+6UzrlAsC/VnRC0Xqjmief3oQi
         fjSZiTUYzWx0+K2uS3N+KzFfMDbuXDhh/Ke3eS06P7NddKqlUTfb2Z2EU9XvadY/ZC
         29wAgQ941mPf2ID5m/6hha494ofAjHIRR4TpG0cw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8BA0860770;
        Fri,  5 Apr 2019 03:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554435345;
        bh=pH5NRHK3JOeaMjJpO5sz2vfcWdz8zkPBSCKyEFpyFn4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=JPYz3nEwwGDOn0+iOFXFqhd940EoF9pZiS/uMd4IHJs36+J6oBi6wAydHfmG23fy+
         KEKx3hYqOJsve1esFr77LXDNjFwui5Ih5UO15EF+BRXLeoZ/pQ3H0Ash3mR0wzz55/
         vg+KSwfCFwtpzLua9GNdaZ5eixAQsGJpHviwqBnI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8BA0860770
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Douglas Anderson <dianders@chromium.org>,
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
Date:   Fri, 05 Apr 2019 06:35:39 +0300
In-Reply-To: <CA+ASDXNfOUmMEWYwts8PuiDaEjuoPK+tZ0BhDSSte5u5toydkA@mail.gmail.com>
        (Brian Norris's message of "Thu, 4 Apr 2019 13:47:17 -0700")
Message-ID: <87ef6hruno.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

> On Wed, Apr 3, 2019 at 10:20 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>> Douglas Anderson <dianders@chromium.org> writes:
>> > Fixes: fc3a2fcaa1ba ("mwifiex: use atomic bitops to represent
>> > adapter status variables")
>> > Signed-off-by: Douglas Anderson <dianders@chromium.org>
>>
>> I'm planning to queue this for 5.1.
>
> With an explicit
>
> Cc: <stable@vger.kernel.org>
>
> please? Somebody would likely pick it up anyway, but it's nice to be
> explicit.

Ok, I'll add that.

> Not that it really matters, but also:
>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

This patchwork picks up automatically so I don't have to do anything.
But I so wish it would do the same for Cc and Fixes tags :)

-- 
Kalle Valo
