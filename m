Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 588DDC8301A
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Dec 2020 21:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE0CA207FF
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Dec 2020 21:00:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="iIr8Ka4J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729933AbgLAVAr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Dec 2020 16:00:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbgLAVAr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Dec 2020 16:00:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606856406;
        bh=JCNmLBukEQuTPP2zu3Hc10F1Mx2+RY0jq117k3+PGzo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iIr8Ka4JWMJ2foudr5Xb+S1vO+O8RJdL9VRKXUO0y9PexDqUze9mThYug63l6X4V3
         YqnPyT5+rL4acagaIbG9GMDtZip+oAVP1N5/n6RbG0hE6DHxb9kH4yVByJVebWLTbu
         Z4/jeCrAqyD7R+UIt3LjKATCPnKNDuEeqqTOF1Go=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: switch to storing KCOV handle directly in
 sk_buff
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160685640656.20133.13714799531747994094.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Dec 2020 21:00:06 +0000
References: <20201125224840.2014773-1-elver@google.com>
In-Reply-To: <20201125224840.2014773-1-elver@google.com>
To:     Marco Elver <elver@google.com>
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        a.nogikh@gmail.com, andreyknvl@google.com, dvyukov@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, idosch@idosch.org, fw@strlen.de,
        willemb@google.com
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 25 Nov 2020 23:48:40 +0100 you wrote:
> It turns out that usage of skb extensions can cause memory leaks. Ido
> Schimmel reported: "[...] there are instances that blindly overwrite
> 'skb->extensions' by invoking skb_copy_header() after __alloc_skb()."
> 
> Therefore, give up on using skb extensions for KCOV handle, and instead
> directly store kcov_handle in sk_buff.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: switch to storing KCOV handle directly in sk_buff
    https://git.kernel.org/netdev/net-next/c/fa69ee5aa48b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


