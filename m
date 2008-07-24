Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:28694 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbYGXNBF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 09:01:05 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1197974ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2008 06:01:04 -0700 (PDT)
Message-ID: <1ba2fa240807240601o2c083347rf5f1b6507e0abe7c@mail.gmail.com> (sfid-20080724_150112_624962_AA2E2115)
Date: Thu, 24 Jul 2008 16:01:03 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"David Miller" <davem@davemloft.net>
Subject: Re: Another fragmentation multiqueue kludge
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Guy Cohen" <guy.cohen@intel.com>,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240807231441u7b870a15rb525771e364f65f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1ba2fa240807231441u7b870a15rb525771e364f65f3@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 24, 2008 at 12:41 AM, Tomas Winkler <tomasw@gmail.com> wrote:
> Here is the scenario. This is happening with what we have in
> wireless-testing code
>
> When hw queue get full we call
>  ieeee80211_stop_queue(dev, q);
>
> When this is happens in the middle of the fragmentation . This is
> easiest to reproduces  with fragmentation but probably happens also in
> other cases.
>
> int __ieee80211_tx()
> ....
>
> if (netif_subqueue_stopped(local->mdev,
>                                                   tx->extra_frag[i]))
>                                return IEEE80211_TX_FRAG_AGAIN;
>
>
> The fragment should  stored into local->queues_pending[queue]
> (Actually I'm not sure it is)
>
> now when we HW queue got cleared a bit we call wake queues where
> tx_pending_tasklet is woken up ( queue is not woken up here)
>
> void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
> {
>        struct ieee80211_local *local = hw_to_local(hw);
>
>        if (test_bit(queue, local->queues_pending)) {
>                tasklet_schedule(&local->tx_pending_tasklet);
>        }
>      ..... <snip>
> }
>
> The check if the queue  is open causes that queue is actually never
> woken up so traffic is stalled. However removing this line causes some
> other panic I didn't have time to process.
>
> void ieee80211_tx_pending(unsigned long data)
> {
> <snip>
>
>        netif_tx_lock_bh(dev);
>        for (i = 0; i < ieee80211_num_regular_queues(&local->hw); i++) {
>                /* Check that this queue is ok */
>                if (__netif_subqueue_stopped(local->mdev, i))
> --- This line causes that fact that the actual wake queue is never
> called.
>                        continue;
>
>                if (!test_bit(i, local->queues_pending)) {
>                        ieee80211_wake_queue(&local->hw, i);
>                        continue;
>                }
> </snip>



This patch solves the problem. Just I'm not sure about not locking a cross
   netif_start_subqueue(local->mdev, queue);
pending assumes that no new packets are to be transmitted before
pending packets are cleared out.


This patch make mac80211 transmit correctly fragmented packet after
stopping queues.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/tx.c   |    8 +++++---
 net/mac80211/util.c |    7 +++++++
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2b912cf..db6540e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1061,13 +1061,15 @@ static int ieee80211_tx_prepare(struct
ieee80211_tx_data *tx,
 static int __ieee80211_tx(struct ieee80211_local *local, struct sk_buff *skb,
                          struct ieee80211_tx_data *tx)
 {
-       struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+       struct ieee80211_tx_info *info;
        int ret, i;

-       if (netif_subqueue_stopped(local->mdev, skb))
-               return IEEE80211_TX_AGAIN;

        if (skb) {
+               if (netif_subqueue_stopped(local->mdev, skb))
+                       return IEEE80211_TX_AGAIN;
+               info = IEEE80211_SKB_CB(skb);
+
                ieee80211_dump_frame(wiphy_name(local->hw.wiphy),
                                     "TX to low-level driver", skb);
                ret = local->ops->tx(local_to_hw(local), skb);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 89ce4e0..8028744 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -361,6 +361,13 @@ void ieee80211_wake_queue(struct ieee80211_hw
*hw, int queue)
        struct ieee80211_local *local = hw_to_local(hw);

        if (test_bit(queue, local->queues_pending)) {
+               /* don't call scheduler just open the queue */
+               if (ieee80211_is_multiqueue(local)) {
+                       netif_start_subqueue(local->mdev, queue);
+               } else {
+                       WARN_ON(queue != 0);
+                       netif_start_queue(local->mdev);
+               }
                tasklet_schedule(&local->tx_pending_tasklet);
        } else {
                if (ieee80211_is_multiqueue(local)) {




Tomas
