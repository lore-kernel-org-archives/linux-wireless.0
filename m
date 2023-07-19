Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 879C6C0015E
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Jul 2023 18:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjGSSAV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Jul 2023 14:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjGSSAU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2023 14:00:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553051FC1
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jul 2023 11:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCD04617CF
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jul 2023 18:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C8AC433C7;
        Wed, 19 Jul 2023 18:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689789619;
        bh=FNSwVas6f40XSnzFCl/wxKNhOZL/iwdgtkRrD84qjIU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YdriETaQyzhulwFyTPXwrKYms+TTdOxo3vHfThCS8frvTobZo/A7cCuOdaV58lL6u
         1FEvfc2zncfpnAijFLAGzJdBrMAtIedfk8wsFqjdLTojOarA8EiqNnfApg2gBWYiLT
         zznTO8z0jHhVgBfXx+/KP+7w9RXXn8kP0rDEmVkrLfjYZsc3qRE71+B+3xdzblk1gm
         comMRCCKX1JrSwYmzEpMsidcPfTMCzhlwnquitlltYGsvmdcDMekA36fZLpcbd+l+L
         t3vhotdQA3J8zbFqqTsEir2DpvwvLVQ7Fdh8e7Dg8v1i3EyWtWU6scAgM2b876HAHz
         FRmXN6cJHqmfA==
Date:   Wed, 19 Jul 2023 11:00:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ilan Peer <ilan.peer@intel.com>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: cfg80211: Fix return value in scan logic
Message-ID: <20230719110018.565eff67@kernel.org>
In-Reply-To: <20230719145120.739521-1-ilan.peer@intel.com>
References: <20230719145120.739521-1-ilan.peer@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 19 Jul 2023 17:51:20 +0300 Ilan Peer wrote:
> As cfg80211_parse_colocated_ap() is not expected to return a negative
> value return 0 and not a negative value if cfg80211_calc_short_ssid()
> fails.

What's the user visible impact of this issue?

> This bug was introduced in commit c8cb5b854b40f
> ('nl80211/cfg80211: support 6 GHz scanning').

And if it does indeed have user-visible impact please use the formal
Fixes tag format.

> Signed-off-by: Ilan Peer <ilan.peer@intel.com>
