Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA360ECAAD3
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Sep 2022 08:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiIGIDE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Sep 2022 04:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiIGICi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Sep 2022 04:02:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EE3AB192
        for <linux-wireless@vger.kernel.org>; Wed,  7 Sep 2022 01:02:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A31C4617C0
        for <linux-wireless@vger.kernel.org>; Wed,  7 Sep 2022 08:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576DAC4314F;
        Wed,  7 Sep 2022 08:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662537736;
        bh=9KAqY7aetdItbTsJtRpGHaOUvbqpChlrc5OGfYixmoE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=MMUHGuQS/zyP7d2K9aLX4AVMwpWd8gCcRKfArlBKkB1ZNa5jwoDMtHVJRzesp0jS/
         /ErOO51958HdVa8XN3GTtpIn6gnGyIUs7/QIPaIBxqdugweIJf+/M945QQJe6+AVRm
         eqlZo5p6j9lTmrgg39Iqm6Gc9c4pKvI+uCJLAefWw7n99fDAq0KR6FnpvQ+fwplm5g
         eDRbUavIo4yGMHUIq8dxemCJei2SWYMZNh5ZF6yDn0ybdglH4+urOxxjnktspA4e7Z
         H4I4h97Piqnp7r+zm7+mTYjBXw5qwAxAx0HB0NPFV1JIYxkGj5HsGnVDuR+YvOvZMf
         jW2GwpYmnjWRg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] wifi: rtl8xxxu: Fix skb misuse in TX queue selection
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <7fa4819a-4f20-b2af-b7a6-8ee01ac49295@gmail.com>
References: <7fa4819a-4f20-b2af-b7a6-8ee01ac49295@gmail.com>
To:     Bitterblue Smith <rtl8821cerfe2@gmail.com>
Cc:     linux-wireless@vger.kernel.org, Jes.Sorensen@gmail.com
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166253773363.23292.14170408152286611932.kvalo@kernel.org>
Date:   Wed,  7 Sep 2022 08:02:15 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:

> rtl8xxxu_queue_select() selects the wrong TX queues because it's
> reading memory from the wrong address. It expects to find ieee80211_hdr
> at skb->data, but that's not the case after skb_push(). Move the call
> to rtl8xxxu_queue_select() before the call to skb_push().
> 
> Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
> Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>

Patch applied to wireless-next.git, thanks.

edd5747aa12e wifi: rtl8xxxu: Fix skb misuse in TX queue selection

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/7fa4819a-4f20-b2af-b7a6-8ee01ac49295@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

