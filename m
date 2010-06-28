Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48413 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062Ab0F1Ujd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jun 2010 16:39:33 -0400
Subject: Re: intel 5100/iwlagn bug in 2.6.35-rc2 during large file transfer
From: reinette chatre <reinette.chatre@intel.com>
To: Richard Farina <sidhayn@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4C28D552.30000@gmail.com>
References: <4C198EF0.5080807@gmail.com>
	 <1277225293.25793.2257.camel@rchatre-DESK>  <4C2383E2.8000909@gmail.com>
	 <1277399636.25793.2389.camel@rchatre-DESK>  <4C23961D.7050500@gmail.com>
	 <1277401731.25793.2391.camel@rchatre-DESK>  <4C24D926.7010806@gmail.com>
	 <1277492229.13673.1297.camel@rchatre-DESK>  <4C278704.5040604@gmail.com>
	 <1277742425.13673.1376.camel@rchatre-DESK>  <4C28D552.30000@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Jun 2010 13:39:23 -0700
Message-ID: <1277757563.4197.11.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-06-28 at 10:01 -0700, Richard Farina wrote:
> reinette chatre wrote:
> > On Sun, 2010-06-27 at 10:14 -0700, Richard Farina wrote:
> >   
> >>> ---
> >>>  drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    5 +++--
> >>>  drivers/net/wireless/iwlwifi/iwl-fh.h      |    2 +-
> >>>  2 files changed, 4 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> >>> index 0f292a2..2815ee7 100644
> >>> --- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> >>> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> >>> @@ -613,7 +613,8 @@ void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
> >>>               }
> >>>               spin_unlock_irqrestore(&rxq->lock, flags);
> >>>
> >>> -             if (rxq->free_count > RX_LOW_WATERMARK)
> >>> +             if ((priority == GFP_ATOMIC) ||
> >>> +                 (rxq->free_count > RX_LOW_WATERMARK / 4))
> >>>                       gfp_mask |= __GFP_NOWARN;
> >>>
> >>>       
> >
> > Here I set the allocation mask to not print _any_ warnings when
> > allocation is atomic ...
> >
> >
> >   
> >> [180257.090410] swapper: page allocation failure. order:1, mode:0x4020
> >> [180257.090414] Pid: 0, comm: swapper Not tainted 2.6.34-pentoo-r2 #2
> >> [180257.090416] Call Trace:
> >>     
> >
> > ... clearly this is an allocation warning ...
> >
> >   
> >> [180257.090418]  <IRQ>  [<ffffffff810984c0>]
> >> __alloc_pages_nodemask+0x571/0x5b9
> >> [180257.090437]  [<ffffffffa05162f3>] iwlagn_rx_allocate+0x98/0x2e0 [iwlagn]
> >> [180257.090445]  [<ffffffffa051668c>] iwlagn_rx_replenish_now+0x16/0x23
> >> [iwlagn]
> >>     
> >
> > ... but it is an atomic one, which after the patch should not be
> > printing _any_ warning ...
> >
> >   
> I dunno, I really don't. but I did just verify the patch and it is 
> correct and applied.

Could you please verify that it is the patch below and not an earlier
patch I sent? Apart from what I mention above there is another strange
thing in the logs you provide. In your logs you have the message:

iwlagn 0000:02:00.0: Failed to alloc_pages with
GFP_ATOMIC. Only 40 free buffers remaining.

while the code is:

»-------»-------»-------if ((rxq->free_count <= RX_LOW_WATERMARK / 4) &&
»-------»-------»-------    net_ratelimit())
»-------»-------»-------»-------IWL_CRIT(priv, "Failed to alloc_pages with %s. Only %u free buffers remaining.\n",
»-------»-------»-------»-------»------- priority == GFP_ATOMIC ?  "GFP_ATOMIC" : "GFP_KERNEL",
»-------»-------»-------»-------»------- rxq->free_count);

with :
#define RX_LOW_WATERMARK 128

The message in your log should thus not be there since it should only
print the message if the free_count less than or equal to 32.

>From 65c459c35332c7039cc84a980e6e04118ba81c04 Mon Sep 17 00:00:00 2001
From: Reinette Chatre <reinette.chatre@intel.com>
Date: Thu, 24 Jun 2010 10:48:59 -0700
Subject: [PATCH] increase low watermark

---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    5 +++--
 drivers/net/wireless/iwlwifi/iwl-fh.h      |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 0f292a2..2815ee7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -613,7 +613,8 @@ void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 		}
 		spin_unlock_irqrestore(&rxq->lock, flags);
 
-		if (rxq->free_count > RX_LOW_WATERMARK)
+		if ((priority == GFP_ATOMIC) ||
+		    (rxq->free_count > RX_LOW_WATERMARK / 4))
 			gfp_mask |= __GFP_NOWARN;
 
 		if (priv->hw_params.rx_page_order > 0)
@@ -627,7 +628,7 @@ void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 					       "order: %d\n",
 					       priv->hw_params.rx_page_order);
 
-			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
+			if ((rxq->free_count <= RX_LOW_WATERMARK / 4) &&
 			    net_ratelimit())
 				IWL_CRIT(priv, "Failed to alloc_pages with %s. Only %u free buffers remaining.\n",
 					 priority == GFP_ATOMIC ?  "GFP_ATOMIC" : "GFP_KERNEL",
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 113c366..431bc58 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -426,7 +426,7 @@
  * RX related structures and functions
  */
 #define RX_FREE_BUFFERS 64
-#define RX_LOW_WATERMARK 8
+#define RX_LOW_WATERMARK 128
 
 /* Size of one Rx buffer in host DRAM */
 #define IWL_RX_BUF_SIZE_3K (3 * 1000) /* 3945 only */
-- 
1.7.0.4





