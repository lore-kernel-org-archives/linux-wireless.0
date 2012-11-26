Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55608 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab2KZThr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 14:37:47 -0500
Message-ID: <50B3C505.3090407@candelatech.com> (sfid-20121126_203749_718668_14BA1EE4)
Date: Mon, 26 Nov 2012 11:37:41 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Kernel splat from 3.5.7+ (tainted)
References: <50B3A275.3010302@candelatech.com>  <50B3AAEB.3070709@candelatech.com> (sfid-20121126_184631_765629_DC554BCF) <1353952597.2800.12.camel@jlt4.sipsolutions.net>
In-Reply-To: <1353952597.2800.12.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/26/2012 09:56 AM, Johannes Berg wrote:
> On Mon, 2012-11-26 at 09:46 -0800, Ben Greear wrote:
>
>> 0x182f9 is in __ieee80211_tx (/home/greearb/git/linux-3.5.dev.y/net/mac80211/tx.c:1256).
>> 1251					skb_queue_splice_init(skbs, &local->pending[q]);
>> 1252				} else {
>> 1253					u32 len = skb_queue_len(&local->pending[q]);
>> 1254					if (len >= max_pending_qsize) {
>> 1255						__skb_unlink(skb, skbs);
>> 1256						dev_kfree_skb(skb);
>> 1257						/* TODO:  Add counter for this */
>> 1258					} else {
>
> Wait .. this appears to be a local patch you have, it doesn't exist.
> That explains why, the bug doesn't exist upstream (all freeing there is
> outside the queue lock)

Ahh, sorry about that..it is entirely my bug it seems.

I added a patch to keep from queing too many skbs since it can
OOM my system (for instance, when using pktgen to generate traffic,
if I recall correctly).

Probably this bug isn't normally hit even in my code because
we rarely over-drive it like this, and upstream probably never
hits the OOM bug for similar reasons.

In case you are still feeling generous of your time, do you think just
changing the call to dev_kfree_skb_any() and moving it outside
the spin-lock would be a proper fix?

commit 4887df3f5409798f633881df7be6cf7168f78e93
Author: Ben Greear <greearb@candelatech.com>
Date:   Mon Jun 4 17:34:08 2012 -0700

     mac80211: Limit number of pending skbs.

     Current code will allow any number of pending skbs, and
     this can OOM the system when used with something like
     the pktgen tool (which may not back off properly if
     queue is stopped).

     Possibly this is just a bug in our version of pktgen,
     but either way, it seems reasonable to add a limit
     so that it is not possible to go OOM in this manner.

     Signed-off-by: Ben Greear <greearb@candelatech.com>

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d84727a..c5c3b8e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -33,6 +33,17 @@
  #include "wpa.h"
  #include "wme.h"
  #include "rate.h"
+#include <linux/moduleparam.h>
+
+/*
+ * Maximum number of skbs that may be queued in a pending
+ * queue.  After that, packets will just be dropped.
+ */
+static int max_pending_qsize = 1000;
+module_param(max_pending_qsize, int, 0644);
+MODULE_PARM_DESC(max_pending_qsize,
+                "Maximum number of skbs that may be queued in a pending queue.");
+

  /* misc utils */

@@ -1236,12 +1247,19 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
                          * transmission from the tx-pending tasklet when the
                          * queue is woken again.
                          */
-                       if (txpending)
+                       if (txpending) {
                                 skb_queue_splice_init(skbs, &local->pending[q]);
-                       else
-                               skb_queue_splice_tail_init(skbs,
-                                                          &local->pending[q]);
-
+                       } else {
+                               u32 len = skb_queue_len(&local->pending[q]);
+                               if (len >= max_pending_qsize) {
+                                       __skb_unlink(skb, skbs);
+                                       dev_kfree_skb(skb);
+                                       /* TODO:  Add counter for this */
+                               } else {
+                                       skb_queue_splice_tail_init(skbs,
+                                                                  &local->pending[q]);
+                               }
+                       }
                         spin_unlock_irqrestore(&local->queue_stop_reason_lock,
                                                flags);
                         return false;

>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

