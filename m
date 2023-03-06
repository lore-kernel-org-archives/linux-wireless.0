Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9AEDC678D4
	for <linux-wireless@archiver.kernel.org>; Mon,  6 Mar 2023 10:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbjCFKIb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 6 Mar 2023 05:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbjCFKIW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2023 05:08:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A993ACC3F
        for <linux-wireless@vger.kernel.org>; Mon,  6 Mar 2023 02:08:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4490860C63
        for <linux-wireless@vger.kernel.org>; Mon,  6 Mar 2023 10:08:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4224C433D2;
        Mon,  6 Mar 2023 10:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678097300;
        bh=e7Qf0cJVCrQyBaLmkjhlAslzdK0ghC3lR/wkrPxnuSw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=k6YhANWfn/uqQa55PCA6wKrqNEl7Y6dw7YQ4LXMqxhLiqiy0khh5trmamY10E8Ff7
         70h1rhqJUNv06TBsuQ/Xuk4YgfU8iTINDOpgbSqBfGs6gGdSffFhLi4ArLM2mbnjHE
         LApLwb1bvQsI0HlSlpPcAQwhfruMsX/6wA89LnSOmyeGvOnO8bQtj0QdIkOBgo3NPj
         jsIAtErXxCKePGawQe8xJ3U2QfQpN0mKdw7RPLE/Uf8Hh/yvN7wEUCzUD+borQkR3M
         edQhe1MZIND+LIlk5kGo0duUqHB1ymf9I9yb81pRMcIdOZQ96YIQneK6qYfr4F9/kL
         JeBwQpZ8aT9Fw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rtw89: fix SER L1 might stop entering LPS issue
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230224082117.21241-1-pkshih@realtek.com>
References: <20230224082117.21241-1-pkshih@realtek.com>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     <gary.chang@realtek.com>, <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167809729397.16730.14646404697836836640.kvalo@kernel.org>
Date:   Mon,  6 Mar 2023 10:08:19 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Chih-Kang Chang <gary.chang@realtek.com>
> 
> When SER L1 triggered, driver need to stop Rx and clear RTW89_FLAG_RUNNING
> flag. If track_work check RTW89_FLAG_RUNNING simultaneously, it will check
> failed and never queue track_work again, and LPS won't enter either.
> Therefore, we cancel delayed work when enter SER L1, and queue delayed work
> when leave SER L1.
> 
> Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

5c48f9432d06 wifi: rtw89: fix SER L1 might stop entering LPS issue

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230224082117.21241-1-pkshih@realtek.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

