Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 718B9CCA479
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Jul 2022 14:56:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbiGDO4L (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Jul 2022 10:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234572AbiGDOzw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jul 2022 10:55:52 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602D2266A;
        Mon,  4 Jul 2022 07:55:50 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1656946547; bh=q82ZevWbswDO1lCTp/t1gLErAmMdV6+FU9ca3hSDzos=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=AIYiImg/MCNc0H0YM+UzS+95TdDNeVwOw3rZdw4QcybAgEpOPMWb79cQ24IwK1Rh7
         9t5t2/4TF86Jej2GU5/mlVWD/YWx+BupoHfQTS7wnDHhqYHikEHKBiaeowMFUbEoNC
         6FWtbCPrJc3pQ9s1LXPd2ERfIPd/0Fj4qq18tRxRmRj4/7ke8EVAxAYIkLd25vMpq9
         OlD65EgM+S+btULHuTQe+5uxIlEAai2VEBBKsVw2In/c2Ulo1+OuHj96p2S5Hx8joC
         ffycRCJUgYqy+za86we3q/fPM9fCAIpEgJYXjvr5KAs+wrzVFknj9C5JOXflQNWPfe
         UxjrWcZE4ETuQ==
To:     Tan Zhongjun <tanzhongjun@coolpad.com>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tan Zhongjun <tanzhongjun@coolpad.com>
Subject: Re: [PATCH] ath9k: Use swap() instead of open coding it
In-Reply-To: <20220704133205.1294-1-tanzhongjun@coolpad.com>
References: <20220704133205.1294-1-tanzhongjun@coolpad.com>
Date:   Mon, 04 Jul 2022 16:55:47 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87fsjh7wr0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"Tan Zhongjun" <tanzhongjun@coolpad.com> writes:

> Use swap() instead of open coding it
>
> Signed-off-by: Tan Zhongjun <tanzhongjun@coolpad.com>

Please don't send HTML email, the mailing lists will drop that. Also, an
identical patch was submitted back in February and an issue was pointed
out which your patch also suffers from:

https://lore.kernel.org/r/a2400dd73f6ea8672bb6e50124cc3041c0c43d6d.1644838854.git.yang.guang5@zte.com.cn

-Toke
