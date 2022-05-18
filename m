Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3EF3C433F5
	for <linux-wireless@archiver.kernel.org>; Wed, 18 May 2022 07:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbiERHVa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 18 May 2022 03:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbiERHVW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 May 2022 03:21:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5686811A31;
        Wed, 18 May 2022 00:21:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E81816125B;
        Wed, 18 May 2022 07:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAD9C385A5;
        Wed, 18 May 2022 07:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652858480;
        bh=Z2Hthqp8KamMwaRyOnQgeWg8sKO8QHlR39SF4zKnXc4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=nGZxLw/nb7pTaCGz5xDXtFkANXc7mb2cwz2A7XO0Wy57+RabREGGiM5RRSn5mLl/J
         FL+7390d9tF1niOyIMVnO3S8rB9I1xoYzw/p+58sQttVtFWeZFaMDWKrpa2J0nyhFq
         cPbpQLBnk/zwGOovIjiw0jyWz2f1IwOBciTzWJA59VJOk+VJyhxYhckmYGshhwChMG
         mitv8g8ayQhIdlF7tMX3MGcRg+DfaJkZGuakcdP6sgDNSOyyCNwrGLFdj5aSA7qioq
         vg376YiDQvlIceWdTPYs/Pa4rNP8dqMWqN5kAApXUH5SrVzSVArM+WE6o7vsI2jWKm
         JgMTyUmiQXc7Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: Fix pointer dereferenced before checking
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <1652671437-20235-1-git-send-email-baihaowen@meizu.com>
References: <1652671437-20235-1-git-send-email-baihaowen@meizu.com>
To:     Haowen Bai <baihaowen@meizu.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Haowen Bai <baihaowen@meizu.com>, <ath11k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165285847598.17755.2700505085056283549.kvalo@kernel.org>
Date:   Wed, 18 May 2022 07:21:17 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Haowen Bai <baihaowen@meizu.com> wrote:

> The pointer sspec is dereferencing pointer sar before sar is being
> null checked. Fix this by assigning sar->sub_specs to sspec only if
> sar is not NULL, otherwise just NULL. The code has checked sar whether
> it is NULL or not as below, but use before checking.
> 
> Signed-off-by: Haowen Bai <baihaowen@meizu.com>

I prefer Baochen's version:

https://patchwork.kernel.org/project/linux-wireless/patch/20220517004844.2412660-1-quic_bqiang@quicinc.com/

Patch set to Superseded.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1652671437-20235-1-git-send-email-baihaowen@meizu.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

