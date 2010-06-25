Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64952 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab0FYS5K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 14:57:10 -0400
Subject: Re: intel 5100/iwlagn bug in 2.6.35-rc2 during large file transfer
From: reinette chatre <reinette.chatre@intel.com>
To: Richard Farina <sidhayn@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4C24D926.7010806@gmail.com>
References: <4C198EF0.5080807@gmail.com>
	 <1277225293.25793.2257.camel@rchatre-DESK>  <4C2383E2.8000909@gmail.com>
	 <1277399636.25793.2389.camel@rchatre-DESK>  <4C23961D.7050500@gmail.com>
	 <1277401731.25793.2391.camel@rchatre-DESK>  <4C24D926.7010806@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Jun 2010 11:57:09 -0700
Message-ID: <1277492229.13673.1297.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-06-25 at 09:28 -0700, Richard Farina wrote:
> reinette chatre wrote:
> > On Thu, 2010-06-24 at 10:30 -0700, Richard Farina wrote:

> I've added this patch to my system.  I'm about 5GB into a download right
> now and here are the issues. First, and relatively quickly this line
> showed up in dmesg:
> [ 1589.605470] CE: hpet increased min_delta_ns to 7500 nsec

I googled a bit for this string and found a few mentions where it is
connected to system hangs. I do not know if you are running into the
same issue as these people (did not spend much time reading through all
the bug reports), but I did notice that sometimes the people were able
to work around the issue by booting with a different clock source (eg.
clocksource=jiffies) or disabling hpet (eg. hpet=disable). I am very
unfamiliar with this aspect so if this is giving you issues I'd propose
you go to lkml or kernel.org bugzilla.

> I've been carefully monitoring my system and I have loads of RAM spare.
> Things have been much smoother but the system still freezes up for a few
> seconds at a time. Mind you, this is an improvement as the freezes are
> slightly less frequent and before the patch the freezes were hitting the
> 120s hangcheck timer in the kernel and now they last like 20-60 seconds.
> 
> I finally managed to trigger the oops again but it does seem that it
> took much longer this time. Pasted at the bottom. (please note the
> timestamps included are accurate to show the time difference bettween
> the hpet warning and the oops).

They seem pretty far apart so may not be related ...

> 
> What else can I do to provide useful information? Or do you just want to
> update the thresholds again?

Sure ... let's try that. Patch is below. I also made things less noisy
when it does fail in atomic.

> 
> Thanks,
> Rick Farina
> 
> PS> The patch does look at bit odd as you change RX_LOW_WATERMARK while
> at the same time removing one of the places that uses it.  I'm sure that
> is on purpose just seems odd to me as I don't understand.

That was on purpose. Since I increased the watermark I did not want to
increase the threshold used to print warnings to the user also. That is
why I just made that a hard 8 so that if memory allocation fails we will
only start seeing the dumps when we are down to 8 buffers and not the
new high watermark.


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




