Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53D58C4708D
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Dec 2022 11:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiLGLyq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Dec 2022 06:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiLGLya (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2022 06:54:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06E853EC7
        for <linux-wireless@vger.kernel.org>; Wed,  7 Dec 2022 03:53:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47F7860FE9
        for <linux-wireless@vger.kernel.org>; Wed,  7 Dec 2022 11:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C88C433D7;
        Wed,  7 Dec 2022 11:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670414005;
        bh=U+9ldIYftCfe1hNasUsm/uCtDZz4afQPBzeuWDbHM8I=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HEWbuwJVcNmg6ylv+bF7VpRZB/nw9bCmP6tHqfiTgWN6MLYdcPZTWGwiNlTf0agO2
         Km5yGO2dvyEd/XTkeknL8LhikPdQZX1H36bs8nusupJgJ4EXtGhtqzVk0f+8vuz1oa
         iL0kmirFwUs5eX2ydBNbvV8JdM0zIMVnyYZDfy6mcksOcABWRs//yQSHgsse5w0sqh
         gp9ot8OrA6xY0bdLsRJjJEYo1f1O7joQVizWVlEVsy0pUkFTs4A97HmzvR1/H1b7ab
         bTJGYSPgQjOk63TsedQG6yfjLphXoeu9K6gzyAwvZYq9+QiWmqiMcr7t8rnn/iWUWR
         gYO9oqWKMwBzQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] wifi: rtlwifi: don't call kfree_skb() under spin_lock_irqsave()
References: <20221207062823.3474551-1-yangyingliang@huawei.com>
Date:   Wed, 07 Dec 2022 13:53:21 +0200
In-Reply-To: <20221207062823.3474551-1-yangyingliang@huawei.com> (Yang
        Yingliang's message of "Wed, 7 Dec 2022 14:28:20 +0800")
Message-ID: <87sfhrmnv2.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yang Yingliang <yangyingliang@huawei.com> writes:

> It is not allowed to call kfree_skb() from hardware interrupt
> context or with interrupts being disabled. This patchset is
> trying to add all skb to a free list, then free them after
> spin_unlock_irqrestore() at once.
>
> v1 -> v2:
>   change subject prefix to "wifi: rtlwifi: ..."

I guess these are just compile tested? Please always include that
information to the commit log.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
