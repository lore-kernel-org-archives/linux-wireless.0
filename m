Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57149 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab1JRIH6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 04:07:58 -0400
Subject: [PATCH] compat-wireless: add iwlwifi RCU compat
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 10:07:52 +0200
Message-ID: <1318925272.3958.5.camel@jlt3.sipsolutions.net> (sfid-20111018_100806_415009_C55DA618)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We need to patch the new kfree_rcu() reference in
iwlwifi out and add rcu_barrier() to make it safe.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Obviously the patch needing this isn't upstream yet, but I wanted to
give you this patch for when it comes upstream. If you prefer we hold
the compat patch and send it together with the kernel patch let me know
we can try to do that.

diff --git a/patches/41-no-kfree-rcu.patch b/patches/41-no-kfree-rcu.patch
index c18b50d..37c5c1b 100644
--- a/patches/41-no-kfree-rcu.patch
+++ b/patches/41-no-kfree-rcu.patch
@@ -81,3 +81,42 @@
  
  static int ieee80211_compatible_rates(const u8 *supp_rates, int supp_rates_len,
  				      struct ieee80211_supported_band *sband,
+--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c	2011-10-17 18:29:19.000000000 +0200
++++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c	2011-10-18 10:00:27.000000000 +0200
+@@ -1032,6 +1032,14 @@ static int iwlagn_rx_reply_rx(struct iwl
+ 	return 0;
+ }
+ 
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,40))
++static void kfree_noa_data(struct rcu_head *head)
++{
++	void *data = container_of(head, struct iwl_wipan_noa_data, rcu_head);
++	kfree(data);
++}
++#endif
++
+ static int iwlagn_rx_noa_notification(struct iwl_priv *priv,
+ 				      struct iwl_rx_mem_buffer *rxb,
+ 				      struct iwl_device_cmd *cmd)
+@@ -1071,7 +1079,11 @@ static int iwlagn_rx_noa_notification(st
+ 	rcu_assign_pointer(priv->noa_data, new_data);
+ 
+ 	if (old_data)
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,40))
++		call_rcu(&old_data->rcu_head, kfree_noa_data);
++#else
+ 		kfree_rcu(old_data, rcu_head);
++#endif
+ 
+ 	return 0;
+ }
+--- a/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-10-17 18:29:19.000000000 +0200
++++ b/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-10-18 10:00:44.000000000 +0200
+@@ -3460,6 +3460,7 @@ static void __exit iwl_exit(void)
+ {
+ 	iwl_pci_unregister_driver();
+ 	iwlagn_rate_control_unregister();
++	rcu_barrier();
+ }
+ 
+ module_exit(iwl_exit);


