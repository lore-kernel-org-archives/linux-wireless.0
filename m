Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D804EC4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 05:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A15B7206DF
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 05:20:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="E6TEYvZR";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ORa7mpWt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfDDFUW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 01:20:22 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43932 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfDDFUV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 01:20:21 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0136B606CF; Thu,  4 Apr 2019 05:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554355221;
        bh=jA/wST5N6jQsW6sxwXK4yuBY7gOPQOoY0kG5nkjUjLM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=E6TEYvZRlKEakTWf9hVxSoKK6yWvoWtcsYGNU0I0KVPKKYWU0WVAvGMjT7KF08O2G
         Jcc/KVRq5IjErwQDzTkNXlckGD+BM/+OgwtgAfx0SByEuNV5yjQ/OoKJjAz17BUDOj
         7McFEl3AH1G8HoYOa2EjCqutokBY1QBIZ9YWTcjM=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 423F7606CF;
        Thu,  4 Apr 2019 05:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554355220;
        bh=jA/wST5N6jQsW6sxwXK4yuBY7gOPQOoY0kG5nkjUjLM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ORa7mpWtwvY9Qg8sfvBpDp8mAJTBIohFtEjo9fCRpoOTuSQ7LSws/95LFNP2JsvcF
         8YD5HF0G/uCEETLXtfS8BTFa+736rK8bmSZ4niBx3JsTUjydUq6AteFeX4I8qgqXRA
         DRyFgyEFYTuXJkh2KZ9KLWtCEOhZP2EWkT8iz8xE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 423F7606CF
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Douglas Anderson <dianders@chromium.org>
Cc:     linux-rockchip@lists.infradead.org, briannorris@chromium.org,
        mka@chromium.org, ryandcase@chromium.org, heiko@sntech.de,
        "David S. Miller" <davem@davemloft.net>,
        Ganapathi Bhat <gbhat@marvell.com>,
        linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-kernel@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        netdev@vger.kernel.org, Xinming Hu <huxinming820@gmail.com>
Subject: Re: [PATCH] mwifiex: Make resume actually do something useful again on SDIO cards
References: <20190404040106.40519-1-dianders@chromium.org>
Date:   Thu, 04 Apr 2019 08:20:08 +0300
In-Reply-To: <20190404040106.40519-1-dianders@chromium.org> (Douglas
        Anderson's message of "Wed, 3 Apr 2019 21:01:06 -0700")
Message-ID: <874l7egxdj.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Douglas Anderson <dianders@chromium.org> writes:

> The commit fc3a2fcaa1ba ("mwifiex: use atomic bitops to represent
> adapter status variables") had a fairly straightforward bug in it.  It
> contained this bit of diff:
>
>  - if (!adapter->is_suspended) {
>  + if (test_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags)) {
>
> As you can see the patch missed the "!" when converting to the atomic
> bitops.  This meant that the resume hasn't done anything at all since
> that commit landed and suspend/resume for mwifiex SDIO cards has been
> totally broken.
>
> After fixing this mwifiex suspend/resume appears to work again, at
> least with the simple testing I've done.
>
> Fixes: fc3a2fcaa1ba ("mwifiex: use atomic bitops to represent adapter status variables")
> Signed-off-by: Douglas Anderson <dianders@chromium.org>

I'm planning to queue this for 5.1.

-- 
Kalle Valo
