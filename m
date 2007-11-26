Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59276 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbXK0NHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 08:07:24 -0500
Message-Id: <20071126225421.729141000@sipsolutions.net> (sfid-20071127_130734_848117_32B96FED)
References: <20071126225416.467939000@sipsolutions.net>
Date: Mon, 26 Nov 2007 23:54:19 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH (2.6.24) 3/3]  iwlwifi: do not allow MAC address change
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The iwlwifi drivers do not allow changing the MAC address (because the 
drivers ignore the MAC address mac80211 gives them). So far I haven't
been successful in making them not ignore it, so this makes them tell
mac80211 that they cannot change the MAC address which will disable
MAC changing completely.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org> 
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ++-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2007-11-26 23:35:47.519044815 +0100
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c	2007-11-26 23:35:54.929043078 +0100
@@ -8381,7 +8381,8 @@ static int iwl_pci_probe(struct pci_dev 
 	hw->max_signal = 100;	/* link quality indication (%) */
 
 	/* Tell mac80211 our Tx characteristics */
-	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
+	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
+		    IEEE80211_HW_NO_MAC_CHANGE_SUPPORT;
 
 	hw->queues = 4;
 
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-11-26 23:35:17.379044217 +0100
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-11-26 23:35:43.209044760 +0100
@@ -8983,7 +8983,8 @@ static int iwl_pci_probe(struct pci_dev 
 	hw->max_signal = 100;	/* link quality indication (%) */
 
 	/* Tell mac80211 our Tx characteristics */
-	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
+	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
+		    IEEE80211_HW_NO_MAC_CHANGE_SUPPORT;
 
 	hw->queues = 4;
 #ifdef CONFIG_IWLWIFI_HT

-- 

