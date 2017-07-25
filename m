Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:35951 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756640AbdGYBON (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 21:14:13 -0400
Received: by mail-pf0-f169.google.com with SMTP id z129so13493244pfb.3
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2017 18:14:12 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v2 01/20] mwifiex: reunite copy-and-pasted remove/reset code
Date: Mon, 24 Jul 2017 18:13:17 -0700
Message-Id: <20170725011336.99993-2-briannorris@chromium.org> (sfid-20170725_031512_632884_CA8575E0)
In-Reply-To: <20170725011336.99993-1-briannorris@chromium.org>
References: <20170725011336.99993-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When PCIe FLR code was added, it explicitly copy-and-pasted much of
mwifiex_remove_card() into mwifiex_shutdown_sw(). This is unnecessary,
as almost all of the code should be reused.

Let's reunite what we can for now.

The only functional changes for now:

 * call netif_device_detach() in the remove() code path -- this wasn't
   done before, but it really should be a no-op, when the device is
   getting totally unregistered soon anyway

 * call the ->down_dev() driver callback only after we've finished all
   SW teardown -- this should have no significant effect, since the only
   user (pcie.c) does very minimal work there, and it doesn't matter
   that we reorder this

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
v2: no change
---
 drivers/net/wireless/marvell/mwifiex/main.c | 104 ++++++++--------------------
 1 file changed, 28 insertions(+), 76 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index f2600b827e81..8615099468da 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1352,26 +1352,12 @@ static void mwifiex_main_work_queue(struct work_struct *work)
 	mwifiex_main_process(adapter);
 }
 
-/*
- * This function gets called during PCIe function level reset. Required
- * code is extracted from mwifiex_remove_card()
- */
-int
-mwifiex_shutdown_sw(struct mwifiex_adapter *adapter)
+/* Common teardown code used for both device removal and reset */
+static void mwifiex_uninit_sw(struct mwifiex_adapter *adapter)
 {
 	struct mwifiex_private *priv;
 	int i;
 
-	if (!adapter)
-		goto exit_return;
-
-	wait_for_completion(adapter->fw_done);
-	/* Caller should ensure we aren't suspending while this happens */
-	reinit_completion(adapter->fw_done);
-
-	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
-	mwifiex_deauthenticate(priv, NULL);
-
 	/* We can no longer handle interrupts once we start doing the teardown
 	 * below.
 	 */
@@ -1393,12 +1379,9 @@ mwifiex_shutdown_sw(struct mwifiex_adapter *adapter)
 	}
 
 	mwifiex_dbg(adapter, CMD, "cmd: calling mwifiex_shutdown_drv...\n");
-
 	mwifiex_shutdown_drv(adapter);
-	if (adapter->if_ops.down_dev)
-		adapter->if_ops.down_dev(adapter);
-
 	mwifiex_dbg(adapter, CMD, "cmd: mwifiex_shutdown_drv done\n");
+
 	if (atomic_read(&adapter->rx_pending) ||
 	    atomic_read(&adapter->tx_pending) ||
 	    atomic_read(&adapter->cmd_pending)) {
@@ -1421,9 +1404,30 @@ mwifiex_shutdown_sw(struct mwifiex_adapter *adapter)
 		rtnl_unlock();
 	}
 	vfree(adapter->chan_stats);
+}
+
+/*
+ * This function gets called during PCIe function level reset.
+ */
+int mwifiex_shutdown_sw(struct mwifiex_adapter *adapter)
+{
+	struct mwifiex_private *priv;
+
+	if (!adapter)
+		return 0;
+
+	wait_for_completion(adapter->fw_done);
+	/* Caller should ensure we aren't suspending while this happens */
+	reinit_completion(adapter->fw_done);
+
+	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
+	mwifiex_deauthenticate(priv, NULL);
+
+	mwifiex_uninit_sw(adapter);
+
+	if (adapter->if_ops.down_dev)
+		adapter->if_ops.down_dev(adapter);
 
-	mwifiex_dbg(adapter, INFO, "%s, successful\n", __func__);
-exit_return:
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mwifiex_shutdown_sw);
@@ -1676,61 +1680,10 @@ EXPORT_SYMBOL_GPL(mwifiex_add_card);
  */
 int mwifiex_remove_card(struct mwifiex_adapter *adapter)
 {
-	struct mwifiex_private *priv = NULL;
-	int i;
-
 	if (!adapter)
-		goto exit_remove;
-
-	/* We can no longer handle interrupts once we start doing the teardown
-	 * below. */
-	if (adapter->if_ops.disable_int)
-		adapter->if_ops.disable_int(adapter);
-
-	adapter->surprise_removed = true;
-
-	mwifiex_terminate_workqueue(adapter);
-
-	/* Stop data */
-	for (i = 0; i < adapter->priv_num; i++) {
-		priv = adapter->priv[i];
-		if (priv && priv->netdev) {
-			mwifiex_stop_net_dev_queue(priv->netdev, adapter);
-			if (netif_carrier_ok(priv->netdev))
-				netif_carrier_off(priv->netdev);
-		}
-	}
-
-	mwifiex_dbg(adapter, CMD,
-		    "cmd: calling mwifiex_shutdown_drv...\n");
-
-	mwifiex_shutdown_drv(adapter);
-	mwifiex_dbg(adapter, CMD,
-		    "cmd: mwifiex_shutdown_drv done\n");
-	if (atomic_read(&adapter->rx_pending) ||
-	    atomic_read(&adapter->tx_pending) ||
-	    atomic_read(&adapter->cmd_pending)) {
-		mwifiex_dbg(adapter, ERROR,
-			    "rx_pending=%d, tx_pending=%d,\t"
-			    "cmd_pending=%d\n",
-			    atomic_read(&adapter->rx_pending),
-			    atomic_read(&adapter->tx_pending),
-			    atomic_read(&adapter->cmd_pending));
-	}
-
-	for (i = 0; i < adapter->priv_num; i++) {
-		priv = adapter->priv[i];
-
-		if (!priv)
-			continue;
+		return 0;
 
-		rtnl_lock();
-		if (priv->netdev &&
-		    priv->wdev.iftype != NL80211_IFTYPE_UNSPECIFIED)
-			mwifiex_del_virtual_intf(adapter->wiphy, &priv->wdev);
-		rtnl_unlock();
-	}
-	vfree(adapter->chan_stats);
+	mwifiex_uninit_sw(adapter);
 
 	wiphy_unregister(adapter->wiphy);
 	wiphy_free(adapter->wiphy);
@@ -1748,7 +1701,6 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter)
 		    "info: free adapter\n");
 	mwifiex_free_adapter(adapter);
 
-exit_remove:
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mwifiex_remove_card);
-- 
2.14.0.rc0.284.gd933b75aa4-goog
