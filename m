Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:40242 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdLIUPi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Dec 2017 15:15:38 -0500
Message-ID: <1512850533.26976.48.camel@sipsolutions.net> (sfid-20171209_211559_269452_2C7A3EE3)
Subject: Re: Wireless regressions in v4.15-rc1
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org
Date: Sat, 09 Dec 2017 21:15:33 +0100
In-Reply-To: <87po7xwajg.fsf@kamboji.qca.qualcomm.com> (sfid-20171202_135939_841463_D1ADD367)
References: <87po7xwajg.fsf@kamboji.qca.qualcomm.com>
         (sfid-20171202_135939_841463_D1ADD367)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-12-02 at 14:59 +0200, Kalle Valo wrote:
> 
> net: netlink: Update attr validation to require exact length for some types
> https://git.kernel.org/linus/28033ae4e0f5

This was reverted, more or less, to print only a warning:

https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=6e237d099fac1f73a7b6d7287bb9191f29585a4e

> Jouni fixed this already in hostapd but we also need a fix for kernel so
> that old hostapd versions continue to work:
> 
> https://w1.fi/cgit/hostap/commit/?id=a2426829ce426de82d2fa47071ca41ea81c43307
> 
> Jouni also found a similar problem with mesh:
> 
> https://w1.fi/cgit/hostap/commit/?id=963d3149abfcbab5b83f9023bc50321f777360d1

See above for the kernel revert to let old hostapd versions continue to
work (properly only on little endian platforms) when they don't have
these fixes.

> And Johannes already submitted a revert related to wpa_supplicant:
> 
> [net] Revert "net: core: maybe return -EEXIST in __dev_alloc_name" diffmboxseries
> https://patchwork.ozlabs.org/patch/843863/

That was applied.

> And with ath10k I'm now seeing this:
> 
> [  133.175508] WARNING: CPU: 2 PID: 1743 at net/mac80211/agg-tx.c:315 ___ieee80211_stop_tx_ba_session+0x1ab/0x280 [mac80211]

Just sent a fix for this, kinda a merge/patch failure.

> johannes
