Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:40476 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731297AbeGRSb2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jul 2018 14:31:28 -0400
Date: Thu, 19 Jul 2018 02:52:24 +0900 (KST)
Message-Id: <20180719.025224.724580559198605486.davem@davemloft.net> (sfid-20180718_195242_798421_EDBB5A63)
To: penguin-kernel@I-love.SAKURA.ne.jp
Cc: sameo@linux.intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+d29d18215e477cfbfbdd@syzkaller.appspotmail.com
Subject: Re: [PATCH] net/nfc: Avoid stalls when nfc_alloc_send_skb()
 returned NULL.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1531907847-3500-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
References: <1531907847-3500-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Wed, 18 Jul 2018 18:57:27 +0900

> syzbot is reporting stalls at nfc_llcp_send_ui_frame() [1]. This is
> because nfc_llcp_send_ui_frame() is retrying the loop without any delay
> when nonblocking nfc_alloc_send_skb() returned NULL.
> 
> Since there is no need to use MSG_DONTWAIT if we retry until
> sock_alloc_send_pskb() succeeds, let's use blocking call.
> Also, in case an unexpected error occurred, let's break the loop
> if blocking nfc_alloc_send_skb() failed.
> 
> [1] https://syzkaller.appspot.com/bug?id=4a131cc571c3733e0eff6bc673f4e36ae48f19c6
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Reported-by: syzbot <syzbot+d29d18215e477cfbfbdd@syzkaller.appspotmail.com>

Applied and queued up for -stable, thanks.
