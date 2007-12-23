Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:54977 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755602AbXLWELx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 23:11:53 -0500
Date: Sun, 23 Dec 2007 05:08:44 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC PATCH 7/7] mac80211: fix sta_info locking
Message-ID: <20071223050844.4e6b8c13@morte> (sfid-20071223_041209_428557_3362934C)
In-Reply-To: <20071223033633.710907923@polimi.it>
References: <20071223033633.710907923@polimi.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While tinkering with a sta_info refcounting bug in rc80211-pid algorithm, I
discovered that calling sta_info_get() and then sta_info_put() right after
would cause a kernel panic on my uniprocessor, preemptible kernel. I
couldn't set up netconsole, however, most of the trace is reported below
(my camera did its best, as the trace wouldn't fit on the screen and I
couldn't scroll, so wasn't able to see the first part with naked eyes :).

EIP at delay_tsc+0x22/0x50
[couldn't read the EBX and such, but I guess you won't care]
panic+0xf9/0x100
die+0x1e0/0x1f0
do_page_fault+0x357/0x640
autoremove_wake_function+0x1b/0x50
__wake_up_common+0x3e/0x70
do_page_fault+0x0/0x640
error_code+0x6a/0x70
sta_info_get+0x3a/0x60 [mac80211]
__ieee80211_rx+0x290/0x1830 [mac80211]
skb_queue_tail+0x3b/0x70
ieee80211_rx_irqsafe+0x30/0x80 [mac80211]
ssb_pci_write32+0x22/0x70 [ssb]
ieee80211_tasklet_handler+0xaf/0xe0 [mac80211]
hrtimer_run_queues+0xf6/0x1a0
process_timeout+0x0/0x10
tasklet_action+0x27/0x60
__do_softirq+0x54/0xb0
do_softirq+0x7b/0xe0
handle_level_irq+0x0/0x110
irq_exit+0x30/0x40
do_IRQ+0x83/0xd0
common_interrupt+0x23/0x20
[...]

So I guessed that locking was lacking somewhere. The following patch fixes
the issue for me, but I'm not sure at all that it's the right fix. Thanks.

NOT-Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
Index: wireless-2.6/net/mac80211/sta_info.c
===================================================================
--- wireless-2.6.orig/net/mac80211/sta_info.c
+++ wireless-2.6/net/mac80211/sta_info.c
@@ -105,6 +105,7 @@ static void sta_info_release(struct kref
 	struct ieee80211_local *local = sta->local;
 	struct sk_buff *skb;

+	write_lock_bh(&local->sta_lock);
 	/* free sta structure; it has already been removed from
 	 * hash table etc. external structures. Make sure that all
 	 * buffered frames are release (one might have been added
@@ -118,6 +119,8 @@ static void sta_info_release(struct kref
 	}
 	rate_control_free_sta(sta->rate_ctrl, sta->rate_ctrl_priv);
 	rate_control_put(sta->rate_ctrl);
+	write_unlock_bh(&local->sta_lock);
+
 	kfree(sta);
 }

-- 
Ciao
Stefano
