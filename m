Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B027FC433EF
	for <linux-wireless@archiver.kernel.org>; Sat, 26 Mar 2022 00:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiCZAJW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Mar 2022 20:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiCZAIu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Mar 2022 20:08:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA813A71A;
        Fri, 25 Mar 2022 17:07:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA6D061811;
        Sat, 26 Mar 2022 00:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830BFC004DD;
        Sat, 26 Mar 2022 00:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648253234;
        bh=r8o9J8nfd9zoplXKjH+VNY9tM59LRhY5cImmkN7hXQE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KhYh1XSzMHuNNU26yhhilFLXwxkcq7OMmlYWYGPTDJYKlt+fjwu7LKHLgRL/NPwUF
         RMEu2s4CeSOU4e7p49i6deinKoocXF/TBuNJbNJHCbNx0tNZQqmSYgkykAHtFN656H
         +y3jX0NMOhCJfBCvAJH++c4HFFL9lBOQz0ExGTsiJKK5sTeVOjxGmdT3FQWxsgHNY8
         kJbJygSG4/TqRvmptFD4PtCMGZGR19uLt57zAOCr0h2X2m7RjAoJd+7UC3qsd+QN+q
         35MTbG7zA53Wzg+A1GBhWEXC46Ap92BD3jaY6Pxa5DlbpV5yA9HSL7fk+V1aJb+7Tz
         rlCtGnB1K4ngA==
Date:   Fri, 25 Mar 2022 17:07:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     William McVicker <willmcvicker@google.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>, kernel-team@android.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [BUG] deadlock in nl80211_vendor_cmd
Message-ID: <20220325170712.69c2c8d3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <Yj5W7VEij0BGwFK0@google.com>
References: <5d5cf050-7de0-7bad-2407-276970222635@quicinc.com>
        <YjpGlRvcg72zNo8s@google.com>
        <dc556455-51a2-06e8-8ec5-b807c2901b7e@quicinc.com>
        <Yjzpo3TfZxtKPMAG@google.com>
        <19e12e6b5f04ba9e5b192001fbe31a3fc47d380a.camel@sipsolutions.net>
        <20220325094952.10c46350@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <f4f8a27dc07c1adaab470fde302ed841113e6b7f.camel@sipsolutions.net>
        <Yj4FFIXi//ivQC3X@google.com>
        <Yj4ntUejxaPhrM5b@google.com>
        <976e8cf697c7e5bc3a752e758a484b69a058710a.camel@sipsolutions.net>
        <Yj5W7VEij0BGwFK0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 25 Mar 2022 23:57:33 +0000 William McVicker wrote:
> Instead of open coding it, we could just pass the internal_flags via struct
> genl_info to nl80211_vendor_cmds() and then handle the rtnl_unlock() there if
> the vendor command doesn't request it. I included the patch below in case
> there's any chance you would consider this for upstream. This would at least
> add backwards compatibility to the vendor ops API so that existing drivers that
> depend on the RTNL being held don't need to be fully refactored.

Sorry to step in, Johannes may be AFK already. There's no asterisk next
to the "we don't cater to out of tree code" rule, AFAIK.  We change
locking often, making a precedent like this would be ill-advised.
