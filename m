Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43771 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783AbXFRI55 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2007 04:57:57 -0400
Subject: Re: iwlwifi - not compatible with xorg 7.1 and i810 ??
From: Zhu Yi <yi.zhu@intel.com>
To: zergavis <zergavis@o2.pl>,
	"John W.Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <93387350.20070610005957@o2.pl>
References: <93387350.20070610005957@o2.pl>
Content-Type: multipart/mixed; boundary="=-h77nhFeN+T2pkuxZwYkH"
Date: Mon, 18 Jun 2007 16:56:03 +0800
Message-Id: <1182156963.4092.98.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-h77nhFeN+T2pkuxZwYkH
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sun, 2007-06-10 at 00:59 +0200, zergavis wrote:
> Hi,
> 
> It's sounds silly, but new iwlwifi-0.0.25 crash down Xorg server. The
> problem is intel i810 video driver.
> 
> In my toshiba A200 I've got intel945GM pci-e video card. It run
> normal on xf-video-i810 driver (kernel support of 945 is experimental)
> on archlinux.
> 
> When I install iwlwifi-0.0.25 (make, make install) for 4965AGN and
> restart xserver, it crash...

The attached patch fixes this problem. Thanks for reporting.

John, can you include this in wireless-dev GIT?

Thanks,
-yi

> Error log:
> 
> (EE) I810(0): V_BIOS Address 0x80 out of range
> (EE) I810(0): VBE initialization failed.
> (EE) Screen(s) found, but none have a usable configuration.
> 
> Fatal server error:
> no screens found
> 
> Now i just go to iwlwifi-0.0.25 and make uninstall. Server restart - and
> xorg run perfectly, but iwl4965 is uninstalled :(
> 
> xorg.conf and other X configuration files or drivers are not changing during
> this process. Only install and uninstall of iwlwifi-0.0.25...
> 
> Is there any known solution to fix this up?
> 
> regards,
> pawel
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-h77nhFeN+T2pkuxZwYkH
Content-Disposition: attachment; filename=iwlwifi-X-fix.patch
Content-Type: text/x-patch; name=iwlwifi-X-fix.patch; charset=GB2312
Content-Transfer-Encoding: 7bit

commit 1ea165c71112f5f973b51378742e8e3204250149
Author: Hong Liu <hong.liu@intel.com>
Date:   Fri Jun 15 14:35:31 2007 +0800

    iwlwifi: Fix X can't start after iwl4965 is loaded
    
    The patch fixed X can't start after iwl4965 is loaded. The ucode will
    use some wrong DMA address when keep_warm area is not setup correctly
    and overwrite the video BIOS area, which made X server fail.
    
    Signed-off-by: Hong Liu <hong.liu@intel.com>
    Signed-off-by: Zhu Yi <yi.zhu@intel.com>

diff --git a/drivers/net/wireless/mac80211/iwlwifi/iwl-4965.c b/drivers/net/wireless/mac80211/iwlwifi/iwl-4965.c
index 20c4c2a..6541bae 100644
--- a/drivers/net/wireless/mac80211/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/mac80211/iwlwifi/iwl-4965.c
@@ -258,15 +258,21 @@ static int iwl4965_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 	return 0;
 }
 
-static void iwl4965_kw_init(struct iwl_priv *priv)
+static int iwl4965_kw_init(struct iwl_priv *priv)
 {
-	return;
-	if (iwl_grab_restricted_access(priv))
-		return;
+	int rc = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	if ((rc = iwl_grab_restricted_access(priv)))
+		goto out;
 
 	iwl_write_restricted(priv, IWL_FH_KW_MEM_ADDR_REG,
 			     (priv->kw.dma_addr >> 4));
 	iwl_release_restricted_access(priv);
+out:
+	spin_unlock_irqrestore(&priv->lock, flags);
+	return rc;
 }
 
 static int iwl4965_kw_alloc(struct iwl_priv *priv)
@@ -329,7 +335,11 @@ static int iwl4965_txq_ctx_reset(struct iwl_priv *priv)
 	iwl_release_restricted_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	iwl4965_kw_init(priv);
+	rc = iwl4965_kw_init(priv);
+	if (rc) {
+		IWL_ERROR("kw_init failed\n");
+		goto error_reset;
+	}
 
 	/* Tx queue(s) */
 	for (txq_id = 0; txq_id < priv->hw_setting.max_queue_number; txq_id++) {

--=-h77nhFeN+T2pkuxZwYkH--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
