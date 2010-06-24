Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:35856 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab0FXRsw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 13:48:52 -0400
Subject: Re: intel 5100/iwlagn bug in 2.6.35-rc2 during large file transfer
From: reinette chatre <reinette.chatre@intel.com>
To: Richard Farina <sidhayn@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4C23961D.7050500@gmail.com>
References: <4C198EF0.5080807@gmail.com>
	 <1277225293.25793.2257.camel@rchatre-DESK>  <4C2383E2.8000909@gmail.com>
	 <1277399636.25793.2389.camel@rchatre-DESK>  <4C23961D.7050500@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 10:48:51 -0700
Message-ID: <1277401731.25793.2391.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-06-24 at 10:30 -0700, Richard Farina wrote:
> There were two compat-wireless releases for 2.6.35_rc2 because Luis had 
> asked me to test and then he changed it for the official release.  I'll 
> use the official 2.6.35_rc2 release for the current testing so if there 
> are any patches you wish to toss my way please base them on that.  The 
> other option is you tell me what to do, I can run any kernel, any git 
> snapshot, whatever you say.  Like I said, all I have to do is download 
> something or transfer something large so it is pretty easily 
> reproducible here so I'll test whatever you like.


Could you please try out this patch? It is based on the latest linux-2.6
so should apply cleanly to your latest 2.6.35 stable compat.

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 0f292a2..028db74 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -613,7 +613,7 @@ void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 		}
 		spin_unlock_irqrestore(&rxq->lock, flags);
 
-		if (rxq->free_count > RX_LOW_WATERMARK)
+		if (rxq->free_count > 8)
 			gfp_mask |= __GFP_NOWARN;
 
 		if (priv->hw_params.rx_page_order > 0)
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 113c366..396a16c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -426,7 +426,7 @@
  * RX related structures and functions
  */
 #define RX_FREE_BUFFERS 64
-#define RX_LOW_WATERMARK 8
+#define RX_LOW_WATERMARK 64
 
 /* Size of one Rx buffer in host DRAM */
 #define IWL_RX_BUF_SIZE_3K (3 * 1000) /* 3945 only */


