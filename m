Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:55082 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759668Ab3DCLgD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 07:36:03 -0400
Received: from mailout-de.gmx.net ([10.1.76.35]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0LrY9r-1UkyR22yfV-013JtW for
 <linux-wireless@vger.kernel.org>; Wed, 03 Apr 2013 13:36:01 +0200
Date: Wed, 3 Apr 2013 13:35:54 +0200
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: Andreas Fenkart <andreas.fenkart@streamunlimited.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"daniel@zonque.org" <daniel@zonque.org>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: Re: [PATCH 1/6] mwifiex: bug: remove NO_PKT_PRIO_TID.
Message-ID: <20130403113554.GA14785@blumentopf> (sfid-20130403_133608_867817_1ADB1E80)
References: <20130402000511.GA31921@blumentopf>
 <1364861325-30844-1-git-send-email-andreas.fenkart@streamunlimited.com>
 <477F20668A386D41ADCC57781B1F70430D9DDAB197@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9DDAB197@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

On Tue, Apr 02, 2013 at 07:40:53PM -0700, Bing Zhao wrote:
> 
> > Using NO_PKT_PRIO_TID and tx_pkts_queued to check for an empty state, can
> > lead to a contradictory state, resulting in an infinite loop.
> > Currently queueing and dequeuing of packets is not synchronized, and can
> > happen concurrently. While tx_pkts_queued is incremented when adding a
> > packet, max prio is set to NO_PKT when the WMM list is empty. If a packet
> > is added right after the check for empty, but before setting max prio to
> > NO_PKT, that packet is trapped and creates an infinite loop.
> > Because of the new packet, tx_pkts_queued is at least 1, indicating wmm
> > lists are not empty. Opposing that max prio is NO_PKT, which means "skip
> > this wmm queue, it has no packets". The infinite loop results, because the
> > main loop checks the wmm lists for not empty via tx_pkts_queued, but when
> > dequeing uses max_prio to see if it can skip a list. This will never end,
> > unless a new packet is added which will restore max prio to the level of
> > the trapped packet.
> > The solution here is to rely on tx_pkts_queued solely for checking wmm
> > queue to be empty, and drop the NO_PKT define. It does not address the
> > locking issue.
> > 
> > Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
> 
> With this patch (1/6) applied, I'm getting soft-lockup watchdog:
> 
> BUG: soft lockup - CPU#3 stuck for 22s! [kworker/3:1:37]

My bad here, should be like this when patch is applied first:

@@ -919,8 +919,12 @@ mwifiex_wmm_get_highest_priolist_ptr(struct
mwifiex_adapter *adapter,
 
                do {
                        priv_tmp = bssprio_node->priv;
-                       hqp = &priv_tmp->wmm.highest_queued_prio;
 
+                       if (atomic_read(&priv_tmp->wmm.tx_pkts_queued) == 0)
+                               goto skip_bss;
+
+                       /* iterate over the WMM queues of the BSS */
+                       hqp = &priv_tmp->wmm.highest_queued_prio;
                        for (i = atomic_read(hqp); i >= LOW_PRIO_TID; --i) {
 
                                tid_ptr = &(priv_tmp)->wmm.
@@ -980,12 +984,7 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
                                } while (ptr != head);
                        }
 
-                       /* No packet at any TID for this priv. Mark as
                        such
-                        * to skip checking TIDs for this priv (until
                         pkt is
-                        * added).
-                        */
-                       atomic_set(hqp, NO_PKT_PRIO_TID);
-
+skip_bss:
                        /* Get next bss priority node */
                        bssprio_node = list_first_entry(&bssprio_node->list,
                                                struct mwifiex_bss_prio_node,

That said, yes I developed the pathset the other way round. First
cleaned up, until I knew how to fix the bug best. Then pulled the fix
in front of the cleanup patches and -- mea culpa -- didn't test the
patches individually. Sorry again.

Also found issue here, which could be a problem without patch 6/6:

--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -688,13 +688,13 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
        ra_list->total_pkts_size += skb->len;
        ra_list->pkt_count++;
 
-       atomic_inc(&priv->wmm.tx_pkts_queued);
-
        if (atomic_read(&priv->wmm.highest_queued_prio) <
                                                tos_to_tid_inv[tid_down])
                atomic_set(&priv->wmm.highest_queued_prio,
                           tos_to_tid_inv[tid_down]);
 
+       atomic_inc(&priv->wmm.tx_pkts_queued);
+


How should I proceed? Can I reorder patches to match my development
cycle, which is? 2-5;1;6 or more verbosely cleanup first followed
by bug fix and proper locking last

Or should keep the order as is, but fix patch 1, and propagate changes
through patch 2 till 6?

rgds,
Andi
