Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3123 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792AbYICHJc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 03:09:32 -0400
Subject: Re: kernel crash during suspend using iwl3945 driver 1.2.26k on
	ubuntu hardy
From: Zhu Yi <yi.zhu@intel.com>
To: Karol Szkudlarek <karol@mikronika.com.pl>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <48BC47C5.2070807@mikronika.com.pl>
References: <48BC47C5.2070807@mikronika.com.pl>
Content-Type: multipart/mixed; boundary="=-l7FOLB2ef6/FSzZE/0do"
Date: Wed, 03 Sep 2008 15:06:38 +0800
Message-Id: <1220425598.28282.190.camel@debian.sh.intel.com> (sfid-20080903_090944_961017_C9158D0A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-l7FOLB2ef6/FSzZE/0do
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2008-09-01 at 21:51 +0200, Karol Szkudlarek wrote:
> I'm using Ubuntu 8.04 with compiled 1.2.26k linux wireless driver for 
> iwl3945 network card on my hp6710b laptop.
> Script during suspend trying to remove the iwl3945 module and I
> receive kernel crash.
> This is repeatable. I attached screenshot of kernel stack. Has
> somebody of iwl3945 developers can look on it?

Please try attached patch.

Thanks,
-yi

--=-l7FOLB2ef6/FSzZE/0do
Content-Disposition: attachment; filename=iwl3945_remove.patch
Content-Type: text/x-patch; name=iwl3945_remove.patch; charset=GB2312
Content-Transfer-Encoding: 7bit

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 53e234d..e312e93 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -8117,9 +8117,15 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 
 	IWL_DEBUG_INFO("*** UNLOAD DRIVER ***\n");
 
+	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);
+
 	set_bit(STATUS_EXIT_PENDING, &priv->status);
 
-	iwl3945_down(priv);
+	if (priv->mac80211_registered) {
+		ieee80211_unregister_hw(priv->hw);
+		priv->mac80211_registered = 0;
+	} else
+		iwl3945_down(priv);
 
 	/* make sure we flush any pending irq or
 	 * tasklet for the driver
@@ -8130,8 +8136,6 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 
 	iwl_synchronize_irq(priv);
 
-	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);
-
 	iwl3945_rfkill_unregister(priv);
 	iwl3945_dealloc_ucode_pci(priv);
 
@@ -8142,9 +8146,6 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 	iwl3945_unset_hw_setting(priv);
 	iwl3945_clear_stations_table(priv);
 
-	if (priv->mac80211_registered)
-		ieee80211_unregister_hw(priv->hw);
-
 	/*netif_stop_queue(dev); */
 	flush_workqueue(priv->workqueue);
 

--=-l7FOLB2ef6/FSzZE/0do--

