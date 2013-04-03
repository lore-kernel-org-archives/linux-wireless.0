Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:52141 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759936Ab3DCSig convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 14:38:36 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"daniel@zonque.org" <daniel@zonque.org>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>
Date: Wed, 3 Apr 2013 11:37:43 -0700
Subject: RE: [PATCH 1/6] mwifiex: bug: remove NO_PKT_PRIO_TID.
Message-ID: <477F20668A386D41ADCC57781B1F70430D9DDAB35D@SC-VEXCH1.marvell.com> (sfid-20130403_203843_405820_3186135A)
References: <20130402000511.GA31921@blumentopf>
 <1364861325-30844-1-git-send-email-andreas.fenkart@streamunlimited.com>
 <477F20668A386D41ADCC57781B1F70430D9DDAB197@SC-VEXCH1.marvell.com>
 <20130403113554.GA14785@blumentopf>
In-Reply-To: <20130403113554.GA14785@blumentopf>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andi,

> > With this patch (1/6) applied, I'm getting soft-lockup watchdog:
> >
> > BUG: soft lockup - CPU#3 stuck for 22s! [kworker/3:1:37]
> 
> My bad here, should be like this when patch is applied first:
> 
> @@ -919,8 +919,12 @@ mwifiex_wmm_get_highest_priolist_ptr(struct
> mwifiex_adapter *adapter,
> 
>                 do {
>                         priv_tmp = bssprio_node->priv;
> -                       hqp = &priv_tmp->wmm.highest_queued_prio;
> 
> +                       if (atomic_read(&priv_tmp->wmm.tx_pkts_queued) == 0)
> +                               goto skip_bss;
> +
> +                       /* iterate over the WMM queues of the BSS */
> +                       hqp = &priv_tmp->wmm.highest_queued_prio;
>                         for (i = atomic_read(hqp); i >= LOW_PRIO_TID; --i) {
> 
>                                 tid_ptr = &(priv_tmp)->wmm.
> @@ -980,12 +984,7 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
>                                 } while (ptr != head);
>                         }
> 
> -                       /* No packet at any TID for this priv. Mark as
>                         such
> -                        * to skip checking TIDs for this priv (until
>                          pkt is
> -                        * added).
> -                        */
> -                       atomic_set(hqp, NO_PKT_PRIO_TID);
> -
> +skip_bss:
>                         /* Get next bss priority node */
>                         bssprio_node = list_first_entry(&bssprio_node->list,
>                                                 struct mwifiex_bss_prio_node,

Thanks for looking into it. This change fixes the soft-lockup.

> 
> That said, yes I developed the pathset the other way round. First
> cleaned up, until I knew how to fix the bug best. Then pulled the fix
> in front of the cleanup patches and -- mea culpa -- didn't test the
> patches individually. Sorry again.
> 
> Also found issue here, which could be a problem without patch 6/6:
> 
> --- a/drivers/net/wireless/mwifiex/wmm.c
> +++ b/drivers/net/wireless/mwifiex/wmm.c
> @@ -688,13 +688,13 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
>         ra_list->total_pkts_size += skb->len;
>         ra_list->pkt_count++;
> 
> -       atomic_inc(&priv->wmm.tx_pkts_queued);
> -
>         if (atomic_read(&priv->wmm.highest_queued_prio) <
>                                                 tos_to_tid_inv[tid_down])
>                 atomic_set(&priv->wmm.highest_queued_prio,
>                            tos_to_tid_inv[tid_down]);
> 
> +       atomic_inc(&priv->wmm.tx_pkts_queued);
> +
> 
> 
> How should I proceed? Can I reorder patches to match my development
> cycle, which is? 2-5;1;6 or more verbosely cleanup first followed
> by bug fix and proper locking last

You can separate 6 patches into two patch sets.
1-3 fix the bug and clean up.
4-6 implement ra list rotation and proper locking.

We will run stress tests against 4-6.

Thanks,
Bing

> 
> Or should keep the order as is, but fix patch 1, and propagate changes
> through patch 2 till 6?

