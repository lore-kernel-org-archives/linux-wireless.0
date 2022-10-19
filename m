Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22646C43217
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Oct 2022 23:23:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbiJSXXa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Oct 2022 19:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbiJSXX2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2022 19:23:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D47A157F63;
        Wed, 19 Oct 2022 16:23:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C737D601C3;
        Wed, 19 Oct 2022 23:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAC7C433D6;
        Wed, 19 Oct 2022 23:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666221806;
        bh=X48XrQw65DNcOVu2462NouGJs7xrBBJ/pVCEccoAvnE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TDmNJzGT2nxlSvbcsbTQGlwK/446bfChwnahMF3ppVgL6TzUsww6AGpsPhyyod8ll
         UY60JoH7bmJwe00mW7DjE9N2K6wgHCuUDp79Hxj/r0gtygum+aA+jFSjW0sn6F35cv
         +GtjxIwqdVDAuHBJFgeA8NAk/5wY7LYKMU7lVecwYfPnKGhiYowN6lz6DeE6Ra/jZC
         rsXQZKExrHu/+ohun0Rsy8p+go2q3UFvV6kO5uFRa3hk39k6Gpl0T2Kyp5LlWpfAOE
         hlj1neX/uVAqDW8iGopA5jxEK8aABFiUFxNPjEzsCn7dNC6Es9ckicwmPOjMMjr6yB
         3/QRTN+2gRHlw==
Date:   Wed, 19 Oct 2022 16:23:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Johannes Berg <johannes.berg@intel.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Wireless <linux-wireless@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Ilan Peer <ilan.peer@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: manual merge of the wireless-next tree with Linus'
 tree
Message-ID: <20221019162324.2baaa7e8@kernel.org>
In-Reply-To: <20221020032340.5cf101c0@canb.auug.org.au>
References: <20221020032340.5cf101c0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 20 Oct 2022 03:23:40 +1100 Stephen Rothwell wrote:
> Today's linux-next merge of the wireless-next tree got a conflict in:
> 
>   net/mac80211/util.c
> 
> between commit:
> 
>   ff05d4b45dd8 ("wifi: mac80211: fix MBSSID parsing use-after-free")
> 
> from the origin tree and commit:
> 
>   ff05d4b45dd8 ("wifi: mac80211: fix MBSSID parsing use-after-free")

Dunno if this is a glitch or real problem. But it reminds me - I see
there is direct wireless -> wireless-next merge without going via
Linus's tree. I think you may have mentioned it to us, but not sure
if I said this clearly - let's try to avoid such merges. Linus certainly
doesn't like when we do net -> net-next merges without sending net to
him first and forwarding. I'm not 100% sure why (maybe Steven knows)
- whether it's an aesthetic thing or avoiding real issues thing, but
either way it's _a_ thing :S
