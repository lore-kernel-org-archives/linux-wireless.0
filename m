Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:30008 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZH1Xce (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 19:32:34 -0400
Received: by fg-out-1718.google.com with SMTP id 22so118455fge.1
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2009 16:32:35 -0700 (PDT)
MIME-Version: 1.0
From: Davide Pesavento <davidepesa@gmail.com>
Date: Sat, 29 Aug 2009 01:32:15 +0200
Message-ID: <2da21fe50908281632v189b0eaq359383c5237748a1@mail.gmail.com>
Subject: 2.6.31-rc8-wl-34750-gd2c67e1 suspected memory leaks
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

with latest wireless-testing I'm seeing the following kmemleak's warnings.

unreferenced object 0xffff88007cb8cbd0 (size 96):
  comm "softirq", pid 0, jiffies 4294914587
  backtrace:
    [<ffffffff810e312c>] create_object+0x14c/0x2f0
    [<ffffffff810e3425>] kmemleak_alloc+0x35/0x80
    [<ffffffff810dd904>] kmem_cache_alloc+0xc4/0x150
    [<ffffffffa01c77eb>] 0xffffffffa01c77eb
    [<ffffffffa01c1616>] 0xffffffffa01c1616
    [<ffffffffa0156f43>] __ieee80211_tx+0x123/0x1c0 [mac80211]
    [<ffffffffa0157fef>] ieee80211_tx+0xef/0x2a0 [mac80211]
    [<ffffffffa0158287>] ieee80211_xmit+0xe7/0x280 [mac80211]
    [<ffffffffa015847f>] ieee80211_tx_skb+0x5f/0x90 [mac80211]
    [<ffffffffa015b164>] ieee80211_send_auth+0x164/0x1f0 [mac80211]
    [<ffffffffa014b1b6>] ieee80211_authenticate+0xf6/0x130 [mac80211]
    [<ffffffffa014bf1a>] ieee80211_rx_mgmt_probe_resp+0x1da/0x200 [mac80211]
    [<ffffffffa014cd95>] ieee80211_sta_work+0x9a5/0x1100 [mac80211]
    [<ffffffff81067478>] worker_thread+0x1c8/0x350
    [<ffffffff8106d066>] kthread+0xb6/0xc0
    [<ffffffff8100d35a>] child_rip+0xa/0x20
unreferenced object 0xffff88007cb8cd20 (size 96):
  comm "softirq", pid 0, jiffies 4294914588
  backtrace:
    [<ffffffff810e312c>] create_object+0x14c/0x2f0
    [<ffffffff810e3425>] kmemleak_alloc+0x35/0x80
    [<ffffffff810dd904>] kmem_cache_alloc+0xc4/0x150
    [<ffffffffa01c77eb>] 0xffffffffa01c77eb
    [<ffffffffa01c1616>] 0xffffffffa01c1616
    [<ffffffffa0156f43>] __ieee80211_tx+0x123/0x1c0 [mac80211]
    [<ffffffffa0157fef>] ieee80211_tx+0xef/0x2a0 [mac80211]
    [<ffffffffa0158287>] ieee80211_xmit+0xe7/0x280 [mac80211]
    [<ffffffffa015847f>] ieee80211_tx_skb+0x5f/0x90 [mac80211]
    [<ffffffffa014cb13>] ieee80211_sta_work+0x723/0x1100 [mac80211]
    [<ffffffff81067478>] worker_thread+0x1c8/0x350
    [<ffffffff8106d066>] kthread+0xb6/0xc0
    [<ffffffff8100d35a>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800625d6c78 (size 96):
  comm "softirq", pid 0, jiffies 4295666572
  backtrace:
    [<ffffffff810e312c>] create_object+0x14c/0x2f0
    [<ffffffff810e3425>] kmemleak_alloc+0x35/0x80
    [<ffffffff810dd904>] kmem_cache_alloc+0xc4/0x150
    [<ffffffffa01c77eb>] 0xffffffffa01c77eb
    [<ffffffffa01c1616>] 0xffffffffa01c1616
    [<ffffffffa0156f43>] __ieee80211_tx+0x123/0x1c0 [mac80211]
    [<ffffffffa0157fef>] ieee80211_tx+0xef/0x2a0 [mac80211]
    [<ffffffffa0158287>] ieee80211_xmit+0xe7/0x280 [mac80211]
    [<ffffffffa015847f>] ieee80211_tx_skb+0x5f/0x90 [mac80211]
    [<ffffffffa014918b>] ieee80211_send_deauth_disassoc+0x12b/0x190 [mac80211]
    [<ffffffffa014d25f>] ieee80211_sta_work+0xe6f/0x1100 [mac80211]
    [<ffffffff81067478>] worker_thread+0x1c8/0x350
    [<ffffffff8106d066>] kthread+0xb6/0xc0
    [<ffffffff8100d35a>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88007e5de110 (size 64):
  comm "events/1", pid 11, jiffies 4295690130
  backtrace:
    [<ffffffff810e312c>] create_object+0x14c/0x2f0
    [<ffffffff810e3425>] kmemleak_alloc+0x35/0x80
    [<ffffffff810de1b2>] __kmalloc+0x122/0x1b0
    [<ffffffffa00a8739>] reg_copy_regd+0x39/0xc0 [cfg80211]
    [<ffffffffa00a8c5c>] reg_todo+0x49c/0x5f0 [cfg80211]
    [<ffffffff81067478>] worker_thread+0x1c8/0x350
    [<ffffffff8106d066>] kthread+0xb6/0xc0
    [<ffffffff8100d35a>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800625d6bd0 (size 96):
  comm "softirq", pid 0, jiffies 4295700338
  backtrace:
    [<ffffffff810e312c>] create_object+0x14c/0x2f0
    [<ffffffff810e3425>] kmemleak_alloc+0x35/0x80
    [<ffffffff810dd904>] kmem_cache_alloc+0xc4/0x150
    [<ffffffffa03227eb>] ath_tx_start+0xbb/0x8b0 [ath9k]
    [<ffffffffa031c616>] ath9k_tx+0x156/0x2b0 [ath9k]
    [<ffffffffa0156f43>] __ieee80211_tx+0x123/0x1c0 [mac80211]
    [<ffffffffa0157fef>] ieee80211_tx+0xef/0x2a0 [mac80211]
    [<ffffffffa0158287>] ieee80211_xmit+0xe7/0x280 [mac80211]
    [<ffffffffa015847f>] ieee80211_tx_skb+0x5f/0x90 [mac80211]
    [<ffffffffa015b164>] ieee80211_send_auth+0x164/0x1f0 [mac80211]
    [<ffffffffa014b1b6>] ieee80211_authenticate+0xf6/0x130 [mac80211]
    [<ffffffffa014bf1a>] ieee80211_rx_mgmt_probe_resp+0x1da/0x200 [mac80211]
    [<ffffffffa014cd95>] ieee80211_sta_work+0x9a5/0x1100 [mac80211]
    [<ffffffff81067478>] worker_thread+0x1c8/0x350
    [<ffffffff8106d066>] kthread+0xb6/0xc0
    [<ffffffff8100d35a>] child_rip+0xa/0x20
unreferenced object 0xffff8800625d6888 (size 96):
  comm "softirq", pid 0, jiffies 4295700339
  backtrace:
    [<ffffffff810e312c>] create_object+0x14c/0x2f0
    [<ffffffff810e3425>] kmemleak_alloc+0x35/0x80
    [<ffffffff810dd904>] kmem_cache_alloc+0xc4/0x150
    [<ffffffffa03227eb>] ath_tx_start+0xbb/0x8b0 [ath9k]
    [<ffffffffa031c616>] ath9k_tx+0x156/0x2b0 [ath9k]
    [<ffffffffa0156f43>] __ieee80211_tx+0x123/0x1c0 [mac80211]
    [<ffffffffa0157fef>] ieee80211_tx+0xef/0x2a0 [mac80211]
    [<ffffffffa0158287>] ieee80211_xmit+0xe7/0x280 [mac80211]
    [<ffffffffa015847f>] ieee80211_tx_skb+0x5f/0x90 [mac80211]
    [<ffffffffa014cb13>] ieee80211_sta_work+0x723/0x1100 [mac80211]
    [<ffffffff81067478>] worker_thread+0x1c8/0x350
    [<ffffffff8106d066>] kthread+0xb6/0xc0
    [<ffffffff8100d35a>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff


Regards,
Davide
