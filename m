Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tjworld.net ([67.18.187.6]:52104 "EHLO tjworld.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755263AbZCXPyU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 11:54:20 -0400
Subject: iwl3945: Don't queue rfkill_poll work when module is exiting
From: TJ <ubuntu@tjworld.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Tue, 24 Mar 2009 15:44:19 +0000
Message-Id: <1237909459.5365.16.camel@hephaestion> (sfid-20090324_165424_122966_556E28B8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tim Gardner suggested I forward this as a possible stable-release
update. I found the problem in our current Ubuntu Jaunty tree - iwlwifi
version 1.2.26k. What follows is a copy of the patch for Jaunty
(2.6.28).

----------
Bug: #345710

When the wireless interface is active and the iwl3945 module is unloaded the
call to ieee80211_unregister_hw() would call iwl3945_mac_stop() which would
restart the delayed workqueue for rfkill_poll. That workqueue had already been
cancelled so when the next work item was run (2 seconds later) the system would
suffer a hard lock-up because the module had been unloaded by then.

This patch implements STATUS_EXIT_PENDING checks in places where the rfkill_poll
work is scheduled, and moves the final workqueue cancellation to occur after the
call to ieee80211_unregister_hw().

Bug discovered, experienced and fix tested on my PC.

Signed-off-by: TJ <ubuntu@tjworld.net>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index bb92db2..acaf038 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6062,7 +6062,9 @@ static void iwl3945_rfkill_poll(struct work_struct *data)
 	if (test_bit(STATUS_RF_KILL_HW, &status) != test_bit(STATUS_RF_KILL_HW, &priv->status))
 	   queue_work(priv->workqueue, &priv->rf_kill);
 
-	queue_delayed_work(priv->workqueue, &priv->rfkill_poll,
+	/* only queue if module isn't exiting */
+	if (! test_bit(STATUS_EXIT_PENDING, &priv->status))
+		queue_delayed_work(priv->workqueue, &priv->rfkill_poll,
 						   round_jiffies_relative(2 * HZ));
 
 }
@@ -6588,7 +6590,10 @@ static void iwl3945_mac_stop(struct ieee80211_hw *hw)
 	flush_workqueue(priv->workqueue);
 
 	/* start polling the killswitch state again */
-	queue_delayed_work(priv->workqueue, &priv->rfkill_poll,
+
+	/* only queue if module isn't exiting */
+	if (! test_bit(STATUS_EXIT_PENDING, &priv->status))
+		queue_delayed_work(priv->workqueue, &priv->rfkill_poll,
 						   round_jiffies_relative(2 * HZ));
 
 	IWL_DEBUG_MAC80211("leave\n");
@@ -8166,7 +8171,6 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);
 
 	iwl3945_rfkill_unregister(priv);
-	cancel_delayed_work(&priv->rfkill_poll);
 	iwl3945_dealloc_ucode_pci(priv);
 
 	if (priv->rxq.bd)
@@ -8182,6 +8186,12 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 	/*netif_stop_queue(dev); */
 	flush_workqueue(priv->workqueue);
 
+	/* ieee80211_unregister_hw calls iwl3945_mac_stop which used to restart the rfkill
+	   polling. Although that now checks STATUS_EXIT_PENDING do cancel and wait for any
+	   pending work to complete */
+	cancel_delayed_work(&priv->rfkill_poll);
+	cancel_work_sync(&priv->rfkill_poll);
+
 	/* ieee80211_unregister_hw calls iwl3945_mac_stop, which flushes
 	 * priv->workqueue... so we can't take down the workqueue
 	 * until now... */
-- 
1.6.0.4

