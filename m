Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36546 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756930Ab2KZRtI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 12:49:08 -0500
Message-ID: <1353952160.2800.8.camel@jlt4.sipsolutions.net> (sfid-20121126_184918_475433_6F6C715B)
Subject: Re: Kernel splat from 3.5.7+ (tainted)
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 26 Nov 2012 18:49:20 +0100
In-Reply-To: <50B3A275.3010302@candelatech.com> (sfid-20121126_184257_410312_9D3ECF7B)
References: <50B3A275.3010302@candelatech.com>
	 (sfid-20121126_184257_410312_9D3ECF7B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-26 at 09:10 -0800, Ben Greear wrote:
> This looks like some sort of locking bug...the warning comes from the code
> in softirq.c (below).
...
> Nov 21 19:33:17 localhost kernel: WARNING: at /home/greearb/git/linux-3.5.dev.y/kernel/softirq.c:159 _local_bh_enable_ip+0x41/0x9f()
> Nov 21 19:33:17 localhost kernel: Hardware name: To be filled by O.E.M.
...
> Nov 21 19:33:17 localhost kernel: Pid: 5905, comm: kworker/u:0 Tainted: P           O 3.5.7+ #27
> Nov 21 19:33:17 localhost kernel: Call Trace:
> Nov 21 19:33:17 localhost kernel: <IRQ>  [<ffffffff8105c5cc>] warn_slowpath_common+0x80/0x98
> Nov 21 19:33:17 localhost kernel: [<ffffffff8105c5f9>] warn_slowpath_null+0x15/0x17
> Nov 21 19:33:17 localhost kernel: [<ffffffff81062dfa>] _local_bh_enable_ip+0x41/0x9f
> Nov 21 19:33:17 localhost kernel: [<ffffffff81062e61>] local_bh_enable_ip+0x9/0xb
> Nov 21 19:33:17 localhost kernel: [<ffffffff814e31a6>] _raw_spin_unlock_bh+0x1c/0x1e
> Nov 21 19:33:17 localhost kernel: [<ffffffff8144fee4>] destroy_conntrack+0xbd/0xfc
> Nov 21 19:33:17 localhost kernel: [<ffffffff8144da47>] nf_conntrack_destroy+0x27/0x2e
> Nov 21 19:33:17 localhost kernel: [<ffffffff81422934>] skb_release_head_state+0x9a/0xdc
> Nov 21 19:33:17 localhost kernel: [<ffffffff81422b77>] __kfree_skb+0x11/0x7d
> Nov 21 19:33:17 localhost kernel: [<ffffffff81422c2c>] consume_skb+0x28/0x2a
> Nov 21 19:33:17 localhost kernel: [<ffffffffa01fa2f9>] __ieee80211_tx+0x1f9/0x31a [mac80211]


I think the problem is the dev_kfree_skb(), it should be
dev_kfree_skb_any() in line 1299 in tx.c because ieee80211_tx() calls
__ieee80211_tx() with RCU lock held. It has pretty much done that
forever though, so it's surprising this shows up now? Was that some sort
of special frame?

Note that this is actually fixed in wireless-next.

johannes

