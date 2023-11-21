Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFADBC54FB9
	for <linux-wireless@archiver.kernel.org>; Tue, 21 Nov 2023 11:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbjKULu7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 21 Nov 2023 06:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbjKULu6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2023 06:50:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24483100
        for <linux-wireless@vger.kernel.org>; Tue, 21 Nov 2023 03:50:55 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8CFAC433C7;
        Tue, 21 Nov 2023 11:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700567454;
        bh=7eQWip1qheX65/nr9TveALEmgmfW2FIiutNAulouSHA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Rz8zMMY++dyndiyxej6nfDplsG+c4q5OX3GhFJKCL5UiudrrvF4mfW9tBuq2t/Uqx
         +0kdqVZHf+ElwxMCAbTGyaLFTdr/mM0Zi7wuGjwIuSUVPiBvceZtZjL6P8GJ0DIhYc
         q3HttFKN6Q6bJ4wuoaU91tC8HUWZgKW3FbsAkxqyoKAE9ROtrRkl9GuWBoo9eQacTC
         37bdQeNE7jAsKB91vseaEhhcdeGI+CqG+okKAGrnsOdeqhfwidNvlWSGeYZk1T4aIf
         lK/YYJ+3ezsVL979NqS++sz8LOuWHZ1crVCKslv4MJhvRbRe8JA9TQnQOn4lmp/gFH
         DmyowzlHVS4Sg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Mingyen Hsieh <mingyen.hsieh@mediatek.com>
Cc:     <nbd@nbd.name>, <lorenzo@kernel.org>, <deren.wu@mediatek.com>,
        <Sean.Wang@mediatek.com>, <Soul.Huang@mediatek.com>,
        <Leon.Yen@mediatek.com>, <Eric-SY.Chang@mediatek.com>,
        <km.lin@mediatek.com>, <robin.chiu@mediatek.com>,
        <ch.yeh@mediatek.com>, <posh.sun@mediatek.com>,
        <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
        <Shayne.Chen@mediatek.com>, <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH 1/3] wifi: mt76: mt7921: fix country count limitation
 for CLC
References: <20231120111212.4478-1-mingyen.hsieh@mediatek.com>
        <20231120111212.4478-2-mingyen.hsieh@mediatek.com>
Date:   Tue, 21 Nov 2023 13:50:48 +0200
In-Reply-To: <20231120111212.4478-2-mingyen.hsieh@mediatek.com> (Mingyen
        Hsieh's message of "Mon, 20 Nov 2023 19:12:10 +0800")
Message-ID: <874jhf8gvb.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Mingyen Hsieh <mingyen.hsieh@mediatek.com> writes:

> From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
>
> Due to the increase in the number of power tables on CLC, the variable
> nr_country is no longer sufficient to represent the total quantity.
> Therefore, we have switched to calculating the length of clc buf to
> obtain the correct power table. Additionally, the version number has
> been incremented to 1.
>
> Fixes: 23bdc5d8cadf ("wifi: mt76: mt7921: introduce Country Location Control support")
> Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
>
> v2:
>  - Convert type of buf_len from "__le16" to "u16"
>
> ---
>  drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)

The changelog ('v2:....') should be after '---' line.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
