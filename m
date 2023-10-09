Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFBE4E95A8E
	for <linux-wireless@archiver.kernel.org>; Mon,  9 Oct 2023 09:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345690AbjJIJTC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 9 Oct 2023 05:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345701AbjJIJTB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Oct 2023 05:19:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0501C5
        for <linux-wireless@vger.kernel.org>; Mon,  9 Oct 2023 02:18:59 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29B9C433C8;
        Mon,  9 Oct 2023 09:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696843139;
        bh=NW6HXAOdDyyzsbXnxbBiq55N+Ir0yG1UhJ97WsoKKS4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IXGBNYkGhwBNjf0yZmemjenMGMttUH8/LtGPRDSLGsLsbDiwcQ1zaR1Qay4K9rgdt
         0afHqCkQBfXp7qBpWhJ/VcTTWwgOUvWUgPnUq3MzY3KDnc7h5YKY1ATiTSpTg0Y9i3
         D/FomHtzBbhCghD/BuZ22e/EezOoPpC41TOhMIJHBlI3aGLrnLt0dXpweJwDc1rd77
         ZQISpwoNnkMYymImSxySL9vc6CwyT18GqJE4MAHcJ5L/YepWG72rK3+FkU31/pXX2P
         3NoozSOn+L2+AAOeVk4Px6PEJVdZUbKBEaX9YFZuAzraHY53ovJKwJwfsO6MkZTXXL
         lnG9VV5a/6p1A==
From:   Kalle Valo <kvalo@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: cfg80211: use system_unbound_wq for wiphy work
References: <20231009101800.bb75408bf635.I6528d97e24b3da36cdf633b4738327d77c7276f2@changeid>
Date:   Mon, 09 Oct 2023 12:18:57 +0300
In-Reply-To: <20231009101800.bb75408bf635.I6528d97e24b3da36cdf633b4738327d77c7276f2@changeid>
        (Johannes Berg's message of "Mon, 9 Oct 2023 10:18:01 +0200")
Message-ID: <87bkd85f26.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> Since wiphy work items can run pretty much arbitrary
> code in the stack/driver, it can take longer to run
> all of this, so we shouldn't be using system_wq via
> schedule_work(). Also, we lock the wiphy (which is
> the reason this exists), so use system_unbound_wq.
>
> Reported-by: Kalle Valo <kvalo@kernel.org>
> Fixes: a3ee4dc84c4e ("wifi: cfg80211: add a work abstraction with special semantics")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Thanks!

So the background of this is that I enabled
CONFIG_WQ_CPU_INTENSIVE_REPORT on my ath11k test box and saw:

[  290.475631] workqueue: cfg80211_wiphy_work [cfg80211] hogged CPU for >10000us 4 times, consider switching to WQ_UNBOUND

With Johannes' patch I don't see it anymore so:

Tested-by: Kalle Valo <kvalo@kernel.org>

I do see one other warning about gc_worker but that's from netfilter and
nothing to do with wireless:

[  440.486683] workqueue: gc_worker hogged CPU for >10000us 128 times, consider switching to WQ_UNBOUND

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
