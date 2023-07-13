Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6593EB64DA
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Jul 2023 00:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbjGMAh2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Jul 2023 20:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjGMAh1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Jul 2023 20:37:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C6E1BFB
        for <linux-wireless@vger.kernel.org>; Wed, 12 Jul 2023 17:37:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6917A619B9
        for <linux-wireless@vger.kernel.org>; Thu, 13 Jul 2023 00:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93ED4C433C7;
        Thu, 13 Jul 2023 00:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689208645;
        bh=LOAVn9+pATn/Vt/7EXwXAcCap/hGsEeh17u0hMrEIVA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BjexO3JT/aiut/uBQ2DmljR3ffJc9ENHEPN3OH70ml8xfgZeaTMEA4eqT0EiZoCUV
         QVKuAWJLtnRm3RArhNwqJ1PpI+gIgaIMEBseY+0eFTRjvnk0ncp8D7D9iPAwxyuxPU
         wzGxu+ZRsU2bv21ByDq46SogTW9otrhj92d2NqfOq2CQt2tZUnr7I8xUfNX/+WlaOi
         V+kM5WBniz+wm0+AQsGhblcxoo4j84Wm6e6VmxW8clznbjqfhu9TscPjLEvyro6UXO
         cLOdtxPe0huHkpX81MYDJpxo6j9l2od76R58NZLg5yA1ZHdD4Zaa/1ii+gOkrUDQnM
         g+vRZdHEUg5hQ==
Date:   Wed, 12 Jul 2023 17:37:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     johannes@sipsolutions.net
Cc:     JUN-KYU SHIN <jk.shin@newratek.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: mac80211: fix error handling when channel_switch
 on S1G band
Message-ID: <20230712173724.607067c7@kernel.org>
In-Reply-To: <20230711080918.20114-1-jk.shin@newratek.com>
References: <20230705141206.22a74fa3@kernel.org>
        <20230711080918.20114-1-jk.shin@newratek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 11 Jul 2023 17:09:18 +0900 JUN-KYU SHIN wrote:
> When channel_switch is performed to a channel with a freq_offset,
> such as 909.5 MHz, channel_switch fails with the "-EOPNOTSUPP" error.
> Since freq_offset is used in the S1G band, it should not be treated
> as an error only with the freq_offset condition.
> 
> Fixes: b6011960f392 ("mac80211: handle channel frequency offset")
> Signed-off-by: JUN-KYU SHIN <jk.shin@newratek.com>

Johannes, since you seem to be around - yes/no/can wait? :)
