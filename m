Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9DFDC3F6B0
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Aug 2022 07:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241223AbiHOHAX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Aug 2022 03:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiHOHAW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Aug 2022 03:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E0324B;
        Mon, 15 Aug 2022 00:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDFA8B80C87;
        Mon, 15 Aug 2022 07:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1374C433D6;
        Mon, 15 Aug 2022 07:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660546817;
        bh=5spCSdjW5x7ryIsjMw7hTdUHSF4GOoGP5GO8fxvWqC4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pPS4pehk4pfLxmtO3uvTEt4K2DMkgSjtTqLY9xDR4n60Z/rVeHK3ErdQajCiLocI4
         FTkdyBwrAinsAp0RR7KPycBZHIYFgVkTWZjeK/P+bpCcORz8iWWPWrHDLGWJQkS9UQ
         IhTCpQqu9AdDuUJJQnsdRcrjUiYdkui1ABc6AaSI=
Date:   Mon, 15 Aug 2022 09:00:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Siddh Raman Pant <code@siddh.me>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        linux-kernel-mentees 
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        syzbot+b6c9fe29aefe68e4ad34@syzkaller.appspotmail.com
Subject: Re: [PATCH] wifi: mac80211: Don't finalize CSA in IBSS mode if state
 is disconnected
Message-ID: <Yvnu/WT1Z+K36UwW@kroah.com>
References: <20220814151512.9985-1-code@siddh.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220814151512.9985-1-code@siddh.me>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Aug 14, 2022 at 08:45:12PM +0530, Siddh Raman Pant via Linux-kernel-mentees wrote:
> When we are not connected to a channel, sending channel "switch"
> announcement doesn't make any sense.
> 
> The BSS list is empty in that case. This causes the for loop in
> cfg80211_get_bss() to be bypassed, so the function returns NULL
> (check line 1424 of net/wireless/scan.c), causing the WARN_ON()
> in ieee80211_ibss_csa_beacon() to get triggered (check line 500
> of net/mac80211/ibss.c), which was consequently reported on the
> syzkaller dashboard.
> 
> Thus, check if we have an existing connection before generating
> the CSA beacon in ieee80211_ibss_finish_csa().
> 
> Fixes: cd7760e62c2a ("mac80211: add support for CSA in IBSS mode")
> Bug report: https://syzkaller.appspot.com/bug?id=05603ef4ae8926761b678d2939a3b2ad28ab9ca6
> Reported-by: syzbot+b6c9fe29aefe68e4ad34@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Siddh Raman Pant <code@siddh.me>

Please no blank line before your signed-off-by line or the tools will
not like it.

And did sysbot verify that this change solved the problem?

thanks,

greg k-h
