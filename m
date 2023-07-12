Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 905C6EB64DC
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Jul 2023 02:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbjGLCaX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Jul 2023 22:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjGLCaW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Jul 2023 22:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF991722;
        Tue, 11 Jul 2023 19:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33995616A4;
        Wed, 12 Jul 2023 02:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F878C433C9;
        Wed, 12 Jul 2023 02:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689129020;
        bh=P4blXZ/KNZGfsUitb08zZr/C5+eX2FocoJvgmALEdm0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=paBfqdkuq3Sx5xcQMiTl27OWk9cKsQWxs54wgcPB6qC+8OIWNGpyFlAoe5YD+ONTu
         QHd0ad4oX8CeSB/oFc+3IwKq3i0xyBrjSbHTLvYObTb2pKwYnN0sK2YK99T6/hBmKj
         l7FxUe/Bt4+7bXfDudtYvj5TzFSYTGw5u7QA8nDoQN2rrMe5hW//N4PAs9dldQ32TG
         xDUVfuoaHDXYSWNzWF7j88kFRfLe6MVJ/IYO+fTm6h5AXuTYvbKTkjT/s+hiMU9p3N
         wtbx/hKXswz+VFeRqUqIUdhEXZl00qhfDrPYylEsFBNbQsD2KRqjDNjU2vFLLz5WF9
         grmXb1oFGT0xQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7184AE29F44;
        Wed, 12 Jul 2023 02:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] wifi: airo: avoid uninitialized warning in
 airo_get_rate()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168912902045.27748.5229570051520953441.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Jul 2023 02:30:20 +0000
References: <20230709133154.26206-1-rdunlap@infradead.org>
In-Reply-To: <20230709133154.26206-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, geert@linux-m68k.org,
        kvalo@kernel.org, linux-wireless@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  9 Jul 2023 06:31:54 -0700 you wrote:
> Quieten a gcc (11.3.0) build error or warning by checking the function
> call status and returning -EBUSY if the function call failed.
> This is similar to what several other wireless drivers do for the
> SIOCGIWRATE ioctl call when there is a locking problem.
> 
> drivers/net/wireless/cisco/airo.c: error: 'status_rid.currentXmitRate' is used uninitialized [-Werror=uninitialized]
> 
> [...]

Here is the summary with links:
  - [net] wifi: airo: avoid uninitialized warning in airo_get_rate()
    https://git.kernel.org/netdev/net/c/9373771aaed1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


