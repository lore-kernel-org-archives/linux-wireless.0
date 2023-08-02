Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC14C001DE
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Aug 2023 08:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbjHBIhw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 2 Aug 2023 04:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbjHBIhv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2023 04:37:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D8EA0
        for <linux-wireless@vger.kernel.org>; Wed,  2 Aug 2023 01:37:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99B63617B4
        for <linux-wireless@vger.kernel.org>; Wed,  2 Aug 2023 08:37:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617B5C433C8;
        Wed,  2 Aug 2023 08:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690965470;
        bh=e7HVn8jnabAhoQs1LJYpx/7sv6qR7TqR5arDP9CPs8E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A7Sww42EsubRI9/Q1+04p0aLyVZF9ZQVZtbPcKG1nQwqZmk32PTWbd7ogad5w24yb
         lGnASeMnCm/BNESYJehIaBBfAqL97burELlJ13Kxth22sg/wn+VDzfHz7L2utjMkzu
         Oyg/zcCFGx625gFZKJ/92PZZUU/CjHfzsQmZVpYsOyxCmKMkFSQeJbnPScdcy4C+zH
         0CDmd0/dSb4PMt0smPpM7uMASg3g0HjU4VWnXxcBU/72VMc6gs+Rc12G064Zdxls4F
         awJCbc9Dl8my4HXJBz4EvRG/7n/tEJUo2DREifhwl3KhlbARhzojgrURySyw4h4UBv
         s+wIc+N8oX8oA==
Date:   Wed, 2 Aug 2023 10:37:46 +0200
From:   Simon Horman <horms@kernel.org>
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] wifi: mac80211: Remove unused function declarations
Message-ID: <ZMoV2qYHru4QModa@kernel.org>
References: <20230801134337.24452-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230801134337.24452-1-yuehaibing@huawei.com>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Aug 01, 2023 at 09:43:37PM +0800, Yue Haibing wrote:
> Commit 685429623f88 ("mac80211: Fix circular locking dependency in ARP filter handling")
> leave ieee80211_set_arp_filter() declaration unused.
> And 164eb02d070a ("mac80211: add radar detection command/event") introducted
> ieee80211_dfs_cac_timer() declaration but never implemented.
> 
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>

Reviewed-by: Simon Horman <horms@kernel.org>

