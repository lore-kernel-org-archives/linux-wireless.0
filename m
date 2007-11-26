Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59267 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbXK0NHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 08:07:16 -0500
Message-Id: <20071126225420.760175000@sipsolutions.net> (sfid-20071127_130724_199152_2FE5EAB1)
References: <20071126225416.467939000@sipsolutions.net>
Date: Mon, 26 Nov 2007 23:54:17 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH (2.6.24) 1/3]  iwlwifi: fix add_interface
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The iwlwifi drivers both make mac80211 accept an arbitrary number of
virtual interfaces while in reality they can only support one. Fix that.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org> 
---
Please apply this to 2.6.24 as that has userspace interface (nl80211) to
add/remove virtual interfaces. There's *LOTS* to be done for proper
support, e.g. monitor mode is completely messed up, but this at least
doesn't let the user create multiple interfaces that won't work.

Please push to Jeff for .24.

 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2007-11-26 23:23:59.689045194 +0100
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c	2007-11-26 23:24:06.049043241 +0100
@@ -6942,7 +6942,7 @@ static int iwl_mac_add_interface(struct 
 
 	if (priv->interface_id) {
 		IWL_DEBUG_MAC80211("leave - interface_id != 0\n");
-		return 0;
+		return -EOPNOTSUPP;
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-11-26 23:23:36.929050673 +0100
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-11-26 23:23:45.039044868 +0100
@@ -7332,7 +7332,7 @@ static int iwl_mac_add_interface(struct 
 
 	if (priv->interface_id) {
 		IWL_DEBUG_MAC80211("leave - interface_id != 0\n");
-		return 0;
+		return -EOPNOTSUPP;
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);

-- 

